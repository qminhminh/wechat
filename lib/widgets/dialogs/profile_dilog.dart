
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../main.dart';
import '../../models/chat_user.dart';
import '../../screens/view_profile_screen.dart';

class ProfileDialog extends StatefulWidget {
 final ChatUser user;
  const ProfileDialog({super.key, required this.user});

  @override
  State<ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
      content: SizedBox(
        width: mq.width*.6,
        height: mq.height*.35,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(mq.height*.1),
                child: CachedNetworkImage(
                  width: mq.width*.5,
                  fit: BoxFit.fill,
                  imageUrl: widget.user.image,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => CircleAvatar(child: Icon(CupertinoIcons.person),),
                ),
              ),
            ),
            Positioned(
                left: mq.width*.04,
                top: mq.height*.02,
                width: mq.width*.55,
                child: Text(widget.user.name,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),)),

            Positioned(
              right: 8,
              top: 4,
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>ViewProfileScreen(user: widget.user)));
                  },
                  icon: Icon(Icons.info_outline,color: Colors.blue,size: 30,),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
