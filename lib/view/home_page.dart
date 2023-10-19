import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:incident_report/model/get_model.dart';
import 'package:incident_report/service/api_service.dart';
import 'package:incident_report/utils/colors.dart';
import 'package:incident_report/view/form_page.dart';
import 'package:incident_report/view/widgets/custom_button.dart';
import 'package:incident_report/view/widgets/custom_shadow_container.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'INCIDENT FORM',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
                width: 110.w,
                height: 40.h,
                borderRadius: 10,
                color: primaryColor,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const FormPage(),
                  ));
                },
                child: const Text('New Form')),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: FutureBuilder<List<GetIncidentModel>>(
            future: fetchIncidentData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No data available.'));
              } else {
                List<GetIncidentModel> datas = snapshot.data!;

                return ListView.builder(
                  itemBuilder: (context, index) {
                    GetIncidentModel data = datas[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomShadowContainer(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.project,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(data.sLocation),
                                  Text(data.date)
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.delete),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                            Icons.edit_note_outlined),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(data.sDocNo)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: datas.length,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
