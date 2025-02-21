class GeneralListModel {
  bool? success;
  List<GeneralListData>? data;
  String? message;

  GeneralListModel({this.success, this.data, this.message});

  GeneralListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <GeneralListData>[];
      json['data'].forEach((v) {
        data!.add(new GeneralListData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class GeneralListData {
  int? followupId;
  int? clientId;
  String? type;
  String? currentFollowup;
  String? nextFollowup;
  String? status;
  String? statusNote;
  String? cusFirstName;
  Null? cusLastName;

  GeneralListData(
      {this.followupId,
      this.clientId,
      this.type,
      this.currentFollowup,
      this.nextFollowup,
      this.status,
      this.statusNote,
      this.cusFirstName,
      this.cusLastName});

  GeneralListData.fromJson(Map<String, dynamic> json) {
    followupId = json['followup_id'];
    clientId = json['client_id'];
    type = json['type'];
    currentFollowup = json['current_followup'];
    nextFollowup = json['next_followup'];
    status = json['status'];
    statusNote = json['status_note'];
    cusFirstName = json['cus_first_name'];
    cusLastName = json['cus_last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['followup_id'] = this.followupId;
    data['client_id'] = this.clientId;
    data['type'] = this.type;
    data['current_followup'] = this.currentFollowup;
    data['next_followup'] = this.nextFollowup;
    data['status'] = this.status;
    data['status_note'] = this.statusNote;
    data['cus_first_name'] = this.cusFirstName;
    data['cus_last_name'] = this.cusLastName;
    return data;
  }
}
