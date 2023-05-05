import 'package:flutter/material.dart';
import 'package:lets_go/screens/FabTabs.dart';
import 'package:lets_go/constans.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyBopLmS7xqMMu113JR3iOH5rViqEVTj8qA',
        appId: '1:929569094769:android:e22414ebb665d548d6efd0',
        messagingSenderId: '929569094769',
        projectId: 'tensaiproject-2e8cc'),
  );
  print("started");
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EthA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Monocraft",
        colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: kPrimaryColor,
            onPrimary: kTextWhiteColor,
            secondary: kSecondaryColor,
            onSecondary: kTextBlackColor,
            error: kErrorBorderColor,
            onError: kTextWhiteColor,
            background: Colors.white,
            onBackground: kTextBlackColor,
            surface: kTextLightColor,
            onSurface: kTextBlackColor),
      ),
      home: Fabs(),
    );
  }
}
