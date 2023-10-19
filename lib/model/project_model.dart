class ResponseModel {
  final String status;
  final String messageDescription;
  final List<ResultData> resultData;

  ResponseModel({
    required this.status,
    required this.messageDescription,
    required this.resultData,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    List<ResultData> resultDataList = [];
    if (json['ResultData'] != null) {
      resultDataList = (json['ResultData'] as List)
          .map((resultData) => ResultData.fromJson(resultData))
          .toList();
    }

    return ResponseModel(
      status: json['Status'],
      messageDescription: json['MessageDescription'],
      resultData: resultDataList,
    );
  }
}

class ResultData {
  final int iId;
  final String sName;
  final String sCode;

  ResultData({
    required this.iId,
    required this.sName,
    required this.sCode,
  });

  factory ResultData.fromJson(Map<String, dynamic> json) {
    return ResultData(
      iId: json['iId'],
      sName: json['sName'],
      sCode: json['sCode'],
    );
  }
}
