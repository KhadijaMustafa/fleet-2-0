import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xtreme_fleet/dashboard/employee_document.dart';
import 'package:xtreme_fleet/dashboard/project_document.dart';
import 'package:xtreme_fleet/utilities/my_assets.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
import 'package:xtreme_fleet/utilities/my_navigation.dart';
import 'package:xtreme_fleet/dashboard/menuScreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();
  int indexColor=0;
  int category=0;
  

  List empList = [];
  List vehList = [];
  List projectList = [];
  bool _loading = true;

  dashboardApi(String entityType, {String? documentType}) async {
    try {
      Map body = {
        "type": "Dashboard_Get",
        "value": {
          "Entity": "$entityType",
          // "Entity": "Vehicle",
          // "Entity": "Employee",
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
      // print(decode);

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
    empList = await dashboardApi('Employee');
    vehList = await dashboardApi('Vehicle');
    projectList = await dashboardApi('Project');
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
        backgroundColor: Color.fromARGB(255, 243, 245, 247),
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
              Icons.menu,
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
                // decoration: BoxDecoration(
                //     image: DecorationImage(
                //         image: AssetImage(MyAssets.dashboardbg),
                //         fit: BoxFit.fill)),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                     Container(
                       margin: EdgeInsets.only(left: 15,right: 15,bottom: 15),
                       child:Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                     
                      GestureDetector(
                        onTap: ()=>setState(() {
                          indexColor=0;
                        }),
                        child:  textCont('Employee ',indexColor==0? MyColors.yellow:Color.fromARGB(255, 243, 245, 247)),
                      ),
                      GestureDetector(
                        onTap: ()=>setState(() {
                          indexColor=1;
                        }),
                        child: 
                      textCont('Vehicle ',indexColor==1? MyColors.yellow:Color.fromARGB(255, 243, 245, 247)),

                      ),
                      GestureDetector(
                        onTap: ()=>setState(() {
                          indexColor=2;

                          
                        }),
                        child: 
                      textCont('Project ',indexColor==2? MyColors.yellow:Color.fromARGB(255, 243, 245, 247)),

                      ),



                       ],
                     )),



                    //  textCont('Employee Document(s)'),

                      GestureDetector(
                        onTap: () => setState(() {
                        // indexColor=0;
                         category=0; 
                        }),
                        child:category==0 && indexColor==0? Container(
                          color: Color.fromARGB(255, 243, 245, 247),
                          margin: EdgeInsets.only(left: 30, right: 30),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 1.1,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10),
                            itemCount: empList.length,
                            itemBuilder: (BuildContext context, int index) {
                              var color = empList[index]['documentType'];
                              return listCont('${empList[index]['expiredCount']}',
                                  '${empList[index]['documentType']}',
                                  IconData: Icons.person, onTap: () {
                                MyNavigation().push(
                                    context,
                                    EmloyeeDocument(
                                      documentType: empList[index]
                                          ['documentType'],
                                      entityName: empList[index]['entityName'],
                                    ));
                              });
                            },
                          ),
                        ):category==0 && indexColor==1?  Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 243, 245, 247),
                        
                        ),
                        margin: EdgeInsets.only(left: 30, right: 30),
                        child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1.2,
                                  crossAxisSpacing: 6,
                                  mainAxisSpacing: 6),
                          shrinkWrap: true,
                          itemCount: vehList.length,
                          itemBuilder: (BuildContext context, int index) {
                            var color = vehList[index]['documentType'];
                            return listCont('${vehList[index]['expiredCount']}',
                                '${vehList[index]['documentType']}',
                               
                                IconData: FontAwesomeIcons.car, onTap: () {
                              MyNavigation().push(
                                  context,
                                  EmloyeeDocument(
                                      documentType: vehList[index]
                                          ['documentType'],
                                      entityName: vehList[index]
                                          ['entityName']));
                            });
                          },
                        ),
                      ): Container(
                        color: Color.fromARGB(255, 243, 245, 247),
                        margin: EdgeInsets.only(left: 30, right: 30),
                        child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1.2,
                                  crossAxisSpacing: 6,
                                  mainAxisSpacing: 6),
                          shrinkWrap: true,
                          itemCount: projectList.length,
                          itemBuilder: (BuildContext context, int index) {
                            var color = projectList[index]['documentType'];
                            return listCont(
                                '${projectList[index]['expiredCount']}',
                                '${projectList[index]['documentType']}',
                            
                                IconData: FontAwesomeIcons.file, onTap: () {
                              MyNavigation().push(
                                  context,
                                  ProjectDocuments(
                                      documentType: projectList[index]
                                          ['documentType'],
                                      entityName: projectList[index]
                                          ['entityName']));
                            });
                          },
                        ),
                      ) ,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    // textCont('Vehicle Document(s)'),
                      // Container(
                      //   decoration: BoxDecoration(
                      //     color: Color.fromARGB(255, 243, 245, 247),
                        
                      //   ),
                      //   margin: EdgeInsets.only(left: 30, right: 30),
                      //   child: GridView.builder(
                      //     physics: NeverScrollableScrollPhysics(),
                      //     gridDelegate:
                      //         const SliverGridDelegateWithFixedCrossAxisCount(
                      //             crossAxisCount: 2,
                      //             childAspectRatio: 1.2,
                      //             crossAxisSpacing: 6,
                      //             mainAxisSpacing: 6),
                      //     shrinkWrap: true,
                      //     itemCount: vehList.length,
                      //     itemBuilder: (BuildContext context, int index) {
                      //       var color = vehList[index]['documentType'];
                      //       return listCont('${vehList[index]['expiredCount']}',
                      //           '${vehList[index]['documentType']}',
                               
                      //           IconData: FontAwesomeIcons.car, onTap: () {
                      //         MyNavigation().push(
                      //             context,
                      //             EmloyeeDocument(
                      //                 documentType: vehList[index]
                      //                     ['documentType'],
                      //                 entityName: vehList[index]
                      //                     ['entityName']));
                      //       });
                      //     },
                      //   ),
                      // ),
                    //   SizedBox(
                    //     height: 20,
                    //   ),
                    //  // textCont('Project Document(s)'),
                    //   Container(
                    //     color: Color.fromARGB(255, 243, 245, 247),
                    //     margin: EdgeInsets.only(left: 30, right: 30),
                    //     child: GridView.builder(
                    //       physics: NeverScrollableScrollPhysics(),
                    //       gridDelegate:
                    //           const SliverGridDelegateWithFixedCrossAxisCount(
                    //               crossAxisCount: 2,
                    //               childAspectRatio: 1.2,
                    //               crossAxisSpacing: 6,
                    //               mainAxisSpacing: 6),
                    //       shrinkWrap: true,
                    //       itemCount: projectList.length,
                    //       itemBuilder: (BuildContext context, int index) {
                    //         var color = projectList[index]['documentType'];
                    //         return listCont(
                    //             '${projectList[index]['expiredCount']}',
                    //             '${projectList[index]['documentType']}',
                            
                    //             IconData: FontAwesomeIcons.file, onTap: () {
                    //           MyNavigation().push(
                    //               context,
                    //               ProjectDocuments(
                    //                   documentType: projectList[index]
                    //                       ['documentType'],
                    //                   entityName: projectList[index]
                    //                       ['entityName']));
                    //         });
                    //       },
                    //     ),
                    //   ),
                    ],
                  ),
                )));
  }

  textCont(String text,Color color) {
    return Container(
      padding: EdgeInsets.only(top: 5,bottom: 5,right: 20,left: 20),
      decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(15)
      ),
      margin: EdgeInsets.only(top: 20,  bottom: 10),
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
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Container(
          //   alignment: Alignment.topLeft,
          //   height: 2,
          //   width: 200,
          //   color: MyColors.yellow,
          // )
        ],
      ),
    );
  }

  listCont(String text, String count, {IconData, Function? onTap}) {
    return GestureDetector(
      onTap: () => onTap!(),
      child: Card(
        shadowColor: Colors.white.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13.0),
        ),
        elevation: 50,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Card(
                            elevation: 2,
                            shadowColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              // side: BorderSide(color: MyColors.yellow),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.topLeft,
                              child: Text(
                                text,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: MyColors.yellow,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          // Container(
                          //   // height: 20,
                          //   // width: 20,
                          //   padding: EdgeInsets.all(6),

                          //   decoration: BoxDecoration(
                          //       shape: BoxShape.circle,
                          //       color: MyColors.yellow2),
                          //   child: Icon(
                          //     IconData,
                          //     color: Colors.white,
                          //     size: 16,
                          //   ),
                          // ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 10),
                            width: 140,
                            child: Text(
                              count,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: MyColors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
