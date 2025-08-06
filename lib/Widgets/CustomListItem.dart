import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconly/iconly.dart';

class Customlistitem extends StatelessWidget {
  const Customlistitem({super.key});

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
              const SizedBox(
                width: 180,
                child: Text(
                  'The Eminence in Shadow',
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
