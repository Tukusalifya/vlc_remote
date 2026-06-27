import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:vlc_remote/Screens/PlaylistScreen.dart';
import 'package:vlc_remote/Screens/RemoteScreen.dart';
import 'package:vlc_remote/Screens/SettingsScreen.dart';
import '../Widgets/CustomBottomNavigationBar.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  int selectedNavindex = 1;

  int navBarTap( int index){
    setState(() {
      selectedNavindex = index;
    });
    return selectedNavindex;
  }

  static const List<Widget> pages = [
      Playlistscreen(),
      Remotescreen(),
      Settingsscreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedNavindex],
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: selectedNavindex,
        onTap: navBarTap,
      ),
    );
  }
}
