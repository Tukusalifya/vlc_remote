import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vlc_remote/Constants.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:vlc_remote/Services/VlcService.dart';
import 'package:vlc_remote/Widgets/NowPlayingCard.dart';
import 'package:vlc_remote/Widgets/ChapterControls.dart';
import 'package:vlc_remote/Widgets/VolumeSliderBar.dart';
import 'package:vlc_remote/Widgets/TransportControls.dart';
import 'package:vlc_remote/Widgets/StopPlaybackButton.dart';
import 'package:vlc_remote/Providers/ConnectionProvider.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';


class Remotescreen extends StatefulWidget {
  const Remotescreen({super.key});

  @override
  State<Remotescreen> createState() => _RemotescreenState();
}

class _RemotescreenState extends State<Remotescreen> {
  late VlcService vlc;
  late Connectionprovider connectionSettings;
  late List<Map<String, dynamic>> playlist;
  List<dynamic> chapters = [];
  int? currentChapter;
  String? currentlyPlaying;
  int volume = 75;
  bool isPlaying = true;
  bool isConnected = false;

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
    collectChapterInformation();
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
    Map<String, dynamic> currentStatus = {};
    try {
      currentStatus = Map.from(await vlc.fetchCurrentStatus());
      setState(() {
        currentlyPlaying = currentStatus['current'];
        volume = (currentStatus['volume'] / 2.56).round();
        isPlaying = currentStatus['state'];
        isConnected = currentStatus['success'];
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

  void collectChapterInformation() async{
    Map<String, dynamic> chapterInformation = {};

    chapterInformation = await vlc.fetchChapterInformation();

    setState(() {
      chapters = chapterInformation['chapters'];
      currentChapter = chapterInformation['currentChapter'];

    });
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
              decoration: BoxDecoration(
                color: isConnected ? Colors.green : Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              isConnected ? "Connected" : "Disconnected",
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
                StreamBuilder<Map<String, dynamic>>(
                  stream: vlc.fetchPlaybackInformation(),
                  builder: (context, snapshot) {
                    int duration = 0;
                    int currentTime = 0;
                    String newPlaying = '';
                    int newVolume = 0;
                    bool newIsPlaying = true;

                    if (snapshot.hasData) {
                      final data = snapshot.data!;
                      duration = data['duration'] ?? 0;
                      currentTime = data['currentTime'] ?? 0;
                      newPlaying = data['currentlyPlaying'] ?? '';
                      newVolume = (data['volume'] / 2.56).round() ?? 0;
                      newIsPlaying = data['state'];

                      if (newPlaying.isNotEmpty) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted && currentlyPlaying != newPlaying) {
                            setState(() {
                              currentlyPlaying = newPlaying;
                            });
                          }
                        });
           }

                      final bool? streamConnected = data['success'];
                      if (streamConnected != null) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted && isConnected != streamConnected) {
                            setState(() {
                              isConnected = streamConnected;
                              volume = newVolume;
                              isPlaying = newIsPlaying;
                            });
                          }
                        });
                      }
                    }

                    return NowPlayingCard(
                      title: currentlyPlaying ?? '',
                      duration: duration,
                      currentTime: currentTime,
                      onSeek: (value) {
                        vlc.seek(seconds: value);
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Transport Controls
                TransportControls(
                  isPlaying: isPlaying,
                  onPlayPause: () async {
                    vlc.play();
                    Map<String, dynamic> state = await vlc.fetchCurrentStatus();
                    bool newIsPlaying = state['state'];

                    setState(() {
                      isPlaying = newIsPlaying;
                    });
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
                    int previousChapter = currentChapter! - 1;
                    if(chapters.isNotEmpty){
                      if(chapters.contains(previousChapter)){
                        vlc.chapter(chapter: previousChapter);
                        collectChapterInformation();
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('No previous chapter available'),
                              duration: Duration(seconds: 1),
                            )
                        );
                      }
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No chapters found'),
                            duration: Duration(seconds: 1),
                          )
                      );
                    }
                  },
                  onNextChapter: () {
                    if(chapters.isNotEmpty){
                      int nextChapter = currentChapter! + 1;

                      if(chapters.contains(nextChapter)){
                        vlc.chapter(chapter: nextChapter);
                        collectChapterInformation();
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text( 'No next chapter available'),
                              duration: Duration(seconds: 1),
                            )
                        );
                      }
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text( 'No chapters found'),
                            duration: Duration(seconds: 1),
                          )
                      );
                    }
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
