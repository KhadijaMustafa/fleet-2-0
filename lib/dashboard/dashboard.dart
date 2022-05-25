import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xtreme_fleet/dashboard/employee_document.dart';
import 'package:xtreme_fleet/dashboard/project_document.dart';
import 'package:xtreme_fleet/utilities/my_assets.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
import 'package:xtreme_fleet/utilities/my_navigation.dart';
import 'package:xtreme_fleet/dashboard/menu_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();
  int indexColor = 0;
  int category = 0;

  List empList = [];
  List vehList = [];
  List projectList = [];
  List mainList = [];
  bool _loading = true;
  List<Map> color = [
    {
      'green': Color.fromRGBO(104, 191, 123, 1),
      'white': Color.fromRGBO(249, 251, 250, 1)
    }
  ];
  var selected;

  dashboardApi(String entityType, {String? documentType}) async {
    try {
      Map body = {
        "type": "Dashboard_Get",
        "value": {
          "Entity": "$entityType",
          "DocumentType": "",
          "Flag": "Count",
          "Language": "en-US"
        }
      };
      var request = await http.post(
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process/'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(body));
      var decode = json.decode(request.body);

      if (request.statusCode == 200) {
        var doDecode = json.decode(decode['Value']);
        print(doDecode);
        print(doDecode[0]['entityName']);
        // setState(() {
        //   empList = doDecode;
        //   print('llllllllllllll');
        // });
        return doDecode;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
    }
  }

  callApis() async {
    empList = await dashboardApi('Employee')??[];
    vehList = await dashboardApi('Vehicle')??[];
    projectList = await dashboardApi('Project')??[];
  
      mainList = await [...empList, ...vehList, ...projectList];
    

    _loading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    callApis();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Color.fromRGBO(234, 239, 243, 1),
        key: _scaffold,
        appBar: AppBar(
          elevation: 0,

          backgroundColor: MyColors.yellow,

          leading: InkWell(
            onTap: () {
              print('gggggggggggggggggggggg');
              _scaffold.currentState!.openDrawer();
            },
            child: Icon(
              FontAwesomeIcons.ellipsis,
              color: Colors.white,
            ),
          ),
          title: Text(
            'Dashboard',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          // actions: [
          //   Container(
          //     margin: EdgeInsets.only(right: 20),
          //     child: Icon(
          //       Icons.settings,
          //       color: Colors.white,
          //     ),
          //   ),
          //   Container(
          //       margin: EdgeInsets.only(right: 20),
          //       child: Icon(
          //         Icons.person,
          //         color: Colors.white,
          //       ))
          // ],
        ),
        drawer: MenuScreen(),
        body: _loading
            ? Center(
                child: CircularProgressIndicator(
                  color: MyColors.yellow,
                ),
              )
            : Container(
                padding: EdgeInsets.only(top: 10, bottom: 20),
              
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                          onTap: () => setState(() {
                                // indexColor=0;
                                category = 0;
                              }),
                          child: Container(
                            // color: Color.fromARGB(255, 243, 245, 247),
                            margin: EdgeInsets.only(left: 30, right: 30),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1.2,
                                      crossAxisSpacing: 3,
                                      mainAxisSpacing: 3),
                              itemCount: mainList.length,
                              itemBuilder: (BuildContext context, int index) {
                                var color = mainList[index];
                                var icon = mainList[index]['documentType'];
                                var item = mainList[index];
                                return listCont(
                                  '${item['expiredCount']}',
                                  '${item['documentType']}',
                                  onTap: () {
                                    setState(() {
                                      selected = item;
                                    });
                                    MyNavigation().push(
                                        context,
                                        EmloyeeDocument(
                                          documentType: mainList[index]
                                              ['documentType'],
                                          entityName: mainList[index]
                                              ['entityName'],
                                        ));
                                  },
                                  bgcolor: selected == item
                                      ? MyColors.bgyellow
                                      : MyColors.cardwhite,
                                  textcolor: selected == item
                                      ? MyColors.red
                                      : MyColors.cardtxtwhite,
                                  icon: icon == 'Visa'
                                      ? FontAwesomeIcons.ccVisa
                                      : icon == 'Boarding Pass'
                                          ? FontAwesomeIcons.planeDeparture
                                          : icon == 'Insurance'
                                              ? FontAwesomeIcons.carBurst
                                              : icon == 'Security Pass'
                                                  ? FontAwesomeIcons.passport
                                                  : icon ==
                                                          'Mulkia ( Registration card)'
                                                      ? FontAwesomeIcons
                                                          .registered
                                                      : icon == 'Emirates Id'
                                                          ? FontAwesomeIcons
                                                              .idCard
                                                          : icon == 'Manifesto'
                                                              ? FontAwesomeIcons
                                                                  .folderOpen
                                                              : icon ==
                                                                      'Contract'
                                                                  ? FontAwesomeIcons
                                                                      .file
                                                                  : FontAwesomeIcons
                                                                      .folderOpen,
                                  iconcolor: selected == item
                                      ? MyColors.red
                                      : MyColors.bgyellow,
                                  countcolor: selected == item
                                      ? MyColors.red
                                      : MyColors.yellow,
                                );
                              },
                            ),
                          )),
                    ],
                  ),
                )));
  }

  textCont(String text, Color color, Color textcolor) {
    return Container(
      padding: EdgeInsets.only(top: 7, bottom: 7, right: 25, left: 25),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.only(top: 20, bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.topLeft,
            // margin: EdgeInsets.only(bottom: 10),
            child: Text(
              text,
              style: TextStyle(
                  // decoration: TextDecoration.underline,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: textcolor),
            ),
          ),
        ],
      ),
    );
  }

  listCont(String text, String count,
      {Function? onTap,
      Color? bgcolor,
      Color? textcolor,
      IconData? icon,
      Color? iconcolor,
      Color? countcolor}) {
    return GestureDetector(
      onTap: () => onTap!(),
      child: Container(
        // alignment: Alignment.bottomCenter,
        height: 250,

        child: Stack(children: [
          Card(
            color: bgcolor,
            // color: Color.fromRGBO(104, 191, 123, 1),
            shadowColor: Colors.white.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13.0),
              side: BorderSide(color: MyColors.grey.withOpacity(0.1)),
            ),
            elevation: 50,
            child: Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    // margin: EdgeInsets.only(top: -15),
                    //  padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // color: MyColors.bggreen
                    ),
                    // alignment: Alignment.topLeft,
                    child: Text(
                      text,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: countcolor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,

                    height: 20,
                    width: 20,
                    margin: EdgeInsets.only(right: 15, top: 5),
                    //  padding: EdgeInsets.all(6),

                    decoration: BoxDecoration(),
                    child: FaIcon(
                      icon,
                      color: iconcolor,
                      size: 35,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 20),
                    width: 130,
                    child: Text(
                      count,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: textcolor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
