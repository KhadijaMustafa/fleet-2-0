import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:one_context/one_context.dart';
import 'package:xtreme_fleet/dashboard/vehicle_supplier.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';

class UpdateVehicleSupplier extends StatefulWidget {
  final item;
  UpdateVehicleSupplier({Key? key, this.item}) : super(key: key);

  @override
  State<UpdateVehicleSupplier> createState() => _UpdateVehicleSupplierState();
}

class _UpdateVehicleSupplierState extends State<UpdateVehicleSupplier> {
  TextEditingController username = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController contactperson = TextEditingController();
  OneContext _context = OneContext.instance;
  bool name = false;
  bool addressfield = false;
  bool contactnumber = false;
  bool contactper = false;

  addVehSupplier() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (username.text.isEmpty) {
      setState(() {
        name = true;
      });
    } else if (address.text.isEmpty) {
      setState(() {
        addressfield = true;
      });
    } else if (contact.text.isEmpty) {
      setState(() {
        contactnumber = true;
      });
    } else if (contactperson.text.isEmpty) {
      setState(() {
        contactper = true;
      });
    } else {
      try {
        var request = http.MultipartRequest(
            'POST',
            Uri.parse(
                'https://fleet.xtremessoft.com/services/Xtreme/multipart'));
        request.fields.addAll({
          'type': 'VehicleSupplier_Save',
          'Id': '${widget.item['id']}',
          'UserId': '00000000-0000-0000-0000-000000000000',
          'NameEng': username.text,
          'NameUrd': 'Name Urd',
          'ContactNumber': contact.text,
          'ContactPersonEng': contactperson.text,
          'ContactPersonUrd': 'Contact Person Urd',
          'AddressEng': address.text,
          'AddressUrd': 'Address Urd',
          'AddToKhata': 'No',
          'Language': 'en-US'
        });
        _context.showProgressIndicator(
            circularProgressIndicatorColor: Color.fromARGB(255, 98, 61, 12));
        http.StreamedResponse streamResponse = await request.send();
        http.Response response = await http.Response.fromStream(streamResponse);
        _context.hideProgressIndicator();
        if (response.statusCode == 200) {
          var decode = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: MyColors.bggreen,
              content: Text('Record succesfully updated.')));
          Navigator.pop(context);
          var route = MaterialPageRoute(
            builder: (context) => VehicleSupplier(),
          );
          Navigator.pushReplacement(context, route);
          print(decode);
          print('decode');
        }
      } catch (e) {}
    }
  }

  @override
  void initState() {
    print(widget.item);
    username.text = widget.item!['name'];
    address.text = widget.item!['address'];
    contact.text = widget.item!['contactNumber'];
    contactperson.text = widget.item!['contactPerson'];

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
          'Add Vehicle Supplier',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //addExpCont('Name', '*', ':', Colors.red),
              Container(
                child: textFieldCont(
                    'Name', username, name ? Colors.red : Colors.black,
                    onChanged: ((value) {
                  setState(() {
                    name = false;
                  });
                })),
              ),
              name ? validationCont() : Container(),
             // addExpCont('Address', '*', ':', Colors.red),
              Container(
                child: textFieldCont('Address', address,
                    addressfield ? Colors.red : Colors.black,
                    onChanged: ((value) {
                  setState(() {
                    addressfield = false;
                  });
                })),
              ),
              addressfield ? validationCont() : Container(),
             // addExpCont('Contact Number', '*', ':', Colors.red),
              Container(
                child: textFieldCont('Contact Number', contact,
                    contactnumber ? Colors.red : Colors.black,
                    onChanged: ((value) {
                  setState(() {
                    contactnumber = false;
                  });
                }), keyboard: TextInputType.phone),
              ),
              contactnumber ? validationCont() : Container(),
              //addExpCont('Contact Person', '*', ':', Colors.red),
              Container(
                child: textFieldCont('Contact Person', contactperson,
                    contactper ? Colors.red : Colors.black,
                    onChanged: ((value) {
                  setState(() {
                    contactper = false;
                  });
                })),
              ),
              contactper ? validationCont() : Container(),
              InkWell(
                onTap: () {
                  addVehSupplier();
                },
                child: Container(
                  height: 50,
                  margin:
                      EdgeInsets.only(left: 20, top: 40, right: 20, bottom: 20),
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
     margin: EdgeInsets.only(left: 20, top: 25, right: 20),
                padding: EdgeInsets.only(left: 20, right: 10),
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
        onChanged: (String? value) => onChanged!(value!),
        // onChanged: (String? Value) {
        //   onChanged;
        // },
      ),
    );
  }

  addExpCont(String title, String asterisk, String colon, Color color) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(left: 20, top: 15),
      child: RichText(
          text: TextSpan(children: [
        TextSpan(
            text: title, style: TextStyle(color: Colors.black, fontSize: 18)),
        TextSpan(text: asterisk, style: TextStyle(color: color, fontSize: 18)),
        TextSpan(
            text: colon, style: TextStyle(color: Colors.black, fontSize: 18)),
      ])),
    );
  }
}
