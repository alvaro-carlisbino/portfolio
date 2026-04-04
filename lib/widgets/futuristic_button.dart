import 'package:flutter/material.dart';
import 'package:repositoriobryzzen/utils/colors.dart';
import 'package:repositoriobryzzen/utils/text_styles.dart';

class FuturisticButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutlined;
  final IconData? icon;
  final bool isSmall;

  const FuturisticButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
    this.icon,
    this.isSmall = false,
  });

  @override
  State<FuturisticButton> createState() => _FuturisticButtonState();
}

class _FuturisticButtonState extends State<FuturisticButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: widget.isSmall ? 16 : 24,
                vertical: widget.isSmall ? 8 : 12,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: widget.isOutlined ? null : AppColors.buttonGradient,
                border: widget.isOutlined
                    ? Border.all(
                        color: AppColors.neonBlue,
                        width: 2,
                      )
                    : null,
                boxShadow: isHovered
                    ? [
                        BoxShadow(
                          color: AppColors.neonBlue.withValues(alpha: 0.3),
                          blurRadius: 12,
                          spreadRadius: 0,
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      color: widget.isOutlined
                          ? AppColors.neonBlue
                          : AppColors.white,
                      size: widget.isSmall ? 16 : 20,
                    ),
                    SizedBox(width: widget.isSmall ? 8 : 12),
                  ],
                  Text(
                    widget.text,
                    style: (widget.isSmall
                            ? AppTextStyles.caption
                            : AppTextStyles.button)
                        .copyWith(
                      color: widget.isOutlined
                          ? AppColors.neonBlue
                          : AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
