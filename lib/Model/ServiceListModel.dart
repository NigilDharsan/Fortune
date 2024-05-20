import 'package:fortune/Model/ServiceModel.dart';

class ServiceListModel {
  bool? success;
  Data? data;
  String? message;

  ServiceListModel({this.success, this.data, this.message});

  ServiceListModel.fromJson(Map<String, dynamic> json) {
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
  Services? services;
  Filter? filter;

  Data({this.services, this.filter});

  Data.fromJson(Map<String, dynamic> json) {
    services = json['services'] != null
        ? new Services.fromJson(json['services'])
        : null;
    filter =
        json['filter'] != null ? new Filter.fromJson(json['filter']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.services != null) {
      data['services'] = this.services!.toJson();
    }
    if (this.filter != null) {
      data['filter'] = this.filter!.toJson();
    }
    return data;
  }
}

class Services {
  int? currentPage;
  List<ServicesData>? data;
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

  Services(
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

  Services.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <ServicesData>[];
      json['data'].forEach((v) {
        data!.add(new ServicesData.fromJson(v));
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

class ServicesData {
  int? serviceId;
  String? status;
  String? clientName;
  String? address;
  String? contactNo;
  String? date;
  String? statusNote;
  List<ServiceExecutives>? serviceExecutives;

  ServicesData(
      {this.serviceId,
      this.status,
      this.clientName,
      this.address,
      this.contactNo,
      this.date,
      this.statusNote,
      this.serviceExecutives});

  ServicesData.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    status = json['status'];
    clientName = json['client_name'];
    address = json['address'];
    contactNo = json['contact_no'];
    date = json['date'];
    statusNote = json['status_note'];
    if (json['service_executives'] != null) {
      serviceExecutives = <ServiceExecutives>[];
      json['service_executives'].forEach((v) {
        serviceExecutives!.add(new ServiceExecutives.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_id'] = this.serviceId;
    data['status'] = this.status;
    data['client_name'] = this.clientName;
    data['address'] = this.address;
    data['contact_no'] = this.contactNo;
    data['date'] = this.date;
    data['status_note'] = this.statusNote;
    if (this.serviceExecutives != null) {
      data['service_executives'] =
          this.serviceExecutives!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceExecutives {
  int? id;
  String? name;

  ServiceExecutives({this.id, this.name});

  ServiceExecutives.fromJson(Map<String, dynamic> json) {
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

class Filter {
  List<Company>? company;
  List<ClientDetails>? clientDetails;
  List<Executives>? executives;
  List<Branch>? branch;

  Status? status;

  Filter(
      {this.company,
      this.clientDetails,
      this.executives,
      this.branch,
      this.status});

  Filter.fromJson(Map<String, dynamic> json) {
    if (json['company'] != null) {
      company = <Company>[];
      json['company'].forEach((v) {
        company!.add(new Company.fromJson(v));
      });
    }
    if (json['client_details'] != null) {
      clientDetails = <ClientDetails>[];
      json['client_details'].forEach((v) {
        clientDetails!.add(new ClientDetails.fromJson(v));
      });
    }
    if (json['executives'] != null) {
      executives = <Executives>[];
      json['executives'].forEach((v) {
        executives!.add(new Executives.fromJson(v));
      });
    }
    if (json['branch'] != null) {
      branch = <Branch>[];
      json['branch'].forEach((v) {
        branch!.add(new Branch.fromJson(v));
      });
    }
    status =
        json['status'] != null ? new Status.fromJson(json['status']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.company != null) {
      data['company'] = this.company!.map((v) => v.toJson()).toList();
    }
    if (this.clientDetails != null) {
      data['client_details'] =
          this.clientDetails!.map((v) => v.toJson()).toList();
    }
    if (this.executives != null) {
      data['executives'] = this.executives!.map((v) => v.toJson()).toList();
    }
    if (this.branch != null) {
      data['branch'] = this.branch!.map((v) => v.toJson()).toList();
    }
    if (this.status != null) {
      data['status'] = this.status!.toJson();
    }
    return data;
  }
}

class Branch {
  int? id;
  String? branchName;
  int? companyId;
  String? createdAt;
  String? updatedAt;

  Branch(
      {this.id,
      this.branchName,
      this.companyId,
      this.createdAt,
      this.updatedAt});

  Branch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    branchName = json['branch_name'];
    companyId = json['company_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['branch_name'] = this.branchName;
    data['company_id'] = this.companyId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Company {
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

  Company(
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

  Company.fromJson(Map<String, dynamic> json) {
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

class ClientDetails {
  int? clientId;
  String? cusFirstName;

  ClientDetails({this.clientId, this.cusFirstName});

  ClientDetails.fromJson(Map<String, dynamic> json) {
    clientId = json['client_id'];
    cusFirstName = json['cus_first_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['client_id'] = this.clientId;
    data['cus_first_name'] = this.cusFirstName;
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
