import 'package:flutter/material.dart';
import 'package:repositoriobryzzen/utils/colors.dart';
import 'package:repositoriobryzzen/utils/text_styles.dart';
import 'package:repositoriobryzzen/widgets/glass_card.dart';
import 'package:simple_icons/simple_icons.dart';

class SkillCard extends StatefulWidget {
  final IconData icon;
  final String name;
  final double proficiency; // 0.0 to 1.0
  final bool isDark;

  const SkillCard({
    Key? key,
    required this.icon,
    required this.name,
    required this.proficiency,
    this.isDark = true,
  }) : super(key: key);

  @override
  State<SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<SkillCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.proficiency,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()
          ..translate(_isHovered ? 0.0 : 0.0, _isHovered ? -5.0 : 0.0),
        child: GlassCard(
          isDark: widget.isDark,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 32,
                color:
                    widget.isDark ? AppColors.neonBlue : AppColors.neonPurple,
              ),
              const SizedBox(height: 12),
              Text(
                widget.name,
                style: AppTextStyles.body2.copyWith(
                  color: widget.isDark ? AppColors.white : AppColors.textDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: _progressAnimation.value,
                    backgroundColor:
                        (widget.isDark ? AppColors.white : AppColors.textDark)
                            .withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      widget.isDark ? AppColors.neonBlue : AppColors.neonPurple,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
