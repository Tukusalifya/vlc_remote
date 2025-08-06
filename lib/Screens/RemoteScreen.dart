
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
              Row(
                children: [
                  SizedBox(width: 25),
                  Icon(IconlyLight.video),
                  SizedBox(width: 10),
                  Text(
                      "The Emminence in shadow"
                  ),
                ]
              ),
              SizedBox(height: 10),
              Row(
                  children: [
                    SizedBox(width: 25),
                    Icon(IconlyLight.volume_up),
                    SizedBox(width: 10),
                    Text(
                        "200"
                    ),
                  ]
              ),
              SizedBox(height: 10),
              Row(
                  children: [
                    SizedBox(width: 25),
                    Icon(IconlyLight.time_square),
                    SizedBox(width: 10),
                    Text(
                        "1h 45m"
                    ),
                  ]
              ),


              SizedBox(height: 50),
              Remotebuttonrow(
                icon_one: Icons.skip_previous_rounded,
                icon_two: Icons.skip_next_rounded,
                onTap_one: vlc.previousChapter,
                onTap_two: vlc.nextChapter
              ),
              SizedBox(height: 15),
              Remotebuttonrow(icon_one: IconlyBold.arrow_left_2,
                icon_two: IconlyBold.arrow_right_2,
                onTap_one: vlc.previous,
                onTap_two: vlc.next
              ),
              SizedBox(height: 15),
              Remotebuttonrow(icon_one: Icons.fast_rewind_rounded,
                icon_two: Icons.fast_forward_rounded,
                onTap_one: vlc.rewind,
                onTap_two: vlc.fastForward
              ),
              SizedBox(height: 15),
              Remotebuttonrow(icon_one: IconlyBold.volume_down,
                icon_two: IconlyBold.volume_up,
                onTap_one: vlc.decreaseVolume,
                onTap_two: vlc.addVolume
              ),
              SizedBox(height: 15),
              Remotebuttonrow(icon_one: Icons.fullscreen_rounded,
                icon_two: Icons.fullscreen_exit_rounded,
                onTap_one: vlc.fullscreen,
                onTap_two: vlc.fullscreen
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
