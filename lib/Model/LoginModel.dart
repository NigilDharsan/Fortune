class LoginModel {
  bool? success;
  Data? data;
  String? message;

  LoginModel({this.success, this.data, this.message});

  LoginModel.fromJson(Map<String, dynamic> json) {
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
  String? token;
  String? name;
  String? role;
  List<String>? permissions;

  Data({this.token, this.name, this.role, this.permissions});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    name = json['name'];
    role = json['role'];
    permissions =
        json['permissions'] != null ? json['permissions'].cast<String>() : null;

    // permissions = json['permissions'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['name'] = this.name;
    data['role'] = this.role;
    data['permissions'] = this.permissions;
    return data;
  }
}
