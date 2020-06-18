import 'package:e_comm/models/book.dart';
import 'package:e_comm/models/user.dart';
import 'package:flutter/cupertino.dart';

@immutable
class AppState {
  final User user;
  final List<Book> books;
  final List<Book> cartBooks;

  AppState(
      {@required this.user, @required this.books, @required this.cartBooks});

  factory AppState.initial() {
    return AppState(
      user: null,
      books: [],
      cartBooks: [],
    );
  }
}
