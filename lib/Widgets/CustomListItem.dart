import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconly/iconly.dart';

class Customlistitem extends StatelessWidget {
  final String filename;
  final String id;
  const Customlistitem({super.key, required this.filename, required this.id});

  @override
  Widget build(BuildContext context) {
    return  Container(
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
                  filename,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.2),
              Align(
                alignment: Alignment.center,
                child: Icon(
                    Icons.circle,
                  size: 15,
                  color: Colors.greenAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
