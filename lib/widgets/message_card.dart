
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import '../api/apis.dart';
import '../helpers/dialogs.dart';
import '../helpers/my_date_uti.dart';
import '../main.dart';
import '../models/message.dart';
import '../screens/image_profile.dart';

class MessageCard extends StatefulWidget {
  final Message message;
  const MessageCard({super.key, required this.message});
  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe=APIs.user.uid==widget.message.fromId;
     return InkWell(
       onLongPress: (){
         _showBottomSheet(isMe);
       },
       child: isMe ? _greenMessage() : _blueMessage(),);

  }

  // send or another user message
  Widget _blueMessage(){

    //update laset read mess if sneder and recevier are different
    if(widget.message.read.isEmpty){
      APIs.updateMessageReadStatus(widget.message);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width*.04),
            margin: EdgeInsets.symmetric(horizontal: mq.height*.04, vertical: mq.height*.01),
            decoration: BoxDecoration(border: Border.all(color: Colors.lightBlue),color: Colors.blue.shade50,borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),bottomRight: Radius.circular(30))),
            child:
                widget.message.type ==Type.text ?
                Text(widget.message.msg,style: TextStyle(fontSize: 15,color: Colors.black54),)
                    :
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),  // You need to have 'mq' defined
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

        // time
        Padding(
          padding: EdgeInsets.only(right: mq.width*.04),
          child: Text(MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),style: TextStyle(fontSize: 13,color: Colors.black54),),
        ),
         SizedBox(width: mq.width*.04,)
      ],

    );
  }

  // our or user message
  Widget _greenMessage(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        
        // time
        Row(
          children: [
            SizedBox(width: mq.width*.04,),
            if(widget.message.read.isNotEmpty)
               Icon(Icons.done_all_rounded,color: Colors.blue,size: 20,),

            SizedBox(width: 2,),
            Text('${MyDateUtil.getFormattedTime(context: context, time: widget.message.sent)}',style: TextStyle(fontSize: 13,color: Colors.black54),),
          ],
        ),

        // message
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width*.04),
            margin: EdgeInsets.symmetric(horizontal: mq.height*.04, vertical: mq.height*.01),
            decoration: BoxDecoration(border: Border.all(color: Colors.lightGreen),color: Colors.green.shade50,borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),bottomLeft: Radius.circular(30))),
            child:
            widget.message.type ==Type.text ?
            Text(widget.message.msg,style: TextStyle(fontSize: 15,color: Colors.black54),)
                :
            ClipRRect(
              borderRadius: BorderRadius.circular(15),  // You need to have 'mq' defined
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
      ],


    );
  }

 // botom sheet
  void _showBottomSheet(bool isMe){
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


              widget.message.type== Type.text ?
              // option COPY TEXT
              _OpionItem(
                  icon: Icon(Icons.copy_all_rounded,color: Colors.blue,size: 26,),
                  name: 'Copy Text',
                  onTap: (){
                    Clipboard.setData(ClipboardData(text: widget.message.msg)).then((value)
                    {
                      Navigator.pop(context);
                    } );
                  }
              ):
              // option COPY TEXT
              _OpionItem(
                  icon: Icon(Icons.add,color: Colors.blue,size: 26,),
                  name: 'Save Image',
                  onTap: () async {
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

              if( widget.message.type== Type.image)
                _OpionItem(
                    icon: Icon(Icons.info_outline,color: Colors.blue,size: 26,),
                    name: 'Image Profile',
                    onTap: (){
                         Navigator.push(context, MaterialPageRoute(builder: (_)=> ImageProfile(message: widget.message)));
                    }
                ),



              if(isMe)
              Divider(
                color: Colors.black54,
                endIndent: mq.width*.04,
                indent: mq.height*.04,
              ),

              // OPTION EDIT
              if(widget.message.type==Type.text && isMe)
              _OpionItem(
                  icon: Icon(Icons.edit,color: Colors.blue,size: 26,),
                  name: 'Edit Message',
                  onTap: (){

                    Navigator.pop(context);
                    _showMessageUpdate();
                  }
              ),

              // OPTION DELETE
              if(isMe)
              _OpionItem(
                  icon: Icon(Icons.delete_forever,color: Colors.blue,size: 26,),
                  name: 'Delete Messgase',
                  onTap: () async {
                    await APIs.gedeleteMessa(widget.message).then((value) {
                      Navigator.pop(context);
                       Dialogs.showSnacker(context, 'Delete Success');
                     });
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
                  name: 'Send at: ${MyDateUtil.getMessgaeTime(context: context, time: widget.message.sent)}',
                  onTap: (){

                  }
              ),

              // READ TIME
              _OpionItem(
                  icon: Icon(Icons.remove_red_eye,color: Colors.blue,size: 26,),
                  name: widget.message.read.isEmpty ? 'Read at: Not seen yet' :
                  'Read at: ${MyDateUtil.getMessgaeTime(context: context, time: widget.message.read)}',
                  onTap: (){

                  }
              ),

            ],
          );
        }
    );
  }
  void _showMessageUpdate(){
    String updatedMsg=widget.message.msg;
    showDialog(context: context,
        builder: (_)=> AlertDialog(
          contentPadding: EdgeInsets.only(left: 24,right: 24,top: 20,bottom: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.message,color: Colors.blue,size: 28,),
              Text('  Update Message')
            ],
          ),
          content: TextFormField(
            maxLines: null,
            onChanged: (val)=>updatedMsg=val,
            //onSaved: (val)=> updatedMsg = val!,
            initialValue: updatedMsg,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15)
                )
            ),
          ),
          actions: [

            MaterialButton(
                onPressed: (){ Navigator.pop(context);},
              child: Text('Cancle',style: TextStyle(fontSize: 16,color: Colors.blue),),
            ),

            MaterialButton(
              onPressed: (){
                Navigator.pop(context);
                APIs.UpdateMessa(widget.message, updatedMsg);
              },
              child: Text('Update',style: TextStyle(fontSize: 16,color: Colors.blue),),
            )
          ],
        )
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

