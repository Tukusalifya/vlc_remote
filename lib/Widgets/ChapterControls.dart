import 'package:flutter/material.dart';
import 'package:vlc_remote/Constants.dart';

class ChapterControls extends StatelessWidget {
  final VoidCallback onPreviousChapter;
  final VoidCallback onNextChapter;

  const ChapterControls({
    super.key,
    required this.onPreviousChapter,
    required this.onNextChapter,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous Chapter Button
        TextButton.icon(
          onPressed: onPreviousChapter,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.onSurfaceVariant.withOpacity(0.8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          icon: const Icon(Icons.keyboard_double_arrow_left, size: 20),
          label: const Text(
            'Chapter',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(width: 32),
        // Next Chapter Button
        TextButton(
          onPressed: onNextChapter,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.onSurfaceVariant.withOpacity(0.8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Chapter',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 6),
              Icon(Icons.keyboard_double_arrow_right, size: 20),
            ],
          ),
        ),
      ],
    );
  }
}
