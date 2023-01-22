class ReportReasonModal {
  String? msg;
  List<ReportReasonData>? data;
  bool? success;

  ReportReasonModal({this.msg, this.data, this.success});

  ReportReasonModal.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['data'] != null) {
      data = <ReportReasonData>[];
      json['data'].forEach((v) {
        data!.add(ReportReasonData.fromJson(v));
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

class ReportReasonData {
  int? id;
  String? reason;

  ReportReasonData({this.id, this.reason});

  ReportReasonData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['reason'] = reason;
    return data;
  }
}
