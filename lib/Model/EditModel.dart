import 'package:fortune/Model/ServiceModel.dart';

class EditModel {
  bool? success;
  Data? data;
  String? message;

  EditModel({this.success, this.data, this.message});

  EditModel.fromJson(Map<String, dynamic> json) {
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
  Status? status;
  List<EditData>? data;
  List<SpareItem>? spareItem;
  List<ServiceSpare>? serviceSpare;

  Data(
      {this.companies,
      this.status,
      this.data,
      this.executives,
      this.spareItem,
      this.serviceSpare});

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
    status =
        json['status'] != null ? new Status.fromJson(json['status']) : null;
    if (json['data'] != null) {
      data = <EditData>[];
      json['data'].forEach((v) {
        data!.add(new EditData.fromJson(v));
      });
    }
    if (json['spare_item'] != null) {
      spareItem = <SpareItem>[];
      json['spare_item'].forEach((v) {
        spareItem!.add(new SpareItem.fromJson(v));
      });
    }
    if (json['service_spare'] != null) {
      serviceSpare = <ServiceSpare>[];
      json['service_spare'].forEach((v) {
        serviceSpare!.add(new ServiceSpare.fromJson(v));
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
    if (this.status != null) {
      data['status'] = this.status!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.spareItem != null) {
      data['spare_item'] = this.spareItem!.map((v) => v.toJson()).toList();
    }
    if (this.serviceSpare != null) {
      data['service_spare'] =
          this.serviceSpare!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Companies {
  int? companyId;
  String? name;
  String? email;
  String? logo;
  String? qrScanner;
  String? mobileNo;
  String? accNo;
  String? ifsc;
  String? bankName;
  String? branchName;
  String? gstNo;
  String? landlineNo;
  String? websiteLink;
  String? address;
  String? city;
  String? state;
  String? pincode;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? bankDetails;
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

class EditData {
  int? serviceId;
  int? companyId;
  String? servicerepsInvolved;
  String? billeddoc;
  String? branchId;
  String? unitId;
  int? customerId;
  String? cusType;
  String? hsn;
  String? ticketNo;
  String? cusFirstName;
  String? cusState;
  String? cusLastName;
  String? gstVerified;
  String? gstNo;
  String? address;
  String? landmark;
  String? city;
  String? contactPerson;
  String? cusMobileNo;
  String? typeOfUnit;
  String? unitCapacity;
  String? unitLocation;
  String? typeOfService;
  String? natureOfComplaint;
  List<String>? reportUpload;
  String? reportDescription;
  String? technicianId;
  String? reportFromTechnician;
  String? callTakenDate;
  String? technicianAllocateDate;
  String? technicianReportDate;
  String? addedby;
  String? status;
  String? paidStatus;
  String? advAmount;
  String? typeOfWork;
  String? serviceType;
  String? amount;
  String? createdAt;
  String? updatedAt;
  String? requirement;

  EditData({
    this.serviceId,
    this.companyId,
    this.servicerepsInvolved,
    this.billeddoc,
    this.branchId,
    this.unitId,
    this.customerId,
    this.cusType,
    this.hsn,
    this.ticketNo,
    this.cusFirstName,
    this.cusState,
    this.cusLastName,
    this.gstVerified,
    this.gstNo,
    this.address,
    this.landmark,
    this.city,
    this.contactPerson,
    this.cusMobileNo,
    this.typeOfUnit,
    this.unitCapacity,
    this.unitLocation,
    this.typeOfService,
    this.natureOfComplaint,
    this.reportUpload,
    this.reportDescription,
    this.technicianId,
    this.reportFromTechnician,
    this.callTakenDate,
    this.technicianAllocateDate,
    this.technicianReportDate,
    this.addedby,
    this.status,
    this.paidStatus,
    this.advAmount,
    this.typeOfWork,
    this.serviceType,
    this.amount,
    this.createdAt,
    this.updatedAt,
    this.requirement,
  });

  EditData.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    companyId = json['company_id'];
    servicerepsInvolved = json['servicereps_involved'];
    billeddoc = json['billeddoc'];
    branchId = json['branch_id'];
    unitId = json['unit_id'];
    customerId = json['customer_id'];
    cusType = json['cus_type'];
    hsn = json['hsn'];
    ticketNo = json['ticket_no'];
    cusFirstName = json['cus_first_name'];
    cusState = json['cus_state'];
    cusLastName = json['cus_last_name'];
    gstVerified = json['gst_verified'];
    gstNo = json['gst_no'];
    address = json['address'];
    landmark = json['landmark'];
    city = json['city'];
    contactPerson = json['contact_person'];
    cusMobileNo = json['cus_mobile_no'];
    typeOfUnit = json['type_of_unit'];
    unitCapacity = json['unit_capacity'];
    unitLocation = json['unit_location'];
    typeOfService = json['type_of_service'];
    natureOfComplaint = json['nature_of_complaint'];

    if (json['report_upload'] is String) {
      final str = json['report_upload'];

      final strArr = [];
      strArr.add(str);
      reportUpload = strArr.cast<String>();
    } else if (json['report_upload'] is List<dynamic>) {
      reportUpload = json['report_upload'].cast<String>();
    } else {}

    reportDescription = json['report_description'];
    technicianId = json['technician_id'];
    reportFromTechnician = json['report_from_technician'];
    callTakenDate = json['call_taken_date'];
    technicianAllocateDate = json['technician_allocate_date'];
    technicianReportDate = json['technician_report_date'];
    addedby = json['addedby'];
    status = json['status'];
    paidStatus = json['paid_status'];
    advAmount = json['adv_amount'];
    typeOfWork = json['type_of_work'];
    serviceType = json['service_type'];
    amount = json['amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    requirement = json['requirement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_id'] = this.serviceId;
    data['company_id'] = this.companyId;
    data['servicereps_involved'] = this.servicerepsInvolved;
    data['billeddoc'] = this.billeddoc;
    data['branch_id'] = this.branchId;
    data['unit_id'] = this.unitId;
    data['customer_id'] = this.customerId;
    data['cus_type'] = this.cusType;
    data['hsn'] = this.hsn;
    data['ticket_no'] = this.ticketNo;
    data['cus_first_name'] = this.cusFirstName;
    data['cus_state'] = this.cusState;
    data['cus_last_name'] = this.cusLastName;
    data['gst_verified'] = this.gstVerified;
    data['gst_no'] = this.gstNo;
    data['address'] = this.address;
    data['landmark'] = this.landmark;
    data['city'] = this.city;
    data['contact_person'] = this.contactPerson;
    data['cus_mobile_no'] = this.cusMobileNo;
    data['type_of_unit'] = this.typeOfUnit;
    data['unit_capacity'] = this.unitCapacity;
    data['unit_location'] = this.unitLocation;
    data['type_of_service'] = this.typeOfService;
    data['nature_of_complaint'] = this.natureOfComplaint;
    data['report_upload'] = this.reportUpload;
    data['report_description'] = this.reportDescription;
    data['technician_id'] = this.technicianId;
    data['report_from_technician'] = this.reportFromTechnician;
    data['call_taken_date'] = this.callTakenDate;
    data['technician_allocate_date'] = this.technicianAllocateDate;
    data['technician_report_date'] = this.technicianReportDate;
    data['addedby'] = this.addedby;
    data['status'] = this.status;
    data['paid_status'] = this.paidStatus;
    data['adv_amount'] = this.advAmount;
    data['type_of_work'] = this.typeOfWork;
    data['service_type'] = this.serviceType;
    data['amount'] = this.amount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['requirement'] = this.requirement;

    return data;
  }
}

class SpareItem {
  int? spareId;
  String? itemName;
  int? quantity;

  SpareItem({this.spareId, this.itemName, this.quantity});

  SpareItem.fromJson(Map<String, dynamic> json) {
    spareId = json['spare_id'];
    itemName = json['item_name'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['spare_id'] = this.spareId;
    data['item_name'] = this.itemName;
    data['quantity'] = this.quantity;
    return data;
  }
}

class ServiceSpare {
  int? id;
  int? spareId;
  int? quantity;
  Spare? spare;

  ServiceSpare({this.id, this.spareId, this.quantity, this.spare});

  ServiceSpare.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    spareId = json['spare_id'];
    quantity = json['quantity'];
    spare = json['spare'] != null ? new Spare.fromJson(json['spare']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['spare_id'] = this.spareId;
    data['quantity'] = this.quantity;
    if (this.spare != null) {
      data['spare'] = this.spare!.toJson();
    }
    return data;
  }
}

class Spare {
  int? id;
  int? servicerepsInvolved;
  int? itemId;
  int? quantity;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  Item? item;

  Spare(
      {this.id,
      this.servicerepsInvolved,
      this.itemId,
      this.quantity,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.item});

  Spare.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    servicerepsInvolved = json['servicereps_involved'];
    itemId = json['item_id'];
    quantity = json['quantity'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    item = json['item'] != null ? new Item.fromJson(json['item']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['servicereps_involved'] = this.servicerepsInvolved;
    data['item_id'] = this.itemId;
    data['quantity'] = this.quantity;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.item != null) {
      data['item'] = this.item!.toJson();
    }
    return data;
  }
}

class Item {
  int? id;
  int? itemId;
  String? itemName;
  String? itemType;
  String? itemCategory;
  Null? addedBy;
  String? createdAt;
  String? updatedAt;

  Item(
      {this.id,
      this.itemId,
      this.itemName,
      this.itemType,
      this.itemCategory,
      this.addedBy,
      this.createdAt,
      this.updatedAt});

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['item_id'];
    itemName = json['item_name'];
    itemType = json['item_type'];
    itemCategory = json['item_category'];
    addedBy = json['added_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['item_id'] = this.itemId;
    data['item_name'] = this.itemName;
    data['item_type'] = this.itemType;
    data['item_category'] = this.itemCategory;
    data['added_by'] = this.addedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
