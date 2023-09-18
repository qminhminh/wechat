import 'package:flutter/material.dart';
import 'package:wechat/api/apis.dart';
import '../helpers/dialogs.dart';
import '../main.dart';
import '../models/chat_user.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'dialogs/profile_dilog.dart';

class UsersCard extends StatefulWidget {
  final ChatUser user;
  const UsersCard({super.key, required this.user});

  @override
  State<UsersCard> createState() => _UsersCardState();
}

class _UsersCardState extends State<UsersCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * 0.04, vertical: 4),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                // Add your action here when the image is tapped
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * 0.3),
                child: CachedNetworkImage(
                  width: mq.height * 0.1, // Increase the image size
                  height: mq.height * 0.1, // Increase the image size
                  imageUrl: widget.user.image,
                  placeholder: (context, url) =>
                      CircularProgressIndicator(),
                  errorWidget: (context, url, error) => CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16), // Add spacing between image and text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user.name,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8), // Add spacing between name and buttons
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          // Add your action for "Thêm bạn bè" button here
                          await APIs.sendPudNOtification(widget.user, 'Đã gửi lời mời kết bạn');
                          await APIs.creteNotice('Đã gửi lời mời kết bạn ', "2");
                          Dialogs.showSnacker(context, 'Đã gửi lời mời kết bạn');
                        },
                        child: Text("Thêm bạn bè"),
                      ),
                      SizedBox(width: 8), // Add spacing between buttons
                      ElevatedButton(
                        onPressed: () {
                          // Add your action for "Xóa" button here
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey, // Đặt màu nền của nút thành màu xám
                        ),
                        child: Text("Xóa", style: TextStyle(color: Colors.white)), // Đặt màu chữ thành trắng
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
