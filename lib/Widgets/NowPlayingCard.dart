import 'package:flutter/material.dart';
import 'package:vlc_remote/Constants.dart';

class NowPlayingCard extends StatefulWidget {
  final String title;
  final int duration;
  final int currentTime;
  final ValueChanged<int>? onSeek;

  const NowPlayingCard({
    super.key,
    required this.title,
    required this.duration,
    required this.currentTime,
    this.onSeek,
  });

  @override
  State<NowPlayingCard> createState() => _NowPlayingCardState();
}

class _NowPlayingCardState extends State<NowPlayingCard> {
  double? _dragValue;

  String _formatTime(int seconds) {
    if (seconds <= 0) return '00:00';
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

  @override
  Widget build(BuildContext context) {
    final String displayTitle = widget.title.isNotEmpty ? widget.title : 'Nothing currently playing';
    final String subtitle = widget.title.isNotEmpty ? 'VLC Media Player' : 'No Active Session';

    final int totalDuration = widget.duration;
    final int current = _dragValue != null ? _dragValue!.round() : widget.currentTime;
    final int displayCurrent = current.clamp(0, totalDuration > 0 ? totalDuration : 0);

    final String timeElapsed = widget.title.isNotEmpty ? _formatTime(displayCurrent) : '--:--';
    final String timeRemaining = widget.title.isNotEmpty ? _formatTime(totalDuration) : '--:--';

    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.surfaceVariant.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        children: [
          // Media Thumbnail / Cover Art with Title overlay
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAg-rzRE8Xzi5b8hwwoBC7PVxFH3i0GielJN31gmq1FQbjmtAaoqpSesOywaO9ql2-ZUuB_AnksuwANVO6bwWgdrMhnEY2jb70I1FvCUyJ_l8VMEvRDIJD8T4whAISq6CLX_TX3C4DWqQTOwrSg3RgPKuhfaecjLCerX-MfuLuON7WZXlL7jh_66WtqQBk-FgmotE9eV6GOspaspIR3nbqRy_eWzzOGxD9H_mm8MUOSDDGBI_qqax2G5nQ4pu_-Ey2yoQhlxcqXV1o',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF3A2E25), Color(0xFF241912)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.video_library_outlined,
                            size: 64,
                            color: AppColors.primaryContainer,
                          ),
                        ),
                      );
                    },
                  ),
                  // Gradient overlay
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.8),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),
                  // Title and Subtitle text overlay
                  Positioned(
                    bottom: 12,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Timeline Seek section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: [
                // Slider seeking progress bar
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 6,
                    activeTrackColor: AppColors.primaryContainer,
                    inactiveTrackColor: AppColors.surfaceVariant,
                    thumbColor: AppColors.primaryContainer,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                    overlayColor: AppColors.primaryContainer.withOpacity(0.2),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                  ),
                  child: Slider(
                    value: displayCurrent.toDouble(),
                    min: 0.0,
                    max: totalDuration > 0 ? totalDuration.toDouble() : 1.0,
                    onChanged: widget.title.isNotEmpty
                        ? (value) {
                            setState(() {
                              _dragValue = value;
                            });
                          }
                        : null,
                    onChangeEnd: (value) {
                      if (widget.onSeek != null) {
                        widget.onSeek!(value.round());
                      }
                      setState(() {
                        _dragValue = null;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        timeElapsed,
                        style: const TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        timeRemaining,
                        style: const TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
