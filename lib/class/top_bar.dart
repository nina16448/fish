import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: Container(
          // width: 300.0,
          // height: 300.0,
          ),
      painter: CurvePainter(),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    path.moveTo(0, size.height * 0.24);
    path.quadraticBezierTo(size.width * 0.03, size.height * 0.15,
        size.width * 0.069, size.height * 0.14);
    path.quadraticBezierTo(
        size.width * 0.12, size.height * 0.12, size.width * 0.14, 0);
    path.lineTo(0, 0);
    path.lineTo(0, size.height);
    path.close();
    paint.color = Color.fromARGB(255, 135, 168, 202);
    canvas.drawPath(path, paint);

    path = Path();
    path.moveTo(size.width, size.height * 0.8);

    path.quadraticBezierTo(size.width * 0.9, size.height * 0.9,
        size.width * 0.7, size.height * 2.5);

    // path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height);
    path.close();
    paint.color = Color.fromARGB(255, 135, 168, 202);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
