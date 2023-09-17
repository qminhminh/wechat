
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wechat/screens/auth/login_screen.dart';
import 'package:wechat/screens/bottom_sheet.dart';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2),(){
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));

      if(FirebaseAuth.instance.currentUser!=null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>BottomSheetScreen()));
      }
      else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoginScreen()));
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size; // Initialize mq within build

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: mq.height * .15,
            right:mq.width * .25,
            width: mq.width * .5,
            child: Image.asset('images/chat.png'),
          ),
          Positioned(
            bottom: mq.height * .15,
            width: mq.width * .8,
            // Changed from 0.9 to 0.8
            child: Text('MADE IN VN WITH ❤ 💖',style: TextStyle(fontSize: 16,color: Colors.black,letterSpacing: .5),textAlign: TextAlign.center,),
          ),
        ],
      ),
    );
  }


}
