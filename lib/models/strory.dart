class StoryU {
  StoryU({
    required this.name,
    required this.id,
    required this.avatar,
    required this.story,
    required this.time,
    required this.ext,
  });
  late final String name;
  late final String id;
  late final String avatar;
  late final String story;
  late final String time;
  late final String ext;

  StoryU.fromJson(Map<String, dynamic> json){
    name = json['name'];
    id = json['id'];
    avatar = json['avatar'];
    story = json['story'];
    time = json['time'];
    ext = json['ext'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['avatar'] = avatar;
    data['story'] = story;
    data['time'] = time;
    data['ext'] = ext;
    return data;
  }
}