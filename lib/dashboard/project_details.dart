import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:xtreme_fleet/dashboard/add_pro_detail.dart';
import 'package:xtreme_fleet/dashboard/file_attachment.dart';
import 'package:xtreme_fleet/utilities/CusDateFormat.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:http/http.dart' as http;
import 'package:xtreme_fleet/utilities/my_navigation.dart';

class ProjectDetails extends StatefulWidget {
  final details;
  ProjectDetails({Key? key, this.details}) : super(key: key);

  @override
  State<ProjectDetails> createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  double valuee = 0;
  bool loading = true;

  DateTime startDate = DateTime.utc(2022);
  DateTime selectedDate = DateTime.now();
  var selectItem;
  var customername;
int itemIndex=0;
  List detailsList = [];
  var listvalues;
   deleteDocument() async {
    print('Delete');
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST',
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'));
      request.body = json.encode({
        "type": "AttachedDocument_Delete",
        "value": {"Id": "${selectItem['id']}", "Language": "en-US"}
      });
      print('${selectItem['id']}');
      request.headers.addAll(headers);

      http.StreamedResponse streamResponse = await request.send();
      http.Response response = await http.Response.fromStream(streamResponse);
      print('???????????????????');

      if (response.statusCode == 200) {
        print('???????????????????');
        var decode = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: MyColors.bggreen,
            content: Text('Record succesfully deleted.')));
        detailsList.removeAt(itemIndex);

        setState(() {
          selectItem = null;
        });
        print('Deleted');
        print(decode);
      }
    } catch (e) {}
  }

  getProjectSearchList() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST',
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'));
      request.body = json.encode({
       "type": "AttachedDocument_GetByFKId",
  "value": {
    "Language": "en-US",
    "FKId": "${widget.details['id']}"
        }
      });

      request.headers.addAll(headers);
      http.StreamedResponse streamResponse = await request.send();
      http.Response response = await http.Response.fromStream(streamResponse);

      if (response.statusCode == 200) {
        var decode = json.decode(response.body);
        print('Success');
        print(decode['Value']);
        print(response.body);
        return json.decode(decode['Value']);
      }
    } catch (e) {
      print(e);
    }
  }

  reportApiCall() async {
    detailsList = await getProjectSearchList();
    loading = false;

    setState(() {});
  }

  @override
  void initState() {
    print('listitem');

    reportApiCall();
    print('listitem');
    // print(widget.details);
    // print('${widget.details['id']}');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.yellow,
        title: Text(
          'Project Detail',
          style: TextStyle(color: Colors.white),
        ),
         actions: [
          selectItem == null
              ? Container()
              : Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  //title: Text('data'),
                                  content: Text(
                                    'Do you want to delete this record?',
                                    style: TextStyle(
                                        color: MyColors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  actions: [
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                Navigator.pop(context, false);
                                              },
                                              child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 8),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: MyColors.bgred),
                                                  margin: EdgeInsets.only(
                                                      left: 5, right: 5),
                                                  child: Text('No',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight
                                                              .bold)))),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(
                                                    context, deleteDocument());
                                                setState(
                                                    () => selectItem = null);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 8),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: MyColors.bggreen),
                                                margin: EdgeInsets.only(
                                                    left: 5, right: 5),
                                                child: Text(
                                                  'Yes',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )),
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              });
                        },
                        child: actionIcon(
                          Icons.delete,
                        )),
                  
                    GestureDetector(
                        onTap: () => setState(() => selectItem = null),
                        child: actionIcon(Icons.close)),
                  ],
                )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MyNavigation().push(context, AddProjectDetail(item: selectItem,));
        },
        child: Icon(Icons.add),
        backgroundColor: MyColors.yellow,
      ),
      body: Container(
          child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 5, bottom: 10),
              child: Column(children: [
                detailsCont('Code #', '${widget.details['code']}'),
                detailsCont('Name', '${widget.details['name']}'),
                detailsCont('From Site', '${widget.details['fromSiteId']}'),
                detailsCont('To Site', '${widget.details['toSiteId']}'),
                detailsCont('Total Trips', '${widget.details['totalTrips']}'),
                detailsCont('Customer', '${widget.details['customerName']}'),
                detailsCont('Start Date', '${widget.details['startDate']}'),
                detailsCont('End Date', '${widget.details['endDate']}'),
              ]),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(width: width+150,
              child: Column(
                children: [
                    proDetailCont('#', 'Document Type', 'Expiry Date', 'Expirt Days',
                15, FontWeight.bold,attachment: 'Attachment',textwidth: 100,iconwidth: 0),
                Container(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: detailsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      int indexx=index+1;
                      var item=detailsList[index];
                      return proDetailCont('$indexx', '${item['documentType']}', '${item['expiryDate']}', '${item['expiryDays']}', 12, FontWeight.normal, onLongPress: (){
                        setState(() {
                          selectItem=item;
                        });
                      },
                       bgColor: '${selectItem}' == '${item}'
                                        ? MyColors.yellow
                                        : Colors.white,
                                    IconData: Icons.attachment,
                                    onTab: () {
                                      print('${item['fileName']}');
                                      MyNavigation().push(
                                          context,
                                          FileAttachment(
                                            image: '${item['fileName']}',
                                          ));
                                    },textwidth: 0,iconwidth: 80,attachment: '');
                    },
                  ),
                )

                ],
              ),
              
              ),
            )
          
          ],
        ),
      )),
    );
  }

  detailsCont(String title, String detail) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30,
          ),
          Container(
            width: 130,
            margin: EdgeInsets.only(top: 10),
            alignment: Alignment.topLeft,
            child: Text(title,
                style: TextStyle(
                    color: MyColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Container(
              width: 150,
              margin: EdgeInsets.only(top: 10),
              alignment: Alignment.topLeft,
              child: Text(detail,
                  style: TextStyle(
                      color: MyColors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w400)),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }
    actionIcon(IconData) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      child: Icon(
        IconData,
        color: Colors.white,
        size: 25,
      ),
    );
  }

  proDetailCont(String serial, String document, String expirydate, String edays,
      double size, FontWeight fontWeight,
      {String? project,
      Function? onLongPress,
      bgColor,
      IconData,
      Function? onTab,
      double? textwidth,
      double? iconwidth,
      String? attachment}) {
    return GestureDetector(
      onLongPress: () => onLongPress!(),
      child: Container(
        decoration: BoxDecoration(
            color: bgColor, borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.only(top: 10, left: 5, right: 5),
        padding: EdgeInsets.all(5),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            width: 25,
            margin: EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            child: Text(
              serial,
              style: TextStyle(fontSize: size, fontWeight: fontWeight),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              right: 10,
            ),
            width: 130,
            child: Text(
              document,
              style: TextStyle(fontSize: size, fontWeight: fontWeight),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              right: 10,
            ),
            width: 100,
            child: Text(expirydate,
                style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          ),
          Container(
            width: 110,
            margin: EdgeInsets.only(
              right: 10,
            ),
            child: Text(edays,
                style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          ),
          Container(
            width: textwidth,
            margin: EdgeInsets.only(right: 10),
            child: Text(attachment!,
                style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          ),
          GestureDetector(
            onTap: () => onTab!(),
            child: Container(
              margin: EdgeInsets.only(right: 10),
              width: iconwidth,
              child: Icon(IconData),
            ),
          ),
        ]),
      ),
    );
  }

  textCont(String text, double size, {Color? color, FontWeight? fontWeight}) {
    return Text(
      '$text  ',
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: fontWeight,
      ),
    );
  }
}
