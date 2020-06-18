import 'package:e_comm/models/app_state.dart';
import 'package:e_comm/models/book.dart';
import 'package:e_comm/redux/actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_comm/pages/books_page.dart';
import 'package:flutter_redux/flutter_redux.dart';

class BookDetailPage extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Book item;

  BookDetailPage({this.item});

  bool _isInCart(AppState state, String id) {
    final List<Book> cartBooks = state.cartBooks;
    return cartBooks.indexWhere((cartBook) => cartBook.id == id) > -1;
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(item.title),
      ),
      body: Container(
        decoration: gradientBackground,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Hero(
                tag: item,
                child: Image.network(
                  item.cover,
                  fit: BoxFit.scaleDown,
                  width: orientation == Orientation.portrait ? 300 : 175,
                  height: orientation == Orientation.portrait ? 200 : 100,
                ),
              ),
            ),
            Text(
              item.title,
              style: Theme.of(context).textTheme.title,
            ),
            Text(
              '\$${item.price}',
              style: Theme.of(context).textTheme.body1,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 32.0,
              ),
              child: StoreConnector<AppState, AppState>(
                converter: (store) => store.state,
                builder: (_, state) {
                  return state.user != null
                      ? IconButton(
                          icon: Icon(Icons.shopping_cart),
                          color: _isInCart(state, item.id)
                              ? Colors.cyan[700]
                              : Colors.white,
                          onPressed: () {
                            StoreProvider.of<AppState>(context)
                                .dispatch(toggleCartBookAction(item));
                            final snackbar = SnackBar(
                              duration: Duration(seconds: 2),
                              content: Text('Cart updated',
                              style: TextStyle(color: Colors.green),),
                            );
                            _scaffoldKey.currentState.showSnackBar(snackbar);
                          },
                        )
                      : Text('');
                },
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  child: Text(item.description),
                  padding: EdgeInsets.only(
                    left: 32.0,
                    right: 32.0,
                    bottom: 32.0,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
