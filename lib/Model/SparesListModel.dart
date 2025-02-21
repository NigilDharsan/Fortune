class SparesListModel {
  bool? success;
  List<SparesData>? data;
  String? message;

  SparesListModel({this.success, this.data, this.message});

  SparesListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <SparesData>[];
      json['data'].forEach((v) {
        data!.add(new SparesData.fromJson(v));
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

class SparesData {
  int? spareId;
  int? servicerepsInvolved;
  int? itemId;
  int? quantity;
  String? itemName;

  SparesData(
      {this.spareId,
      this.servicerepsInvolved,
      this.itemId,
      this.quantity,
      this.itemName});

  SparesData.fromJson(Map<String, dynamic> json) {
    spareId = json['spare_id'];
    servicerepsInvolved = json['servicereps_involved'];
    itemId = json['item_id'];
    quantity = json['quantity'];
    itemName = json['item_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['spare_id'] = this.spareId;
    data['servicereps_involved'] = this.servicerepsInvolved;
    data['item_id'] = this.itemId;
    data['quantity'] = this.quantity;
    data['item_name'] = this.itemName;
    return data;
  }
}
