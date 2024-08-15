import 'package:flutter/material.dart';

class CustomCircularIndicator extends StatelessWidget {
  final double percent;

  CustomCircularIndicator({required this.percent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 50,
      child: CustomPaint(
        painter: CircularIndicatorPainter(percent: percent),
      ),
    );
  }
}

class CircularIndicatorPainter extends CustomPainter {
  final double percent;

  CircularIndicatorPainter({required this.percent});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    final Paint progressPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final double radius = size.width / 2;
    final double angle = 2 * 3.14 * percent;

    canvas.drawCircle(Offset(radius, radius), radius, backgroundPaint);
    canvas.drawArc(
      Rect.fromCircle(center: Offset(radius, radius), radius: radius),
      -3.14 / 2,
      angle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
