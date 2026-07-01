import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vlc_remote/Providers/ConnectionProvider.dart';
import 'package:vlc_remote/Screens/MainScreen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'Models/ConnectionSettings.dart';
import 'boxes.dart';


void main() async{
  await Hive.initFlutter();
  Hive.registerAdapter(ConnectionSettingsAdapter());
  connectionSettingsBox = await Hive.openBox<ConnectionSettings>('connectionSettingsBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Connectionprovider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),

        home:
            AnnotatedRegion<SystemUiOverlayStyle>(
            value:SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.light,
            ),
             child: const Mainscreen(),
            )
      ),
    );
  }
}

