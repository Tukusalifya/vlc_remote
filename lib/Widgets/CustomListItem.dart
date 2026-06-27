import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconly/iconly.dart';
import 'package:vlc_remote/Services/VlcService.dart';

class Customlistitem extends StatefulWidget {
  final String filename;
  final int id;
  final bool current;
  final VoidCallback onCallback;
  final VlcService vlc;
  const Customlistitem({
    super.key,
    required this.filename,
    required this.id, required this.current,
    required this.onCallback,
    required this.vlc
  });

  @override
  State<Customlistitem> createState() => _CustomlistitemState();
}

class _CustomlistitemState extends State<Customlistitem> {

  late bool playing;

  @override
  void initState() {
    super.initState();
    playing = widget.current;
  }

  @override
  Widget build(BuildContext context) {

    return  GestureDetector(
      onLongPress: (){
        showDialog(
            context: context,
            builder: (BuildContext context)
            {
              return AlertDialog(
                title: const Text(
                  'FileName',
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500
                  ),
                ),
                content: Text(
                  widget.filename
                ),
                actions: [
                  TextButton(
                    onPressed: (){
                      widget.vlc.playID(widget.id);
                      widget.onCallback();
                    },
                    child: Text(
                        'Play'
                    ),
                  ),
                  TextButton(
                      onPressed: ()=> Navigator.of(context).pop(),
                      child: Text(
                        'Close'
                      ),
                  )
                ],
              );
            }

        );
      },
      child: Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width * 0.9,
        height: 80,
        child: Material(
          borderRadius: BorderRadius.circular(10),
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: (){

            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 5),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFF4F4F4),

                  ),
                  child: const Center(
                    child: Icon(
                        IconlyLight.video
                    ),
                  ),
                ),
                SizedBox(width: 10),
                 SizedBox(
                  width: 180,
                  child: Text(
                    widget.filename,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                Align(
                  alignment: Alignment.center,
                  child: playing ? IconButton(
                    onPressed: () {
                      widget.vlc.playID(widget.id);
                      widget.onCallback();
                    },
                    icon: Icon(
                        Icons.play_arrow,
                        size: 30,
                        color: Colors.black87,
                    ),
                  ): IconButton(
                    onPressed: () {
                      widget.vlc.playID(widget.id);
                      widget.onCallback();
                    },
                    icon: Icon(
                      Icons.play_arrow_outlined,
                      size: 30,
                      color: Colors.black87,
                    ),
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
