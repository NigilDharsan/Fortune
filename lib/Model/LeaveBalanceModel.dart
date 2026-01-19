class LeaveBalanceModel {
  bool? success;
  Data? data;
  String? message;

  LeaveBalanceModel({this.success, this.data, this.message});

  LeaveBalanceModel.fromJson(Map<String, dynamic> json) {
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
  String? leaveType;
  int? availableBalance;
  int? yearlyUsed;
  int? yearlyLop;
  int? annualEntitlement;
  int? monthlyLimit;
  int? maxConsecutive;

  Data(
      {this.leaveType,
      this.availableBalance,
      this.yearlyUsed,
      this.yearlyLop,
      this.annualEntitlement,
      this.monthlyLimit,
      this.maxConsecutive});

  Data.fromJson(Map<String, dynamic> json) {
    leaveType = json['leave_type'];
    availableBalance = json['available_balance'];
    yearlyUsed = json['yearly_used'];
    yearlyLop = json['yearly_lop'];
    annualEntitlement = json['annual_entitlement'];
    monthlyLimit = json['monthly_limit'];
    maxConsecutive = json['max_consecutive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leave_type'] = this.leaveType;
    data['available_balance'] = this.availableBalance;
    data['yearly_used'] = this.yearlyUsed;
    data['yearly_lop'] = this.yearlyLop;
    data['annual_entitlement'] = this.annualEntitlement;
    data['monthly_limit'] = this.monthlyLimit;
    data['max_consecutive'] = this.maxConsecutive;
    return data;
  }
}
