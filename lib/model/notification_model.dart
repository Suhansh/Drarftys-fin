class NotificationModal {
  String? msg;
  Data? data;
  bool? success;

  NotificationModal({this.msg, this.data, this.success});

  NotificationModal.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['msg'] = msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = success;
    return data;
  }
}

class Data {
  int? requesteCount;
  LastRequest? lastRequest;
  List<Current>? current;
  List<LastSeven>? lastSeven;

  Data(
      {this.requesteCount,
      required this.lastRequest,
      this.current,
      this.lastSeven});

  Data.fromJson(Map<String, dynamic> json) {
    requesteCount = json['requeste_count'];
    lastRequest = json['last_request'] != null
        ? LastRequest.fromJson(json['last_request'])
        : null;
    if (json['current'] != null) {
      current = <Current>[];
      json['current'].forEach((v) {
        current!.add(Current.fromJson(v));
      });
    }
    if (json['last_seven'] != null) {
      lastSeven = <LastSeven>[];
      json['last_seven'].forEach((v) {
        lastSeven!.add(LastSeven.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['requeste_count'] = requesteCount;
    data['last_request'] = lastRequest;
    if (current != null) {
      data['current'] = current!.map((v) => v.toJson()).toList();
    }
    if (lastRequest != null) {
      data['last_request'] = lastRequest!.toJson();
    }
    if (lastSeven != null) {
      data['last_seven'] = lastSeven!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Current {
  int? id;
  String? userId;
  String? friendId;
  String? videoId;
  String? commentId;
  String? reason;
  String? msg;
  String? createdAt;
  String? time;
  User? user;
  Video? video;

  Current(
      {this.id,
      this.userId,
      this.friendId,
      this.videoId,
      this.commentId,
      this.reason,
      this.msg,
      this.createdAt,
      this.time,
      this.user,
      this.video});

  Current.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    friendId = json['friend_id'];
    videoId = json['video_id'];
    commentId = json['comment_id'];
    reason = json['reason'];
    msg = json['msg'];
    createdAt = json['created_at'];
    time = json['time'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    video = json['video'] != null ? Video.fromJson(json['video']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['friend_id'] = friendId;
    data['video_id'] = videoId;
    data['comment_id'] = commentId;
    data['reason'] = reason;
    data['msg'] = msg;
    data['created_at'] = createdAt;
    data['time'] = time;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (video != null) {
      data['video'] = video!.toJson();
    }
    return data;
  }
}

class LastRequest {
  int? id;
  String? image;
  String? imagePath;

  LastRequest({required this.id, required this.image, required this.imagePath});

  LastRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['imagePath'] = imagePath;
    return data;
  }
}

class LastSeven {
  int? id;
  String? userId;
  String? friendId;
  String? videoId;
  String? commentId;
  String? reason;
  String? msg;
  String? createdAt;
  String? time;
  User? user;
  Video? video;

  LastSeven(
      {this.id,
      this.userId,
      this.friendId,
      this.videoId,
      this.commentId,
      this.reason,
      this.msg,
      this.createdAt,
      this.time,
      this.user,
      this.video});

  LastSeven.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    friendId = json['friend_id'];
    videoId = json['video_id'];
    commentId = json['comment_id'];
    reason = json['reason'];
    msg = json['msg'];
    createdAt = json['created_at'];
    time = json['time'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    video = json['video'] != null ? Video.fromJson(json['video']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['friend_id'] = friendId;
    data['video_id'] = videoId;
    data['comment_id'] = commentId;
    data['reason'] = reason;
    data['msg'] = msg;
    data['created_at'] = createdAt;
    data['time'] = time;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (video != null) {
      data['video'] = video!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? userId;
  String? name;
  String? image;
  String? imagePath;

  User({this.id, this.userId, this.name, this.image, this.imagePath});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    image = json['image'];
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['image'] = image;
    data['imagePath'] = imagePath;
    return data;
  }
}

class Video {
  int? id;
  String? screenshot;
  String? imagePath;

  Video({this.id, this.screenshot, this.imagePath});

  Video.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    screenshot = json['screenshot'];
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['screenshot'] = screenshot;
    data['imagePath'] = imagePath;
    return data;
  }
}
