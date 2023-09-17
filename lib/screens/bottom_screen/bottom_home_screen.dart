
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../api/apis.dart';
import '../../main.dart';
import '../../models/publications.dart';
import '../../models/strory.dart';
import '../../widgets/dialogs/post_card.dart';
import '../../widgets/story_card.dart';
import '../home_screen.dart';
import '../screen_chucnang/post_screen.dart';
import '../screen_chucnang/profile_story.dart';
import '../screen_chucnang/story_screen.dart';

class BottomHomeScreen extends StatefulWidget {
  BottomHomeScreen({super.key});

  @override
  State<BottomHomeScreen> createState() => _BottomHomeScreenState();
}

class _BottomHomeScreenState extends State<BottomHomeScreen> {
  List<StoryU> storylist=[];
  List<PostU> postlist=[];

  @override
  void initState() {
    super.initState();
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


    return Scaffold(
          appBar: AppBar(
            leading: Icon(Icons.facebook, color: Colors.blue, size: 40),
            actions: [
              //WidgetsUtilsApp().buttonThemeBrightness(context: context),
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.black12,
                child: IconButton(
                    splashRadius: 20,
                    icon: Icon(Icons.search,
                        size: 24, color: Theme.of(context).iconTheme.color),
                    onPressed: () {}),
              ),
              SizedBox(width: 4,),
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.black12,
                child: IconButton(
                    splashRadius: 20,
                    icon: Icon(Icons.add,
                        size: 24, color: Theme.of(context).iconTheme.color),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_)=> PostScreen()));
                    }),
              ),
              SizedBox(width: 4,),
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.black12,
                child: IconButton(
                    splashRadius: 20,
                    icon: Icon(Icons.message_outlined,
                        size: 24, color: Theme.of(context).iconTheme.color),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>HomeScreen()));
                    }),
              ),
              SizedBox(width: 12),

            ],
          ),
          body: body(context: context),
    );
  }

  // widgets body
   Widget body({required BuildContext context}){
      Widget widgets=Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 20, right: 12, left: 12),
            child: widgetTextFeld(),
          ),
          Padding(
              padding: EdgeInsets.only(top: 12, right: 12, left: 12),
              child: widgetButton(),
          ),
          Container(padding: EdgeInsets.only(top: 12), child: widgetStory()),
        ],
      );
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

                          return ListView.builder(
                            itemCount:postlist.length,
                            padding: EdgeInsets.only(top: mq.height * .01),
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) =>index==0 ? Column(
                              children: [
                                widgets,
                                Divider(thickness: 8, color: Colors.black12),
                                PostCard(postU: postlist[index],context: context,)
                              ],
                            ) :PostCard(postU: postlist[index],context: context,)
                          );


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

  // widget TextField
   Widget widgetTextFeld(){
      return Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.black12,
        child: Container(
          padding: EdgeInsets.only(left: 12),
          child: TextFormField(
            decoration: InputDecoration(
              hintText: 'Your status?',
              border: InputBorder.none,
              fillColor: Colors.white
            ),
          ),
        ),
      );
   }

   // widget Button
   Widget widgetButton(){
    return Row(
      children: [
        Expanded(
            child: ElevatedButton.icon(
                onPressed: (){},
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 18,vertical: 12),),
                  backgroundColor: MaterialStateProperty.all<Color?>(Colors.red[400]),
                  shape: MaterialStateProperty.all<StadiumBorder>(StadiumBorder(
                    side:
                      BorderSide(color: Colors.transparent)
                  )),
                ),
                icon: Icon(Icons.video_call,size: 20,),
                label: Text('Video')
            ),
        ),
        SizedBox(width: 12,),
        Expanded(
          flex: 1,
          child: ElevatedButton.icon(
              onPressed: (){},
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 18,vertical: 12),),
                backgroundColor: MaterialStateProperty.all<Color?>(Colors.green[400]),
                shape: MaterialStateProperty.all<StadiumBorder>(StadiumBorder(
                    side:
                    BorderSide(color: Colors.transparent)
                )),
              ),
              icon: Icon(Icons.photo,size: 20,),
              label: Text('Photo')
          ),
        ),
        SizedBox(width: 12,),
        ElevatedButton(
            onPressed: (){},
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 18,vertical: 12),),
              backgroundColor: MaterialStateProperty.all<Color?>(Colors.black12),
              shape: MaterialStateProperty.all<StadiumBorder>(StadiumBorder(
                  side:
                  BorderSide(color: Colors.transparent)
              )),
            ),
            child: Icon(Icons.more_horiz)
        )
      ],
    );
   }

   // widget Story
   Widget widgetStory(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12),
          child: Text('History',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
        ),
        Container(
          width: double.infinity,
          height: 170,
          child: StreamBuilder(
            stream: APIs.getMyUserId(),
            builder: (context,snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Center(child: CircularProgressIndicator(),); // Thêm trường hợp ConnectionState.none
                case ConnectionState.active:
                case ConnectionState.done:
                  return StreamBuilder(
                    stream: APIs.getAllStory(snapshot.data!.docs.map((e) => e.id).toList() ?? []),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return Center(child: CircularProgressIndicator(),); // Thêm trường hợp ConnectionState.none
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          storylist = data?.map((e) => StoryU.fromJson(e.data())).toList() ?? [];
                          if(storylist.isNotEmpty){
                            return ListView.builder(
                                padding: EdgeInsets.all(10),
                                scrollDirection: Axis.horizontal,
                                itemCount:storylist.length,
                                itemBuilder: (context, index) {
                                     if(index==0){
                                       return Row(
                                         children: [
                                           cardHIstoryAdd(),
                                           InkWell(
                                                onTap:(){ Navigator.push(context, MaterialPageRoute(builder: (_)=>FullScreenStoryPage(initialStoryIndex: index, stories: storylist,)));},
                                               child: StoryCard(storyU: storylist[index])
                                           ),
                                         ],
                                       );
                                     }
                                     return StoryCard(storyU: storylist[index]);
                                }
                            );
                          }
                          else{
                            return cardHIstoryAdd();
                          }
                      }
                    },
                  );
              }
              // return Center(child: CircularProgressIndicator(strokeWidth: 2,),);

            },
          ),

        ),
      ],
    );
   }

   // widget History Add
   Widget cardHIstoryAdd(){
     String url='https://img.freepik.com/fotos-kostenlos/laechelnde-frau-im-hemd-das-selfie-im-studio%02macht_171337-17196.jpg?w=500';
     return Padding(
       padding: EdgeInsets.only(left: 8),
       child: Card(
         shadowColor: Colors.blue.shade200,
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
         elevation: 3,
         clipBehavior: Clip.antiAlias,
         child: Container(
           width: 85,
           height: 160,
           child: Stack(
             fit: StackFit.expand,
             children: [
               CachedNetworkImage(
                   imageUrl: APIs.auth.currentUser!.photoURL.toString(),
                   fadeInDuration: Duration(milliseconds: 200),
                   fit: BoxFit.cover,
                   placeholder: (context, urlImage) =>
                     Container(color: Colors.grey),
                   errorWidget:  (context, urlImage, error) => Center(
                     child: Icon(Icons.music_note,size: 50,color: Colors.white,),
                   ),
               ),
               Padding(
                 padding:  EdgeInsets.only(top: 70),
                 child: Stack(
                   alignment: AlignmentDirectional.topCenter,
                   children: [
                     Container(
                       margin: EdgeInsets.only(top: 18),
                       height: double.infinity,
                       width: double.infinity,
                       color: Colors.blue,
                       child: Center(
                         child: Padding(
                           padding: EdgeInsets.only(bottom: 5,left: 7,right: 7,top: 14),
                           child: Text('Creat History',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                         ),
                       ),
                     ),
                     InkWell(
                       onTap: (){
                         Navigator.push(context, MaterialPageRoute(builder: (_)=> StoryScreen()));
                         },
                       child: Material(
                         elevation: 8,
                         color: Colors.white,
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                         child: Padding(
                             padding:  EdgeInsets.all(8.0),
                             child: Icon(Icons.add,color: Colors.blue,size: 18,),
                         ),
                       ),
                     ),
                   ],
                 ),
               )
             ],
           ),
         ),
       ),
     );
   }
}
