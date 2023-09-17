import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import '../api/apis.dart';
import '../helpers/dialogs.dart';
import '../helpers/my_date_uti.dart';
import '../main.dart';
import '../models/chat_user.dart';
import '../models/post_comment.dart';
import '../models/publications.dart';
import '../utiliti/PreferenceManager.dart';
import 'comment_card.dart';

class VideoCard extends StatefulWidget {

  final PostU postU;
  final BuildContext context;
  const VideoCard({super.key,required this.postU,required this.context});

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  PreferenceManager preferenceManager=new PreferenceManager();
  bool like=false;
  bool save =false;
  int count=0;
  late VideoPlayerController _videoPlayerController;
  bool isImage = true;
  final textController=TextEditingController();
  late List<PostComment> listcomnet;
  bool _showEmoji=false;
  int co=0;



  @override
  void initState() {
    super.initState();

    if (widget.postU.type == 1) {
      isImage = false;
      // Video
    }
    else{
      isImage = true;
      _videoPlayerController = VideoPlayerController.network(
        widget.postU.urlImgPost,
      )..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized
        setState(() {});
      });
      _videoPlayerController.play();
    }
    count = widget.postU.live;
    co=widget.postU.countcommnet;

  }
  @override
  Widget build(BuildContext context) {
    bool isMe=APIs.user.uid==widget.postU.id;
    return  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[

        Padding(
          padding: const EdgeInsets.only(bottom: 12, left: 12, top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(isImage)
              Row(
                children: <Widget>[
                  // avatar of user
                  CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: widget.postU.urlFoto,
                    placeholder: (context, url) => CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 24.0,),

                    imageBuilder: (context, image) => CircleAvatar(
                      backgroundImage: image,
                      radius: 24.0,),

                    errorWidget: (context, url, error) => CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 24.0,),
                  ),
                  SizedBox(width: 10.0),
                  // name and time
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(isImage)
                      Text(widget.postU.name,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),

                      Row(
                        children: [
                          if(isImage)
                          Text(MyDateUtil.getLastMessageTime(context: context, time: widget.postU.time),style: TextStyle(color: Colors.grey, fontSize: 12.0)),
                          if(isImage)
                          StreamBuilder(
                              stream: APIs.getUserInfoPost(widget.postU.email),
                              builder: (context,snapshot){
                                final data = snapshot.data?.docs;
                                final list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

                                if(list[0].isOnline )
                                { APIs.updateActiveStatusPost(true,widget.postU.time,list[0].pushToken);}
                                else
                                { APIs.updateActiveStatusPost(false,widget.postU.time,list[0].pushToken);}
                                widget.postU.isOnline==list[0].isOnline;
                                return Text('');
                              }
                          ),
                          widget.postU.isOnline  ? Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(color: Colors.greenAccent.shade400,
                                borderRadius: BorderRadius.circular(10)),
                          ):Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(color: Colors.grey,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          if(isImage)
                          SizedBox(width: 5),
                          if(isImage)
                          Icon(Icons.people, size: 14, color: Colors.grey),

                        ],
                      )
                    ],
                  ),
                  if(isImage)
                  Expanded(child: Container()),
                  if(isImage)
                  IconButton(icon: Icon(Icons.more_vert), onPressed: () {
                    _showBottomSheetMore(isMe);
                  }),
                ],
              ),
              // comment of user
              if(isImage)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(widget.postU.text),
              ),
            ],
          ),
        ),
        if(isImage)
        Flexible(
          fit: FlexFit.loose,
          child: Container(
              color: Colors.black12,
              child:  Stack(
                alignment: Alignment.center,
                children: [
                  if(isImage)
                  _videoPlayerController.value.isInitialized
                      ? AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController),
                  )
                      : Container(child: Text('False',style: TextStyle(color: Colors.red),),
                  ),
                  if(isImage)
                  FloatingActionButton(
                    backgroundColor: Colors.grey,
                    onPressed: () {
                      setState(() {
                        if (_videoPlayerController.value.isPlaying) {
                          _videoPlayerController.pause();
                        } else {
                          _videoPlayerController.play();
                        }
                      });
                    },
                    child: Icon(_videoPlayerController.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                  ),
                ],
              )

          ),
        ),
        if(isImage)
        Column(
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Row(
                children: <Widget>[
                  Row(
                    children: [
                      Material(
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(Icons.thumb_up_rounded,color: Colors.white,size: 12,),),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
                        child: Text('${widget.postU.live}', style: TextStyle(fontSize: 16),),),
                    ],
                  ),
                  Expanded(child: Container()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                    child: Text('${widget.postU.countcommnet} comments',style: new TextStyle(color: Colors.grey)),),
                ],
              ),
            ),
            if(isImage)
            Divider(thickness: 1, height: 0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                      onPressed: () {
                        setState(() {
                          like = !like;
                          if (like) {
                            APIs.updateLikeBool(false, widget.postU.time);
                            count--; // Tăng giá trị của count khi like
                          } else {
                            APIs.updateLikeBool(true, widget.postU.time);
                            count++; // Giảm giá trị của count khi bỏ like
                          }
                        });

                        APIs.updateLike(count, widget.postU.time);
                        APIs.sendPudNOtificatPost('liked your post',widget.postU.pushToken);
                      },
                      icon: Icon(Icons.thumb_up_alt_outlined, color:widget.postU.like ? Colors.blue : Colors.grey),
                      label: Text('Like',style: TextStyle(color:widget.postU.like ?  Colors.blue : Colors.grey))),


                  TextButton.icon(
                      onPressed: () {
                        _showBottomSheet();
                      },
                      icon:Icon(Icons.mode_comment_outlined, color: Colors.grey), label: Text('Comment', style: TextStyle(color: Colors.grey))),


                  TextButton.icon(
                      onPressed: () {

                      },
                      icon: Icon(Icons.share_outlined, color: Colors.grey),
                      label: Text('Share', style: TextStyle(color: Colors.grey))),
                ],
              ),
            ),
          ],
        ),
        if(isImage)
        Divider(thickness: 8, color: Colors.black12),
      ],
    );
  }
  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Comment',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: StreamBuilder(
                        stream: APIs.getComment(widget.postU.time),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting ||
                              snapshot.connectionState == ConnectionState.none) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(child: Text('Error loading comments'));
                          }
                          final data = snapshot.data?.docs;
                          listcomnet = data?.map((e) => PostComment.fromJson(e.data())).toList() ?? [];
                          if (listcomnet.isNotEmpty) {
                            return ListView.builder(
                              itemCount: listcomnet.length,
                              itemBuilder: (context, index) {
                                return CommentCard(postComment: listcomnet[index],);
                              },
                              padding: EdgeInsets.only(top: 8),
                              physics: BouncingScrollPhysics(),
                            );
                          } else {
                            return Center(child: Text('No comments yet'));
                          }
                        },
                      ),
                    ),

                    Divider(thickness: 1),
                    _chatInput(),
                    SizedBox(height: 20,)
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _chatInput(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: mq.height*.01,horizontal: mq.width*.025),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  // text feld
                  Expanded(
                      child: TextField(
                        controller: textController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        onTap: (){

                        },
                        decoration: InputDecoration(hintText: '  Type...',hintStyle: TextStyle(color: Colors.blueAccent),border: InputBorder.none),

                      )),
                  // take image from camera
                ],

              ),
            ),
          ),

          // sent message button
          MaterialButton(
            onPressed: (){
              if(textController.text.isNotEmpty){
                co++;
                APIs.sendMessagePostComm(widget.postU.time, textController.text, widget.postU,co);
                Dialogs.showSnacker(context, "Comment success");
                textController.text='';
                APIs.updateCountComment(co, widget.postU.time);
              }

            },
            minWidth: 0,
            padding: EdgeInsets.only(top: 10,bottom: 10,right: 5,left: 10),
            shape: CircleBorder(),
            color: Colors.lightBlueAccent,
            child: Icon(Icons.send,color: Colors.black,size: 28,),
          ),
        ],
      ),
    );
  }

  void _showBottomSheetMore(bool isMe){
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))),
        builder: (_){
          return ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(vertical: mq.height*.015,horizontal: mq.width*.4),
                decoration:
                BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(8)),),

              // option COPY TEXT
              _OpionItem(
                  icon: Icon(Icons.copy_all_rounded,color: Colors.blue,size: 26,),
                  name: 'Copy Text',
                  onTap: (){
                    Clipboard.setData(ClipboardData(text: widget.postU.text)).then((value)
                    {
                      Navigator.pop(context);
                    } );
                  }
              ),
              // option COPY TEXT
              if(widget.postU.type==1)
                _OpionItem(
                    icon: Icon(Icons.add,color: Colors.blue,size: 26,),
                    name: 'Save Image',
                    onTap: () async {
                      try {
                        var response = await Dio().get(
                          "${widget.postU.urlImgPost}",
                          options: Options(responseType: ResponseType.bytes),
                        );
                        final result = await ImageGallerySaver.saveImage(
                          Uint8List.fromList(response.data),
                        );
                        if (result != null && result['isSuccess']) {
                          log("Image saved successfully!");
                          Navigator.pop(context);
                          Dialogs.showSnacker(context, 'Save Image Success');
                        } else {
                          log("Image saving failed.");
                        }
                      } catch (error) {
                        log("Error saving image: $error");
                      }
                    }

                ),


              if(isMe)
                Divider(
                  color: Colors.black54,
                  endIndent: mq.width*.04,
                  indent: mq.height*.04,
                ),


              // OPTION DELETE
              if(isMe)
                _OpionItem(
                    icon: Icon(Icons.delete_forever,color: Colors.blue,size: 26,),
                    name: 'Delete Post',
                    onTap: () async {
                      APIs.gedeletePost(widget.postU.time);
                      Dialogs.showSnacker(context, 'Delete Post Success');
                      Navigator.pop(context);
                    }
                ),

              Divider(
                color: Colors.black54,
                endIndent: mq.width*.04,
                indent: mq.height*.04,
              ),

              // SEND TIME
              _OpionItem(
                  icon: Icon(Icons.access_time,color: Colors.blue,size: 26,),
                  name: 'Send post: ${MyDateUtil.getMessgaeTime(context: context, time: widget.postU.time)}',
                  onTap: (){

                  }
              ),

            ],
          );
        }
    );
  }
}
class _OpionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;
  const _OpionItem({required this.icon,required this.name,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=>onTap(),
      child: Padding(
        padding: EdgeInsets.only(left: mq.width*.05,top: mq.height*.015,bottom: mq.height*.025),
        child: Row(
          children: [
            icon,
            Flexible(
                child: Text('    $name',style: TextStyle(fontSize: 15,),)
            ),
          ],
        ),
      ),
    );
  }
}