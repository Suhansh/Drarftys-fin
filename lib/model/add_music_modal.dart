class AddMusicModal {
  String? msg;
  Data? data;
  bool? success;

  AddMusicModal({this.msg, this.data, this.success});

  AddMusicModal.fromJson(Map<String, dynamic> json) {
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
  List<All>? all;
  List<Popular>? popular;
  List<Playlist>? playlist;
  List<Favorite>? favorite;

  Data({this.all, this.popular, this.playlist, this.favorite});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['all'] != null) {
      all = <All>[];
      json['all'].forEach((v) {
        all!.add(All.fromJson(v));
      });
    }
    if (json['popular'] != null) {
      popular = <Popular>[];
      json['popular'].forEach((v) {
        popular!.add(Popular.fromJson(v));
      });
    }
    if (json['playlist'] != null) {
      playlist = <Playlist>[];
      json['playlist'].forEach((v) {
        playlist!.add(Playlist.fromJson(v));
      });
    }
    if (json['favorite'] != null) {
      favorite = <Favorite>[];
      json['favorite'].forEach((v) {
        favorite!.add(Favorite.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (all != null) {
      data['all'] = all!.map((v) => v.toJson()).toList();
    }
    if (popular != null) {
      data['popular'] = popular!.map((v) => v.toJson()).toList();
    }
    if (playlist != null) {
      data['playlist'] = playlist!.map((v) => v.toJson()).toList();
    }
    if (favorite != null) {
      data['favorite'] = favorite!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class All {
  int? id;
  String? title;
  String? image;
  String? artist;
  String? movie;
  String? audio;
  int? duration;
  String? imagePath;
  int? songUsed;
  int? isFavorite;

  All(
      {this.id,
      this.title,
      this.image,
      this.artist,
      this.movie,
      this.audio,
      this.duration,
      this.imagePath,
      this.songUsed,
      this.isFavorite});

  All.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    artist = json['artist'];
    movie = json['movie'];
    audio = json['audio'];
    duration = json['duration'];
    imagePath = json['imagePath'];
    songUsed = json['songUsed'];
    isFavorite = json['isFavorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    data['artist'] = artist;
    data['movie'] = movie;
    data['audio'] = audio;
    data['duration'] = duration;
    data['imagePath'] = imagePath;
    data['songUsed'] = songUsed;
    data['isFavorite'] = isFavorite;
    return data;
  }
}

class Popular {
  int? id;
  String? title;
  String? image;
  String? artist;
  String? movie;
  String? audio;
  int? duration;
  String? imagePath;
  int? isFavorite;

  Popular(
      {this.id,
      this.title,
      this.image,
      this.artist,
      this.movie,
      this.audio,
      this.duration,
      this.imagePath,
      this.isFavorite});

  Popular.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    artist = json['artist'];
    movie = json['movie'];
    audio = json['audio'];
    duration = json['duration'];
    imagePath = json['imagePath'];
    isFavorite = json['isFavorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    data['artist'] = artist;
    data['movie'] = movie;
    data['audio'] = audio;
    data['duration'] = duration;
    data['imagePath'] = imagePath;
    data['isFavorite'] = isFavorite;
    return data;
  }
}

class Playlist {
  int? id;
  String? title;
  String? image;
  String? imagePath;

  Playlist({this.id, this.title, this.image, this.imagePath});

  Playlist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    data['imagePath'] = imagePath;
    return data;
  }
}

class Favorite {
  int? id;
  Song? song;

  Favorite({this.id, this.song});

  Favorite.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    song = json['song'] != null ? Song.fromJson(json['song']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (song != null) {
      data['song'] = song!.toJson();
    }
    return data;
  }
}

class Song {
  int? id;
  String? title;
  String? image;
  String? artist;
  String? movie;
  String? audio;
  String? imagePath;

  Song(
      {this.id,
      this.title,
      this.image,
      this.artist,
      this.movie,
      this.audio,
      this.imagePath});

  Song.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    artist = json['artist'];
    movie = json['movie'];
    audio = json['audio'];
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    data['artist'] = artist;
    data['movie'] = movie;
    data['audio'] = audio;
    data['imagePath'] = imagePath;
    return data;
  }
}
