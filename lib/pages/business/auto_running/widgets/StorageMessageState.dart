class StorageStateMessage {
  SigSetStorageUiStatus? sigSetStorageUiStatus;

  StorageStateMessage({this.sigSetStorageUiStatus});

  StorageStateMessage.fromJson(Map<String, dynamic> json) {
    sigSetStorageUiStatus = json['sigSetStorageUiStatus'] != null
        ? SigSetStorageUiStatus.fromJson(json['sigSetStorageUiStatus'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (sigSetStorageUiStatus != null) {
      data['sigSetStorageUiStatus'] = sigSetStorageUiStatus!.toJson();
    }
    return data;
  }
}

class SigSetStorageUiStatus {
  List<DataStorage>? data;

  SigSetStorageUiStatus({this.data});

  SigSetStorageUiStatus.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DataStorage>[];
      json['data'].forEach((v) {
        data!.add(DataStorage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataStorage {
  int? shelfNum;
  int? storageIndex;
  String? workPieceType;
  int? stateType;
  String? processTipInfo;
  bool? priorityStatus;

  DataStorage(
      {this.shelfNum,
      this.storageIndex,
      this.workPieceType,
      this.stateType,
      this.processTipInfo,
      this.priorityStatus});

  DataStorage.fromJson(Map<String, dynamic> json) {
    shelfNum = json['ShelfNum'];
    storageIndex = json['StorageIndex'];
    workPieceType = json['WorkPieceType'];
    stateType = json['StateType'];
    processTipInfo = json['ProcessTipInfo'];
    priorityStatus = json['PriorityStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ShelfNum'] = shelfNum;
    data['StorageIndex'] = storageIndex;
    data['WorkPieceType'] = workPieceType;
    data['StateType'] = stateType;
    data['ProcessTipInfo'] = processTipInfo;
    data['PriorityStatus'] = priorityStatus;
    return data;
  }
}
