import 'package:flutter/material.dart';

class DrawCircle extends CustomPainter {
  Paint _paint;
  double radius;
  Color circleColor;


  DrawCircle(this.circleColor, {this.radius = 13}) {

    _paint = Paint()
      ..color = circleColor
      ..style = PaintingStyle.fill;
  }


  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(0.5,0.5), radius, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}


class DrawRing extends CustomPainter {
  Paint _paint;
  double radius;
  Color circleColor;
  double strokeWidth;


  DrawRing(this.circleColor, {this.radius = 13, this.strokeWidth = 2.5}) {

    _paint = Paint()
      ..color = circleColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
  }


  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(0.5,0.5), radius, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}



class ColorsPalette {
  final map = {
    "black" : Colors.black,
    "yellow" : Colors.yellowAccent,
    "red" : Colors.red,
    "orange" : Colors.orange,
    "green" : Colors.green,
    "cyan" : Colors.cyan,
    "lightBlue" : Colors.lightBlue,
    "purple" : Colors.purple,
    "pink" : Colors.pink,
  };
}