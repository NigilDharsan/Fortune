import 'package:fortune/Model/ServiceListModel.dart';

class ClientsModel {
  bool? success;
  Data? data;
  String? message;

  ClientsModel({this.success, this.data, this.message});

  ClientsModel.fromJson(Map<String, dynamic> json) {
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
  Filter? filter;
  ClientsData? clients;

  Data({this.filter, this.clients});

  Data.fromJson(Map<String, dynamic> json) {
    filter =
        json['filter'] != null ? new Filter.fromJson(json['filter']) : null;
    clients = json['clients'] != null
        ? new ClientsData.fromJson(json['clients'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.filter != null) {
      data['filter'] = this.filter!.toJson();
    }
    if (this.clients != null) {
      data['clients'] = this.clients!.toJson();
    }
    return data;
  }
}

class ClientsData {
  int? currentPage;
  List<ClientsDataObject>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  Null? prevPageUrl;
  int? to;
  int? total;

  ClientsData(
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

  ClientsData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <ClientsDataObject>[];
      json['data'].forEach((v) {
        data!.add(new ClientsDataObject.fromJson(v));
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

class ClientsDataObject {
  int? customerId;
  String? contactId;
  Null? cusType;
  String? cusFirstName;
  Null? cusLastName;
  String? gstNo;
  Null? gstVerified;
  String? contactPerson;
  String? cusMobileNo;
  Null? cusLandlineNo;
  Null? cusEmail;
  String? address;
  Null? landmark;
  Null? city;
  String? cusState;
  Null? pincode;
  int? companyId;
  int? addedby;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? customerName;

  ClientsDataObject(
      {this.customerId,
      this.contactId,
      this.cusType,
      this.cusFirstName,
      this.cusLastName,
      this.gstNo,
      this.gstVerified,
      this.contactPerson,
      this.cusMobileNo,
      this.cusLandlineNo,
      this.cusEmail,
      this.address,
      this.landmark,
      this.city,
      this.cusState,
      this.pincode,
      this.companyId,
      this.addedby,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.customerName});

  ClientsDataObject.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    contactId = json['contact_id'];
    cusType = json['cus_type'];
    cusFirstName = json['cus_first_name'];
    cusLastName = json['cus_last_name'];
    gstNo = json['gst_no'];
    gstVerified = json['gst_verified'];
    contactPerson = json['contact_person'];
    cusMobileNo = json['cus_mobile_no'];
    cusLandlineNo = json['cus_landline_no'];
    cusEmail = json['cus_email'];
    address = json['address'];
    landmark = json['landmark'];
    city = json['city'];
    cusState = json['cus_state'];
    pincode = json['pincode'];
    companyId = json['company_id'];
    addedby = json['addedby'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    customerName = json['customer_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.customerId;
    data['contact_id'] = this.contactId;
    data['cus_type'] = this.cusType;
    data['cus_first_name'] = this.cusFirstName;
    data['cus_last_name'] = this.cusLastName;
    data['gst_no'] = this.gstNo;
    data['gst_verified'] = this.gstVerified;
    data['contact_person'] = this.contactPerson;
    data['cus_mobile_no'] = this.cusMobileNo;
    data['cus_landline_no'] = this.cusLandlineNo;
    data['cus_email'] = this.cusEmail;
    data['address'] = this.address;
    data['landmark'] = this.landmark;
    data['city'] = this.city;
    data['cus_state'] = this.cusState;
    data['pincode'] = this.pincode;
    data['company_id'] = this.companyId;
    data['addedby'] = this.addedby;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['customer_name'] = this.customerName;
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
