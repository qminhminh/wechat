import 'package:flutter/material.dart';
import 'package:wechat/models/chat_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wechat/screens/chat_screen.dart';

import '../../api/apis.dart';
import '../../helpers/dialogs.dart';


class ProfileUsersScreen extends StatefulWidget {
  const ProfileUsersScreen({super.key, required this.chatUser});
  final ChatUser chatUser;

  @override
  State<ProfileUsersScreen> createState() => _ProfileUsersScreenState();
}

class _ProfileUsersScreenState extends State<ProfileUsersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: CustomScrollView(
            slivers: [
             SliverPersistentHeader(delegate: MySliverAppBar(expandedHeight: 200, chatUser: widget.chatUser,),pinned: true,),
              sliverBody(context: context),
            ],
          )
      ),
    );
  }

  SliverList sliverBody({required BuildContext context}){
    return SliverList(
        delegate: SliverChildListDelegate(
          [
            Padding(padding: EdgeInsets.only(top: 100),child: profileInfo(context: context),),
            Padding(padding: EdgeInsets.symmetric(horizontal: 12),child: widgetButton(),),
            Padding(padding: EdgeInsets.symmetric(vertical: 20),child: contentInfo(),),
            Padding(padding: EdgeInsets.symmetric(horizontal: 20),child: contentFriends(context:context),),
            Padding(padding: EdgeInsets.symmetric(vertical: 20),child: listFiends(),),
            SizedBox(height: 100,width: double.infinity,),
          ]
        ),
    );
  }

  // Widget component
 Widget profileInfo({required BuildContext context}){
    return Column(
      children: <Widget>[
        Column(
          children: [
            Padding(
                padding: EdgeInsets.all(8.0),
              child: Text(widget.chatUser.name,style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(widget.chatUser.about,style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white30 : Colors.black38),),
            ),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('864',style: TextStyle(fontWeight: FontWeight.bold,),),
                        SizedBox(width: 8,),
                        Text('images',style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal,color:Theme.of(context).brightness == Brightness.dark ? Colors.white60 : Colors.black54 ),),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('2.8k',style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(width: 8,),
                        Text('seguidores',style: TextStyle(fontWeight: FontWeight.normal,color: Theme.of(context).brightness == Brightness.dark ? Colors.white60 : Colors.black54),)
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
 }

// wideget Buttons
 Widget widgetButton(){
    return Row(
      children: [
        Expanded(
          flex: 1,
            child:  ElevatedButton.icon(
                onPressed: () async {
                  await APIs.sendPudNOtification(widget.chatUser, 'Đã gửi lời mời kết bạn');
                  await APIs.creteNotice('Đã gửi lời mời kết bạn ', "2");
                  Dialogs.showSnacker(context, 'Đã gửi lời mời kết bạn');
                },
                icon: Icon(Icons.person_add,size: 20,), 
                label: Text('Add friends'),
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(12),
                shadowColor: MaterialStateProperty.all(Colors.blue[300]),
                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 18,vertical: 12)),
                backgroundColor: MaterialStateProperty.all<Color?>(Colors.blue[400]),
                shape: MaterialStateProperty.all<StadiumBorder>(StadiumBorder(side: BorderSide(color: Colors.transparent))),
              ),
            ),
        ),
        SizedBox(width: 12,),
        Expanded(
          flex: 1,
          child:  ElevatedButton.icon(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(user: widget.chatUser)));
            },
            icon: Icon(Icons.chat_bubble,size: 20,color: Colors.black,),
            label: Text('Chat',style: TextStyle(color: Colors.black),),
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 18,vertical: 12)),
              backgroundColor: MaterialStateProperty.all<Color?>(Colors.grey[300]),
              shape: MaterialStateProperty.all<StadiumBorder>(StadiumBorder(side: BorderSide(color: Colors.transparent))),
            ),
          ),
        ),
        SizedBox(width: 12,),
        Expanded(
          flex: 1,
          child:  ElevatedButton.icon(
            onPressed: (){

            },
            icon: Icon(Icons.more_horiz,size: 20,color: Colors.black,),
            label: Text('More',style: TextStyle(color: Colors.black),),
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 18,vertical: 12)),
              backgroundColor: MaterialStateProperty.all<Color?>(Colors.grey[300]),
              shape: MaterialStateProperty.all<StadiumBorder>(StadiumBorder(side: BorderSide(color: Colors.transparent))),
            ),
          ),
        ),
      ],
    );
 }

 // contentInfo()
 Widget contentInfo(){
    Color colorIcon = Colors.grey;
    TextStyle textStyle = TextStyle(fontWeight: FontWeight.normal);
    return Container(
      color: Colors.grey.withOpacity(0.1),
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.location_on,color: colorIcon,),
              SizedBox(width: 8,),
              Text('44/12 ,16A',style: textStyle,),
            ],
          ),
          SizedBox(height: 8,),
          Row(
            children: [
              Icon(Icons.web,color: colorIcon,),
              SizedBox(width: 8,),
              Text('minhminh',style: textStyle,),
            ],
          ),
          SizedBox(height: 8,),
          Row(
            children: [
              Icon(Icons.person,color: colorIcon,),
              SizedBox(width: 8,),
              Text('Ma information',style: textStyle,),
            ],
          ),
        ],
      ),
    );
 }

 // contentFriends
 Widget contentFriends({required BuildContext context}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Amigos',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                    Text('864-3 amigos en conmon',style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white60 : Colors.black54),)
                  ],
                )
            ),
            ElevatedButton(
                onPressed: (){

                },
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  shadowColor: MaterialStateProperty.all(Colors.blue[300]),
                  padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 18,vertical: 12)),
                  backgroundColor: MaterialStateProperty.all<Color?>(Colors.grey[300]),
                  shape: MaterialStateProperty.all<StadiumBorder>(StadiumBorder(side: BorderSide(color: Colors.transparent))),
                ),
                child: Text('Ver todos',style: TextStyle(color: Colors.black),),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Stack(
            children: [
              avatar(urlImage: 'https://blogphanmem.vn/wp-content/uploads/2022/09/9_anh-dai-dien-zalo-dep-nhat.jpg',margin: EdgeInsets.only(left: 60),size: 50),
              avatar(urlImage: 'https://blogphanmem.vn/wp-content/uploads/2022/09/21_anh-dai-dien-zalo-dep-nhat.jpg',margin: EdgeInsets.only(left: 30),size: 50),
              avatar(urlImage: 'https://pgdgiolinhqt.edu.vn/wp-content/uploads/2023/04/hinh-anh-avatar-dep-cute-ngau.jpg',margin: EdgeInsets.only(left: 0),size: 50),

            ],
          ),
        ),
      ],
    );
 }

 // avatar
 Widget avatar({String urlImage = 'default',double size = 50, EdgeInsetsGeometry margin = EdgeInsets.zero,double elevetion = 5}){
    return Container(
      margin: margin,
      height: size,
      width: size,
      child: Material(
        borderRadius: BorderRadius.circular(100),
        elevation: elevetion,
        color: Colors.white,
        child: CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey,
          backgroundImage: NetworkImage(urlImage),
        ),
      ),
    );
 }

// listFiends()
 Widget listFiends(){
    return Container(
      height: 150,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          card(urlAvatar: 'https://blogphanmem.vn/wp-content/uploads/2022/09/9_anh-dai-dien-zalo-dep-nhat.jpg',name: 'Hồng Yến',padding: EdgeInsets.only(bottom: 12,top: 12,left: 12,right: 0)),
          card(urlAvatar: 'https://blogphanmem.vn/wp-content/uploads/2022/09/21_anh-dai-dien-zalo-dep-nhat.jpg',name: 'Hương Giang',padding: EdgeInsets.only(bottom: 12,top: 12,left:5,right: 0)),
          card(urlAvatar: 'https://pgdgiolinhqt.edu.vn/wp-content/uploads/2023/04/hinh-anh-avatar-dep-cute-ngau.jpg',name: 'Trúc Ly',padding: EdgeInsets.only(bottom: 12,top: 12,left:5,right: 0)),
          card(urlAvatar: 'https://i.pinimg.com/550x/bb/b4/18/bbb418fa565ecb915e03dad41ad4a0e3.jpg',name: 'Ngọc Hân',padding: EdgeInsets.only(bottom: 12,top: 12,left:5,right: 0)),
          card(urlAvatar: 'https://toigingiuvedep.vn/wp-content/uploads/2022/11/hinh-anh-avatar-cute-de-thuong.jpg',name: 'Khánh linh',padding: EdgeInsets.only(bottom: 12,top: 12,left:5,right: 0)),
        ],
      ),
    );
 }

 //  card
 Widget card({String name = 'Minh',String urlAvatar = 'default',EdgeInsetsGeometry padding = EdgeInsets.zero}){
    return Padding(
      padding: padding,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        elevation: 8,
        clipBehavior: Clip.antiAlias,
        child: Container(
          width: 85,
          height: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                  imageUrl: urlAvatar,
                fadeInDuration: Duration(milliseconds: 200),
                fit: BoxFit.cover,
                placeholder: (context, urlImage) => Container(color: Colors.grey[100],),
                errorWidget: (context, urlImage, error) => Center(child: Container(color: Colors.grey[100],),),
              ),
              Padding(
                padding: EdgeInsets.only(top: 70),
                child: Container(
                  margin: EdgeInsets.only(top: 18),
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Center(
                      child: Text(name,style: TextStyle(fontSize: 10,color: Colors.black,fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
 }

}

// MysliverApp Bar

class MySliverAppBar extends SliverPersistentHeaderDelegate{
  final double expandedHeight;
  final ChatUser chatUser;

  MySliverAppBar({required this.expandedHeight,required this.chatUser});


  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        CachedNetworkImage(
            imageUrl: chatUser.image,
            fadeInDuration: Duration(milliseconds: 200),
          fit: BoxFit.cover,
          placeholder: (context,imgUrl) => Container(color: Colors.grey,),
          errorWidget: (context,imgUrl,error) => Center(child: Container(color: Colors.grey,)),
        ),
        Align(
          alignment: Alignment.topRight,
          child:  Padding(
            padding: EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: (){

            }, icon: Icon(Icons.search,color: Colors.white,size: 30,)
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child:  Padding(
            padding: EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back,color: Colors.white,size: 30,)
            ),
          ),
        ),
        Opacity(
            opacity: shrinkOffset / expandedHeight,
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Row(
              children: [
                IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(Icons.arrow_back)),
                Expanded(child: Container()),
                IconButton(onPressed: (){}, icon: Icon(Icons.search)),
              ],
            ),
          ),
        ),
        Positioned(
          top: expandedHeight / 2- shrinkOffset,
            left: MediaQuery.of(context).size.width / 3.5,
            child: Opacity(
                opacity: (1- shrinkOffset/ expandedHeight),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white,width: 3),
                ),
                child: SizedBox(
                  height: expandedHeight,
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: CircleAvatar(
                    radius: 41.0,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(chatUser.image),
                  ),
                ),
              ),
            )
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate) => true;

}
