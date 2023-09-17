
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import '../api/apis.dart';
import '../models/chat_user.dart';
import 'constants.dart';

class CallPage extends StatelessWidget {
  final ChatUser chatUser;
  final String callID;
  const CallPage({Key? key, required this.callID, required this.chatUser}) : super(key: key);


  @override
  Widget build(BuildContext context) {


    return ZegoUIKitPrebuiltCall(
      appID: MyConst.appId, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign: MyConst.appSign, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID: APIs.me.id,
      userName: APIs.me.name,
      callID: callID,
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
        ..onOnlySelfInRoom = (context) => Navigator.of(context).pop(),
    );
  }
}