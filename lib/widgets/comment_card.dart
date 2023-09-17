
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../helpers/my_date_uti.dart';
import '../main.dart';
import '../models/post_comment.dart';


class CommentCard extends StatefulWidget {
  final PostComment postComment;
  const CommentCard({super.key, required this.postComment});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: InkWell(
        onTap: (){},
        child: ClipRRect(
          borderRadius: BorderRadius.circular(mq.height*.3),
          child: CachedNetworkImage(
            width: mq.height*.055,
            height: mq.height*.055,
            imageUrl: widget.postComment.img,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => CircleAvatar(child: Icon(CupertinoIcons.person),),
          ),
        ),
      ),
      title: Text('${widget.postComment.name}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
      subtitle: Text('${widget.postComment.text}',style: TextStyle(fontSize: 14),),
      trailing:   Text(MyDateUtil.getMessgaeTime(context: context, time:widget.postComment.time)),
    );
  }
}
