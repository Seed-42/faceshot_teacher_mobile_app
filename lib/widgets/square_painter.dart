import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui' as ui;

class SquarePainter extends CustomPainter {
  final ui.Image theImage;
  final double left, top, width, height;
  SquarePainter(
    this.theImage,
    this.left,
    this.top,
    this.width,
    this.height,
  );
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawAtlas(
      theImage,
      [
        /* Identity transform */
        RSTransform.fromComponents(
            rotation: 0.0,
            scale: 1.0,
            anchorX: 0.0,
            anchorY: 0.0,
            translateX: 0.0,
            translateY: 0.0)
      ],
      [
        /// A 5x5 source rectangle within the image at position (left, height)
        Rect.fromLTWH(
          left,
          top,
          width,
          height,
        )
      ],
      [/* No need for colors */],
      BlendMode.src,
      null /* No need for cullRect */,
      Paint(),
    );
  }

  @override
  bool shouldRepaint(SquarePainter oldDelegate) => false;
  @override
  bool shouldRebuildSemantics(SquarePainter oldDelegate) => false;
}
