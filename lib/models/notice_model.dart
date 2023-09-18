class NoticeModel {
  NoticeModel({
    required this.image,
    required this.type,
    required this.name,
    required this.noiDung,
    required this.time,
    required this.id,
    required this.email,
  });
  late final String image;
  late final String type;
  late final String name;
  late final String noiDung;
  late final String time;
  late final String id;
  late final String email;

  NoticeModel.fromJson(Map<String, dynamic> json){
    image = json['image'] ?? '';
    type = json['type'] ?? '';
    name = json['name'] ?? '';
    noiDung = json['noi_dung'] ?? '';
    time = json['time'] ?? '';
    id = json['id'] ?? '';
    email = json['email'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['type'] = type;
    data['name'] = name;
    data['noi_dung'] = noiDung;
    data['time'] = time;
    data['id'] = id;
    data['email'] = email;
    return data;
  }
}