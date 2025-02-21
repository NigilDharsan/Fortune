import 'package:fortune/Model/EditModel.dart';

class ServiceModel {
  bool? success;
  Data? data;
  String? message;

  ServiceModel({this.success, this.data, this.message});

  ServiceModel.fromJson(Map<String, dynamic> json) {
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
  List<Companies>? companies;
  List<Executives>? executives;
  List<Clients>? clients;

  Data({this.companies, this.executives, this.clients});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['companies'] != null) {
      companies = <Companies>[];
      json['companies'].forEach((v) {
        companies!.add(new Companies.fromJson(v));
      });
    }
    if (json['executives'] != null) {
      executives = <Executives>[];
      json['executives'].forEach((v) {
        executives!.add(new Executives.fromJson(v));
      });
    }
    if (json['clients'] != null) {
      clients = <Clients>[];
      json['clients'].forEach((v) {
        clients!.add(new Clients.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.companies != null) {
      data['companies'] = this.companies!.map((v) => v.toJson()).toList();
    }
    if (this.executives != null) {
      data['executives'] = this.executives!.map((v) => v.toJson()).toList();
    }
    if (this.clients != null) {
      data['clients'] = this.clients!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Executives {
  int? id;
  int? companyId;
  int? branchId;
  String? name;
  String? mobile;
  String? email;
  String? emailVerifiedAt;
  String? fcmToken;
  int? status;
  String? createdAt;
  String? updatedAt;

  Executives(
      {this.id,
      this.companyId,
      this.branchId,
      this.name,
      this.mobile,
      this.email,
      this.emailVerifiedAt,
      this.fcmToken,
      this.status,
      this.createdAt,
      this.updatedAt});

  Executives.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    branchId = json['branch_id'];
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    fcmToken = json['fcm_token'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['branch_id'] = this.branchId;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['fcm_token'] = this.fcmToken;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Clients {
  int? customerId;
  int? cusType;
  String? cusFirstName;
  String? cusLastName;
  String? gstNo;
  int? gstVerified;
  String? contactPerson;
  String? cusMobileNo;
  String? cusLandlineNo;
  String? cusEmail;
  String? address;
  String? landmark;
  String? city;
  String? cusState;
  String? pincode;
  int? companyId;
  int? addedby;
  String? status;
  String? createdAt;
  String? updatedAt;

  Clients(
      {this.customerId,
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
      this.updatedAt});

  Clients.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.customerId;
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
    return data;
  }
}
