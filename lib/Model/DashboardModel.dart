import 'package:fortune/Model/MarketingHistoryModel.dart';
import 'package:fortune/Model/ServiceHistoryModel.dart';

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
  int? servicesCount;
  int? marketingCount;

  int? itemCount;
  int? clientCount;
  List<ServicesData1>? services;
  List<HistoryData>? marketings;
  List<HistoryData>? todayMarketings;

  Data({this.servicesCount, this.marketingCount, this.services});

  Data.fromJson(Map<String, dynamic> json) {
    servicesCount = json['servicesCount'];
    marketingCount = json['marketingCount'];
    itemCount = json['itemCount'];
    clientCount = json['clientCount'];

    if (json['services'] != null) {
      services = <ServicesData1>[];
      json['services'].forEach((v) {
        services!.add(ServicesData1.fromJson(v));
      });
    }

    if (json['marketings'] != null) {
      marketings = <HistoryData>[];
      json['marketings'].forEach((v) {
        marketings!.add(HistoryData.fromJson(v));
      });
    }

    if (json['todayMarketings'] != null) {
      todayMarketings = <HistoryData>[];
      json['todayMarketings'].forEach((v) {
        todayMarketings!.add(HistoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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

    return data;
  }
}
