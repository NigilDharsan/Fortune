import 'package:fortune/Model/ServiceListModel.dart';

class MarketingListModel {
  bool? success;
  Data? data;
  String? message;

  MarketingListModel({this.success, this.data, this.message});

  MarketingListModel.fromJson(Map<String, dynamic> json) {
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
  Marketings? marketings;
  Filter? filter;

  Data({this.marketings, this.filter});

  Data.fromJson(Map<String, dynamic> json) {
    marketings = json['marketings'] != null
        ? new Marketings.fromJson(json['marketings'])
        : null;
    filter =
        json['filter'] != null ? new Filter.fromJson(json['filter']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.marketings != null) {
      data['marketings'] = this.marketings!.toJson();
    }
    if (this.filter != null) {
      data['filter'] = this.filter!.toJson();
    }
    return data;
  }
}

class Marketings {
  int? currentPage;
  List<MarketingListData>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  Marketings(
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

  Marketings.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <MarketingListData>[];
      json['data'].forEach((v) {
        data!.add(new MarketingListData.fromJson(v));
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

class MarketingListData {
  int? leadId;
  String? status;
  String? clientName;
  String? address;
  String? contactNo;
  String? date;
  String? statusNote;
  List<MarketingExecutives>? marketingExecutives;
  String? nextFollowupDate;
  String? planForNextMeet;

  MarketingListData(
      {this.leadId,
      this.status,
      this.clientName,
      this.address,
      this.contactNo,
      this.date,
      this.statusNote,
      this.marketingExecutives,
      this.nextFollowupDate,
      this.planForNextMeet});

  MarketingListData.fromJson(Map<String, dynamic> json) {
    leadId = json['lead_id'];
    status = json['status'];
    clientName = json['client_name'];
    address = json['address'];
    contactNo = json['contact_no'];
    date = json['date'];
    statusNote = json['status_note'];
    if (json['marketing_executives'] != null) {
      marketingExecutives = <MarketingExecutives>[];
      json['marketing_executives'].forEach((v) {
        marketingExecutives!.add(new MarketingExecutives.fromJson(v));
      });
    }
    nextFollowupDate = json['next_followup_date'];
    planForNextMeet = json['plan_for_next_meet'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lead_id'] = this.leadId;
    data['status'] = this.status;
    data['client_name'] = this.clientName;
    data['address'] = this.address;
    data['contact_no'] = this.contactNo;
    data['date'] = this.date;
    data['status_note'] = this.statusNote;
    if (this.marketingExecutives != null) {
      data['marketing_executives'] =
          this.marketingExecutives!.map((v) => v.toJson()).toList();
    }
    data['next_followup_date'] = this.nextFollowupDate;
    data['plan_for_next_meet'] = this.planForNextMeet;
    return data;
  }
}

class MarketingExecutives {
  int? id;
  String? name;

  MarketingExecutives({this.id, this.name});

  MarketingExecutives.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
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
