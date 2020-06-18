import 'dart:convert';
import 'package:e_comm/models/book.dart';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';
import 'package:e_comm/models/app_state.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_comm/models/user.dart';

ThunkAction<AppState> getUserAction = (Store<AppState> store) async {
  final prefs = await SharedPreferences.getInstance();
  final String storedUser = prefs.getString('user');
  final user =
      storedUser != null ? User.fromJson(json.decode(storedUser)) : null;
  User();
  print(storedUser);
  print(user);
  store.dispatch(GetUserAction(user));
};

class GetUserAction {
  final User _user;

  User get user => this._user;

  GetUserAction(this._user);
}

ThunkAction<AppState> getBooksAction = (Store<AppState> store) async {
  http.Response response =
      await http.get('https://pure-mountain-29084.herokuapp.com/api/books/');
  final List<dynamic> responseData = json.decode(response.body);
  List<Book> books = [];
  responseData.forEach((bookData) {
    final Book book = Book.fromJson(bookData);
    books.add(book);
  });
  store.dispatch(GetBooksAction(books));
};

ThunkAction<AppState> logoutUserAction = (Store<AppState> store) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('user');
  User user;
  store.dispatch(LogoutUserAction(user));
};

ThunkAction<AppState> toggleCartBookAction(Book cartBook) {
  return (Store<AppState> store) {
    final List<Book> cartBooks = store.state.cartBooks;
    final int index = cartBooks.indexWhere((book) => book.id == cartBook.id);
    bool isInCart = index > -1 == true;
    List<Book> updatedCartBooks = List.from(cartBooks);
    if (isInCart) {
      updatedCartBooks.removeAt(index);
    } else {
      updatedCartBooks.add(cartBook);
    }
    store.dispatch(ToggleCartBookAction(updatedCartBooks));
  };
}

ThunkAction<AppState> clearCartBooksAction = (Store<AppState> store) {
  store.dispatch(ClearCartBooksAction(List(0)));
};

class ClearCartBooksAction {
  final List<Book> _cartBooks;

  List<Book> get cartBooks => this._cartBooks;

  ClearCartBooksAction(this._cartBooks);
}

class ToggleCartBookAction {
  final List<Book> _cartBooks;

  List<Book> get cartBooks => this._cartBooks;

  ToggleCartBookAction(this._cartBooks);
}

class GetBooksAction {
  final List<Book> _books;

  List<Book> get books => this._books;

  GetBooksAction(this._books);
}

class LogoutUserAction {
  final User _user;

  User get user => this._user;

  LogoutUserAction(this._user);
}
