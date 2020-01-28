import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  final bool iconCheck;
  final List<ImageLabel> labels;
  final File imageFile;
  ResultScreen(this.iconCheck, this.labels, this.imageFile);
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
   // print('fk'+widget.labels[0].text.toString());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Result'),
          actions: <Widget>[
            widget.iconCheck
                ? IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {},
                  )
                : IconButton(
                    icon: Icon(Icons.save),
                    onPressed: () {},
                  ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: Image.file(widget.imageFile,fit: BoxFit.cover,),
              ),
              Container(
                height: 400,
                child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    return ListTile(
                      title: Text(widget.labels[index].text),
                      subtitle: Text(widget.labels[index].entityId.toString() +
                          "\n" +
                          widget.labels[index].confidence.toString()),
                      isThreeLine: true,
                    );
                  },
                  itemCount: widget.labels.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
