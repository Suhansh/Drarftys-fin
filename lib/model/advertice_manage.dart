class AdvertiseManage {
  String? msg;
  List<Data>? data;
  bool? success;

  AdvertiseManage({this.msg, this.data, this.success});

  AdvertiseManage.fromJson(Map<String, dynamic> json) {
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
  String? location;
  String? network;
  String? type;
  String? unit;
  String? interval;
  int? status;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.location,
      this.network,
      this.type,
      this.unit,
      this.interval,
      this.status,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    location = json['location'];
    network = json['network'];
    type = json['type'];
    unit = json['unit'];
    interval = json['interval'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['location'] = location;
    data['network'] = network;
    data['type'] = type;
    data['unit'] = unit;
    data['interval'] = interval;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
