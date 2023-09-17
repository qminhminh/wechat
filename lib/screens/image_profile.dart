import 'dart:developer';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../helpers/dialogs.dart';
import '../models/message.dart';

class ImageProfile extends StatefulWidget {
  Message message;
  ImageProfile({super.key,required this.message});

  @override
  State<ImageProfile> createState() => _ImageProfileState();
}

class _ImageProfileState extends State<ImageProfile> {
  double imageScale = 1.0; // Initialize the image scale
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile Image'),
          actions: [
            IconButton(
                onPressed: () async {
                  try {
                    var response = await Dio().get(
                      "${widget.message.msg}",
                      options: Options(responseType: ResponseType.bytes),
                    );
                    final result = await ImageGallerySaver.saveImage(
                      Uint8List.fromList(response.data),
                    );
                    if (result != null && result['isSuccess']) {
                      log("Image saved successfully!");
                      Dialogs.showSnacker(context, 'Save Image Success');
                    } else {
                      log("Image saving failed.");
                    }
                  } catch (error) {
                    log("Error saving image: $error");
                  }
                },
                icon: Icon(Icons.download)
            ),
          ],
        ),
        body: Center(
          child: InkWell(
            onDoubleTap: (){
              setState(() {
                // Toggle the image scale between 1.0 (original) and 2.0 (enlarged)
                imageScale = imageScale == 1.0 ? 2.0 : 1.0;
              });
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Transform.scale(
                scale: imageScale, // Apply the scale to the image
                child: CachedNetworkImage(
                  imageUrl: widget.message.msg,
                  placeholder: (context, url) => Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.image,size: 70,),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
