import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vlc_remote/Providers/ConnectionProvider.dart';
import 'package:vlc_remote/Constants.dart';
import 'package:vlc_remote/Widgets/PlaylistTile.dart';
import '../Services/VlcService.dart';

class Playlistscreen extends StatefulWidget {
  const Playlistscreen({super.key});

  @override
  State<Playlistscreen> createState() => _PlaylistscreenState();
}

class _PlaylistscreenState extends State<Playlistscreen> {
  late VlcService vlc;
  late Connectionprovider connectionSettings;
  List<Map<String, dynamic>> playlist = [];
  String searchQuery = '';
  final TextEditingController searchController = TextEditingController();

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
      print('Error fetching playlist: $e');
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
  void dispose() {
    connectionSettings.removeListener(onSettingsChanged);
    searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredPlaylist {
    if (searchQuery.isEmpty) return playlist;
    return playlist.where((item) {
      final String filename = (item['filename'] as String? ?? '').toLowerCase();
      return filename.contains(searchQuery.toLowerCase());
    }).toList();
  }

  void _onTilePlay(int id) async {
    // Optimistic UI Update: Mark this item as playing locally first
    setState(() {
      for (var item in playlist) {
        if (item['id'] == id) {
          item['playing'] = true;
        } else {
          item['playing'] = false;
        }
      }
    });

    try {
      vlc.playID(id);
      loadPlaylist(); // Refresh to sync actual status from VLC
    } catch (e) {
      print('Error trying to play media: $e');
      loadPlaylist(); // Fallback reload
    }
  }

  void _showOptionsDialog(String filename, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceContainer,
          title: const Text(
            'Media Options',
            style: TextStyle(
              color: AppColors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            filename,
            style: const TextStyle(color: AppColors.onSurfaceVariant),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _onTilePlay(id);
              },
              child: const Text(
                'Play',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Close',
                style: TextStyle(color: AppColors.outline),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filteredPlaylist;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            const Icon(
              Icons.cast_connected,
              color: AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: 12),
            const Text(
              'Playlist',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: TextField(
              controller: searchController,
              onChanged: (val) {
                setState(() {
                  searchQuery = val;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search media...',
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.onSurfaceVariant,
                ),
                filled: true,
                fillColor: AppColors.surfaceContainerLow,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9999),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          // List View
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      playlist.isEmpty
                          ? 'No playlist items loaded'
                          : 'No matching items found',
                      style: const TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      final String filename = item['filename'] as String? ?? 'Unknown';
                      final int id = item['id'] as int? ?? 0;
                      final bool isPlaying = item['playing'] as bool? ?? false;
                      final dynamic duration = item['duration'];

                      return PlaylistTile(
                        filename: filename,
                        id: id,
                        isPlaying: isPlaying,
                        duration: duration,
                        onTap: () => _onTilePlay(id),
                        onMorePressed: () => _showOptionsDialog(filename, id),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: loadPlaylist,
        backgroundColor: AppColors.primaryContainer,
        foregroundColor: AppColors.onPrimaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.refresh, size: 28),
      ),
    );
  }
}
