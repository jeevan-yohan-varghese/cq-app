import 'package:cq_app/screens/bottom_nav_screen.dart';
import 'package:cq_app/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp( MyApp());
  //await dotenv.load(fileName: ".env");
      
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
final ThemeData theme = ThemeData();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'CQ App',
      debugShowCheckedModeBanner: false,
      theme:ThemeData(
          
          fontFamily: 'Poppins',
          brightness: Brightness.light,
          colorScheme: theme.colorScheme.copyWith(
              brightness: Brightness.light,
              secondary: const Color(0xff4CB5AE),
              primary: const Color(0xff677AF3)),
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          }),
        ),
      home: BottomNavScreen(),
    );
  }
}



