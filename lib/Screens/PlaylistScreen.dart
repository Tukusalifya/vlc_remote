import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:iconly/iconly.dart';
import 'package:vlc_remote/Widgets/CustomListItem.dart';

import '../Services/VlcService.dart';

class Playlistscreen extends StatefulWidget {
  const Playlistscreen({super.key});

  @override
  State<Playlistscreen> createState() => _PlaylistscreenState();
}

class _PlaylistscreenState extends State<Playlistscreen> {
  final VlcService vlc = VlcService(host: '192.168.8.100', port: '8080', password: '1234');
  late List<Map<String, dynamic>> playlist = [];

  void loadPlaylist() async{
    final List<Map<String, dynamic>>  middlePLaylist = [];
    middlePLaylist.addAll(await vlc.fetchPlaylist());
    setState(() {
      playlist = middlePLaylist;
    });
  }
  @override
  void initState(){
    super.initState();
    loadPlaylist();
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
            String id = playlist[index]['id'] as String;
            return Customlistitem(filename: filename, id: id,);
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
