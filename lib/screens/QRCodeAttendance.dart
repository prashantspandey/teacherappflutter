import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeAttendance extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QRCodeAttendance();
  }
}

class _QRCodeAttendance extends State<QRCodeAttendance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code'),
        backgroundColor: Colors.black.withOpacity(0.95),
      ),
      body: Center(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            QrImage(
              backgroundColor: Colors.white,
              data: 'Student Attendance',
              size: 300,
            )
          ],
        ),
      ),
    );
  }
}
