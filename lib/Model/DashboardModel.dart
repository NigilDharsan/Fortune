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

  Data({this.servicesCount, this.marketingCount});

  Data.fromJson(Map<String, dynamic> json) {
    servicesCount = json['servicesCount'];
    marketingCount = json['marketingCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['servicesCount'] = this.servicesCount;
    data['marketingCount'] = this.marketingCount;
    return data;
  }
}
