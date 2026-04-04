import 'package:flutter/material.dart';
import 'package:repositoriobryzzen/utils/colors.dart';

class NeoBrutalCard extends StatelessWidget {
  const NeoBrutalCard({
    super.key,
    required this.child,
    required this.isDarkMode,
    this.padding = const EdgeInsets.all(18),
    this.backgroundColor,
    this.offset = const Offset(8, 8),
  });

  final Widget child;
  final bool isDarkMode;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    final Color fill = backgroundColor ??
        (isDarkMode ? AppColors.cardDark : AppColors.whiteContainerColor);

    return Container(
      decoration: BoxDecoration(
        color: fill,
        border: Border.all(
          color: isDarkMode ? AppColors.white : AppColors.black,
          width: 2.5,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: isDarkMode ? AppColors.neonYellow : AppColors.borderStrong,
            blurRadius: 0,
            offset: offset,
          ),
        ],
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
