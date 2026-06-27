import 'package:flutter/material.dart';
import 'package:vlc_remote/Constants.dart';

class TransportControls extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onRewind;
  final VoidCallback onForward;

  const TransportControls({
    super.key,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onPrevious,
    required this.onNext,
    required this.onRewind,
    required this.onForward,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Skip Previous
        IconButton(
          onPressed: onPrevious,
          iconSize: 28,
          color: AppColors.onSurfaceVariant,
          icon: const Icon(Icons.skip_previous),
        ),
        // Replay 10s
        IconButton(
          onPressed: onRewind,
          iconSize: 28,
          color: AppColors.onSurfaceVariant,
          icon: const Icon(Icons.replay_10),
        ),
        // Center Play/Pause circle
        GestureDetector(
          onTap: onPlayPause,
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryContainer.withOpacity(0.4),
                  offset: const Offset(0, 4),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              size: 40,
              color: AppColors.onPrimaryContainer,
            ),
          ),
        ),
        // Forward 10s
        IconButton(
          onPressed: onForward,
          iconSize: 28,
          color: AppColors.onSurfaceVariant,
          icon: const Icon(Icons.forward_10),
        ),
        // Skip Next
        IconButton(
          onPressed: onNext,
          iconSize: 28,
          color: AppColors.onSurfaceVariant,
          icon: const Icon(Icons.skip_next),
        ),
      ],
    );
  }
}
