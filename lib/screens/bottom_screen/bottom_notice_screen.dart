import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wechat/api/apis.dart';
import 'package:wechat/models/notice_model.dart';
import 'package:wechat/widgets/notice_card.dart';



class BottomNoticeScreen extends StatefulWidget {
  const BottomNoticeScreen({super.key});

  @override
  State<BottomNoticeScreen> createState() => _BottomNoticeScreenState();
}

class _BottomNoticeScreenState extends State<BottomNoticeScreen> {
  bool _isSearching=false;
  List<NoticeModel> list = [];
  List<NoticeModel> searchList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:  Text('Thông báo',style: TextStyle(fontSize: 20,color: Colors.black87,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),
        actions: [
          IconButton(
              onPressed: (){
                setState(() {
                  _isSearching = !_isSearching;
                });
              },
              icon: Icon(_isSearching ? CupertinoIcons.clear_circled_solid : Icons.search)
          )
        ],
      ),
      body: body(context: context),
    );
  }

  Widget body({required BuildContext context}){
    return Stack(
      children: [

        SizedBox(height: 5,),
        StreamBuilder(
            stream: APIs.getMyUserId(),
            builder: (context, snapshot){
              switch(snapshot.connectionState){
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return CircularProgressIndicator();
                case ConnectionState.active:
                case ConnectionState.done:
                  return StreamBuilder(
                      stream: APIs.getAllNOtice(),
                      builder:(context,snapshot){
                        switch(snapshot.connectionState){
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return CircularProgressIndicator();
                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data =snapshot.data!.docs;
                            list=data?.map((e) => NoticeModel.fromJson(e.data())).toList() ?? [];
                            return ListView.builder(
                                itemCount:list.length,
                                padding: EdgeInsets.only(top: 2),
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context,index) =>index == 0 ? Column(
                                  children: [

                                    NoticeCard(noteMod: list[index])
                                  ],
                                )  : NoticeCard(noteMod: list[index])
                            );
                        }
                      }
                  );
              }

            }
        ),
      ],
    );
  }
}
