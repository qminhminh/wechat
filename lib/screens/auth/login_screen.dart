
import 'dart:io';


import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

import '../../api/apis.dart';
import '../../helpers/dialogs.dart';
import '../../main.dart';
import '../bottom_sheet.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
   // Declare the Size variable for MediaQuery usage
  bool _isAnimate=false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500),(){
      setState(() {
        _isAnimate=true;
      });
    });
  }
  // dang nhap bang google sau khi thanh cong chuyen qua trang home
  _hanldeGoogleBTnClick(){

    Dialogs.showProgressBar(context);

    signInWithGoogle().then((user) async{
      Navigator.pop(context);
      if(user!=null){
        log('\nUser: ${user.user}');
        log('\nUserAdditionalInfo: ${user.additionalUserInfo}');
        if(await APIs.userExixts()){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>BottomSheetScreen()));
        }
        else{
          await APIs.createUser().then((value) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>BottomSheetScreen()));
          });
        }

      }
    });
  }

  Future<UserCredential?> signInWithGoogle() async {
   try{
     await InternetAddress.lookup('google.com');
     // Trigger the authentication flow
     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

     // Obtain the auth details from the request
     final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

     // Create a new credential
     final credential = GoogleAuthProvider.credential(
       accessToken: googleAuth?.accessToken,
       idToken: googleAuth?.idToken,
     );

     // Once signed in, return the UserCredential
     return await FirebaseAuth.instance.signInWithCredential(credential);
   }
       catch(e){
          log('\n_signinwithgoogle: $e');
          Dialogs.showSnacker(context, 'Something went Wrong Check Internet');
          return null;
       }
  }
  @override
  Widget build(BuildContext context) {
   // mq = MediaQuery.of(context).size; // Initialize mq within build

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Welcome to WeChat'), // Corrected the title spelling
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
            top: mq.height * .15,
            right:_isAnimate? mq.width * .25: -mq.width * .5,
            width: mq.width * .5,
            duration: Duration(seconds: 1),
            child: Image.asset('images/chat.png'),
          ),
          Positioned(
            bottom: mq.height * .15,
            left: mq.width * .05,
            width: mq.width * .8,
            height: mq.height*.07,
            // Changed from 0.9 to 0.8
            child: ElevatedButton.icon(
              onPressed: () {
                _hanldeGoogleBTnClick();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade300,
                  shape: StadiumBorder(),
                  elevation: 1
              ),
              icon: Image.asset('images/google.png',height: mq.height*.03,),
              label: Text('Sign in with Google',style: TextStyle(color: Colors.black,fontSize: 16),), // Corrected the label spelling
            ),
          ),
        ],
      ),
    );
  }


}
