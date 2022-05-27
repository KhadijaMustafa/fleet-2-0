import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';
import 'package:xtreme_fleet/dashboard/vehicle_list.dart';
import 'package:xtreme_fleet/resources/app_data.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
import 'package:http/http.dart' as http;

class UpdateVehicle extends StatefulWidget {
  final item;
  final String? driver;
  UpdateVehicle({Key? key, this.item, this.driver}) : super(key: key);

  @override
  State<UpdateVehicle> createState() => _UpdateVehicleState();
}

class _UpdateVehicleState extends State<UpdateVehicle> {
  TextEditingController platenumber = TextEditingController();
  bool pltnumber = false;
  bool suppliername = false;
  var vehiclesupplier;
  bool vehicle = false;
  var vehicletype;
  bool drivername = false;
  var driver;
  List supplierList = [];
  List vehicltypelist = [];
  List driverlist = [];
  List vehicleList = [];
  List valuesList = [];
  var listvalues;
  var platenumberr;
  var vehicletypee;
  var vehiclesupplierr;
  var driverr;
  OneContext _context = OneContext.instance;
  getValue() async {
      print('//////////////////////////////////11111111111');

    try {
      var response = await http.post(
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "type": "Vehicle_GetById",
            "value": {
              "Language": "en-US",
              "Id": '${widget.item['id']}'
            }
          }));

      var decode = json.decode(response.body);
      print('Successssssssssssssss');
      print(decode['Value']);
      print(response.body);
     
       listvalues = json.decode(decode['Value']);
     platenumber.text = listvalues["platNumber"];
     vehiclesupplier = {
      'value': listvalues['vehicleSupplierId'],
      'text': listvalues['vehicleSupplierName']
    };
     vehicletype = {
      'value': listvalues['setupVehicleTypeId'],
      'text': listvalues['vehicleTypeName']
    };
     driver = {
      'value': listvalues['employeeId'],
      'text': listvalues['employeeName']
    };
   //  vehicletype=listvalues["vehicleSupplierName"];


      // driver=(json.decode(listvalues))['employeeName'];
      print('dribver');
      print(driver);
   
      print('//////////////////////////////////');
      print(listvalues);
      // print(vehicletype);
      print('//////////////////////////////////');
setState(() {
  
});
      
    } catch (e) {
      print(e);
    }
  }

 

  getDropDownValues(String valueType) async {
    try {
      var response = await http.post(
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "type": "$valueType",
            "value": {"Language": "en-US"}
          }));

      print(response.body);
      print(response.statusCode);

      var decode = json.decode(response.body);
      vehicleList = json.decode(decode['Value']);

      print(vehicleList);

      setState(() {});

      return vehicleList;
    } catch (e) {
      print(e);
    }
    ;
  }

  getListCall() async {
    supplierList = await getDropDownValues('VehicleSupplier_DropdownList_Get');
    vehicltypelist =
        await getDropDownValues('Setup_VehicleType_DropdownList_Get');
    driverlist = await getDropDownValues('Driver_DropdownList_Get');
    setState(() {
      
    });
  }

  updateVeh() async {
    FocusManager.instance.primaryFocus?.unfocus();

    print('starttttt..................');
    if (platenumber.text.isEmpty) {
      setState(() {
        pltnumber = true;
      });
    } else if (vehiclesupplier == null) {
      setState(() {
        suppliername = true;
      });
    } else if (vehicletype == null) {
      setState(() {
        vehicle = true;
      });
    } else if (driver == null) {
      setState(() {
        drivername = true;
      });
    } else {
      try {
        var request = http.MultipartRequest(
            'POST',
            Uri.parse(
                'https://fleet.xtremessoft.com/services/Xtreme/multipart'));
        request.fields.addAll({
          'type': 'Vehicle_Save',
          'Id': '${widget.item['id']}',
          'PlatNumber': platenumber.text,
          'VehicleSupplierId': vehiclesupplier['value'],
          'SetupVehicleTypeId': vehicletype['value'],
          'EmployeeId': driver['value'],
          'Language': 'en-US'
        });

        _context.showProgressIndicator(
            circularProgressIndicatorColor: Color.fromARGB(255, 98, 61, 12));
        http.StreamedResponse streamResponse = await request.send();
        http.Response response = await http.Response.fromStream(streamResponse);
        _context.hideProgressIndicator();
        if (response.statusCode == 200) {
          print(response.statusCode);
          print('statuscode');
          var decode = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: MyColors.bggreen,
              content: Text('Record succesfully updated.')));
          Navigator.pop(context);
          var route = MaterialPageRoute(
            builder: (context) => VehicleList(),
          );
          Navigator.pushReplacement(context, route);
          print(decode);
          print('decode');
        }
      } catch (e) {
        _context.hideProgressIndicator();
        print(e);
      }
    }
  }

  @override
  void initState() {
    getListCall();
 
    getValue();
    print('////////////////////////employeeid');
   
  

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        elevation: 0,
        backgroundColor: MyColors.yellow,
        title: Text(
          'Update Vehicle',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              textFieldCont('Plate Number', platenumber,
                  pltnumber ? Colors.red : Colors.black, onChanged: (value) {
                setState(() {
                  pltnumber = false;
                });
              }),
              pltnumber ? validationCont() : Container(),
              dropdownComp(
                  vehiclesupplier == null
                      ? "Vehicle Supplier Name"
                      : vehiclesupplier["text"],
                  suppliername ? Colors.red : Colors.black, onchanged: (value) {
                setState(() {
                  vehiclesupplier = value;
                  suppliername = false;
                  print(vehiclesupplier);
                });
              }, list: supplierList, dropdowntext: "text"),
              suppliername ? validationCont() : Container(),
              dropdownComp(
                  vehicletype == null ? "Vehicle Type" : vehicletype["text"],
                  vehicle ? Colors.red : Colors.black, onchanged: (value) {
                setState(() {
                  vehicletype = value;
                  vehicle = false;
                  print(vehicletype);
                  print('vehicle');
                });
              }, list: vehicltypelist, dropdowntext: "text"),
              vehicle ? validationCont() : Container(),
              dropdownComp(driver == null ? "Driver Name" : driver["text"],
                  drivername ? Colors.red : Colors.black, onchanged: (value) {
                setState(() {
                  driver = value;
                  drivername = false;
                  print(driver);
                  print('driver');
                });
              }, list: driverlist, dropdowntext: "text"),
              drivername ? validationCont() : Container(),
              InkWell(
                onTap: () {
                  updateVeh();
                },
                child: Container(
                  height: 50,
                  margin: EdgeInsets.only(
                    left: 20,
                    top: 40,
                    right: 20,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: MyColors.yellow,
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(
                    'Save',
                    style: TextStyle(
                        color: MyColors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  dropdownComp(String hinttext, Color bordercolor,
      {Function? onchanged, List? list, String? dropdowntext}) {
    return Container(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: bordercolor,
            )),
        margin: EdgeInsets.only(left: 20, top: 25, right: 20),
        child: DropdownButtonFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          isExpanded: true,
          decoration: InputDecoration(
              border: InputBorder.none,
              filled: false,
              hintStyle: TextStyle(color: MyColors.black),
              hintText: '$hinttext',
              fillColor: Colors.white),
          onChanged: (value) => onchanged!(value),
          items: list
              ?.map((item) => DropdownMenuItem(
                  value: item, child: Text("${item[dropdowntext]}")))
              .toList(),
        ));
  }

  validationCont() {
    return Container(
      margin: EdgeInsets.only(left: 35),
      alignment: Alignment.topLeft,
      height: 15,
      child: Text(
        'This field is required',
        style: TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }

  textFieldCont(String hint, TextEditingController controller, Color,
      {Function(String)? onChanged, TextInputType? keyboard}) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 10),
      margin: EdgeInsets.only(left: 20, top: 25, right: 20),
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Color)),
      child: TextFormField(
        keyboardType: keyboard,
        controller: controller,
        cursorColor: Colors.black,
        decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: MyColors.black, fontSize: 14),
            border: InputBorder.none),
        onChanged: (value) => onChanged!(value),

        // onChanged: (String? Value) {
        //   onChanged;
        // },
      ),
    );
  }
}
