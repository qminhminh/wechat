import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wechat/widgets/users_card.dart';

import '../../api/apis.dart';
import '../../main.dart';
import '../../models/chat_user.dart';


class BottomprofileScreen extends StatefulWidget {
  const BottomprofileScreen({super.key});

  @override
  State<BottomprofileScreen> createState() => _BottomprofileScreenState();
}

class _BottomprofileScreenState extends State<BottomprofileScreen> {
  List<ChatUser> list=[];
  final List<ChatUser> searchlist=[];
  bool _isSearching=false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: ()=> FocusScope.of(context).unfocus(),
        child: WillPopScope(
        // if search is on & back buttonn is pressed then close search
        // or else simple close current screen on back button click
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          }
          else {
            return Future.value(true);
          }
        },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: (){
                  setState(() {
                    _isSearching = !_isSearching;
                  });
                }, icon: Icon(_isSearching ? CupertinoIcons.clear_circled_solid : Icons.search)),
          ],
          title: _isSearching ? TextField(
          decoration: InputDecoration(
          border: InputBorder.none,
             hintText: 'Name, Text.....',
              ),
           autofocus: true,
    style: TextStyle(fontSize: 16,letterSpacing: 0.5),
    //when search text changes then updatesd search list
    onChanged: (val){
       searchlist.clear();

    for(var i in list){
        if(i.name.toLowerCase().contains(val.toLowerCase()) || i.email.toLowerCase().contains(val.toLowerCase())){
       searchlist.add(i);
       }
        setState(() {
       searchlist;
      });
      }
    },
           ) : Text('Users',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black87),),
        ),
        body: StreamBuilder(
          stream:  APIs.getMyUserId(),
          builder: (context,snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.waiting:
              case ConnectionState.none:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.active:
              case ConnectionState.done:
                 return StreamBuilder(
                     stream: APIs.getAllUersss(snapshot.data?.docs.map((e) => e.id).toList() ?? []),
                     builder: (context,snapshot){
                       switch(snapshot.connectionState){
                         case ConnectionState.waiting:
                         case ConnectionState.none:
                           return Center(child: CircularProgressIndicator(),);
                         case ConnectionState.active:
                         case ConnectionState.done:
                            final data = snapshot.data?.docs;
                            list =data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
                            return ListView.builder(
                              itemCount:_isSearching ? searchlist.length : list.length,
                              padding: EdgeInsets.only(top: mq.height * .01),
                                physics: BouncingScrollPhysics(),
                               itemBuilder: (context,index){
                                 return UsersCard(user: _isSearching ? searchlist[index] : list[index]);
                             }
                         );
                       }
                     }
                 );
            }

          },
        ),
      ),
    )
    );
  }
}
