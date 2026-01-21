class LeaveRequestListModel {
  bool? success;
  List<RequestListData>? data;
  String? message;

  LeaveRequestListModel({this.success, this.data, this.message});

  LeaveRequestListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <RequestListData>[];
      json['data'].forEach((v) {
        data!.add(new RequestListData.fromJson(v));
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

class RequestListData {
  String? id;
  String? fromDate;
  String? toDate;
  String? fromDisplay;
  String? toDisplay;
  String? fromTime;
  String? toTime;
  String? reason;
  String? status;
  String? approvedDate;
  String? rejectReason;
  String? recordType;
  String? leaveTypeName;

  RequestListData(
      {this.id,
      this.fromDate,
      this.toDate,
      this.fromDisplay,
      this.toDisplay,
      this.fromTime,
      this.toTime,
      this.reason,
      this.status,
      this.approvedDate,
      this.rejectReason,
      this.recordType,
      this.leaveTypeName});

  RequestListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
    fromDisplay = json['from_display'];
    toDisplay = json['to_display'];
    fromTime = json['from_time'];
    toTime = json['to_time'];
    reason = json['reason'];
    status = json['status'];
    approvedDate = json['approved_date'];
    rejectReason = json['reject_reason'];
    recordType = json['record_type'];
    leaveTypeName = json['leave_type_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['from_date'] = this.fromDate;
    data['to_date'] = this.toDate;
    data['from_display'] = this.fromDisplay;
    data['to_display'] = this.toDisplay;
    data['from_time'] = this.fromTime;
    data['to_time'] = this.toTime;
    data['reason'] = this.reason;
    data['status'] = this.status;
    data['approved_date'] = this.approvedDate;
    data['reject_reason'] = this.rejectReason;
    data['record_type'] = this.recordType;
    data['leave_type_name'] = this.leaveTypeName;
    return data;
  }
}
