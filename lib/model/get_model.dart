class GetIncidentModel {
  final int iTransId;
  final String sDocNo;
  final String date;
  final String time;
  final String project;
  final String sLocation;

  GetIncidentModel({
    required this.iTransId,
    required this.sDocNo,
    required this.date,
    required this.time,
    required this.project,
    required this.sLocation,
  });

  factory GetIncidentModel.fromJson(Map<String, dynamic> json) {
    return GetIncidentModel(
      iTransId: json['iTransId'],
      sDocNo: json['sDocNo'],
      date: json['Date'],
      time: json['Time'],
      project: json['Project'],
      sLocation: json['sLocation'],
    );
  }
}
