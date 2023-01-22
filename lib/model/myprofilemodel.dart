class MyProfileModel {
  String? msg;
  MyProfileData? data;
  bool? success;

  MyProfileModel({this.msg, this.data, this.success});

  MyProfileModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    data =
        json['data'] != null ? MyProfileData.fromJson(json['data']) : null;
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

class MyProfileData {
  MainUser? mainUser;
  List<Posts>? posts;
  List<Saved>? saved;
  List<Liked>? liked;

  MyProfileData({this.mainUser, this.posts, this.saved, this.liked});

  MyProfileData.fromJson(Map<String, dynamic> json) {
    mainUser = json['mainUser'] != null
        ? MainUser.fromJson(json['mainUser'])
        : null;
    if (json['posts'] != null) {
      posts = <Posts>[];
      json['posts'].forEach((v) {
        posts!.add(Posts.fromJson(v));
      });
    }
    if (json['saved'] != null) {
      saved = <Saved>[];
      json['saved'].forEach((v) {
        saved!.add(Saved.fromJson(v));
      });
    }
    if (json['liked'] != null) {
      liked = <Liked>[];
      json['liked'].forEach((v) {
        liked!.add(Liked.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (mainUser != null) {
      data['mainUser'] = mainUser!.toJson();
    }
    if (posts != null) {
      data['posts'] = posts!.map((v) => v.toJson()).toList();
    }
    if (saved != null) {
      data['saved'] = saved!.map((v) => v.toJson()).toList();
    }
    if (liked != null) {
      data['liked'] = liked!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MainUser {
  int? id;
  String? name;
  String? userId;
  String? image;
  String? bio;
  String? bdate;
  String? phone;
  String? email;
  String? gender;
  String? imagePath;
  String? followersCount;
  String? followingCount;

  MainUser(
      {this.id,
      this.name,
      this.userId,
      this.image,
      this.bio,
      this.bdate,
      this.phone,
      this.email,
      this.gender,
      this.imagePath,
      this.followersCount,
      this.followingCount});

  MainUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userId = json['user_id'];
    image = json['image'];
    bio = json['bio'];
    bdate = json['bdate'];
    phone = json['phone'];
    email = json['email'];
    gender = json['gender'];
    imagePath = json['imagePath'];
    followersCount = json['followersCount'];
    followingCount = json['followingCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['user_id'] = userId;
    data['image'] = image;
    data['bio'] = bio;
    data['bdate'] = bdate;
    data['phone'] = phone;
    data['email'] = email;
    data['gender'] = gender;
    data['imagePath'] = imagePath;
    data['followersCount'] = followersCount;
    data['followingCount'] = followingCount;
    return data;
  }
}

class Posts {
  int? id;
  String? screenshot;
  String? video;
  bool? isLike;
  String? imagePath;
  String? viewCount;
  bool showred = false;
  bool showwhite = false;

  Posts(
      {this.id,
      this.screenshot,
      this.video,
      this.isLike,
      this.imagePath,
      this.viewCount});

  Posts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    screenshot = json['screenshot'];
    video = json['video'];
    isLike = json['isLike'];
    imagePath = json['imagePath'];
    viewCount = json['viewCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['screenshot'] = screenshot;
    data['video'] = video;
    data['isLike'] = isLike;
    data['imagePath'] = imagePath;
    data['viewCount'] = viewCount;
    return data;
  }
}

class Saved {
  int? id;
  String? userId;
  Video? video;

  Saved({this.id, this.userId, this.video});

  Saved.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    video = json['video'] != null ? Video.fromJson(json['video']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    if (video != null) {
      data['video'] = video!.toJson();
    }
    return data;
  }
}

class Video {
  int? id;
  String? userId;
  String? video;
  String? screenshot;
  String? imagePath;
  bool? isLike;
  String? viewCount;
  User? user;
  bool showred = false;
  bool showwhite = false;

  Video(
      {this.id,
      this.userId,
      this.video,
      this.screenshot,
      this.imagePath,
      this.isLike,
      this.viewCount,
      this.user});

  Video.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    video = json['video'];
    screenshot = json['screenshot'];
    imagePath = json['imagePath'];
    isLike = json['isLike'];
    viewCount = json['viewCount'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['video'] = video;
    data['screenshot'] = screenshot;
    data['imagePath'] = imagePath;
    data['isLike'] = isLike;
    data['viewCount'] = viewCount;
    if (user != null) {
      data['user'] = user!.toJson();
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

class Liked {
  int? id;
  Video? video;

  Liked({this.id, this.video});

  Liked.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    video = json['video'] != null ? Video.fromJson(json['video']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (video != null) {
      data['video'] = video!.toJson();
    }
    return data;
  }
}
