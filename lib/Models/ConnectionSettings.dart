import 'package:hive/hive.dart';

part 'ConnectionSettings.g.dart';

@HiveType(typeId: 0)
class ConnectionSettings extends  HiveObject{

  @HiveField(0)
  String name;

  @HiveField(1)
  String host;

  @HiveField(2)
  String port;

  @HiveField(3)
  String password;

  @HiveField(4)
  bool isDefault;

  ConnectionSettings({
    required this.name,
    required this.host,
    required this.port,
    required this.password,
    required this.isDefault,
  });

}



