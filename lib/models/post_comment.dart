class PostComment {
  PostComment({
    required this.name,
    required this.id,
    required this.img,
    required this.text,
    required this.time,
  });
  late final String name;
  late final String id;
  late final String img;
  late final String text;
  late final String time;

  PostComment.fromJson(Map<String, dynamic> json){
    name = json['name'] ?? '';
    id = json['id'] ?? '';
    img = json['img'] ?? '';
    text = json['text'] ?? '';
    time = json['time'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['img'] = img;
    data['text'] = text;
    data['time'] = time;
    return data;
  }
}