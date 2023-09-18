
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat/api/apis.dart';
import 'bottom_screen/bottom_home_screen.dart';
import 'bottom_screen/bottom_notice_screen.dart';
import 'bottom_screen/bottom_video_screen.dart';
import 'bottom_screen/bottom_profile_screen.dart';

class BottomSheetScreen extends StatefulWidget {
  BottomSheetScreen({Key? key}) : super(key: key);

  @override
  State<BottomSheetScreen> createState() => _BottomSheetScreenState();
}

class _BottomSheetScreenState extends State<BottomSheetScreen> {
  List<Widget> pages = [
    BottomHomeScreen(),
    BottomVideoScreen(),
    BottomNoticeScreen(),
    BottomprofileScreen()
  ];

  @override
  void initState() {
    super.initState();
    SystemChannels.lifecycle.setMessageHandler((message) {
      if(APIs.auth.currentUser!=null)
      {
        if(message.toString().contains('resume')) APIs.updateActiveStatus(true);
        if(message.toString().contains('pause')) APIs.updateActiveStatus(false);
      }
      return Future.value(message);
    });
  }

  int currentIndex = 0;

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTap,
        currentIndex: currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.video_collection_outlined), label: 'Video'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_active_outlined), label: 'Notice'),
          BottomNavigationBarItem(icon: Icon(Icons.person_search), label: 'Users'),
        ],
      ),
    );
  }
}
