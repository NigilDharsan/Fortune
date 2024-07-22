class AttendanceLogsModel {
  bool? success;
  Data? data;
  String? message;

  AttendanceLogsModel({this.success, this.data, this.message});

  AttendanceLogsModel.fromJson(Map<String, dynamic> json) {
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
  List<LogHours>? logHours;
  Filter? filter;

  Data({this.logHours, this.filter});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['log_hours'] != null) {
      logHours = <LogHours>[];
      json['log_hours'].forEach((v) {
        logHours!.add(new LogHours.fromJson(v));
      });
    }
    filter =
        json['filter'] != null ? new Filter.fromJson(json['filter']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.logHours != null) {
      data['log_hours'] = this.logHours!.map((v) => v.toJson()).toList();
    }
    if (this.filter != null) {
      data['filter'] = this.filter!.toJson();
    }
    return data;
  }
}

class LogHours {
  String? userName;
  int? id;
  String? logDate;
  String? checkInTime;
  String? checkOutTime;
  String? totalLoggedHrs;
  String? actionLink;
  String? actionLinkText;

  LogHours(
      {this.userName,
      this.id,
      this.logDate,
      this.checkInTime,
      this.checkOutTime,
      this.totalLoggedHrs,
      this.actionLink,
      this.actionLinkText});

  LogHours.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    id = json['id'];
    logDate = json['log_date'];
    checkInTime = json['check_in_time'];
    checkOutTime = json['check_out_time'];
    totalLoggedHrs = json['total_logged_hrs'];
    actionLink = json['action_link'];
    actionLinkText = json['action_link_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.userName;
    data['id'] = this.id;
    data['log_date'] = this.logDate;
    data['check_in_time'] = this.checkInTime;
    data['check_out_time'] = this.checkOutTime;
    data['total_logged_hrs'] = this.totalLoggedHrs;
    data['action_link'] = this.actionLink;
    data['action_link_text'] = this.actionLinkText;
    return data;
  }
}

class Filter {
  Months? months;
  Years? years;
  List<Executives>? executives;

  Filter({this.months, this.years, this.executives});

  Filter.fromJson(Map<String, dynamic> json) {
    months =
        json['months'] != null ? new Months.fromJson(json['months']) : null;
    years = json['years'] != null ? new Years.fromJson(json['years']) : null;
    if (json['executives'] != null) {
      executives = <Executives>[];
      json['executives'].forEach((v) {
        executives!.add(new Executives.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.months != null) {
      data['months'] = this.months!.toJson();
    }
    if (this.years != null) {
      data['years'] = this.years!.toJson();
    }
    if (this.executives != null) {
      data['executives'] = this.executives!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Months {
  String? s06;
  String? s07;

  Months({this.s06, this.s07});

  Months.fromJson(Map<String, dynamic> json) {
    s06 = json['06'];
    s07 = json['07'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['06'] = this.s06;
    data['07'] = this.s07;
    return data;
  }
}

class Years {
  int? i2024;

  Years({this.i2024});

  Years.fromJson(Map<String, dynamic> json) {
    i2024 = json['2024'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['2024'] = this.i2024;
    return data;
  }
}

class Executives {
  int? id;
  int? companyId;
  int? branchId;
  String? name;
  Null? mobile;
  String? email;
  Null? emailVerifiedAt;
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
