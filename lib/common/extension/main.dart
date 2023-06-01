class MenuItem {
  String? id;
  String? module;
  String? name;
  String? nameEn;
  int? orderBy;
  String? pid;
  String? remark;
  String? subsystemId;
  String? url;
  List<MenuItem>? children;

  MenuItem(
      {this.id,
      this.module,
      this.name,
      this.nameEn,
      this.orderBy,
      this.pid,
      this.remark,
      this.subsystemId,
      this.url,
      this.children});

  MenuItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    module = json['module'];
    name = json['name'];
    nameEn = json['nameEn'];
    orderBy = json['orderBy'];
    pid = json['pid'];
    remark = json['remark'];
    subsystemId = json['subsystemId'];
    url = json['url'];
    if (json['children'] != null) {
      children = <MenuItem>[];
      json['children'].forEach((v) {
        children!.add(new MenuItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['module'] = this.module;
    data['name'] = this.name;
    data['nameEn'] = this.nameEn;
    data['orderBy'] = this.orderBy;
    data['pid'] = this.pid;
    data['remark'] = this.remark;
    data['subsystemId'] = this.subsystemId;
    data['url'] = this.url;
    if (this.children != null) {
      data['children'] = this.children!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
