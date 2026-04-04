import 'package:flutter/material.dart';
import 'package:repositoriobryzzen/utils/colors.dart';
import 'package:repositoriobryzzen/utils/text_styles.dart';

class SectionAnchorBar extends StatelessWidget {
  const SectionAnchorBar({
    super.key,
    required this.sections,
    required this.activeIndex,
    required this.onTap,
    required this.isDarkMode,
  });

  final List<String> sections;
  final int activeIndex;
  final ValueChanged<int> onTap;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.cardDark : AppColors.white,
        border: Border.all(
          color: isDarkMode ? AppColors.white : AppColors.black,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: isDarkMode ? AppColors.neonYellow : AppColors.black,
            blurRadius: 0,
            offset: const Offset(6, 6),
          ),
        ],
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: List<Widget>.generate(sections.length, (int index) {
          final bool isActive = index == activeIndex;
          return InkWell(
            onTap: () => onTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isActive
                    ? (isDarkMode ? AppColors.neonYellow : AppColors.brutalRed)
                    : Colors.transparent,
                border: Border.all(
                  color: isDarkMode ? AppColors.white : AppColors.black,
                  width: 1.8,
                ),
              ),
              child: Text(
                sections[index],
                style: AppTextStyles.caption.copyWith(
                  color: isActive
                      ? AppColors.black
                      : (isDarkMode ? AppColors.white : AppColors.black),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
