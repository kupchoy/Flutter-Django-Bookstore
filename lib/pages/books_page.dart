import 'package:e_comm/widgets/book_item.dart';
import 'package:e_comm/models/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:e_comm/redux/actions.dart';
import 'package:badges/badges.dart';

final gradientBackground = BoxDecoration(
  gradient: LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      stops: [
        0.1,
        0.3,
        0.5,
        0.7,
        0.9
      ],
      colors: [
        Colors.deepOrange[300],
        Colors.deepOrange[400],
        Colors.deepOrange[500],
        Colors.deepOrange[600],
        Colors.deepOrange[700],
      ]),
);

class BooksPage extends StatefulWidget {
  final void Function() onInit;

  BooksPage({this.onInit});

  @override
  BooksPageState createState() => BooksPageState();
}

class BooksPageState extends State<BooksPage> {
  @override
  void initState() {
    super.initState();

    widget.onInit();
  }

  final _appBar = PreferredSize(
    preferredSize: Size.fromHeight(60.0),
    child: StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return AppBar(
          centerTitle: true,
          title: SizedBox(
            child: state.user != null
                ? Text(state.user.email)
                : FlatButton(
                    child: Text(
                      'Log In',
                      style: Theme.of(context).textTheme.body1,
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                  ),
          ),
          leading: state.user != null
              ? Badge(
                  badgeColor: Colors.lime,
                  position: BadgePosition.topRight(top: 1, right: 3),
                  badgeContent: Text(
                    '${state.cartBooks.length}',
                    style: TextStyle(color: Colors.black),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.store),
                    onPressed: () => Navigator.pushNamed(context, '/cart'),
                  ),
                )
              : Text(''),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 12.0),
                child: StoreConnector<AppState, VoidCallback>(
                  converter: (store) {
                    return () => store.dispatch(logoutUserAction);
                  },
                  builder: (_, callback) {
                    return state.user != null
                        ? IconButton(
                            icon: Icon(Icons.exit_to_app), onPressed: callback)
                        : Text('');
                  },
                )),
          ],
        );
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: _appBar,
      body: Container(
        decoration: gradientBackground,
        child: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (_, state) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: SafeArea(
                    top: false,
                    bottom: false,
                    child: GridView.builder(
                      itemCount: state.books.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            orientation == Orientation.portrait ? 2 : 3,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0,
                      ),
                      itemBuilder: (context, i) =>
                          BookItem(item: state.books[i]),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );

//        StoreConnector<AppState, AppState>(
//        converter: (store) => store.state,
//        builder: (context, state) {
//          return state.user != null ? Text(state.user.email) : Text('');
//        },
//      );
  }
}
