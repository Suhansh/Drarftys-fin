class DefaultSearch {
  String? msg;
  List<Data>? data;
  bool? success;

  DefaultSearch({this.msg, this.data, this.success});

  DefaultSearch.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['msg'] = msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    return data;
  }
}

class Data {
  int? id;
  String? title;
  String? image;
  List<Videos>? videos;
  dynamic views;
  int? trending;
  String? imagePath;

  Data(
      {this.id,
      this.title,
      this.image,
      this.videos,
      this.views,
      this.trending,
      this.imagePath});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    if (json['videos'] != null) {
      videos = <Videos>[];
      json['videos'].forEach((v) {
        videos!.add(Videos.fromJson(v));
      });
    }
    views = json['views'];
    trending = json['trending'];
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    if (videos != null) {
      data['videos'] = videos!.map((v) => v.toJson()).toList();
    }
    data['views'] = views;
    data['trending'] = trending;
    data['imagePath'] = imagePath;
    return data;
  }
}

class Videos {
  int? id;
  String? screenshot;
  String? imagePath;
  dynamic viewCount;

  Videos({this.id, this.screenshot, this.imagePath, this.viewCount});

  Videos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    screenshot = json['screenshot'];
    imagePath = json['imagePath'];
    viewCount = json['viewCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['screenshot'] = screenshot;
    data['imagePath'] = imagePath;
    data['viewCount'] = viewCount;
    return data;
  }
}
