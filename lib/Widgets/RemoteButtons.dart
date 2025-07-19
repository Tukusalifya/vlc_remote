import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';

class Remotebuttons extends StatelessWidget {
  final IconData icon;

  const Remotebuttons({
    super.key,
    required this.icon
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
