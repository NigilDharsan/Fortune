class MarketingEditModel {
  bool? success;
  Data? data;
  String? message;

  MarketingEditModel({this.success, this.data, this.message});

  MarketingEditModel.fromJson(Map<String, dynamic> json) {
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
  Status? status;
  MarketingEditData? data;

  Data({this.companies, this.status, this.data});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['companies'] != null) {
      companies = <Companies>[];
      json['companies'].forEach((v) {
        companies!.add(new Companies.fromJson(v));
      });
    }
    status =
        json['status'] != null ? new Status.fromJson(json['status']) : null;
    data = json['data'] != null
        ? new MarketingEditData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.companies != null) {
      data['companies'] = this.companies!.map((v) => v.toJson()).toList();
    }
    if (this.status != null) {
      data['status'] = this.status!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Companies {
  int? companyId;
  String? name;
  Null? email;
  Null? logo;
  Null? qrScanner;
  Null? mobileNo;
  Null? accNo;
  Null? ifsc;
  Null? bankName;
  Null? branchName;
  Null? gstNo;
  Null? landlineNo;
  Null? websiteLink;
  Null? address;
  String? city;
  Null? state;
  Null? pincode;
  int? status;
  Null? createdAt;
  Null? updatedAt;
  Null? bankDetails;
  String? companyBranch;

  Companies(
      {this.companyId,
      this.name,
      this.email,
      this.logo,
      this.qrScanner,
      this.mobileNo,
      this.accNo,
      this.ifsc,
      this.bankName,
      this.branchName,
      this.gstNo,
      this.landlineNo,
      this.websiteLink,
      this.address,
      this.city,
      this.state,
      this.pincode,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.bankDetails,
      this.companyBranch});

  Companies.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    name = json['name'];
    email = json['email'];
    logo = json['logo'];
    qrScanner = json['qr_scanner'];
    mobileNo = json['mobile_no'];
    accNo = json['acc_no'];
    ifsc = json['ifsc'];
    bankName = json['bank_name'];
    branchName = json['branch_name'];
    gstNo = json['gst_no'];
    landlineNo = json['landline_no'];
    websiteLink = json['website_link'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    bankDetails = json['bank_details'];
    companyBranch = json['company_branch'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company_id'] = this.companyId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['logo'] = this.logo;
    data['qr_scanner'] = this.qrScanner;
    data['mobile_no'] = this.mobileNo;
    data['acc_no'] = this.accNo;
    data['ifsc'] = this.ifsc;
    data['bank_name'] = this.bankName;
    data['branch_name'] = this.branchName;
    data['gst_no'] = this.gstNo;
    data['landline_no'] = this.landlineNo;
    data['website_link'] = this.websiteLink;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['pincode'] = this.pincode;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['bank_details'] = this.bankDetails;
    data['company_branch'] = this.companyBranch;
    return data;
  }
}

class Status {
  String? s1;
  String? s2;
  String? s3;
  String? s4;

  Status({this.s1, this.s2, this.s3, this.s4});

  Status.fromJson(Map<String, dynamic> json) {
    s1 = json['1'];
    s2 = json['2'];
    s3 = json['3'];
    s4 = json['4'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1'] = this.s1;
    data['2'] = this.s2;
    data['3'] = this.s3;
    data['4'] = this.s4;
    return data;
  }
}

class MarketingEditData {
  int? leadId;
  String? salesrepInvolved;
  int? customerId;
  String? clientName;
  String? companyId;
  String? address;
  String? contactNo;
  String? contactPerson;
  String? contactPersonNo;
  Null? architectDetails;
  Null? consultant;
  Null? builder;
  Null? leadGivenBy;
  Null? typeOfUnit;
  Null? tonnageExp;
  String? leadEnteredDate;
  Null? currentFollowDetails;
  String? planForNextMeet;
  String? nextFollowupDate;
  Null? leadDocument;
  String? instructions;
  Null? enquiryType;
  String? addedby;
  String? status;
  String? createdAt;
  String? updatedAt;

  MarketingEditData(
      {this.leadId,
      this.salesrepInvolved,
      this.customerId,
      this.clientName,
      this.companyId,
      this.address,
      this.contactNo,
      this.contactPerson,
      this.contactPersonNo,
      this.architectDetails,
      this.consultant,
      this.builder,
      this.leadGivenBy,
      this.typeOfUnit,
      this.tonnageExp,
      this.leadEnteredDate,
      this.currentFollowDetails,
      this.planForNextMeet,
      this.nextFollowupDate,
      this.leadDocument,
      this.instructions,
      this.enquiryType,
      this.addedby,
      this.status,
      this.createdAt,
      this.updatedAt});

  MarketingEditData.fromJson(Map<String, dynamic> json) {
    leadId = json['lead_id'];
    salesrepInvolved = json['salesrep_involved'];
    customerId = json['customer_id'];
    clientName = json['client_name'];
    companyId = json['company_id'];
    address = json['address'];
    contactNo = json['contact_no'];
    contactPerson = json['contact_person'];
    contactPersonNo = json['contact_person_no'];
    architectDetails = json['architect_details'];
    consultant = json['consultant'];
    builder = json['builder'];
    leadGivenBy = json['lead_given_by'];
    typeOfUnit = json['type_of_unit'];
    tonnageExp = json['tonnage_exp'];
    leadEnteredDate = json['lead_entered_date'];
    currentFollowDetails = json['current_follow_details'];
    planForNextMeet = json['plan_for_next_meet'];
    nextFollowupDate = json['next_followup_date'];
    leadDocument = json['lead_document'];
    instructions = json['instructions'];
    enquiryType = json['enquiry_type'];
    addedby = json['addedby'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lead_id'] = this.leadId;
    data['salesrep_involved'] = this.salesrepInvolved;
    data['customer_id'] = this.customerId;
    data['client_name'] = this.clientName;
    data['company_id'] = this.companyId;
    data['address'] = this.address;
    data['contact_no'] = this.contactNo;
    data['contact_person'] = this.contactPerson;
    data['contact_person_no'] = this.contactPersonNo;
    data['architect_details'] = this.architectDetails;
    data['consultant'] = this.consultant;
    data['builder'] = this.builder;
    data['lead_given_by'] = this.leadGivenBy;
    data['type_of_unit'] = this.typeOfUnit;
    data['tonnage_exp'] = this.tonnageExp;
    data['lead_entered_date'] = this.leadEnteredDate;
    data['current_follow_details'] = this.currentFollowDetails;
    data['plan_for_next_meet'] = this.planForNextMeet;
    data['next_followup_date'] = this.nextFollowupDate;
    data['lead_document'] = this.leadDocument;
    data['instructions'] = this.instructions;
    data['enquiry_type'] = this.enquiryType;
    data['addedby'] = this.addedby;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
