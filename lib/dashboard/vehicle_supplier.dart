import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:xtreme_fleet/dashboard/add_veh_supplier.dart';
import 'package:xtreme_fleet/dashboard/update_veh_supplier.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
import 'package:http/http.dart' as http;
import 'package:xtreme_fleet/utilities/my_navigation.dart';

class VehicleSupplier extends StatefulWidget {
  VehicleSupplier({Key? key}) : super(key: key);

  @override
  State<VehicleSupplier> createState() => _VehicleSupplierState();
}

class _VehicleSupplierState extends State<VehicleSupplier> {
  TextEditingController searchController = TextEditingController();
  List supplierList = [];
  bool loading = true;
  List filterList = [];
  bool isSearching = false;
  var selectedItem;
  int itemIndex = 0;
  getVehExpense() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST',
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'));
      request.body = json.encode({
        "type": "VehicleSupplier_GetAll",
        "value": {"Language": "en-US"}
      });
      // print('${selectedItem['id']}');
      request.headers.addAll(headers);

      http.StreamedResponse streamResponse = await request.send();
      http.Response response = await http.Response.fromStream(streamResponse);

      if (response.statusCode == 200) {
        var decode = json.decode(response.body);
        print('Successssssssssssssss');
        print(decode['Value']);
        return json.decode(decode['Value']);
        //json.decode(decode['Value']);

      }
    } catch (e) {
      print(e);
    }
  }

  expCallApi() async {
    supplierList = await getVehExpense();
    loading = false;

    setState(() {});
  }

  @override
  void initState() {
    expCallApi();
    super.initState();
  } //

  deleteSupplier() async {
    print('Delete');
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST',
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'));
      request.body = json.encode({
        "type": "VehicleSupplier_Delete",
        "value": {"Id": "${selectedItem['id']}"}
      });
      request.headers.addAll(headers);

      http.StreamedResponse streamResponse = await request.send();
      http.Response response = await http.Response.fromStream(streamResponse);

      if (response.statusCode == 200) {
        print('???????????????????');
        var decode = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: MyColors.bggreen,
            content: Text('Record succesfully deleted.')));
        supplierList.removeAt(itemIndex);

        setState(() {
          selectedItem = null;
        });
        print('Deleted');
        print(decode);
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //getVehExpense();
          MyNavigation().push(context, AddVehicleSupplier());
        },
        child: Icon(Icons.add),
        backgroundColor: MyColors.yellow,
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.yellow,
        title:selectedItem==null? Text('Vehicle Supplier List'):Container(),
        actions: [
          selectedItem==null?Container():Row(
             children: [
                    GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  //title: Text('data'),
                                  content: Text(
                                    'Delete this record?',
                                    style: TextStyle(
                                        color: MyColors.yellow,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  actions: [
                                    InkWell(
                                        onTap: () {
                                          Navigator.pop(context, false);
                                        },
                                        child: Text('Cancel')),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, deleteSupplier());
                                          setState(() => selectedItem = null);
                                        },
                                        child: Text(
                                          'Ok',
                                          style: TextStyle(color: Colors.black),
                                        )),
                                  ],
                                );
                              });
                     
                        },
                        child: actionIcon(
                          Icons.delete,
                        )),
                  
                    GestureDetector(
                        onTap: () {
                          MyNavigation().push(
                              context,
                              UpdateVehicleSupplier(
                                item: selectedItem,
                              ));
                        },
                        child: actionIcon(Icons.edit)),
                    GestureDetector(
                        onTap: () => setState(() => selectedItem = null),
                        child: actionIcon(Icons.close)),
                  ],
          )
        ],
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: MyColors.yellow,
              ),
            )
          : Container(
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  Container(
                    //margin: EdgeInsets.all(10),
                    // height: 50,
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 20, top: 4, bottom: 4, right: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: MyColors.grey)),
                      margin: EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 10),
                      child: TextFormField(
                        cursorColor: MyColors.black,
                        controller: searchController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search here .........',
                            suffixIcon: GestureDetector(
                                onTap: isSearching
                                    ? () {
                                        searchController.clear();
                                        setState(() {
                                          isSearching = false;
                                        });
                                      }
                                    : () {
                                        setState(() {
                                          isSearching = true;
                                          filterList.clear();
                                        });

                                        List filtered = supplierList
                                            .where((item) =>
                                                '${item['name']}'
                                                    .toLowerCase()
                                                    .contains(searchController
                                                        .text
                                                        .toLowerCase()) ||
                                                '${item['address']}'
                                                    .toLowerCase()
                                                    .contains(searchController
                                                        .text
                                                        .toLowerCase()) ||
                                                '${item['contactPerson']}'
                                                    .toLowerCase()
                                                    .contains(searchController
                                                        .text
                                                        .toLowerCase()))
                                            .toList();

                                        print(filtered);
                                        setState(() {
                                          filterList = filtered;
                                        });
                                      },
                                child: Icon(
                                  isSearching ? Icons.close : Icons.search,
                                  size: 30,
                                  color: MyColors.yellow,
                                ))),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    color: Color.fromARGB(255, 234, 227, 227),
                    child: supplierCont(
                        'Name', 'Address', 'Contact ', 14, FontWeight.bold),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount:
                          isSearching ? filterList.length : supplierList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var item = isSearching
                            ? filterList[index]
                            : supplierList[index];
                        return supplierCont(
                            '${item['name']}',
                            '${item['address']}',
                            '${item['contactPerson']}',
                            12,
                            FontWeight.normal,
                             onLongPress: () {
                                      print('object');
                                     
                                      setState(() {
                                        selectedItem = item;
                                        itemIndex = index;
                                      });
                                    }, bgColor: '${selectedItem}' == '${item}'
                                        ? MyColors.yellow
                                        : Colors.white,
                        //     delete: Icons.delete,
                        //     edit: Icons.edit, onPress: () {
                        //   setState(() {
                        //     selectedItem = item;
                        //     itemIndex = index;
                        //   });
                        //   showDialog(
                        //       context: context,
                        //       builder: (BuildContext context) {
                        //         return AlertDialog(
                        //           //title: Text('data'),
                        //           content: Text(
                        //             'Delete this record?',
                        //             style: TextStyle(
                        //                 color: MyColors.yellow,
                        //                 fontWeight: FontWeight.bold),
                        //           ),
                        //           actions: [
                        //             InkWell(
                        //                 onTap: () {
                        //                   Navigator.pop(context, false);
                        //                 },
                        //                 child: Text('Cancel')),
                        //             TextButton(
                        //                 onPressed: () {
                        //                   Navigator.pop(
                        //                       context, deleteSupplier());
                        //                   setState(() => selectedItem = null);
                        //                 },
                        //                 child: Text(
                        //                   'Ok',
                        //                   style: TextStyle(color: Colors.black),
                        //                 )),
                        //           ],
                        //         );
                        //       });
                        // }, onTab: () {
                        //   setState(() {
                        //     selectedItem = item;
                        //   });
                        //   MyNavigation().push(
                        //       context,
                        //       UpdateVehicleSupplier(
                        //         item: selectedItem,
                        //       )
                  // );
                  //       }
                        );
                      },
                    ),
                  )
                ],
              )),
            ),
    );
  }
   actionIcon(IconData) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      child: Icon(
        IconData,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  supplierCont(String name, String address, String contact, double size,
      FontWeight fontWeight,
      {
      // String? project,
      Function? onLongPress,
       bgColor,
    
     }) {
    return GestureDetector(
       onLongPress: () => onLongPress!(),
      child: Container(
        decoration: BoxDecoration(
             color: bgColor,
             
            borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(5),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            child: Container(
              child: Text(
                name,
                style: TextStyle(fontSize: size, fontWeight: fontWeight),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Text(address,
                  style: TextStyle(fontSize: size, fontWeight: fontWeight)),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 5),
              child: Text(contact,
                  style: TextStyle(fontSize: size, fontWeight: fontWeight)),
            ),
          ),
          SizedBox(width: 30,)
          // Container(
          //   child: Row(
          //     children: [
          //       GestureDetector(
          //         onTap: () => onPress!(),
          //         child: Container(
          //           margin: EdgeInsets.only(right: 10),
          //           child: Icon(
          //             delete,
          //             color: MyColors.yellow,
          //           ),
          //         ),
          //       ),
          //       GestureDetector(
          //         onTap: () => onTab!(),
          //         child: Container(
          //           margin: EdgeInsets.only(right: 5),
          //           child: Icon(
          //             edit,
          //             color: MyColors.yellow,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ]),
      ),
    );
  }
}
