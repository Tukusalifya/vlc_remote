import '../boxes.dart';
import 'package:vlc_remote/Models/ConnectionSettings.dart';

class Settingsservice{
  final ConnectionSettings newSettings;

  Settingsservice({
    required this.newSettings,
});

// function to add a new default config.
  Future<bool> addFavourite() async{

    for(final f in connectionSettingsBox.values){
      if (f.isDefault){
        f.isDefault = false;
        await f.save();
        break;
      }
    }

    await connectionSettingsBox.add(newSettings);

    return true;

  }

// function to update a default config.
  Future<bool> updateFavourite(
      int key,
      ) async {

    if (newSettings.isDefault) {

      for (final otherKey in connectionSettingsBox.keys) {

        if (otherKey == key) continue;

        final favourite =
        connectionSettingsBox.get(otherKey)!;

        if (favourite.isDefault) {

          favourite.isDefault = false;

          await connectionSettingsBox.put(
            otherKey,
            favourite,
          );

          break;
        }
      }
    }

    await connectionSettingsBox.put(
      key,
      newSettings,
    );

    return true;
  }


}