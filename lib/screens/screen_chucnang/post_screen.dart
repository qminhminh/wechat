import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../../api/apis.dart';
import '../../helpers/dialogs.dart';
import '../../main.dart';
import '../../models/chat_user.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  String? _image;
  File? _video;
  final textController=TextEditingController();
  String? text;
 late VideoPlayerController _videoPlayerController;


  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.asset('assets/default_video.mp4');
    _videoPlayerController.initialize().then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }
  List<ChatUser> list=[];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:() => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create post'),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.only(left: 6,right: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          width: 40,
                          height: 40,
                          fit: BoxFit.fill,
                          imageUrl: APIs.auth.currentUser!.photoURL.toString(),
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => CircleAvatar(child: Icon(CupertinoIcons.person),),
                        ),
                      ),
                      SizedBox(width: 20,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(APIs.auth.currentUser!.displayName.toString(),style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
                          Text(APIs.auth.currentUser!.email.toString(),style: TextStyle(color: Colors.black54,fontSize: 16),),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),

                  // Text input noi dung
                  TextField(
                    controller: textController,
                    decoration:InputDecoration(
                       border: InputBorder.none,
                       hintText: 'Input text...',
                    ),
                    autofocus: true,
                    style: TextStyle(fontSize: 16,letterSpacing: 0.5),

                  ),
                  SizedBox(height: 5,),

                  if(_image!=null)
                    Center(
                      child: ClipRRect(
                        child: Image.file(
                          File(_image!),
                          height: 400,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),



                  if(_video!=null)
                    _videoPlayerController.value.isInitialized
                    ? AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController),
                    )
                        : Container(child: Text('False',style: TextStyle(color: Colors.red),),),
                  if(_video!=null)
                   FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _videoPlayerController.value.isPlaying
                            ? _videoPlayerController.pause()
                            : _videoPlayerController.play();
                      });
                    },
                    child: Icon(
                      _videoPlayerController.value.isPlaying ? Icons.pause : Icons.play_arrow,color: _videoPlayerController.value.isPlaying ?  Colors.transparent :Colors.white54,
                    ),
                  ),

                  SizedBox(height: 5,),
                  Row(
                    children: [
                      IconButton(
                          onPressed: (){
                              _showBottomSheet();
                          },
                          icon: Icon(Icons.add_a_photo)
                      ),

                      Text('Camera or Galary',style: TextStyle(fontSize: 17,),)
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: (){
                            _showBottomSheetVideo();
                          },
                          icon: Icon(Icons.video_collection)
                      ),

                      Text('Video or Galary Video',style: TextStyle(fontSize: 17,),)
                    ],
                  ),
                   // Button dang ca nhan hoac cong dong
                  SizedBox(height: 5,),
                  Center(
                    child: Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {

                            if(_image !=null || _video !=null ) {
                              await APIs.createPostMyFrends(
                                  _image != null ? 1 : 0, textController.text,
                                  _image != null ? File(_image!) : _video!);

                              Dialogs.showSnacker(context, 'Post Success');
                              await APIs.creteNotice(textController.text, _image != null ? "1" : "0");
                              Navigator.pop(context);
                            }
                            else{
                              Dialogs.showSnacker(context, 'No Image or Video . Please choose Image and video ');
                            }

                          },
                          icon: Icon(Icons.edit,size: 28,),
                          style: ElevatedButton.styleFrom(shape: StadiumBorder(),minimumSize: Size(mq.width*.5, mq.height*.06)),
                          label: Text('Posted with friends only',style: TextStyle(fontSize: 16),),

                        ),
                        SizedBox(height: 5,),
                        ElevatedButton.icon(
                          onPressed: () async {
                            if(_image !=null || _video !=null ) {
                              await APIs.createPostPublic(
                                  _image != null ? 1 : 0, textController.text,
                                  _image != null ? File(_image!) : _video!);

                              await APIs.creteNotice(textController.text, _image != null ? "1" : "0");

                              Dialogs.showSnacker(context, 'Post Success');
                              Navigator.pop(context);
                            }
                            else{
                              Dialogs.showSnacker(context, 'No Image or Video . Please choose Image and video ');
                            }
                          },
                          icon: Icon(Icons.edit,size: 28,),
                          style: ElevatedButton.styleFrom(shape: StadiumBorder(),minimumSize: Size(mq.width*.5, mq.height*.06)),
                          label: Text('Posted with public',style: TextStyle(fontSize: 16),),

                        ),
                      ],
                    ),
                  ),

                ],
              ),
          ),
        ),
      ),
    );

  }

  // bototm sheet video
  void _showBottomSheetVideo(){
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))),
        builder: (_){
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: mq.height*.03,bottom: mq.height*.05),
            children: [
              Text('Pick Video',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
              SizedBox(height: mq.height*.02,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final video = await picker.pickVideo(source: ImageSource.gallery);
                        if(video!=null){
                          setState(() {
                              _video = File(video.path);
                          });
                          _videoPlayerController = VideoPlayerController.file(_video!)
                            ..initialize().then((_) {
                              // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                              setState(() {});
                            });
                          _videoPlayerController.play();
                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }

                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: CircleBorder(),
                          fixedSize: Size(mq.width*.3, mq.height*.15)
                      ),
                      child: Image.asset('images/add-image.png')
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an .
                        final video = await picker.pickVideo(source: ImageSource.camera);
                        if(video!=null){
                          setState(() {
                            _video=File(video.path);
                          });
                          _videoPlayerController=VideoPlayerController.file(_video!)
                            ..initialize().then((_) {
                              // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                              setState(() {});
                            });
                          _videoPlayerController.play();

                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: CircleBorder(),
                          fixedSize: Size(mq.width*.3, mq.height*.15)
                      ),
                      child: Image.asset('images/camera.png')
                  ),
                ],
              )
            ],
          );
        }
    );
  }

  //// bottom sheet cammera and galary
  void _showBottomSheet(){
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))),
        builder: (_){
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: mq.height*.03,bottom: mq.height*.05),
            children: [
              Text('Pick Picture',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
              SizedBox(height: mq.height*.02,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image = await picker.pickImage(source: ImageSource.gallery,imageQuality: 80);
                        if(image!=null){
                          setState(() {
                            _image=image.path;
                          });

                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }

                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: CircleBorder(),
                          fixedSize: Size(mq.width*.3, mq.height*.15)
                      ),
                      child: Image.asset('images/add-image.png')
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image = await picker.pickImage(source: ImageSource.camera,imageQuality: 80);
                        if(image!=null){
                          setState(() {
                            _image=image.path;
                          });
                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: CircleBorder(),
                          fixedSize: Size(mq.width*.3, mq.height*.15)
                      ),
                      child: Image.asset('images/camera.png')
                  ),
                ],
              )
            ],
          );
        }
    );
  }

}



