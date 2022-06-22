import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:xtreme_fleet/dashboard/file_attachment.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
import 'package:xtreme_fleet/utilities/CusDateFormat.dart';
import 'package:http/http.dart' as http;
import 'package:xtreme_fleet/utilities/my_navigation.dart';

class VehicleExpenseReport extends StatefulWidget {
  final item;
  VehicleExpenseReport({Key? key, this.item}) : super(key: key);

  @override
  State<VehicleExpenseReport> createState() => _VehicleExpenseReportState();
}

class _VehicleExpenseReportState extends State<VehicleExpenseReport> {
  DateTime startDate = DateTime.utc(2022);
  DateTime selectedDate = DateTime.now();
  List filterList = [];
  bool isSearching = false;
  bool _loading = true;
  List reportList = [];
  double totalAmount = 0.0;

   calculateAmount() {
    totalAmount = 0.0;
    reportList.forEach((element) {
      totalAmount = totalAmount + element['amount'];
      print(totalAmount);
      print('totalAmount');
      setState(() {});
    });
  } 

  expenseReport() async {
    print("StartDate" + CusDateFormat.getDate(startDate));
    print("EndDate" + CusDateFormat.getDate(selectedDate));
    // return;
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST',
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'));
      request.body = json.encode({
        "type": "VehicleExpense_GetByDateRange",
        "value": {
          "StartDate": CusDateFormat.getDate(startDate),
          "EndDate": CusDateFormat.getDate(selectedDate),
          "Language": "en-US"
        }
      });
      request.headers.addAll(headers);

      http.StreamedResponse streamResponse = await request.send();
      http.Response response = await http.Response.fromStream(streamResponse);

      if (response.statusCode == 200) {
        var decode = json.decode(response.body);
        print('StatusCode');
        print(decode);
        return json.decode(decode['Value']);
      }
    } catch (e) {}
  }

  vehicleReport() async {
    reportList = await expenseReport();
calculateAmount();
    setState(() {});
    _loading = false;
  }

  @override
  void initState() {
    super.initState();
    vehicleReport();
  }

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
         bottomNavigationBar: BottomAppBar(
        child: Container(
                padding: EdgeInsets.only(right: 25),

          alignment: Alignment.centerLeft,
          height: 40,
          color: MyColors.yellow,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                child: Text(
                  'Tatal : ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text('$totalAmount'.split('.').first,style: TextStyle(fontSize: 16, color: MyColors.red,),),
              ),
             
            ],
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.yellow,
        title: Text(
          'Vehicle Expense Report',
          style: TextStyle(color: Colors.white),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                color: MyColors.yellow,
              ),
            )
          : Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              left: 10,
                            ),
                            margin: EdgeInsets.only(
                              left: 5,
                            ),
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.black)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  //child: Text('day-mon-year'),
                                  child: Text(
                                      '${CusDateFormat.getDate(startDate)}'),
                                ),
                                InkWell(
                                  onTap: () async {
                                    DateTime? date = await showDatePicker(
                                        context: context,
                                        fieldHintText: 'day-mon-year',
                                        initialDate: DateTime.utc(2022),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2025));
                                    if (date != null) {
                                      setState(() {
                                        startDate = date;
                                      });
                                      print(date);
                                      print(CusDateFormat.getDate(date));
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: 20, right: 5),
                                    child: Icon(
                                      Icons.calendar_month,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: 10,
                            ),
                            margin: EdgeInsets.only(
                              left: 5,
                            ),
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.black)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  //child: Text('day-mon-year'),
                                  child: Text(
                                      '${CusDateFormat.getDate(selectedDate)}'),
                                ),
                                InkWell(
                                  onTap: () async {
                                    DateTime? date = await showDatePicker(
                                        context: context,
                                        fieldHintText: 'year-mon-day',
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2025));
                                    if (date != null) {
                                      setState(() {
                                        selectedDate = date;
                                      });
                                      print(date);
                                      print(CusDateFormat.getDate(date));
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: 20, right: 5),
                                    child: Icon(Icons.calendar_month),
                                  ),
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              vehicleReport();
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: MyColors.yellow),
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ), ////
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        width: width+190,
                        child: Column(
                        children: [
                            Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          Container(
                            //padding: EdgeInsets.all(5),
                            //margin: EdgeInsets.all(5),
                            color: Color.fromARGB(255, 234, 227, 227),
                            child: vehExpCont('#','Plate #', 'Expense Type', 'Expense Date',
                                'Amount', 'Remarks', 15, FontWeight.bold),
                          ),
                          Container(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              // scrollDirection: Axis.vertical,
                              itemCount: reportList.length,
                              itemBuilder: (BuildContext context, int index) {
                                int indexx=index+1;
                                var item = reportList[index];

                                // return Container();
                                return vehExpCont(
                                  '$indexx',
                                  '${item['platNumber']} ',
                                  '${item['expenseType']}',
                                  '${item['expenseDate']}',
                                  '${item['amount']}'.split('.').first,
                                  '${item['remarks']}',
                                  12,
                                  FontWeight.normal,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )

                        ],
                      )),
                    )
                  
                  ],
                ),
              ),
            ),
    );
  }

  actionIcon(IconData) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      child: Icon(
        IconData,
        color: Colors.black,
        size: 30,
      ),
    );
  }

  vehExpCont(
    String serial,
    String platenmbr,
    String expType,
    String expiryDate,
    String amount,
    String remarks,
    double size,
    FontWeight fontWeight, {
    String? project,
    Function? onLongPress,
    bgColor,
  }) {
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
            width: 20,
            margin: EdgeInsets.only(left: 10,right: 10),
            child: Text(
              serial,
              style: TextStyle(fontSize: size, fontWeight: fontWeight),
            ),
          ),
          Container(
margin: EdgeInsets.only(right: 10),
width: 90,
            child: Text(
              platenmbr,
              style: TextStyle(fontSize: size, fontWeight: fontWeight),
            ),
          ),
          Container(
            width: 110,
            child: Text(expType,
                style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          ),
          Container(
            width: 100,

           margin: EdgeInsets.only(right: 10),

            child: Text(expiryDate,
                style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          ),
          Container(
            width: 90,

          margin: EdgeInsets.only(right: 10),

            child: Text(amount,
                style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          ),
          Container(
            width: 110,

           margin: EdgeInsets.only(right: 10),

            child: Text(remarks,
                style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          ),
          // Expanded(
          //   child: GestureDetector(
          //     onTap: () => onTab!(),
          //     child: Container(
          //       child: Icon(IconData),
          //     ),
          //   ),
          // ),
        ]),
      ),
    );
  }
}
