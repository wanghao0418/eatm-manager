import 'package:eatm_manager/pages/business/scheduling/models.dart';

class MachineSchedulingInfo {
  List<ProductionOrders>? list;
  String? plant;
  int? useStatus;
  int? deviceInlineStatus;

  MachineSchedulingInfo(
      {this.list, this.plant, this.useStatus, this.deviceInlineStatus});

  MachineSchedulingInfo.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <ProductionOrders>[];
      json['list'].forEach((v) {
        list!.add(ProductionOrders.fromJson(v));
      });
    }
    plant = json['plant'];
    useStatus = json['useStatus'];
    deviceInlineStatus = json['deviceInlineStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    data['plant'] = this.plant;
    data['useStatus'] = this.useStatus;
    data['deviceInlineStatus'] = this.deviceInlineStatus;
    return data;
  }
}
