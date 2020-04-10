import 'package:flutter/material.dart';

class FeatureHomeScreen extends StatelessWidget {
  final screenHeight;
  final screenName;
  FeatureHomeScreen({this.screenHeight, this.screenName});
  @override
  Widget build(BuildContext context) {
    var backgroundColor = Color(0xFFFF4700).withOpacity(0.95);
    // var backgroundColor = Colors.orange;
    return ClipPath(
      clipper: FeatureScreenClipper(),
      child: Container(
        height: screenHeight * 0.30,
        width: MediaQuery.of(context).size.width,
        color: backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(screenName,style: TextStyle(color: Colors.white,fontSize: 41),),
          ],
        ),
      ),
    );
  }
}

class FeatureScreenClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    Offset curveStartPoint = Offset(0, size.height * 0.85);
    Offset curveEndPoint = Offset(size.width, size.height * 0.85);
    path.lineTo(curveStartPoint.dx, curveEndPoint.dy);
    path.quadraticBezierTo(
        size.width / 2, size.height, curveEndPoint.dx, curveEndPoint.dy);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
