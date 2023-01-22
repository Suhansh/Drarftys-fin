class SingleUser {
  int? id;
  String? userId;
  String? name;
  String? image;
  String? bio;
  int? followerRequest;
  List<Videos>? videos;
  int? postCount;
  String? imagePath;
  int? isFollowing;
  int? isRequested;
  String? followersCount;
  String? followingCount;
  int? isBlock;
  int? isReported;

  SingleUser(
      {this.id,
      this.userId,
      this.name,
      this.image,
      this.bio,
      this.followerRequest,
      this.videos,
      this.postCount,
      this.imagePath,
      this.isFollowing,
      this.isRequested,
      this.followersCount,
      this.followingCount,
      this.isBlock,
      this.isReported});

  SingleUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    image = json['image'];
    bio = json['bio'];
    followerRequest = json['follower_request'];
    if (json['videos'] != null) {
      videos = <Videos>[];
      json['videos'].forEach((v) {
        videos!.add(Videos.fromJson(v));
      });
    }
    postCount = json['postCount'];
    imagePath = json['imagePath'];
    isFollowing = json['isFollowing'];
    isRequested = json['isRequested'];
    followersCount = json['followersCount'];
    followingCount = json['followingCount'];
    isBlock = json['isBlock'];
    isReported = json['isReported'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['image'] = image;
    data['bio'] = bio;
    data['follower_request'] = followerRequest;
    if (videos != null) {
      data['videos'] = videos!.map((v) => v.toJson()).toList();
    }
    data['postCount'] = postCount;
    data['imagePath'] = imagePath;
    data['isFollowing'] = isFollowing;
    data['isRequested'] = isRequested;
    data['followersCount'] = followersCount;
    data['followingCount'] = followingCount;
    data['isBlock'] = isBlock;
    data['isReported'] = isReported;
    return data;
  }
}

class Videos {
  int? id;
  String? screenshot;
  String? imagePath;
  bool? isLike;
  String? viewCount;

  Videos(
      {this.id, this.screenshot, this.imagePath, this.isLike, this.viewCount});

  Videos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    screenshot = json['screenshot'];
    imagePath = json['imagePath'];
    isLike = json['isLike'];
    viewCount = json['viewCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['screenshot'] = screenshot;
    data['imagePath'] = imagePath;
    data['isLike'] = isLike;
    data['viewCount'] = viewCount;
    return data;
  }
}
