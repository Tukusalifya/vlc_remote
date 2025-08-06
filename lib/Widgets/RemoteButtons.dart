import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:vlc_remote/Services/VlcService.dart';

class Remotebuttons extends StatelessWidget {
  final IconData icon;
  final void Function() onTap;

  const Remotebuttons({
    super.key,
    required this.icon,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF4F4F4),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: (){
          HapticFeedback.lightImpact();
          print("tapped");
          onTap();
        },
        child: SizedBox(
          width: 130,
          height: 44,
          child: Icon(icon),
        ),
      ),
    );
  }
}
