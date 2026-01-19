class LeaveRequestListModel {
  bool? success;
  Data? data;
  String? message;

  LeaveRequestListModel({this.success, this.data, this.message});

  LeaveRequestListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? currentPage;
  List<RequestListData>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  Null? nextPageUrl;
  String? path;
  int? perPage;
  Null? prevPageUrl;
  int? to;
  int? total;

  Data(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.links,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <RequestListData>[];
      json['data'].forEach((v) {
        data!.add(new RequestListData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
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
      this.recordType});

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
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}
