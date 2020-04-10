import 'package:flutter/material.dart';

class SuccessDialogBox extends StatelessWidget {
  double height;
  double width;
  String message;
  SuccessDialogBox(this.message, this.height, this.width);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: height/2,
        width: width/2,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Text(
              message,
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            )
          ],
        ),
      ),
    );
  }
}
