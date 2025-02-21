class ExectiveModel {
  bool? success;
  List<ExectiveData>? data;
  String? message;

  ExectiveModel({this.success, this.data, this.message});

  ExectiveModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <ExectiveData>[];
      json['data'].forEach((v) {
        data!.add(new ExectiveData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class ExectiveData {
  int? id;
  String? name;

  ExectiveData({this.id, this.name});

  ExectiveData.fromJson(Map<String, dynamic> json) {
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
