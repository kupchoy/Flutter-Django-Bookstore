import 'package:e_comm/models/app_state.dart';
import 'package:e_comm/models/book.dart';
import 'package:e_comm/redux/actions.dart';
import 'package:e_comm/models/user.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    user: userReducer(state.user, action),
    books: booksReducer(state.books, action),
    cartBooks: cartBooks(state.cartBooks, action),
  );
}

User userReducer(User user, dynamic action) {
  if (action is GetUserAction) {
    return action.user;
  } else if (action is LogoutUserAction) {
    return action.user;
  }
  return user;
}

List<Book> booksReducer(List<Book> books, dynamic action) {
  if (action is GetBooksAction) {
    return action.books;
  }

  return books;
}

List<Book> cartBooks(List<Book> cartBooks, dynamic action) {
  if (action is ToggleCartBookAction) {
    return action.cartBooks;
  } else if (action is ClearCartBooksAction) {
    return action.cartBooks;
  }
  return cartBooks;
}