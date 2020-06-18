import 'package:e_comm/models/app_state.dart';
import 'package:e_comm/redux/actions.dart';
import 'package:e_comm/widgets/book_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:stripe_payment/stripe_payment.dart';

class CartPage extends StatefulWidget {
  @override
  CartPageState createState() => CartPageState();
}

String calculateTotalPrice(cartBooks) {
  double totalPrice = 0.0;

  cartBooks.forEach((cartBooks) {
    totalPrice += double.parse(cartBooks.price);
  });

  return totalPrice.toStringAsFixed(2);
}

class CartPageState extends State<CartPage> {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void initState() {
    super.initState();
    StripePayment.setOptions(StripeOptions(
        publishableKey: "pk_test_utDn0dhH2rq0JI7g1AnIQ50X00MvVnMlQN"));
  }

  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (_, state) {
          return DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                title: Text('Cart Page'),
                bottom: TabBar(
                  labelColor: Colors.deepOrange[600],
                  unselectedLabelColor: Colors.deepOrange[900],
                  tabs: <Widget>[
                    Tab(icon: Icon(Icons.shopping_cart)),
//              Tab(icon: Icon(Icons.credit_card)),
                    Tab(
                      icon: Icon(Icons.receipt),
                      child: Text('Check Out'),
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  _cartTab(state),
//            _cardsTab(),
                  _ordersTab(state),
                ],
              ),
            ),
          );
        });
  }

  Future _showSuccessDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Success'),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('Order successful\n\nCheck your email for a receipt',
              style: Theme.of(context).textTheme.body1,),
            )
          ],
        );
      }
    );
  }

  Widget _cartTab(state) {
    final Orientation orientation = MediaQuery.of(context).orientation;

    return Column(
      children: <Widget>[
        Expanded(
          child: SafeArea(
            top: false,
            bottom: false,
            child: GridView.builder(
              itemCount: state.cartBooks.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemBuilder: (context, i) => BookItem(item: state.cartBooks[i]),
            ),
          ),
        )
      ],
    );
  }

  Widget _cardsTab() {
    return Text('cards');
  }

  Widget _ordersTab(state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: ListView.builder(
              itemCount: state.cartBooks.length,
              itemBuilder: (context, i) {
                return ListTile(
                  leading: Icon(Icons.book),
                  title: Text("${state.cartBooks[i].title}"),
                  subtitle: Text('\$${state.cartBooks[i].price}'),
                  trailing: FlatButton(
                    color: Colors.red,
                    shape: CircleBorder(),
                    child: Icon(
                      Icons.remove_circle_outline,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      StoreProvider.of<AppState>(context)
                          .dispatch(toggleCartBookAction(state.cartBooks[i]));
                    },
                  ),
                );
              }),
        ),
        Expanded(
          child: ListView(
            children: <Widget>[
              ListTile(
                  trailing: Text(
                'Total: \$${calculateTotalPrice(state.cartBooks)}',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              ListTile(
                trailing: FlatButton(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Text('Sumbit Order'),
                  onPressed: () {
                    StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest()).then((paymentMethod) {
                      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Received ${paymentMethod.id}')));
                      StoreProvider.of<AppState>(context).dispatch(clearCartBooksAction);
                      _showSuccessDialog();
//                      setState(() {
//
//                      });
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
