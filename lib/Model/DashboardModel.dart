import 'package:fortune/Model/MarketingHistoryModel.dart';
import 'package:fortune/Model/ServiceHistoryModel.dart';

// class DashboardModel {
//   bool? success;
//   Data? data;
//   String? message;

//   DashboardModel({this.success, this.data, this.message});

//   DashboardModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
//     message = json['message'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['success'] = this.success;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     data['message'] = this.message;
//     return data;
//   }
// }

// class Data {
//   int? servicesCount;
//   int? marketingCount;

//   int? itemCount;
//   int? clientCount;
//   List<ServicesData1>? services;
//   List<HistoryData>? marketings;
//   List<HistoryData>? todayMarketings;

//   Data({this.servicesCount, this.marketingCount, this.services});

//   Data.fromJson(Map<String, dynamic> json) {
//     servicesCount = json['servicesCount'];
//     marketingCount = json['marketingCount'];
//     itemCount = json['itemCount'];
//     clientCount = json['clientCount'];

//     if (json['services'] != null) {
//       services = <ServicesData1>[];
//       json['services'].forEach((v) {
//         services!.add(ServicesData1.fromJson(v));
//       });
//     }

//     if (json['marketings'] != null) {
//       marketings = <HistoryData>[];
//       json['marketings'].forEach((v) {
//         marketings!.add(HistoryData.fromJson(v));
//       });
//     }

//     if (json['todayMarketings'] != null) {
//       todayMarketings = <HistoryData>[];
//       json['todayMarketings'].forEach((v) {
//         todayMarketings!.add(HistoryData.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['servicesCount'] = this.servicesCount;
//     data['marketingCount'] = this.marketingCount;
//     data['itemCount'] = this.itemCount;
//     data['clientCount'] = this.clientCount;

//     if (this.services != null) {
//       data['services'] = this.services!.map((v) => v.toJson()).toList();
//     }
//     if (this.marketings != null) {
//       data['marketings'] = this.marketings!.map((v) => v.toJson()).toList();
//     }
//     if (this.todayMarketings != null) {
//       data['todayMarketings'] =
//           this.todayMarketings!.map((v) => v.toJson()).toList();
//     }

//     return data;
//   }
// }

class DashboardModel {
  bool? success;
  Data? data;
  String? message;

  DashboardModel({this.success, this.data, this.message});

  DashboardModel.fromJson(Map<String, dynamic> json) {
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
  int? usersCount;
  int? servicesCount;
  int? marketingCount;
  int? itemCount;
  int? clientCount;
  List<ServicesData1>? services;
  List<HistoryData>? marketings;
  List<HistoryData>? todayMarketings;
  CheckIncheckOut? checkIncheckOut;
  UserRolePermission? userRolePermission;
  String? appVersion;
  String? appUrl;
  String? appUrlIOS;

  Data(
      {this.usersCount,
      this.servicesCount,
      this.marketingCount,
      this.itemCount,
      this.clientCount,
      this.services,
      this.marketings,
      this.todayMarketings,
      this.checkIncheckOut,
      this.userRolePermission,
      this.appVersion,
      this.appUrl,
      this.appUrlIOS});

  Data.fromJson(Map<String, dynamic> json) {
    usersCount = json['usersCount'];
    servicesCount = json['servicesCount'];
    marketingCount = json['marketingCount'];
    itemCount = json['itemCount'];
    clientCount = json['clientCount'];
    if (json['services'] != null) {
      services = <ServicesData1>[];
      json['services'].forEach((v) {
        services!.add(new ServicesData1.fromJson(v));
      });
    }
    if (json['marketings'] != null) {
      marketings = <HistoryData>[];
      json['marketings'].forEach((v) {
        marketings!.add(new HistoryData.fromJson(v));
      });
    }
    if (json['todayMarketings'] != null) {
      todayMarketings = <HistoryData>[];
      json['todayMarketings'].forEach((v) {
        todayMarketings!.add(new HistoryData.fromJson(v));
      });
    }
    checkIncheckOut = json['checkIncheckOut'] != null
        ? new CheckIncheckOut.fromJson(json['checkIncheckOut'])
        : null;
    userRolePermission = json['userRolePermission'] != null
        ? new UserRolePermission.fromJson(json['userRolePermission'])
        : null;
    appVersion = json['appVersion'];
    appUrl = json['appUrl'];
    appUrlIOS = json['appUrlIOS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['usersCount'] = this.usersCount;
    data['servicesCount'] = this.servicesCount;
    data['marketingCount'] = this.marketingCount;
    data['itemCount'] = this.itemCount;
    data['clientCount'] = this.clientCount;
    if (this.services != null) {
      data['services'] = this.services!.map((v) => v.toJson()).toList();
    }
    if (this.marketings != null) {
      data['marketings'] = this.marketings!.map((v) => v.toJson()).toList();
    }
    if (this.todayMarketings != null) {
      data['todayMarketings'] =
          this.todayMarketings!.map((v) => v.toJson()).toList();
    }
    if (this.checkIncheckOut != null) {
      data['checkIncheckOut'] = this.checkIncheckOut!.toJson();
    }
    if (this.userRolePermission != null) {
      data['userRolePermission'] = this.userRolePermission!.toJson();
    }
    data['appVersion'] = this.appVersion;
    data['appUrl'] = this.appUrl;
    data['appUrlIOS'] = this.appUrlIOS;

    return data;
  }
}

class CheckIncheckOut {
  int? isUserNotCheckOut;
  String? notCheckOutDate;
  int? isUserCheckInToday;

  CheckIncheckOut(
      {this.isUserNotCheckOut, this.notCheckOutDate, this.isUserCheckInToday});

  CheckIncheckOut.fromJson(Map<String, dynamic> json) {
    isUserNotCheckOut = json['is_user_not_check_out'];
    notCheckOutDate = json['not_check_out_date'];
    isUserCheckInToday = json['is_user_check_in_today'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_user_not_check_out'] = this.isUserNotCheckOut;
    data['not_check_out_date'] = this.notCheckOutDate;
    data['is_user_check_in_today'] = this.isUserCheckInToday;
    return data;
  }
}

class UserRolePermission {
  String? role;
  List<String>? permissions;

  UserRolePermission({this.role, this.permissions});

  UserRolePermission.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    permissions = json['permissions'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role'] = this.role;
    data['permissions'] = this.permissions;
    return data;
  }
}
