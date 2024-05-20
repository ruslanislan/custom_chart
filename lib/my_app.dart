import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Row(
                children: [
                  Container(
                    width: constraints.maxWidth * 0.17,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          width: 1,
                          color: Colors.black,
                        ),
                        right: BorderSide(
                          width: 1,
                          color: Colors.black,
                        ),
                        bottom: BorderSide(
                          width: 1,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(
                        top: 32,
                        bottom: 16,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('2'),
                          Text('1'),
                          Text('0'),
                          Text('1'),
                          Text('2'),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: constraints.maxWidth * 0.23 * 7,
                        child: Column(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    width: 1,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              height: 32,
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(child: Center(child: Text('1'))),
                                  Expanded(child: Center(child: Text('2'))),
                                  Expanded(child: Center(child: Text('3'))),
                                  Expanded(child: Center(child: Text('4'))),
                                  Expanded(child: Center(child: Text('5'))),
                                  Expanded(child: Center(child: Text('6'))),
                                  Expanded(child: Center(child: Text('7'))),
                                ],
                              ),
                            ),
                            Expanded(
                              child: CustomPaint(
                                size: Size(
                                  constraints.maxWidth * 0.23 * 7,
                                  constraints.maxHeight,
                                ),
                                painter: CustomChartPainter(),
                              ),
                            ),
                            Container(
                              height: 16,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 1,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class CustomChartPainter extends CustomPainter {
  late Canvas _canvas;
  late Size _size;
  late double maxValue = 5;
  late final zeroY = _size.height / 2;

  final List<double> data = [0.3, 2, 1, -2, 1, 0, 2];

  @override
  void paint(Canvas canvas, Size size) {
    print(size);
    _canvas = canvas;
    _size = size;
    _paintChart();
  }

  void _paintChart() {
    final gradient = ui.Gradient.linear(
      const Offset(0.0, 0.0),
      Offset(0.0, _size.height),
      [
        Colors.blue,
        Colors.blue.withOpacity(0.0),
      ],
    );

    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = gradient;

    final stepX = _size.width / data.length;
    final stepY = _size.height / maxValue;

    final path = Path()..moveTo(0, _size.height / 2);

    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final x = i * stepX + stepX / 2;
      final y = stepY * -data[i] + zeroY;
      path.lineTo(x, y);
      points.add(Offset(x, y));
    }
    path
      ..lineTo(_size.width, _size.height)
      ..lineTo(0, _size.height)
      ..close();

    _canvas.drawPath(path, paint);
    _paintPoints(points);
  }

  void _paintPoints(List<Offset> list) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    for (final point in list) {
      _canvas.drawCircle(point, 6, paint);
      _canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromPoints(
            point.translate(-1, 0),
            point.translate(1, 12),
          ),
          const Radius.circular(6),
        ),
        paint,
      );
      _drawText('red', point.translate(0, 16));
    }
  }

  void _drawText(String text, Offset offset) {
    TextSpan span = TextSpan(
      text: text,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 12,
      ),
    );

    TextPainter textPainter = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout();

    final x = offset.dx - textPainter.width / 2;
    final height = textPainter.height;
    final width = textPainter.width;

    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    _canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(
          offset.translate(-width / 2 - 4, -2),
          offset.translate(width / 2 + 4, height + 2),
        ),
        const Radius.circular(4),
      ),
      paint,
    );

    textPainter.paint(_canvas, Offset(x, offset.dy));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
