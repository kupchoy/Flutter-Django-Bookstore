import 'package:e_comm/pages/login_page.dart';
import 'package:e_comm/pages/register_page.dart';
import 'package:e_comm/pages/cart_page.dart';
import 'package:e_comm/models/app_state.dart';
import 'package:e_comm/redux/reducers.dart';
import 'package:e_comm/redux/actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'pages/books_page.dart';

void main() {
  final store = Store<AppState>(appReducer,
      initialState: AppState.initial(),
      middleware: [
        thunkMiddleware,
        LoggingMiddleware.printer(),
      ]);
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  MyApp({this.store});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'eComm',
        routes: {
          '/': (BuildContext context) => BooksPage(onInit: () {
                StoreProvider.of<AppState>(context).dispatch(getUserAction);
                StoreProvider.of<AppState>(context).dispatch(getBooksAction);
              }),
          '/login': (BuildContext context) => LoginPage(),
          '/register': (BuildContext context) => RegisterPage(),
          '/cart': (BuildContext context) => CartPage(),
        },
        theme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.cyan[400],
            accentColor: Colors.deepOrange[200],
            textTheme: TextTheme(
              headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
              title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
              body1: TextStyle(fontSize: 18.0),
            )),
      ),
    );
  }
}
