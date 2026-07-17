import 'boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'Models/ConnectionSettings.dart';
import 'package:vlc_remote/Constants.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vlc_remote/Screens/MainScreen.dart';
import 'package:vlc_remote/Providers/ConnectionProvider.dart';


void main() async{
  await Hive.initFlutter();
  Hive.registerAdapter(ConnectionSettingsAdapter());
  connectionSettingsBox = await Hive.openBox<ConnectionSettings>('connectionSettingsBox');

  ConnectionSettings? defaultSettings;

  for (final setting in connectionSettingsBox.values){
    if(setting.isDefault){
      defaultSettings = setting;
      break;
    }
  }

  runApp(
       MyApp(
      defaultSettings: defaultSettings)
  );

}

class MyApp extends StatelessWidget {
  final ConnectionSettings? defaultSettings;

  const MyApp({
    super.key,
    required this.defaultSettings
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final provider = Connectionprovider();

            provider.changeConnectionSettings(
                newHost: defaultSettings?.host ?? "192.168.1.179",
                newPort: defaultSettings?.port ?? "8080",
                newPassword: defaultSettings?.password ?? "1234",
            );

            return provider;
        },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'VLC Remote',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),

        home:
            const AnnotatedRegion<SystemUiOverlayStyle>(
            value:SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.light,
            ),
             child: Mainscreen(),
            )
      ),
    );
  }
}

