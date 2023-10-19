import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:incident_report/model/get_model.dart';
import 'package:incident_report/model/post_incident_model.dart';

class ApiService {}

Future<void> postIncidentData(PostIncidentModel incidentData) async {
  final apiUrl =
      Uri.parse('http://103.120.178.195/Sang.Ray.Mob.Api/Ray/PostIncident');

  final incidentJson = incidentData.toJson();

  final response = await http.post(
    apiUrl,
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: jsonEncode(incidentJson),
  );

  if (response.statusCode == 200) {
    log('Incident data posted successfully');
  } else {
    throw Exception('Failed to post incident data');
  }
}

Future<List<GetIncidentModel>> fetchIncidentData() async {
  const String apiUrl =
      'http://103.120.178.195/Sang.Ray.Mob.Api/Ray/GetIncidentSummary?UserId=1';

  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    final dynamic jsonData = json.decode(response.body);
    if (jsonData is Map<String, dynamic> &&
        jsonData.containsKey('ResultData')) {
      final List<dynamic> jsonList = json.decode(jsonData['ResultData']);
      List<GetIncidentModel> incidents =
          jsonList.map((item) => GetIncidentModel.fromJson(item)).toList();

      return incidents;
    } else {
      throw Exception('ResultData is not available in the response');
    }
  } else {
    throw Exception('Failed to load incident data');
  }
}

