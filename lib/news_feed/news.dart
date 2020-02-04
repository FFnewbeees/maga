import 'package:flutter/material.dart';

class News {
  final String id;
  final String thumbNail;
  final String title;
  final String date;
  final String author;
  final String content;
  final String url;
  final String user;
  bool isFavourite = false;

  News({
    @required this.id, 
    @required this.thumbNail, 
    @required this.title, 
    @required this.date, 
    @required this.author,
    @required this.content,
    @required this.url,
    @required this.user,
    this.isFavourite 
  });

}