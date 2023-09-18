
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat/screens/profile_screen.dart';
import '../api/apis.dart';
import '../helpers/dialogs.dart';
import '../main.dart';
import '../models/chat_user.dart';
import '../widgets/chat_user_card.dart';
import 'bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // for storing all users
  List<ChatUser> list=[];
  // for storing search items
  final List<ChatUser> searchlist=[];
  // for storing search status
  bool _isSearching=false;
  int inde=0;

  @override
  void initState() {
    super.initState();
    APIs.getSetInfo();
    SystemChannels.lifecycle.setMessageHandler((message) {
      if(APIs.auth.currentUser!=null)
     {
       if(message.toString().contains('resume')) APIs.updateActiveStatus(true);
       if(message.toString().contains('pause')) APIs.updateActiveStatus(false);
     }
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hinding keyboard hwen a tap is deteced on screen 
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: WillPopScope(
        // if search is on & back buttonn is pressed then close search
        // or else simple close current screen on back button click
        onWillPop: () {
          if(_isSearching){
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          }
          else{
            return Future.value(true);
          }

        },
        child: Scaffold(
          appBar:AppBar(
            leading: IconButton(
              onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (_)=>BottomSheetScreen())); },
              icon: Icon(Icons.home),

            ),
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
            ):
            Text('Video'),

            actions: [
              IconButton(
                  onPressed: (){
                    setState(() {
                      _isSearching = !_isSearching;
                    });
              }, icon: Icon(_isSearching ? CupertinoIcons.clear_circled_solid : Icons.search)),
              IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>  ProfileScreen(user: APIs.me,)));
              }, icon: Icon(Icons.more_vert)),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
              child: Icon(Icons.add_comment_rounded),
              onPressed: () async{
                _showMessageUpdate();
              },

            ),
          ),
         // stream tự động  cập nhật giao diện khi có sự thay đôi
          body: StreamBuilder(
            stream: APIs.getMyUserId(),
            builder: (context,snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Center(child: CircularProgressIndicator(),); // Thêm trường hợp ConnectionState.none
                case ConnectionState.active:
                case ConnectionState.done:
                   return StreamBuilder(
                     stream: APIs.getAllUser(snapshot.data!.docs.map((e) => e.id).toList() ?? []),
                     builder: (context, snapshot) {
                       switch (snapshot.connectionState) {
                         case ConnectionState.waiting:
                         case ConnectionState.none:
                           return Center(child: CircularProgressIndicator(),); // Thêm trường hợp ConnectionState.none
                         case ConnectionState.active:
                         case ConnectionState.done:
                           final data = snapshot.data?.docs;
                           list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
                           if(list.isNotEmpty){
                             return ListView.builder(
                               itemCount:_isSearching ? searchlist.length : list.length,
                               padding: EdgeInsets.only(top: mq.height * .01),
                               physics: BouncingScrollPhysics(),
                               itemBuilder: (context, index) {
                                 return CharUserCard(user:_isSearching ? searchlist[index] : list[index]);
                                 // return Text('Name: ${list[index].name}'); // Thay thế tên biến phù hợp
                               },
                             );
                           }
                           else{
                             return Center(child: Text('No Connection Found',style: TextStyle(fontSize: 20),));
                           }
                       }
                     },
                   );
                 }
                 // return Center(child: CircularProgressIndicator(strokeWidth: 2,),);

          },
          ),
        ),
      ),
    );
  }


  void _showMessageUpdate(){
    String email='';
    showDialog(context: context,
        builder: (_)=> AlertDialog(
          contentPadding: EdgeInsets.only(left: 24,right: 24,top: 20,bottom: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.person_add,color: Colors.blue,size: 28,),
              Text('  Add User')
            ],
          ),
          content: TextFormField(
            maxLines: null,
            onChanged: (val)=>email=val,
            //onSaved: (val)=> updatedMsg = val!,
            decoration: InputDecoration(
              hintText: 'Email Id',
                prefixIcon: Icon(Icons.email,color: Colors.blue,),
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
              onPressed: () async {
                Navigator.pop(context);
                if(email.isNotEmpty)
                 await APIs.addChatUser(email).then((value) {
                   Dialogs.showSnacker(context, 'Add Success');
                 });
              },
              child: Text('Add',style: TextStyle(fontSize: 16,color: Colors.blue),),
            )
          ],
        )
    );
  }
}
