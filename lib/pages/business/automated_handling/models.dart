/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-09-12 09:33:03
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-13 17:02:58
 * @FilePath: /eatm_manager/lib/pages/business/automated_handling/models.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
class AGVTaskDataSearch {
  int? taskType;
  int? workPieceType;
  int? workPieceState;
  String? startTime;
  String? endTime;

  AGVTaskDataSearch(
      {this.taskType,
      this.workPieceType,
      this.workPieceState,
      this.startTime,
      this.endTime});

  Map<String, dynamic> toMap() {
    return {
      "TaskType": taskType,
      "WorkPieceType": workPieceType,
      "WorkPieceState": workPieceState,
      "startTime": startTime,
      "endTime": endTime
    };
  }

  clear() {
    taskType = null;
    workPieceType = null;
    workPieceState = null;
  }

  bool validate() {
    bool flag1 = taskType != null;
    bool flag2 = ([2, 3].contains(taskType) || workPieceType != null);
    bool flag3 = ([2, 3].contains(taskType) || workPieceState != null);
    return flag1 && flag2 && flag3;
  }
}

class AGVTask {
  String? id;
  String? taskType;
  String? workpieceType;
  String? recordTime;

  AGVTask({this.id, this.taskType, this.workpieceType, this.recordTime});

  AGVTask.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    taskType = json['TaskType'];
    workpieceType = json['WORKPIECETYPE'];
    recordTime = json['RecordTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.id;
    data['TaskType'] = this.taskType;
    data['WORKPIECETYPE'] = this.workpieceType;
    data['RecordTime'] = this.recordTime;
    return data;
  }
}
