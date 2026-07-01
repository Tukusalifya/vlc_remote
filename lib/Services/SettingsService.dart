import 'package:vlc_remote/Models/ConnectionSettings.dart';
import '../boxes.dart';

class Settingsservice{
  final ConnectionSettings connectionSettings;

  Settingsservice({
    required this.connectionSettings,
});

// function to add a new default config => return the config settings.
  Future<Map<String, dynamic>> addFavourite() async{

    for(final f in connectionSettingsBox.values){
      if (f.isDefault){
        f.isDefault = false;
        await f.save();
        break;
      }
    }

    connectionSettings.isDefault = true;
    await connectionSettingsBox.add(connectionSettings);

    return {
      'host': connectionSettings.host,
      'port': connectionSettings.port,
      'password': connectionSettings.password,
      'name': connectionSettings.name
    };
  }


}