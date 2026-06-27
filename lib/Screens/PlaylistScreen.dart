import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:vlc_remote/Providers/ConnectionProvider.dart';
import 'package:vlc_remote/Widgets/CustomListItem.dart';

import '../Services/VlcService.dart';

class Playlistscreen extends StatefulWidget {
  const Playlistscreen({super.key});

  @override
  State<Playlistscreen> createState() => _PlaylistscreenState();
}

class _PlaylistscreenState extends State<Playlistscreen> {
  late VlcService vlc;
  late Connectionprovider connectionSettings;
  late List<Map<String, dynamic>> playlist = [];


  @override
  void initState(){
    super.initState();
    connectionSettings = Provider.of<Connectionprovider>(context, listen: false);
    vlc = VlcService(
        host: connectionSettings.host,
        port: connectionSettings.port,
        password:  connectionSettings.password,
    );
    loadPlaylist();
    connectionSettings.addListener(onSettingsChanged);
  }
  void loadPlaylist() async{
    final List<Map<String, dynamic>>  middlePLaylist = [];
    middlePLaylist.addAll(await vlc.fetchPlaylist());
    setState(() {
      playlist = middlePLaylist;
    });
  }

  void onSettingsChanged() async{
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            'Playlist',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500
            ),
          ),
        ),
      ),
      body: ListView.builder(
          itemCount: playlist.length,
          itemBuilder: (context, index){
            String filename = playlist[index]['filename'] as String;
            int id = playlist[index]['id'];
            bool current = playlist[index]['playing'];
            return Customlistitem(
              filename: filename,
              id: id,
              current: current,
              onCallback: () {
                setState(() {
                  loadPlaylist();
                });
              },
              vlc: vlc,
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Tapped');
        },
        backgroundColor: const Color(0xFF1D4B54),
        child: const Icon(Icons.add,
        color: Colors.white,),

      ),
    );
  }
}
