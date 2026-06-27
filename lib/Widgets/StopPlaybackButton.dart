import 'package:flutter/material.dart';
import 'package:vlc_remote/Constants.dart';

class StopPlaybackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const StopPlaybackButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.error.withOpacity(0.1)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.stop_circle,
              color: AppColors.error,
              size: 24,
            ),
            SizedBox(width: 8),
            Text(
              'Stop Playback',
              style: TextStyle(
                color: AppColors.error,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
