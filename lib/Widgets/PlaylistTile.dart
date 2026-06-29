import 'package:flutter/material.dart';
import 'package:vlc_remote/Constants.dart';

class PlaylistTile extends StatelessWidget {
  final String filename;
  final int id;
  final bool isPlaying;
  final dynamic duration;
  final VoidCallback onTap;
  final VoidCallback onMorePressed;

  const PlaylistTile({
    super.key,
    required this.filename,
    required this.id,
    required this.isPlaying,
    required this.duration,
    required this.onTap,
    required this.onMorePressed,
  });

  String _formatDuration(dynamic durationSecs) {
    if (durationSecs == null) return '--:--';
    int seconds = 0;
    if (durationSecs is int) {
      seconds = durationSecs;
    } else if (durationSecs is String) {
      seconds = int.tryParse(durationSecs) ?? 0;
    }
    if (seconds <= 0) return '--:--';

    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int remainingSeconds = seconds % 60;

    final String minutesStr = minutes.toString().padLeft(2, '0');
    final String secondsStr = remainingSeconds.toString().padLeft(2, '0');

    if (hours > 0) {
      return '$hours:$minutesStr:$secondsStr';
    } else {
      return '$minutes:$secondsStr';
    }
  }

  String _getFileType(String filename) {
    final int dotIndex = filename.lastIndexOf('.');
    if (dotIndex == -1 || dotIndex == filename.length - 1) {
      return 'Media File';
    }
    final String ext = filename.substring(dotIndex + 1).toUpperCase();
    if (['MP3', 'M4A', 'WAV', 'FLAC', 'AAC'].contains(ext)) {
      return '$ext Audio';
    }
    if (['MP4', 'MKV', 'AVI', 'WEBM', 'MOV', 'MPEG', 'FLV'].contains(ext)) {
      return '$ext Video';
    }
    return '$ext File';
  }

  IconData _getIconData(String filename) {
    final int dotIndex = filename.lastIndexOf('.');
    if (dotIndex == -1) return Icons.movie;
    final String ext = filename.substring(dotIndex + 1).toLowerCase();
    if (['mp3', 'm4a', 'wav', 'flac', 'aac'].contains(ext)) {
      return Icons.music_note;
    }
    return Icons.movie;
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDuration = _formatDuration(duration);
    final String fileType = _getFileType(filename);
    final IconData itemIcon = _getIconData(filename);

    if (isPlaying) {
      // "Now Playing" highlight state styling
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHighest.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: const Border(
            left: BorderSide(
              color: AppColors.primary,
              width: 4,
            ),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Play Icon in container
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.play_arrow,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Title, Subtitle, and Badge
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'NOW PLAYING',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          filename,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$formattedDuration • $fileType',
                          style: TextStyle(
                            color: AppColors.onSurfaceVariant.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // More action button
                  IconButton(
                    icon: const Icon(
                      Icons.more_vert,
                      color: AppColors.onSurfaceVariant,
                    ),
                    onPressed: onMorePressed,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      // Inactive tile styling with bottom divider
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border(
            bottom: BorderSide(
              color: AppColors.outlineVariant.withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // File type icon in container
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Icon(
                        itemIcon,
                        color: AppColors.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Title and Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          filename,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$formattedDuration • $fileType',
                          style: TextStyle(
                            color: AppColors.onSurfaceVariant.withOpacity(0.6),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // More action button
                  IconButton(
                    icon: const Icon(
                      Icons.more_vert,
                      color: AppColors.onSurfaceVariant,
                    ),
                    onPressed: onMorePressed,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
