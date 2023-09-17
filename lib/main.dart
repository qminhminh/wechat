import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:wechat/screens/splash_screen.dart';
import 'firebase_options.dart';


late Size mq;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]).then((value) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
   _initializeFirebase();
    // Khởi tạo Firebase trước khi runApp
    runApp(MyApp());
  });
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeChat',  // Removed extra spaces from the title
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 1,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            fontFamily: 'YourFontFamily', // Specify the actual font family
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 19,
          ),
          backgroundColor: Colors.white,
        ),
      ),
      home: SplashScreen(),
    );
  }
}
_initializeFirebase() async{


  var result = await FlutterNotificationChannel.registerNotificationChannel(
    description: 'For Showing Messgae',
    id: 'Chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Your channel name',

  );
  log('Notifi Chanal: '+result);
}