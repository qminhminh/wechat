
import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:http/http.dart' ;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wechat/models/notice_model.dart';
import '../models/chat_user.dart';
import '../models/message.dart';
import '../models/post_comment.dart';
import '../models/publications.dart';
import '../models/strory.dart';


class APIs{
  static FirebaseAuth auth=FirebaseAuth.instance;
  static FirebaseFirestore firestore=FirebaseFirestore.instance;
  static FirebaseStorage firebaseStorage=FirebaseStorage.instance;
  static FirebaseMessaging fmessaging = FirebaseMessaging.instance;
  // to return current user
  static User get user => auth.currentUser!;

  // for storing self infomation
  static late ChatUser me;
  static late PostU postme;


  // get current user info
  static Future<void> getFiMesaingToken() async{
     await fmessaging.requestPermission(

    );

    await fmessaging.getToken().then((t){
        if(t != null){
          me.pushToken=t;
          log('Token : $t');

        }
     });
     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
       log('Got a message whilst in the foreground!');
       log('Message data: ${message.data}');

       if (message.notification != null) {
         log('Message also contained a notification: ${message.notification}');
       }
     });
  }

  static Future<void> getFiMesaingTokenPost() async{
    await fmessaging.requestPermission(

    );

    await fmessaging.getToken().then((t){
      if(t != null){
        postme.pushToken=t;
        log('Token : $t');

      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');

      if (message.notification != null) {
        log('Message also contained a notification: ${message.notification}');
      }
    });
  }
  // get current user info
  static Future<void> getSetInfo() async{
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      // kiem tra nguoi dung co ton tai khong
      if(user.exists){
        me=ChatUser.fromJson(user.data()!);
       await getFiMesaingToken();
        APIs.updateActiveStatus(true);
      }
      else{
        await createUser().then((value) => getSetInfo());
      }
    });
  }

  static Future<void> sendPudNOtification(ChatUser chatUser,String msg) async{
       try{
         final body=
           {
             "to":chatUser.pushToken,
             "notification":{
               "title":chatUser.name,
               "body":msg,
               "android_channel_id": "Chats",
               "data": {
                 "some_data" : "User ID: ${me.id}",
               },
             }

         };

         var response = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
             headers: {
               HttpHeaders.contentTypeHeader:'application/json',
               HttpHeaders.authorizationHeader:
               'key=AAAAwovMORc:APA91bHYF4j8eZ5LbfJWB8Pfw07R8GV2onhlugNIOITZ7eSBGAgzfOaHuX6AgZ7-WdSr4HjBW6BqDVrDOd9GfrnqVa3ATc1W6d6hGeH_ci3b8PW0CXHYEkmBsGasqBk_uaeMzP1UI70S'
             },
             body:jsonEncode(body)
         );
         log('Response status: ${response.statusCode}');
         log('Response body: ${response.body}');
       }catch(e){
         log('\n: ${e.toString()}');
       }
  }

  // for sending push notification
  static Future<void> sendPudNOtificatPost(String msg,String token) async{

    try{
      final body=
      {
        "to":token,
        "notification":{
          "title":auth.currentUser!.displayName,
          "body":msg,
          "android_channel_id": "Chats",
          "data": {
            "some_data" : "User ID: ${me.id}",
          },
        }

      };

      var response = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader:'application/json',
            HttpHeaders.authorizationHeader:
            'key=AAAAfwBLU6Q:APA91bEVOkqypmWfTAoRjE9MTqSpgGSiXyaQcI2fpLGqBUDlW_G7FKQAeXycYNXH3n6zC3shBLBBX6rCKnoB_Et5OOMcQvGZELFKl2kOAtow-wwJuiT-MKQSTDc02v_OT14QeNq47Hmc'
          },
          body:jsonEncode(body)
      );
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');
    }catch(e){
      log('\n: ${e.toString()}');
    }
  }

  // for checking if user exixts or not?
  static Future<bool> userExixts() async{
     return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  // ADD CHAT USER
  static Future<bool> addChatUser(String email) async{
          final data= await firestore.collection('users').where('email',isEqualTo: email).get();

          if(data.docs.isNotEmpty && data.docs.first.id != user.uid ){

            await firestore.collection('users')
                .doc(user.uid)
                .collection('my_users')
                .doc(data.docs.first.id)
                .set({});
            return true;
          }else{
            return false;
          }
  }

  // for creatign a new user
  static Future<void>  createUser() async{
    final time=DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser=ChatUser(
        image:  auth.currentUser!.photoURL.toString(),
        about: "I am using WeChat",
        name:  auth.currentUser!.displayName.toString(),
        createdAt: time,
        isOnline: false,
        id: auth.currentUser!.uid,
        lastActive: time,
        email:  auth.currentUser!.email.toString(),
        pushToken: ""
    );
    return await firestore.collection('users').doc(auth.currentUser!.uid).set(chatUser.toJson());
  }

  // create notice
  static Future<void> creteNotice(String text, String type) async{
      final time = DateTime.now().millisecondsSinceEpoch.toString();
      final noticeModle= NoticeModel(
          image: auth.currentUser!.photoURL.toString(),
          type: type,
          name: auth.currentUser!.displayName.toString(),
          noiDung: text,
          time: time,
          id: auth.currentUser!.uid,
          email: auth.currentUser!.email.toString(),
      );
      return await firestore.collection("notice").doc(time).set(noticeModle.toJson());
  }

  // get all notice
  static Stream<QuerySnapshot<Map<String,dynamic>>> getAllNOtice(){

    return firestore.collection('notice')
      //  .where('id',whereIn: [...userIds,auth.currentUser!.uid])
        .snapshots();
  }
  // for create Post cho ban be
  static Future<void>  createPostMyFrends(int type,String text,File file) async{
    final time=DateTime.now().millisecondsSinceEpoch.toString();
    final ext =file.path.split('.').last;

    //storage file ref with path
    final ref=  firebaseStorage.ref().child('post_pictures/${time}.$ext');
    await ref.putFile(file,SettableMetadata(contentType: 'image/$ext')).then((p0) {

    });

    final post=PostU(
        id: auth.currentUser!.uid,
        name: auth.currentUser!.displayName.toString(),
        email: auth.currentUser!.email.toString(),
        time: time,
        text: text,
        live: 1,
        urlFoto: auth.currentUser!.photoURL.toString(),
        urlImgPost: await ref.getDownloadURL(),
        type: type,
        isOnline: false,
         pushToken: '',
        like: false,
         countcommnet: 0,
        ext: ext
    );
    return await firestore.collection('post').doc(time).set(post.toJson());
  }

  // for create Post cho ban be
  static Future<void>  createStoryMyFrends(int type,File file) async{
    final time=DateTime.now().millisecondsSinceEpoch.toString();
    final ext =file.path.split('.').last;

    //storage file ref with path
    final ref=  firebaseStorage.ref().child('story_pictures/${time}.$ext');
    await ref.putFile(file,SettableMetadata(contentType: 'image/$ext')).then((p0) {

    });

    final story=StoryU(
        name: auth.currentUser!.displayName.toString(),
        id: auth.currentUser!.uid,
        avatar:  auth.currentUser!.photoURL.toString(),
        story: await ref.getDownloadURL(),
        time: time,
        ext: ext);

    return await firestore.collection('story').doc(time).set(story.toJson());
  }


  // for create Post Me cho ban be
  static Future<void> deletePostMe(String time, String ext) async {
    try {
      // Xây dựng lại đường dẫn của tệp dựa trên thời gian và phần mở rộng
      final ref = firebaseStorage.ref().child('post_pictures/$time.$ext');
      // Sử dụng tham chiếu để xóa tệp
      await ref.delete();

      // Xóa thành công
      print('Tệp đã được xóa thành công.');
    } catch (error) {
      // Xử lý lỗi nếu có lỗi xảy ra trong quá trình xóa
      print('Lỗi khi xóa tệp: $error');
    }
  }



  static Future<void> deleteStoryMe(String time, String ext) async {
    try {
      // Xây dựng lại đường dẫn của tệp dựa trên thời gian và phần mở rộng
      final ref = firebaseStorage.ref().child('story_pictures/$time.$ext');
      final reff = firebaseStorage.ref().child('storyme_pictures/$time.$ext');
      // Sử dụng tham chiếu để xóa tệp
      await ref.delete();
      await reff.delete();

      // Xóa thành công
      print('Tệp đã được xóa thành công.');
    } catch (error) {
      // Xử lý lỗi nếu có lỗi xảy ra trong quá trình xóa
      print('Lỗi khi xóa tệp: $error');
    }
  }

  // for create Post cho ban be
  static Future<void>  createPostPublic(int type,String text,File file) async{
    final time=DateTime.now().millisecondsSinceEpoch.toString();
    final ext =file.path.split('.').last;

    //storage file ref with path
    final ref=  firebaseStorage.ref().child('post_pictures/${time}.$ext');
    await ref.putFile(file,SettableMetadata(contentType: 'image/$ext')).then((p0) {

    });


    final post=PostU(
        id: '2',
        name: auth.currentUser!.displayName.toString(),
        email: auth.currentUser!.email.toString(),
        time: time,
        text: text,
        live: 1,
        urlFoto: auth.currentUser!.photoURL.toString(),
        urlImgPost: await ref.getDownloadURL(),
        type: type,
        isOnline: false,
        pushToken: '',
        like: false,
        countcommnet: 0,
        ext: ext
    );
    return await firestore.collection('post').doc(time).set(post.toJson());
  }
  // for getting all users from firebase
  static Stream<QuerySnapshot<Map<String,dynamic>>> getAllUser(List<String> userIds){

    return firestore.collection('users')
        .where('id',whereIn: userIds)
        .snapshots();
  }
//for getting Id users from firebase
  static Stream<QuerySnapshot<Map<String,dynamic>>> getAllIDUser(List<String> userIds){

    return firestore.collection('users')
        .where('id',whereIn: userIds)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String,dynamic>>> getAllUersss(List<String> userIds){

    return firestore.collection('users')
        // .where('id',whereNotIn:  userIds)
        .snapshots();
  }
  // for getting MY users from firebase
  static Stream<QuerySnapshot<Map<String,dynamic>>> getMyUserId(){
    return firestore.collection('users')
        .doc(user.uid)
        .collection('my_users')
        .snapshots();
  }

  static Future<void> gedeleteNotice(String date) async{
    await firestore.collection('notice')
        .doc(date)
        .delete();
  }


  //for getting Id users from firebase
  static Stream<QuerySnapshot<Map<String,dynamic>>> getAllPost(List<String> userIds){

    return firestore.collection('post')
        .where('id',whereIn: [...userIds,'2',auth.currentUser!.uid])
        .snapshots();
  }
  static Stream<QuerySnapshot<Map<String,dynamic>>> getAllStory(List<String> userIds){

    return firestore.collection('story')
        .where('id',whereIn: [...userIds,auth.currentUser!.uid])
        .snapshots();
  }

  // for getting specific user infoau
  static Stream<QuerySnapshot<Map<String,dynamic>>> getUserInfo(ChatUser chuser){
    return firestore
        .collection('users')
        .where('id',isEqualTo: chuser.id)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String,dynamic>>> getUserInfoPost(String id){
    return firestore
        .collection('users')
        .where('email',isEqualTo: id)
        .snapshots();
  }

  //update online or last active status
  static Future<void>  updateActiveStatus(bool isOnline) async{
    firestore
        .collection('users')
        .doc(user.uid)
        .update(
        {
          'is_online':isOnline,
          'last_active':DateTime.now().millisecondsSinceEpoch.toString(),
          'push_token': me.pushToken,
        });
  }

  //update online or last active status
  static Future<void>  updateActiveStatusPost(bool isOnline,String date ,String token) async{
    firestore
        .collection('post')
        .doc(date)
        .update(
        {
          'is_online':isOnline,
          'push_token': token,
        });
  }

 // update count like
  static Future<void>  updateLike(int count,String date) async{
    firestore
        .collection('post')
        .doc(date)
        .update(
        {
          'live': count
        });
  }

  // update count comment
  static Future<void>  updateCountComment(int count,String date) async{
    firestore
        .collection('post')
        .doc(date)
        .update(
        {
          'countcommnet': count
        });
  }

  static Future<void>  updateLikeBool(bool like,String date) async{
    firestore
        .collection('post')
        .doc(date)
        .update(
        {
          'like': like
        });
  }

  // for update uer
  static Future<void> sendFirstMessage(ChatUser chatUser,String msg,Type type) async{
    await firestore.collection('users').doc(chatUser.id).
    collection('my_users')
    .doc(user.uid)
    .set({}).then((value) => sendMessage(chatUser, msg, type));
  }

  // for update uer
  static Future<void> userUpdateInfo() async{
    await firestore.collection('users').doc(user.uid).update({
        'name':me.name,
        'about':me.about});
  }

  // update profile Picture
  static Future<void> updateProfilePicture(File file) async{
    // getting image file extension
    final ext =file.path.split('.').last;

    //storage file ref with path
    final ref=  firebaseStorage.ref().child('profile_pictures/${user.uid}.$ext');
    await ref.putFile(file,SettableMetadata(contentType: 'image/$ext')).then((p0) {

    });

    //update iamge in firebase
    me.image= await ref.getDownloadURL();
    await firestore.collection('users').doc(user.uid).update({
      'image':me.image,
      });
}
  // useful for getting conversation id
  static String getConvertsationID(String id) => user.uid.hashCode<=id.hashCode
      ? '${user.uid}_$id' : '${id}_${user.uid}';

  // for getting all chat screen
  static Stream<QuerySnapshot<Map<String,dynamic>>> getAllMessages(ChatUser user){
    return firestore
        .collection('chats/${getConvertsationID(user.id)}/messages/')
        .orderBy('sent',descending: true)
        .snapshots();
  }

  // for sending message
  static Future<void> sendMessage(ChatUser chatuser, String msg,Type type) async{
   
    // message time
    final time=DateTime.now().millisecondsSinceEpoch.toString();
    
    // messgae to send
    final Message message=Message(toId: chatuser.id, msg: msg, read: '', type: type, fromId: user.uid, sent: time);

    final ref=firestore.collection('chats/${getConvertsationID(chatuser.id)}/messages/');
    await ref.doc(time).set(message.toJson()).then((value) => sendPudNOtification(chatuser, type ==Type.text ? msg :'img'));
  }

  static Future<void> sendMessagePostComm(String datetime, String msg,PostU postU,int count) async{

    // message time
    final time=DateTime.now().millisecondsSinceEpoch.toString();

    final PostComment postComment=PostComment(name:auth.currentUser!.displayName.toString(), id: auth.currentUser!.uid , img: auth.currentUser!.photoURL.toString(), text: msg, time: time);

    final ref=firestore.collection('post/${datetime}/commnent/');
    await ref.doc(time).set(postComment.toJson());
  }

  static Stream<QuerySnapshot<Map<String,dynamic>>> getComment(String datetime){
    return firestore.collection('post/${datetime}/commnent/').snapshots();
  }

  static Future<void> gedeleteComment(String date) async{
    await firestore.collection('post/${date}/commnent/')
        .doc()
        .delete();
  }

  static Future<void> gedeleteCStory(String date) async{
    await firestore.collection('story')
        .doc(date)
        .delete();
  }

  static Future<void> gedeletePost(String date) async{
    await firestore.collection('post')
        .doc(date)
        .delete();
  }

  // update read sttus of messgae
  static Future<void> updateMessageReadStatus(Message message) async{
    firestore.collection('chats/${getConvertsationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read':DateTime.now().millisecondsSinceEpoch.toString()});
  }

  // get only last message of a specific chat
  static Stream<QuerySnapshot<Map<String,dynamic>>> getLastMessages(ChatUser user){
    return firestore.collection('chats/${getConvertsationID(user.id)}/messages/')
        .orderBy('sent',descending: true)
        .limit(1).snapshots();
  }

  // send chat img
  static Future<void> sendChatImage(ChatUser chatUser,File file) async{
    // getting image file extension
    final ext =file.path.split('.').last;

    //storage file ref with path
    final ref=  firebaseStorage.ref().child('images/${getConvertsationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    await ref.putFile(file,SettableMetadata(contentType: 'image/$ext')).then((p0) {

    });

    //update iamge in firebase
    final imagUrl= await ref.getDownloadURL();
    await sendMessage(chatUser, imagUrl, Type.image);
  }

  // delete messgae
  static Future<void> gedeleteMessa(Message message) async{
    await firestore.collection('chats/${getConvertsationID(message.toId)}/messages/')
        .doc(message.sent)
        .delete();
    if(message.type==Type.image)
    firebaseStorage.refFromURL(message.msg).delete();
  }

  // update mess
  static Future<void> UpdateMessa(Message message, String updateMsg) async{
    await firestore.collection('chats/${getConvertsationID(message.toId)}/messages/')
        .doc(message.sent)
        .update({"msg":updateMsg});
  }
}