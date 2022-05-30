import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:http/http.dart' as http;

class KhataReport extends StatefulWidget {
  final item;
  KhataReport({Key? key, this.item}) : super(key: key);

  @override
  State<KhataReport> createState() => _KhataReportState();
}

class _KhataReportState extends State<KhataReport> {
  double _currentValue = 0;
  setEndPressed(double value) {
    setState(() {
      _currentValue = value;
    });
  }

  var khata;
  var contact;
  var nameeng;
  var nameurd;
  var addresseng;
  var addressurd;
  double _value = 0;
  bool loading = true;

  @override
  void initState() {
    print('/////////////////');
    print(widget.item);
    print('/////////////////');

    khata = widget.item['khataNumber'];
    contact = widget.item['contactNumber'];
    nameeng = widget.item['nameEng'];
    nameurd = widget.item['nameUrd'];
    addresseng = widget.item['addressEng'];
    addressurd = widget.item['addressUrd'];
getTransactionList();
    super.initState();
  }

  getTransactionList() async {
        print('/////////////////////// 1');

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST',
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'));
      request.body = json.encode({
        "type": "Transaction_TotalDrCr_ByKhataId",
        "value": {"Language": "en-US"}
      });
        print('/////////////////////// 2');

      request.headers.addAll(headers);
      http.StreamedResponse streamResponse = await request.send();
      http.Response response = await http.Response.fromStream(streamResponse);

      if (response.statusCode == 200) {
        var decode = json.decode(response.body);
        print('///////////////////////');
       
        print(response.body);
        print(decode);
       // return json.decode(decode['Value']);
      }
    } catch (e) {
      print(e);
    }
  }

  transactionApiCall() async {
    await getTransactionList();
    loading = false;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.yellow,
        title: Text(
          'Khata',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20, left: 30, right: 30),
              child: Column(children: [
                detailsCont('Khata #', '$khata'),
                detailsCont('Contact Number', '$contact'),
                detailsCont('Name (English)', '$nameeng'),
                detailsCont('Name (Urdu)', '$nameurd'),
                detailsCont('Address (English)', '$addresseng'),
                detailsCont('Address (Urdu)', '$addressurd'),
              ]),
            ),
            Container(
              width: width,
              margin: EdgeInsets.only(top: 20, right: 10, left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  cardCont(MyColors.bgyellow, 'Total Debit', '0'),
                  cardCont(MyColors.bgyellow, 'Total Credit', '0'),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, left: 10),
              alignment: Alignment.topLeft,
              child: cardCont(MyColors.bgyellow, 'Total Credit', '0'),
            )

            //   cardCont(MyColors.bgyellow, 'Total Debit', '0')
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
          Container(
            width: 150,
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            alignment: Alignment.topLeft,
            child: Text(title,
                style: TextStyle(
                    color: MyColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Container(
              width: 150,
              margin: EdgeInsets.only(left: 10, right: 10, top: 10),
              alignment: Alignment.topLeft,
              child: Text(detail,
                  style: TextStyle(
                      color: MyColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400)),
            ),
          ),
        ],
      ),
    );
  }

  cardCont(Color bgcolor, String text, String count) {
    return Card(
      color: bgcolor,
      // color: Color.fromRGBO(104, 191, 123, 1),
      shadowColor: Colors.white.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13.0),
        side: BorderSide(color: MyColors.grey.withOpacity(0.1)),
      ),
      elevation: 50,
      child: Container(
        alignment: Alignment.centerLeft,
        height: 100,
        width: 180,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(count,
                  style: TextStyle(
                      color: MyColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400)),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(text,
                  style: TextStyle(
                      color: MyColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400)),
            ),
            Container(
              child: LinearProgressIndicator(
                value: 0.1,
                
                 valueColor: AlwaysStoppedAnimation<Color>(MyColors.red),
              backgroundColor: MyColors.grey,
              ),
            //     child: FAProgressBar(
            //   currentValue: _currentValue,
            //   size: 2,
            //   maxValue: 150,
            //   changeColorValue: 100,
            //   changeProgressColor: MyColors.red,
            //   backgroundColor: MyColors.grey,
            //   progressColor: MyColors.yellow,
            //   animatedDuration: const Duration(milliseconds: 300),
            //   direction: Axis.horizontal,
            //   verticalDirection: VerticalDirection.up,
            //   formatValueFixed: 2,
            // )
            )
          ],
        ),
      ),
    );
  }
}
