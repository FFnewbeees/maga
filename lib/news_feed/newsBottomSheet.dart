import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BottomSheetWidget extends StatelessWidget {

  final url;
  BottomSheetWidget({this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 10),
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(blurRadius: 10, color: Colors.grey[300], spreadRadius: 5)
              ] 
            ),
            child: Column(children: <Widget>[
                DecoratedTextField(url: url),
                CopyButton(url: url),
              ],
            ),
          )
        ],
      ),
    );
  }
}


class DecoratedTextField extends StatelessWidget {

  final url;

  DecoratedTextField({this.url, Widget child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[300], 
        borderRadius: BorderRadius.circular(10)
      ),
      child: Text(this.url),
    );
  }
}

class CopyButton extends StatefulWidget {
  @override
  _CopyButtonState createState() => _CopyButtonState(url);

  final url;
  CopyButton({this.url});

}

class _CopyButtonState extends State<CopyButton> {

  bool copyUrl = false;
  bool copied = false;

  final url;
  _CopyButtonState(this.url);

  @override
  Widget build(BuildContext context) {
    return !copyUrl ?
    MaterialButton(
      height: 50,
      color: Colors.grey[800],
      onPressed: () async{

        Clipboard.setData(ClipboardData(text: url));

        setState(() {
          copyUrl = true;
        });

        await Future.delayed(Duration(seconds: 1));

        setState(() {
          copied = true;
        });

        await Future.delayed(Duration(milliseconds: 500));

        Navigator.pop(context);

      },
      child: Text('Copy URL', style: TextStyle(color: Colors.white),),
    )
    :!copied 
    ? CircularProgressIndicator() 
    : 
    Column(
      children: <Widget>[
        Icon(
          Icons.check, 
          color: Colors.green
        ),
        Text('Copied')
      ],
    );
  }
}