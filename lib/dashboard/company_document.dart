import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:xtreme_fleet/dashboard/file_attachment.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
import 'package:xtreme_fleet/utilities/my_navigation.dart';
class CompanyDocument extends StatefulWidget {
  CompanyDocument({Key? key}) : super(key: key);

  @override
  State<CompanyDocument> createState() => _CompanyDocumentState();
}

class _CompanyDocumentState extends State<CompanyDocument> {
   TextEditingController searchController = TextEditingController();
  
  bool loading = true;
  List filterList = [];
  bool isSearching = false;
  var selectedItem;
  int itemIndex = 0;
  List documentList = [];

  deleteDocument() async {
    print('Delete');
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST',
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'));
      request.body = json.encode({
        "type": "CompanyDocument_Delete",
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
        documentList.removeAt(itemIndex);

        setState(() {
          selectedItem = null;
        });
        print('Deleted');
        print(decode);
      }
    } catch (e) {}
  }

  getDocumentList() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST',
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'));
      request.body = json.encode({
         "type": "CompanyDocument_GetAll",
  "value": {
    "Language": "en-US",
    "Id": "9eb1b314-64d7-ec11-9168-00155d12d305"
  }
      });

      request.headers.addAll(headers);
      http.StreamedResponse streamResponse = await request.send();
      http.Response response = await http.Response.fromStream(streamResponse);

      if (response.statusCode == 200) {
        var decode = json.decode(response.body);
        print('Successssssssssssssss');
        print(decode['Value']);
        print(response.body);
        return json.decode(decode['Value']);
      }
    } catch (e) {
      print(e);
    }
  }

  documentApiCall() async {
    documentList =
     await getDocumentList();
    loading = false;

    setState(() {});
  }

  @override
  void initState() {
    documentApiCall();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         // MyNavigation().push(context, AddVehicleList());
        },
        child: Icon(Icons.add),
        backgroundColor: MyColors.yellow,
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.yellow,
        title: selectedItem == null ? Text('Company Document List') : Container(),
        actions: [
          selectedItem == null
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
                                          Navigator.pop(
                                              context, deleteDocument());
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
                       
                      
                        // MyNavigation().push(
                        //     context,
                        //     UpdateVehicle(
                        //       item: selectedItem,
                        //     ));
                      },
                      child: actionIcon(FontAwesomeIcons.penToSquare),
                    ),
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
                      height: 45,
                      padding: EdgeInsets.only(
                          left: 20, top: 5, bottom: 4, right: 20),
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

                                        List filtered = documentList
                                            .where((item) =>
                                                '${item['monthlyRentDate']}'
                                                    .toLowerCase()
                                                    .contains(searchController
                                                        .text
                                                        .toLowerCase()) ||
                                                '${item['projectCode']}'
                                                    .toLowerCase()
                                                    .contains(searchController
                                                        .text
                                                        .toLowerCase()) ||
                                                '${item['monthlyRentNumber']}'
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
                    // padding: EdgeInsets.only(left: 10),
                    color: Color.fromARGB(255, 234, 227, 227),
                    child: vehicleListCont('Name', 
                        'Description','Issue','Expiry', 14, FontWeight.bold),
                  ),

                 
                  Container(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount:
                          isSearching ? filterList.length : documentList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var item = isSearching
                            ? filterList[index]
                            : documentList[index];
                        return vehicleListCont(
                          '${item['nameEng']}',
                          '${item['descriptionEng']}',
                          '${item['issueDate']}',
                          '${item['expiryDate']}',
                          
                       
                          10,
                          FontWeight.w400,
                          onLongPress: () {
                            print('object');
                            print(item);

                            setState(() {
                              print('???///////////');
                              print(selectedItem);
                              selectedItem = item;
                              itemIndex = index;
                            });
                          },
                          bgColor: '${selectedItem}' == '${item}'
                              ? MyColors.yellow
                              : Colors.white,
                               IconData: Icons.attachment,
                              onTab: () {
                                print('${item['currentFileName']}');
                                MyNavigation().push(
                                    context,
                                    FileAttachment(
                                      image: '${item['currentFileName']}',
                                    ));
                              }
                        );
                      },
                    ),
                  )
                ],
              ),
            )),
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

  vehicleListCont(
    String name,
    String description,
    String issuedate,
    String expirydate,
   
 
    double size,
    FontWeight fontWeight, {
    // String? project,
    Function? onLongPress,
    bgColor,
    IconData,
      Function? onTab
  }) {
    return GestureDetector(
      onLongPress: () => onLongPress!(),
      child: Container(
        decoration: BoxDecoration(
            color: bgColor, borderRadius: BorderRadius.circular(10)),
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
              child: Text(description,
                  style: TextStyle(fontSize: size, fontWeight: fontWeight)),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 5),
              child: Text(issuedate,
                  style: TextStyle(fontSize: size, fontWeight: fontWeight)),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 5),
              child: Text(expirydate,
                  style: TextStyle(fontSize: size, fontWeight: fontWeight)),
            ),
          ),
            Expanded(
            child: GestureDetector(
              onTap: () => onTab!(),
              child: Container(
                child: Icon(IconData),
              ),
            ),
          ),
          //   Expanded(
          //   child: Container(
          //     margin: EdgeInsets.only(left: 5),
          //     child: Text(hour,
          //         style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          //   ),
          // ),
          //   Expanded(
          //   child: Container(
          //     margin: EdgeInsets.only(left: 5),
          //     child: Text(dmTc,
          //         style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          //   ),
          // ),
        ]),
      ),
    );
  }
}