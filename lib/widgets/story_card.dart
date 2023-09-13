import 'dart:async';


import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../api/apis.dart';
import '../models/strory.dart';

class StoryCard extends StatefulWidget {
  final StoryU storyU;
  const StoryCard({super.key, required this.storyU});

  @override
  State<StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard> {

  late Timer _timer;
  @override
  void initState() {
    super.initState();
    startStoryExpirationTimer(); // Bắt đầu tính thời gian tồn tại story
  }

  void startStoryExpirationTimer() {
    final int twentyFourHoursInMillis = 24 * 60 * 60 * 1000; // 24 giờ

    final int currentTimeInMillis = DateTime.now().millisecondsSinceEpoch;
    final int storyTimeInMillis = int.tryParse(widget.storyU.time) ?? 0;
    final int remainingTimeInMillis = storyTimeInMillis + twentyFourHoursInMillis - currentTimeInMillis;

    if (remainingTimeInMillis > 0) {
      _timer = Timer(Duration(milliseconds: remainingTimeInMillis), () {
        // Xóa story sau 24 giờ
        setState(() {
          // Thực hiện xóa story trong danh sách hoặc hiển thị một cách thích hợp
           APIs.gedeleteCStory(widget.storyU.time);
        });
      });
    } else {

      // Story đã hết hạn ngay từ ban đầu
      // Thực hiện xóa story trong danh sách hoặc hiển thị một cách thích hợp
    }
  }

  @override
  void dispose() {
    _timer.cancel(); // Hủy Timer khi Widget bị hủy
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(left: 8),
      child: Card(
        shadowColor: Colors.grey.shade200,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        elevation: 3,
        clipBehavior: Clip.antiAlias,
        child: Container(
          width: 85,
          height: 160,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                  fadeInDuration: Duration(milliseconds: 200),
                  fit: BoxFit.cover,
                  imageUrl: widget.storyU.story,
                  placeholder: (context, urlImage) =>
                      Container(color: Colors.grey),
                  errorWidget: (context, urlImage, error) => Center(
                      child: Icon(Icons.music_note,
                          size: 50.0, color: Colors.white))),
              Padding(
                padding: const EdgeInsets.only(top: 70),
                child: Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 18),
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.white10,
                          Colors.white70
                        ]),
                      ),
                    ),
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 19,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundImage: CachedNetworkImageProvider(
                              widget.storyU.avatar
                            ),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        Expanded(child: Center(
                          child: Text('${widget.storyU.name}',style: TextStyle(fontSize: 12,color: Colors.white,fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                        )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }
}
