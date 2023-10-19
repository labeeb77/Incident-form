class PostIncidentModel {
    int iTransId;
    int project;
    String location;
    DateTime date;
    String time;
    int incidentType;
    int severityRate;
    int potentialRate;
    String others;
    String incidentDescription;
    String damageDescription;
    int noInjuredPerson;
    String detailsOfPersons;
    String immediateCauses;
    String underlyingCauses;
    int userId;
    String images;
    List<Body> body;

    PostIncidentModel({
        required this.iTransId,
        required this.project,
        required this.location,
        required this.date,
        required this.time,
        required this.incidentType,
        required this.severityRate,
        required this.potentialRate,
        required this.others,
        required this.incidentDescription,
        required this.damageDescription,
        required this.noInjuredPerson,
        required this.detailsOfPersons,
        required this.immediateCauses,
        required this.underlyingCauses,
        required this.userId,
        required this.images,
        required this.body,
    });

    factory PostIncidentModel.fromJson(Map<String, dynamic> json) => PostIncidentModel(
        iTransId: json["iTransId"],
        project: json["Project"],
        location: json["Location"],
        date: DateTime.parse(json["Date"]),
        time: json["Time"],
        incidentType: json["IncidentType"],
        severityRate: json["Severity_Rate"],
        potentialRate: json["Potential_Rate"],
        others: json["Others"],
        incidentDescription: json["IncidentDescription"],
        damageDescription: json["DamageDescription"],
        noInjuredPerson: json["No_Injured_Person"],
        detailsOfPersons: json["DetailsOfPersons"],
        immediateCauses: json["ImmediateCauses"],
        underlyingCauses: json["UnderlyingCauses"],
        userId: json["UserId"],
        images: json["Images"],
        body: List<Body>.from(json["Body"].map((x) => Body.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "iTransId": iTransId,
        "Project": project,
        "Location": location,
        "Date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "Time": time,
        "IncidentType": incidentType,
        "Severity_Rate": severityRate,
        "Potential_Rate": potentialRate,
        "Others": others,
        "IncidentDescription": incidentDescription,
        "DamageDescription": damageDescription,
        "No_Injured_Person": noInjuredPerson,
        "DetailsOfPersons": detailsOfPersons,
        "ImmediateCauses": immediateCauses,
        "UnderlyingCauses": underlyingCauses,
        "UserId": userId,
        "Images": images,
        "Body": List<dynamic>.from(body.map((x) => x.toJson())),
    };
}

class Body {
    int iResponsible;
    String sCloseDate;
    int iAction;
    String sActionDes;
    String sExtraDetails;

    Body({
        required this.iResponsible,
        required this.sCloseDate,
        required this.iAction,
        required this.sActionDes,
        required this.sExtraDetails,
    });

    factory Body.fromJson(Map<String, dynamic> json) => Body(
        iResponsible: json["iResponsible"],
        sCloseDate: json["sCloseDate"],
        iAction: json["iAction"],
        sActionDes: json["sAction_Des"],
        sExtraDetails: json["sExtraDetails"],
    );

    Map<String, dynamic> toJson() => {
        "iResponsible": iResponsible,
        "sCloseDate": sCloseDate,
        "iAction": iAction,
        "sAction_Des": sActionDes,
        "sExtraDetails": sExtraDetails,
    };
}
