import 'package:flutter/cupertino.dart';
import 'package:vlc_remote/Widgets/RemoteButtons.dart';

class Remotebuttonrow extends StatelessWidget {
  final IconData icon_one;
  final IconData icon_two;

  const Remotebuttonrow({
    super.key,
    required this.icon_one,
    required this.icon_two});


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        Remotebuttons(icon: icon_one),
        SizedBox(width: 50),
        Remotebuttons(icon: icon_two)
      ],
    );
  }
}
