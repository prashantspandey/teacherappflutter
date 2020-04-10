import 'package:bodhiai_teacher_flutter/styles/textStyles.dart';
import 'package:flutter/material.dart';

class HomePageBackground extends StatelessWidget {
  final screenHeight;
  const HomePageBackground({Key key, @required this.screenHeight})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var backgroundColor = Color(0xFFFF4700).withOpacity(0.95);
    // var backgroundColor = Colors.orange;
    return ClipPath(
      clipper: BottomShapeClipper(),
      child: Container(
        height: screenHeight * 0.30,
        color: backgroundColor,
      ),
    );
  }
}

class BottomShapeClipper extends CustomClipper<Path> {
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
