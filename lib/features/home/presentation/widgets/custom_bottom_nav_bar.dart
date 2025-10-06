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
        decoration: BoxDecoration(
          color: ColorPaletter.cardDark,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(icon: Icons.map, text: 'Mapa', index: 0),
            _buildNavItem(icon: Icons.add, text: 'Reportar', index: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required String text, required int index}) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? ColorPaletter.primary.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? ColorPaletter.primary : ColorPaletter.textGrey),
            const SizedBox(width: 8),
            if (isSelected)
              Text(text, style: const TextStyle(color: ColorPaletter.primary, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}