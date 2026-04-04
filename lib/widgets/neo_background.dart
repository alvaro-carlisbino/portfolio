import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:repositoriobryzzen/utils/colors.dart';

class NeoBackground extends StatelessWidget {
  const NeoBackground({
    super.key,
    required this.scrollOffset,
    required this.isDarkMode,
  });

  final double scrollOffset;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: _NeoBackgroundPainter(
            scrollOffset: scrollOffset,
            isDarkMode: isDarkMode,
          ),
        ),
      ),
    );
  }
}

class _NeoBackgroundPainter extends CustomPainter {
  const _NeoBackgroundPainter({
    required this.scrollOffset,
    required this.isDarkMode,
  });

  final double scrollOffset;
  final bool isDarkMode;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint gridPaint = Paint()
      ..color = (isDarkMode ? AppColors.white : AppColors.black)
          .withValues(alpha: 0.08)
      ..strokeWidth = 1;
    const double gap = 48;
    for (double x = 0; x <= size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y <= size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final Paint shapePaintA = Paint()
      ..color = (isDarkMode ? AppColors.neonYellow : AppColors.brutalRed)
          .withValues(alpha: 0.18);
    final Paint shapePaintB = Paint()
      ..color = (isDarkMode ? AppColors.neonPink : AppColors.neonBlue)
          .withValues(alpha: 0.16);

    final double yShift = (scrollOffset * 0.18) % size.height;
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.72, 80 + yShift, 180, 120),
      shapePaintA,
    );
    canvas.drawCircle(
      Offset(size.width * 0.15, 220 - yShift * 0.35),
      70,
      shapePaintB,
    );

    final Path zigzag = Path();
    final double startX = size.width * 0.08;
    double x = startX;
    const double step = 36;
    zigzag.moveTo(x, size.height * 0.76 + math.sin(scrollOffset * 0.01) * 10);
    for (int i = 0; i < 16; i++) {
      x += step;
      final double y = size.height * 0.76 + (i.isEven ? -18 : 18);
      zigzag.lineTo(x, y);
    }
    final Paint zigPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = isDarkMode ? AppColors.neonBlue : AppColors.neonPurple;
    canvas.drawPath(zigzag, zigPaint);
  }

  @override
  bool shouldRepaint(covariant _NeoBackgroundPainter oldDelegate) {
    return oldDelegate.scrollOffset != scrollOffset ||
        oldDelegate.isDarkMode != isDarkMode;
  }
}
