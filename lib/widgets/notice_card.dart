import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wechat/api/apis.dart';
import 'package:wechat/helpers/my_date_uti.dart';
import 'package:wechat/models/notice_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../helpers/dialogs.dart';
import '../main.dart';
import '../screens/bottom_sheet.dart';

class NoticeCard extends StatefulWidget {
  const NoticeCard({super.key, required this.noteMod});
  final NoticeModel noteMod;

  @override
  State<NoticeCard> createState() => _NoticeCardState();
}

class _NoticeCardState extends State<NoticeCard> {



  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.user.uid == widget.noteMod.id;

    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_) => BottomSheetScreen()));
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: mq.width*.04,vertical: 4),
        elevation: 0.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(

          leading: ClipRRect(
            borderRadius: BorderRadius.circular(mq.height*.05),
            child: CachedNetworkImage(
                imageUrl: widget.noteMod.image,
                width: mq.height*.055,
                height: mq.height*.055,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => CircleAvatar(child: Icon(CupertinoIcons.person),),
            ),
          ),
          title: widget.noteMod.type.toString() == "2" ? Text('${widget.noteMod.name + ' đã gửi lời mời kết bạn \n ${MyDateUtil.getLastMessageTime(context: context, time: widget.noteMod.time)}'} ${widget.noteMod.noiDung}')  : Text('${widget.noteMod.name + ' đã đăng \n ${MyDateUtil.getLastMessageTime(context: context, time: widget.noteMod.time)}'} ${widget.noteMod.noiDung}'),
          subtitle:widget.noteMod.email.toString() != APIs.auth.currentUser!.email ? ElevatedButton(
              onPressed: () async {
                await APIs.addChatUser(widget.noteMod.email);
                Dialogs.showSnacker(context, 'Đã thêm thành công');
              },
              child: Text("Chấp nhận lời mời")
          ) : Text(''),
          trailing: InkWell(
             onTap: () {
               _showBottomSheetMore(isMe);
             },
              child: Icon(Icons.more_vert)
          ),
        ),
      ),
    );
  }
  void _showBottomSheetMore(bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              Container(
            height: 4,
            margin: EdgeInsets.symmetric(vertical: mq.height*.015,horizontal: mq.width*.4),
            decoration:
            BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(8)),),
              _OpionItem(
                  icon: Icon(Icons.delete_forever,color: Colors.blue,size: 26,),
                  name: 'Delete Post',
                  onTap: () {
                    APIs.gedeleteNotice(widget.noteMod.time);
                    Dialogs.showSnacker(context, 'Delete Post Success');
                    Navigator.pop(context);
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
