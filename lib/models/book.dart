import 'package:flutter/cupertino.dart';

class Book {

/*
  "id": "217a4559-9f02-4cd0-8caf-d1c693873cd2",
  "title": "Django 2 by Example",
  "author": "Antonio Mele",
  "price": "31.19",
  "description": "Learn Django 2.0 with four end-to-end projects",
  "cover": "http://192.168.1.99:9000/media/covers/django_2_by_example_mele.jpg"
*/
  String id;
  String title;
  String author;
  String price;
  String description;
  String cover;

  Book({@required this.id, @required this.title, @required this.author,
    @required this.price, @required this.description, @required this.cover,});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      price: json['price'],
      description: json['description'],
      cover: json['cover'],
    );
  }

}