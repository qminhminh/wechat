
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';

import '../helpers/my_date_uti.dart';
import '../main.dart';
import '../models/chat_user.dart';

class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ViewProfileScreen({super.key,required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar:AppBar(
          title: Text(widget.user.name),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Joined On: ',style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w500,fontSize: 16),),

            Text(MyDateUtil.getLastMessageTime(context: context, time: widget.user.createdAt,showYear: true),style: TextStyle(color: Colors.black54,fontSize: 16),),
          ],
        ),

        // stream tự động  cập nhật giao diện khi có sự thay đôi
        body:Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.height*.05),
          child: Form(

            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width*.05),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                     Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(mq.height*.1),
                          child: CachedNetworkImage(
                            width: mq.height*.2,
                            height: mq.height*.2,
                            fit: BoxFit.fill,
                            imageUrl: widget.user.image,
                            placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) => CircleAvatar(child: Icon(CupertinoIcons.person),),
                          ),
                        ),

                      ],
                    ),
                    // use profile picture
                    SizedBox(width: mq.width,height: mq.height*.03,),
                    SizedBox(height: mq.height*.03,),
                    Text(widget.user.email,style: TextStyle(color: Colors.black,fontSize: 16),),
                    SizedBox(height: mq.height*.02,),

                    // user about
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('About: ',style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w500,fontSize: 16),),
                        Text(widget.user.about,style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w500,fontSize: 16),),

                      ],
                    )



                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}