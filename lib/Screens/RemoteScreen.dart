import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vlc_remote/Providers/ConnectionProvider.dart';
import 'package:vlc_remote/Services/VlcService.dart';
import 'package:vlc_remote/Constants.dart';
import 'package:vlc_remote/Widgets/NowPlayingCard.dart';
import 'package:vlc_remote/Widgets/TransportControls.dart';
import 'package:vlc_remote/Widgets/ChapterControls.dart';
import 'package:vlc_remote/Widgets/VolumeSliderBar.dart';
import 'package:vlc_remote/Widgets/StopPlaybackButton.dart';

class Remotescreen extends StatefulWidget {
  const Remotescreen({super.key});

  @override
  State<Remotescreen> createState() => _RemotescreenState();
}

class _RemotescreenState extends State<Remotescreen> {
  late VlcService vlc;
  late Connectionprovider connectionSettings;
  late List<Map<String, dynamic>> playlist;
  Map<String, dynamic> currentlyPlaying = {
    'current': 'Nothing currently playing',
  };
  int volume = 75; // Default volume matching the Stitch design template (75%)
  bool isPlaying = true; // Assume playing initially (displays pause button)

  @override
  void initState() {
    super.initState();
    connectionSettings = Provider.of<Connectionprovider>(context, listen: false);
    vlc = VlcService(
      host: connectionSettings.host,
      port: connectionSettings.port,
      password: connectionSettings.password,
    );
    loadPlaylist();
    fetchCurrent();
    connectionSettings.addListener(onSettingsChanged);
  }

  void loadPlaylist() async {
    final List<Map<String, dynamic>> middlePlaylist = [];
    try {
      middlePlaylist.addAll(await vlc.fetchPlaylist());
      setState(() {
        playlist = middlePlaylist;
      });
    } catch (e) {
      print('Error loading playlist: $e');
    }
  }

  void fetchCurrent() async {
    Map<String, dynamic> middleCurrentlyPlaying = {};
    try {
      middleCurrentlyPlaying = Map.from(await vlc.fetchCurrentStatus());
      setState(() {
        print(middleCurrentlyPlaying);
        currentlyPlaying = Map.from(middleCurrentlyPlaying);
      });
    } catch (e) {
      print('Error fetching current status: $e');
    }
  }

  void onSettingsChanged() async {
    vlc = VlcService(
      host: connectionSettings.host,
      port: connectionSettings.port,
      password: connectionSettings.password,
    );
    loadPlaylist();
  }

  @override
  Widget build(BuildContext context) {
    final VlcService vlc = VlcService(
        host: context.watch<Connectionprovider>().host,
        port: context.watch<Connectionprovider>().port,
        password: context.watch<Connectionprovider>().password);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            const Icon(
              Icons.cast_connected,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            const Text(
              'VLC Remote',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'Connected',
              style: TextStyle(
                color: AppColors.onSurfaceVariant.withOpacity(0.7),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.fullscreen, color: AppColors.primary),
            tooltip: 'Fullscreen Toggle',
            onPressed: () {
              vlc.fullscreen();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Toggled Fullscreen'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Now Playing Card
                NowPlayingCard(title: currentlyPlaying['current'] ?? ''),
                const SizedBox(height: 24),

                // Transport Controls
                TransportControls(
                  isPlaying: isPlaying,
                  onPlayPause: () {
                    setState(() {
                      isPlaying = !isPlaying;
                    });
                    vlc.play();
                  },
                  onPrevious: () {
                    vlc.previous();
                    fetchCurrent();
                    loadPlaylist();
                  },
                  onNext: () {
                    vlc.next();
                    fetchCurrent();
                    loadPlaylist();
                  },
                  onRewind: () {
                    vlc.rewind();
                  },
                  onForward: () {
                    vlc.fastForward();
                  },
                ),
                const SizedBox(height: 16),

                // Chapter Controls
                ChapterControls(
                  onPreviousChapter: () {
                    vlc.previousChapter();
                  },
                  onNextChapter: () {
                    vlc.nextChapter();
                  },
                ),
                const SizedBox(height: 24),

                // Volume Slider Section
                VolumeSliderBar(
                  volume: volume,
                  onVolumeChanged: (val) {
                    setState(() {
                      volume = val;
                    });
                    // Set absolute volume in VLC (0-512, 256 = 100%)
                    vlc.sendCommand('volume', value: '${(val * 2.56).round()}');
                  },
                ),
                const SizedBox(height: 24),

                // Stop Playback Button
                StopPlaybackButton(
                  onPressed: () {
                    vlc.stop();
                    fetchCurrent();
                    loadPlaylist();
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
