import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:repositoriobryzzen/utils/colors.dart';
import 'package:repositoriobryzzen/utils/text_styles.dart';

class AnimatedTitle extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final bool showHighlight;
  final TextAlign? textAlign;

  const AnimatedTitle({
    super.key,
    required this.text,
    this.style,
    this.showHighlight = true,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (showHighlight)
          Text(
            text,
            style: (style ?? AppTextStyles.h1).copyWith(
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2
                ..color = AppColors.neonBlue.withValues(alpha: 0.5),
            ),
            textAlign: textAlign,
          )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(
                  duration: 2000.ms,
                  color: AppColors.neonPurple.withValues(alpha: 0.3))
              .animate()
              .fadeIn(duration: 600.ms),
        Text(
          text,
          style: style ?? AppTextStyles.h1,
          textAlign: textAlign,
        ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
      ],
    );
  }
}
