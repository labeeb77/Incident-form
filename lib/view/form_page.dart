import 'dart:convert';
import 'dart:developer';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:image_picker/image_picker.dart';
import 'package:incident_report/model/post_incident_model.dart';
import 'package:incident_report/model/project_model.dart';
import 'package:incident_report/service/api_service.dart';

import 'package:incident_report/utils/colors.dart';
import 'package:incident_report/view/widgets/custom_button.dart';
import 'package:incident_report/view/widgets/custom_dropdown.dart';
import 'package:incident_report/view/widgets/custom_textfield.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  List<DataRow> incidentDataRows = [];
  final navigatorKey = GlobalKey<NavigatorState>();

  List<Map<String, dynamic>> projectsData = [];
  final List<String> states = [
    'kerala',
    'tamilnadu',
    'karnadata',
    'Andrapradesh',
    'panjab',
  ];

  List<ResultData> data = [];
  ResultData? selectedProject;
  ResultData? selectedCode;
  List<Body> body = [];
  int siNo = 1;
  String? imagePath;
  DataRow? selectedDataRow;
  bool isEditing = false;

  DateTime currentDate = DateTime.now();
  TimeOfDay currentTime = TimeOfDay.now();

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController projectController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController desOfIncidentController = TextEditingController();
  TextEditingController desOfDamageController = TextEditingController();
  TextEditingController noOfPersonInjController = TextEditingController();
  TextEditingController nameOfInjController = TextEditingController();
  TextEditingController immediateCausController = TextEditingController();
  TextEditingController underlyingCausController = TextEditingController();
  TextEditingController correctiveAndPrevController = TextEditingController();
  TextEditingController responsibeController = TextEditingController();
  TextEditingController employeCodeController = TextEditingController();
  TextEditingController closedDateController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final List<DropdownMenuItem<String>> incidentTypes = [
    const DropdownMenuItem(value: '1', child: Text('Near Miss')),
    const DropdownMenuItem(value: '2', child: Text('First Aid Case')),
    const DropdownMenuItem(value: '3', child: Text('Restricted Work')),
    const DropdownMenuItem(value: '4', child: Text('Medically Treated')),
    const DropdownMenuItem(value: '5', child: Text('LostTime Injury')),
    const DropdownMenuItem(value: '6', child: Text('Fatality')),
    const DropdownMenuItem(value: '7', child: Text('Occupational illness')),
    const DropdownMenuItem(value: '8', child: Text('Asset Damage')),
    const DropdownMenuItem(value: '9', child: Text('Environmental Damage')),
    const DropdownMenuItem(value: '10', child: Text('Traffic Accident')),
    const DropdownMenuItem(value: '11', child: Text('Roll Over')),
    const DropdownMenuItem(value: '12', child: Text('Other')),
  ];

  final List<DropdownMenuItem<String>> severityRates = [
    const DropdownMenuItem(value: '1', child: Text('Catastrophic')),
    const DropdownMenuItem(value: '2', child: Text('Major')),
    const DropdownMenuItem(value: '3', child: Text('Moderate')),
    const DropdownMenuItem(value: '4', child: Text('Minor')),
  ];

  final List<DropdownMenuItem<String>> potentialRates = [
    const DropdownMenuItem(value: '1', child: Text('Rare')),
    const DropdownMenuItem(value: '2', child: Text('Unlikely')),
    const DropdownMenuItem(value: '3', child: Text('Possible')),
    const DropdownMenuItem(value: '4', child: Text('Likely')),
    const DropdownMenuItem(value: '5', child: Text('Almost Certain')),
  ];

  final List<DropdownMenuItem<String>> types = [
    const DropdownMenuItem(value: '1', child: Text('corrective')),
    const DropdownMenuItem(value: '2', child: Text('preventive')),
  ];

  String? selectedIncidentType;
  String? selectedSeverityRate;
  String? selectedPotentialRate;
  String? selectedActionType;
  String? selectedResponsibleType;
  String? responsible;

  @override
  void initState() {
    dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    timeController.text = DateFormat('HH:mm').format(DateTime.now());
    fetchData();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'INCIDENT REPORT',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FadeInRight(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'REPORT ORIGINATED BY:',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500),
                        )),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomDropdownField<ResultData>(
                    labelText: 'Select a Project',
                    value: selectedProject,
                    validator: (selectedValue) {
                      if (selectedValue == null) {
                        return 'Please select a project';
                      }
                      return null;
                    },
                    items: data.map((project) {
                      return DropdownMenuItem<ResultData>(
                        value: project,
                        child: Text(project.sName),
                      );
                    }).toList(),
                    onChanged: (ResultData? newValue) {
                      setState(() {
                        selectedProject = newValue;
                      });
                    },
                  ),

                  CustomTextField(
                    labelText: 'Location of incident',
                    controller: locationController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Location is required';
                      }
                      return null;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: CustomTextField(
                        labelText: 'Date of Incident',
                        controller: dateController,
                        onTap: () async {
                          final DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: currentDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (selectedDate != null) {
                            setState(() {
                              currentDate = selectedDate;
                              dateController.text =
                                  DateFormat('dd-MM-yyyy').format(currentDate);
                            });
                          }
                        },
                      )),
                      Flexible(
                          child: CustomTextField(
                        labelText: 'Time of incident',
                        controller: timeController,
                        onTap: () async {
                          final TimeOfDay? selectedTime = await showTimePicker(
                            context: context,
                            initialTime: currentTime,
                          );
                          if (selectedTime != null) {
                            setState(() {
                              currentTime = selectedTime;
                              timeController.text =
                                  selectedTime.format(context);
                            });
                          }
                        },
                      )),
                    ],
                  ),
                  //---- Drop Down ----//

                  CustomDropdownField<String>(
                    labelText: 'Incident Type',
                    items: incidentTypes,
                    value: selectedIncidentType,
                    validator: (selectedValue) {
                      if (selectedValue == null) {
                        return 'Please select a Incidet Type';
                      }
                      return null;
                    },
                    onChanged: (newValue) {
                      setState(() {
                        selectedIncidentType = newValue;
                      });
                    },
                  ),

                  CustomDropdownField<String>(
                    labelText: 'Severity Rate',
                    items: severityRates,
                    value: selectedSeverityRate,
                    validator: (selectedValue) {
                      if (selectedValue == null) {
                        return 'Please select Severity rate';
                      }
                      return null;
                    },
                    onChanged: (newValue) {
                      setState(() {
                        selectedSeverityRate = newValue;
                      });
                    },
                  ),

                  CustomDropdownField<String>(
                    labelText: 'Potential Rate',
                    items: potentialRates,
                    value: selectedPotentialRate,
                    validator: (selectedValue) {
                      if (selectedValue == null) {
                        return 'Please select a potential rate';
                      }
                      return null;
                    },
                    onChanged: (newValue) {
                      setState(() {
                        selectedPotentialRate = newValue;
                      });
                    },
                  ),

                  //--------- Details -----------//

                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'DETAILS:',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500),
                        )),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomTextField(
                    labelText: 'Description of Incident',
                    controller: desOfIncidentController,
                    maxLine: 3,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Description is required';
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    labelText: 'Description of Damage',
                    controller: desOfDamageController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Description is required';
                      }
                      return null;
                    },
                    maxLine: 3,
                  ),
                  CustomTextField(
                    labelText: 'Number of person injured',
                    controller: noOfPersonInjController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'number is required';
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    labelText: 'Names of injured people and injury details',
                    controller: nameOfInjController,
                    maxLine: 3,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),

                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'The following for potential incidents',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500),
                        )),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomTextField(
                    labelText: 'Immidiate Causes',
                    controller: immediateCausController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Cause is required';
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    labelText: 'Underlying Causes',
                    controller: underlyingCausController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Cause is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // --------------- Table --------------/

                  const Divider(),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(columns: const [
                      DataColumn(label: Text('Actions')),
                      DataColumn(label: Text('SI No')),
                      DataColumn(
                          label: Text('Corrective and Preventive Actions')),
                      DataColumn(label: Text('Responsible')),
                      DataColumn(label: Text('Date')),
                    ], rows: incidentDataRows),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: CustomButton(
                          width: 140.w,
                          height: 42.h,
                          borderRadius: 10,
                          color: primaryColor,
                          onPressed: () {
                            showCustomDialog(context);
                          },
                          child: const Text(
                            'Add Data',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  Material(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () => _pickImage(),
                      child: Container(
                        width: 330.w,
                        height: 180.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_upload_sharp,
                                color: Colors.blueGrey[300], size: 60),
                            const Text(
                              'Upload Image',
                              style: TextStyle(color: Colors.grey),
                            ),
                            if (imagePath != null)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  imagePath?.substring(
                                          0, imagePath!.length ~/ 2) ??
                                      "",
                                  style: const TextStyle(color: Colors.black),
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                      width: 330.w,
                      height: 45.h,
                      borderRadius: 10,
                      color: primaryColor,
                      onPressed: () async {
                        
                        if (formKey.currentState!.validate()) {
                          final incidentData = PostIncidentModel(
                            iTransId: 5,
                            project: selectedProject?.iId ?? 1,
                            location: locationController.text,
                            date: currentDate,
                            time: timeController.text,
                            incidentType:
                                int.parse(selectedIncidentType ?? '1'),
                            severityRate:
                                int.parse(selectedSeverityRate ?? '1'),
                            potentialRate:
                                int.parse(selectedPotentialRate ?? '1'),
                            others: 'no others',
                            incidentDescription: desOfIncidentController.text,
                            damageDescription: desOfDamageController.text,
                            noInjuredPerson:
                                int.parse(noOfPersonInjController.text),
                            detailsOfPersons: nameOfInjController.text,
                            immediateCauses: immediateCausController.text,
                            underlyingCauses: underlyingCausController.text,
                            userId: 1,
                            images: imagePath ?? '',
                            body: body,
                          );
                          final newBody = Body(
                            iResponsible: selectedCode?.iId ?? 1,
                            sCloseDate: closedDateController.text,
                            iAction: int.parse(selectedActionType ?? '1'),
                            sActionDes: correctiveAndPrevController.text,
                            sExtraDetails: 'nothing',
                          );
                          body.add(newBody);
                          EasyLoading.show(status: 'loading...');

                          await postIncidentData(incidentData);
                          EasyLoading.dismiss();
                          EasyLoading.showToast(
                              'Form submitted successfully..');
                              fetchIncidentData();
                          Navigator.of(context).pop();
                          
                        }
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }

  // Function to show the custom dialog

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });
    }
  }

  //   fetch projects
  Future<void> fetchData() async {
    final response = await http.get(
        Uri.parse('http://103.120.178.195/Sang.Ray.Mob.Api/Ray/GetProject'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final resultDataString = jsonResponse['ResultData'];
      final resultDataList = json.decode(resultDataString);
      final responseModel = ResponseModel.fromJson({
        'Status': jsonResponse['Status'],
        'MessageDescription': jsonResponse['MessageDescription'],
        'ResultData': resultDataList,
      });

      setState(() {
        data = responseModel.resultData;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void deleteRow(int index) {
    setState(() {
      incidentDataRows.removeAt(index);
    });
  }

  showCustomDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          content: SingleChildScrollView(
            child: FadeInRight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Add Data',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  CustomDropdownField<String>(
                    labelText: 'Type',
                    items: types,
                    value: selectedActionType,
                    validator: (selectedValue) {
                      if (selectedValue == null) {
                        return 'Please select a type';
                      }
                      return null;
                    },
                    onChanged: (newValue) {
                      setState(() {
                        selectedActionType = newValue;
                      });
                    },
                  ),
                  CustomTextField(
                    maxLine: 2,
                    labelText: 'Corrective and Preventive actions',
                    controller: correctiveAndPrevController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'action is required';
                      }
                      return null;
                    },
                  ),
                  CustomDropdownField<ResultData>(
                    labelText: 'Responsible',
                    value: selectedCode,
                    validator: (selectedValue) {
                      if (selectedValue == null) {
                        return 'Please select Responsibel';
                      }
                      return null;
                    },
                    items: data.map((project) {
                      return DropdownMenuItem<ResultData>(
                        alignment: Alignment.bottomLeft,
                        value: project,
                        child: Text(project.sName),
                      );
                    }).toList(),
                    onChanged: (ResultData? newValue) {
                      setState(() {
                        selectedCode = newValue;
                      });
                    },
                  ),
                  CustomDropdownField<ResultData>(
                    labelText: 'Employee code',
                    value: selectedCode,
                    validator: (selectedValue) {
                      if (selectedValue == null) {
                        return 'Please select employee code';
                      }
                      return null;
                    },
                    items: data.map((project) {
                      return DropdownMenuItem<ResultData>(
                        alignment: Alignment.center,
                        value: project,
                        child: Text(project.sCode),
                      );
                    }).toList(),
                    onChanged: (ResultData? newValue) {
                      setState(() {
                        selectedCode = newValue;
                        responsible = selectedCode!.sName;
                      });
                    },
                  ),
                  CustomTextField(
                    labelText: 'Closed Date',
                    controller: closedDateController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Date is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomButton(
                      width: 220.w,
                      height: 40.h,
                      borderRadius: 10,
                      color: primaryColor,
                      onPressed: () {
                        DataRow newRow = DataRow(
                          cells: [
                            DataCell(Row(
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () {
                                      deleteRow(incidentDataRows.length - 1);
                                      log('tap delete');
                                    },
                                    icon: const Icon(Icons.delete))
                              ],
                            )),
                            DataCell(Text((siNo++).toString())),
                            DataCell(Text(correctiveAndPrevController.text)),
                            DataCell(Text(responsible.toString())),
                            DataCell(Text(closedDateController.text)),
                          ],
                        );

                        incidentDataRows.add(newRow);

                        Navigator.of(context).pop();

                        setState(() {});
                        correctiveAndPrevController.clear();
                        responsibeController.clear();
                        employeCodeController.clear();
                        closedDateController.clear();
                      },
                      child: const Text(
                        'Add',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
