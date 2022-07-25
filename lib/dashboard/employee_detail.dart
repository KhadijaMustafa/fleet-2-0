import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:xtreme_fleet/dashboard/add_pro_detail.dart';
import 'package:xtreme_fleet/dashboard/file_attachment.dart';
import 'package:xtreme_fleet/utilities/CusDateFormat.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:http/http.dart' as http;
import 'package:xtreme_fleet/utilities/my_navigation.dart';
class EmployeeDetailo extends StatefulWidget {
  final detail;
  EmployeeDetailo({Key? key,this.detail}) : super(key: key);

  @override
  State<EmployeeDetailo> createState() => _EmployeeDetailoState();
}

class _EmployeeDetailoState extends State<EmployeeDetailo> {
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

  getEmployeeSearchList() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST',
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'));
      request.body = json.encode({
       "type": "AttachedDocument_GetByFKId",
  "value": {
    "Language": "en-US",
    "FKId": "67d91d77-e90b-ed11-916f-00155d12d305"
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
    detailsList = await getEmployeeSearchList();
    loading = false;

    setState(() {});
  }

  @override
  void initState() {
    print('listitem');

    reportApiCall();
    print('listitem');
     print(widget.detail);
    // print('${widget.details['id']}');

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
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
                detailsCont('Employee #', '${widget.detail['empNumber']}'),
                detailsCont('Name', '${widget.detail['name']}'),
                detailsCont('Contact Number', '${widget.detail['contact']}'),
                detailsCont('Position Name', '${widget.detail['positionName']}'),
             
               
              ]),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: width+180,
              child: Column(
                children: [
                    empDetailCont('#', 'Document Type', 'Document Name', 'Expiry Date',
                15, FontWeight.bold,attachment: 'Attachment',textwidth: 100,iconwidth: 0),
                Container(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: detailsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      int indexx=index+1;
                      var item=detailsList[index];
                      return empDetailCont('$indexx', '${item['documentType']}', '${item['expiryDate']}', '${item['expiryDays']}', 12, FontWeight.normal, onLongPress: (){
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

  empDetailCont(String serial, String document, String docName, String expirtdate,
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
            width: 130,
            child: Text(docName,
                style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          ),
          Container(
            width: 110,
            margin: EdgeInsets.only(
              right: 10,
            ),
            child: Text(expirtdate,
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