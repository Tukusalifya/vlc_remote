import 'package:flutter/material.dart';

class Connectionprovider extends ChangeNotifier {
  String host;
  String port;
  String password;

  Connectionprovider({
    this.host = '192.168.8.100',
    this.port = '8080',
    this.password = '1234'
});

  void changeConnectionSettings({required String newHost, required String newPort, required String newPassword}) async {
    host = newHost;
    port = newPort;
    password = newPassword;
    notifyListeners();
  }

}