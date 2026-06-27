
import 'package:flutter/material.dart';
import 'package:vlc_remote/Constants.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer.withOpacity(0.9),
        // borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        // boxShadow: [
        //   BoxShadow(
        //     color: AppColors.primary.withOpacity(0.12),
        //     offset: const Offset(0, -4),
        //     blurRadius: 12,
        //   ),
        // ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.queue_music, "Playlist"),
            _buildNavItem(1, Icons.settings_remote, "Remote"),
            _buildNavItem(2, Icons.settings, "Settings"),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 90,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            decoration: isSelected
                ? BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(9999),
                  )
                : null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? AppColors.onPrimaryContainer
                      : AppColors.onSurfaceVariant.withOpacity(0.7),
                  size: 24,
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.onPrimaryContainer
                        : AppColors.onSurfaceVariant.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}