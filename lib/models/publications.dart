class PostU {
  PostU({
    required this.id,
    required this.name,
    required this.email,
    required this.time,
    required this.text,
    required this.live,
    required this.urlFoto,
    required this.urlImgPost,
    required this.type,
    required this.isOnline,
    required this.pushToken,
    required this.like,
    required this.countcommnet,
    required this.ext,
  });
  late final String id;
  late final String name;
  late final String email;
  late final String time;
  late final String text;
  late final int live;
  late final String urlFoto;
  late final String urlImgPost;
  late final int type;
  late final bool isOnline;
  late final String pushToken;
  late final bool like;
  late final int countcommnet;
  late final String ext;

  PostU.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    email = json['email'] ?? ''; // Corrected this line
    time = json['time'] ?? '';
    text = json['text'] ?? '';
    live = json['live']??0;
    urlFoto = json['url_foto'] ?? '';
    urlImgPost = json['url_img_post'] ?? '';
    type = json['type'] ?? 0;
    isOnline = json['is_online'];
    pushToken = json['push_token'] ?? '';
    like = json['like'];
    countcommnet = json['countcommnet'];
    ext = json['ext'] ?? '';
    // Default value for type if not provided
  }


  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['time'] = time;
    data['text'] = text;
    data['live'] = live;
    data['url_foto'] = urlFoto;
    data['url_img_post'] = urlImgPost;
    data['type'] = type;
    data['is_online'] = isOnline;
    data['push_token'] = pushToken;
    data['like'] = like;
    data['countcommnet'] = countcommnet;
    data['ext'] = ext;
    return data;
  }
}
