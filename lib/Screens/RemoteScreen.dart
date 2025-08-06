
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:vlc_remote/Services/VlcService.dart';
import 'package:vlc_remote/Widgets/RemoteButtonRow.dart';

class Remotescreen extends StatefulWidget {
  const Remotescreen({super.key});

  @override
  State<Remotescreen> createState() => _RemotescreenState();
}

class _RemotescreenState extends State<Remotescreen> {
  final VlcService vlc = VlcService(host: '192.168.8.100', port: '8080', password: '1234');

  @override
  void initState(){
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            'VLC Remote',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500
            ),
          ),
        ),
      ),
      body: Container(
          child: Column(
            children: [
              Center(
                child: Text(
                  "Now Playing: The Emminence in shadow"
                ),
              ),
              SizedBox(height: 120),
              Remotebuttonrow(
                icon_one: Icons.skip_previous,
                icon_two: Icons.skip_next,
                onTap_one: vlc.previous,
                onTap_two: vlc.next
              ),
              SizedBox(height: 15),
              Remotebuttonrow(icon_one: Icons.arrow_left,
                icon_two: Icons.arrow_right,
                onTap_one: vlc.fastForward,
                onTap_two: vlc.rewind
              ),
              SizedBox(height: 15),
              Remotebuttonrow(icon_one: Icons.fast_rewind,
                icon_two: Icons.fast_forward,
                onTap_one: vlc.fastForward,
                onTap_two: vlc.rewind
              ),
              SizedBox(height: 15),
              Remotebuttonrow(icon_one: Icons.volume_down,
                icon_two: Icons.volume_up,
                onTap_one: vlc.addVolume,
                onTap_two: vlc.decreaseVolume
              ),
              SizedBox(height: 15),
              Remotebuttonrow(icon_one: Icons.fullscreen_rounded,
                icon_two: Icons.fullscreen_exit_rounded,
                onTap_one: vlc.addVolume,
                onTap_two: vlc.decreaseVolume
              ),
              SizedBox(height: 20),

              Material(
                color: const Color(0xFFFF5050),
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  splashColor: Color(0xFFFF5050),
                  borderRadius: BorderRadius.circular(10),
                  onTap: (){
                    HapticFeedback.lightImpact();
                    print("tapped");
                    vlc.stop();
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 44,
                    child: const Center(
                        child: Text(
                          'Stop',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        )
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15),
              Material(
                color: const Color(0xFF1D4B54),
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  splashColor: Color(0xFF1D4B54),
                  borderRadius: BorderRadius.circular(10),
                  onTap: (){
                    HapticFeedback.lightImpact();
                    print("tapped");
                    vlc.play();
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 44,
                    child: const Center(
                        child: Text(
                          'Pause/Play',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )
                    ),
                  ),
                ),
              ),
            ],
          ),
      ),
    );
  }
}
