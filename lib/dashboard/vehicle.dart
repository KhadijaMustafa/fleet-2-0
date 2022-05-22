import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xtreme_fleet/utilities/my_colors.dart';
class Vehicle extends StatefulWidget {
  Vehicle({Key? key}) : super(key: key);

  @override
  State<Vehicle> createState() => _VehicleState();
}

class _VehicleState extends State<Vehicle> {
  var vehicleList;
    getVehExpense() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST',
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'));
      request.body = json.encode({
     "type": "Vehicle_GetById",
	"value": {
		"Language": "en-US",
		"Id": "dbf3f873-6eb2-ec11-8347-74867ad401de"
	}
      });
      // print('${selectedItem['id']}');
      request.headers.addAll(headers);

      http.StreamedResponse streamResponse = await request.send();
      http.Response response = await http.Response.fromStream(streamResponse);

      if (response.statusCode == 200) {
        var decode = json.decode(response.body);
        print('Successssssssssssssss');
        print(decode['Value']);
        return json.decode(decode['Value']);//vys

        //json.decode(decode['Value']); 

      }
    } catch (e) {
      print(e);
    }
  }

  expCallApi() async {
    vehicleList = await getVehExpense();
    print(vehicleList);

    setState(() {});
  }

  @override
  void initState() {
    expCallApi();
    super.initState();
  } 
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(),
    backgroundColor: MyColors.red,);
  }
}