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

  Data({this.services});

  Data.fromJson(Map<String, dynamic> json) {
    services = json['services'] != null
        ? new Services.fromJson(json['services'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.services != null) {
      data['services'] = this.services!.toJson();
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
  Null? prevPageUrl;
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
