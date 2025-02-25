import 'package:fortune/Model/StockItemModel.dart';

class ActivityEditModel {
  bool? success;
  Data? data;
  String? message;

  ActivityEditModel({this.success, this.data, this.message});

  ActivityEditModel.fromJson(Map<String, dynamic> json) {
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
  List<StockItemData>? items;
  ActivityEditData? data;

  Data({this.items, this.data});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <StockItemData>[];
      json['items'].forEach((v) {
        items!.add(new StockItemData.fromJson(v));
      });
    }
    data = json['data'] != null
        ? new ActivityEditData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ActivityEditData {
  int? id;
  String? invoiceNo;
  String? customer;
  List<Items>? items;
  String? dispatchVehicleNo;
  int? companyId;
  int? branchId;
  int? addedBy;
  String? createdAt;
  String? updatedAt;

  ActivityEditData(
      {this.id,
      this.invoiceNo,
      this.customer,
      this.items,
      this.dispatchVehicleNo,
      this.companyId,
      this.branchId,
      this.addedBy,
      this.createdAt,
      this.updatedAt});

  ActivityEditData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    invoiceNo = json['invoice_no'];
    customer = json['customer'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    dispatchVehicleNo = json['dispatch_vehicle_no'];
    companyId = json['company_id'];
    branchId = json['branch_id'];
    addedBy = json['added_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['invoice_no'] = this.invoiceNo;
    data['customer'] = this.customer;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['dispatch_vehicle_no'] = this.dispatchVehicleNo;
    data['company_id'] = this.companyId;
    data['branch_id'] = this.branchId;
    data['added_by'] = this.addedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Items {
  String? productName;
  String? quantity;

  Items({this.productName, this.quantity});

  Items.fromJson(Map<String, dynamic> json) {
    productName = json['product_name'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_name'] = this.productName;
    data['quantity'] = this.quantity;
    return data;
  }
}
