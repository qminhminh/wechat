
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../api/apis.dart';
import '../../main.dart';
import '../../models/publications.dart';
import '../../models/strory.dart';
import '../../widgets/video_card.dart';

class BottomVideoScreen extends StatefulWidget {
  const BottomVideoScreen({super.key});

  @override
  State<BottomVideoScreen> createState() => _BottomVideoScreenState();
}

class _BottomVideoScreenState extends State<BottomVideoScreen> {
  List<StoryU> storylist=[];
  List<PostU> postlist=[];
  List<PostU> searchlist=[];

  bool _isSearching=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching ? TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Name, Email.....',
          ),
          autofocus: true,
          style: TextStyle(fontSize: 16,letterSpacing: 0.5),
          //when search text changes then updatesd search list
          onChanged: (val){
            searchlist.clear();

            for(var i in postlist){
              if(i.text.toLowerCase().contains(val.toLowerCase()) || i.name.toLowerCase().contains(val.toLowerCase())){
                searchlist.add(i);
              }
              setState(() {
                searchlist;
              });
            }
          },
        ):
        Text('We Chat'),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: (){
                setState(() {
                  _isSearching = !_isSearching;
                });
              }, icon: Icon(_isSearching ? CupertinoIcons.clear_circled_solid : Icons.search)),
        ],
      ),
      body: body(context: context),
    );
  }
  Widget body({required BuildContext context}){
    return Stack(
      children: [

        StreamBuilder(
          stream: APIs.getMyUserId(),
          builder: (context,snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return Center(child: CircularProgressIndicator(),); // Thêm trường hợp ConnectionState.none
              case ConnectionState.active:
              case ConnectionState.done:
                return StreamBuilder(
                  stream: APIs.getAllPost(snapshot.data!.docs.map((e) => e.id).toList() ?? []),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Center(child: CircularProgressIndicator(),); // Thêm trường hợp ConnectionState.none
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        postlist = data?.map((e) => PostU.fromJson(e.data())).toList() ?? [];
                        if(postlist.isNotEmpty){
                          return ListView.builder(
                              itemCount:_isSearching ? searchlist.length : postlist.length,
                              padding: EdgeInsets.only(top: mq.height * .01),
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) =>index==0 ? Column(
                                children: [
                                  Divider(thickness: 8, color: Colors.black12),
                                  VideoCard(postU: _isSearching ? searchlist[index] :postlist[index],context: context,)
                                ],
                              ) :VideoCard(postU:_isSearching ? searchlist[index] : postlist[index],context: context,)
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
      ],
    );
  }
}
