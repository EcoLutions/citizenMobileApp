import 'package:citizen_mobile_app/core/theme/color_paletter.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 70,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: ColorPaletter.cardDark.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: Icons.map_outlined,
              text: 'Mapa',
              index: 0,
              isSelected: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            _buildNavItem(
              icon: Icons.add_circle_outline,
              text: 'Reportar',
              index: 1,
              isSelected: currentIndex == 1,
              onTap: () => onTap(1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String text,
    required int index,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: 50,
          decoration: BoxDecoration(
            color: isSelected ? ColorPaletter.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? ColorPaletter.white : ColorPaletter.textGrey),
              if (isSelected) const SizedBox(width: 8),
              if (isSelected)
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    text,
                    style: const TextStyle(
                        color: ColorPaletter.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14
                    ),
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}