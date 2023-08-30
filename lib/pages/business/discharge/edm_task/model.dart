// 任务夹具
class EdmTaskFixtureData {
  int? edmTaskId;
  String? taskState;
  String? fixture;

  EdmTaskFixtureData({this.edmTaskId, this.taskState, this.fixture});

  EdmTaskFixtureData.fromJson(Map<String, dynamic> json) {
    edmTaskId = json['edmTaskId'];
    taskState = json['taskState'];
    fixture = json['fixture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['edmTaskId'] = this.edmTaskId;
    data['taskState'] = this.taskState;
    data['fixture'] = this.fixture;
    return data;
  }
}
