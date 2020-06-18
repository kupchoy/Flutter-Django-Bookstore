import 'package:e_comm/models/book.dart';
import 'package:e_comm/redux/actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:e_comm/models/app_state.dart';
import 'package:e_comm/pages/book_detail.dart';

class BookItem extends StatelessWidget {
  final Book item;

  BookItem({this.item});

  bool _isInCart(AppState state, String id) {
    final List<Book> cartBooks = state.cartBooks;
    return cartBooks.indexWhere((cartBook) => cartBook.id == id) > -1;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return BookDetailPage(item: item);
          }
        ),
      ),
      child: GridTile(
        footer: GridTileBar(
          subtitle: Text(
            "\$${item.price}",
            style: TextStyle(fontSize: 16.0),
          ),
          backgroundColor: Color(0xBB000000),
          trailing: StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
          builder: (_, state) {
            return state.user != null ?
            IconButton(
              icon: Icon(
                  Icons.shopping_cart
              ),
              color: _isInCart(state, item.id) ? Colors.cyan[700] : Colors.white,
              onPressed: () {
                StoreProvider.of<AppState>(context).dispatch(toggleCartBookAction(item));
              },
            )
                : Text('');
          },
        )
        ),
        child: Hero(
          tag: item,
          child: Image.network(
            item.cover,
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
    );
  }
}