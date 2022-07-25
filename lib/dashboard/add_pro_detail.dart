import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one_context/one_context.dart';
import 'package:xtreme_fleet/dashboard/project_details.dart';
import 'package:xtreme_fleet/utilities/CusDateFormat.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
import 'package:xtreme_fleet/utilities/pickers.dart';
import 'package:http/http.dart'as http;
class AddProjectDetail extends StatefulWidget {
  final item;
  AddProjectDetail({Key? key,this.item}) : super(key: key);

  @override
  State<AddProjectDetail> createState() => _AddProjectDetailState();
}

class _AddProjectDetailState extends State<AddProjectDetail> {
  OneContext _context = OneContext.instance;

  DateTime? expiryDate;

  bool document=false;
  var docType;
  List docList=[];
  String? imageFile;
  String? currentImage;
  bool expDate = false;
bool file=false;
  bool _expiry = false;
  bool get expiry => _expiry;
   checkbox(bool value) {
    print(value);
    _expiry = value;
    setState(() {});
  }
  pickImageFomG(ImageSource source) async {
    XFile? file = await Pickers.instance.pickImage(source: source);
    if (file != null) {
      imageFile = file.path;
      setState(() {});
    }
  }
   getDropDownValues() async {
    try {
      var response = await http.post(
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "type": "Project_DocumentType_DropdownList_Get",
            "value": {"Language": "en-US"}
          }));
      print(response.body);
      print(response.statusCode);
      print(response.statusCode);
      var decode = json.decode(response.body);
      docList = json.decode(decode['Value']);

      setState(() {});

      return docList;
    } catch (e) {
      print(e);
    }
    ;
  }
  addProjectDetail()async{
    FocusManager.instance.primaryFocus?.unfocus();
    if(docType==null){
      setState(() {
        
        document=true;
      });
    }else if (imageFile == null && currentImage==null) {
      setState(() {
        file = true;
      });
    }
     
    else if(expiryDate==null && _expiry==false){
      setState(() {
        expDate=true;
      });
    }
      else{
    Map<String, String> body= {
      'type': 'AttachedDocument_Save',
  'Id': '00000000-0000-0000-0000-000000000000',
  'FKId': '25766be6-eb0b-ed11-916f-00155d12d305',
  'UserId': 'f14198a1-1a9a-ec11-8327-74867ad401de',
  'DocumentTypeId': '${widget.item['id']}',
  'DocumentName':docType['text'],
  'ExpiryDate': _expiry? 'year-month-day': CusDateFormat.getDate(expiryDate!),
  'NoExpiryCheckbox': 'NoExpiryCheckbox',
  'Other': ''
          
        } ;
        print(body);
      try {
        var request = http.MultipartRequest(
            'POST',
            Uri.parse(
                'https://fleet.xtremessoft.com/services/Xtreme/multipart'));
        request.fields.addAll(body);
        if (imageFile != null) {
          request.files.add(
              await http.MultipartFile.fromPath('Attachment', '$imageFile'));
        }
        _context.showProgressIndicator(
            circularProgressIndicatorColor: Color.fromARGB(255, 98, 61, 12));
        http.StreamedResponse streamResponse = await request.send();
        http.Response response = await http.Response.fromStream(streamResponse);
        _context.hideProgressIndicator();

        print('false');
      
        if (response.statusCode == 200) {
          var decode = json.decode(response.body);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: MyColors.bggreen,
            content: Text('Record succesfully added.'),
          ));
          Navigator.pop(context);
          var route = MaterialPageRoute(
            builder: (context) => ProjectDetails(),
          );
          Navigator.pushReplacement(context, route);
          print(decode);
          return decode;
        } else {
          print('falseeeeeeeeeeeeeeeeeeee');
          print(response.reasonPhrase);
        }
      } catch (e) {
        print(e);
      }

    }
      
  }
  @override
  void initState() {
    super.initState();
    getDropDownValues();
   
  }

  // getListCall() async {
  //   empNameList = await getDropDownValues();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Project Detail'),
        backgroundColor: MyColors.yellow,
        elevation: 0,
      ),
      body: Container(
        child: SingleChildScrollView(child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
             Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: document ? Colors.red : Colors.black,
                    )),
                margin: EdgeInsets.only(left: 20, top: 30, right: 20),
                padding: EdgeInsets.only(left: 20, right: 10),
                child: DropdownButtonFormField(
                  isExpanded: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      filled: false,
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: MyColors.black),
                      hintText: docType == null ? "Document Type" : docType['text'],
                      fillColor: Colors.white),
                  onChanged: (value) {
                    print(value);
                    setState(() {
                      docType = value;
                      document = false;
                    });
                  },
                  items: docList
                      .map((item) => DropdownMenuItem(
                          value: item, child: Text("${item['text']}")))
                      .toList(),
                ),
              ),
              document ? validationCont() : Container(),
               Container(
              margin: EdgeInsets.only(left: 20, top: 25, right: 20),
              padding: EdgeInsets.only(left: 20, right: 10),
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color:file?Colors.red: Colors.black)),
              child: Row(
                children: [
                  Container(
                    height: 25,
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(right: 10, left: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(1)),
                    child: InkWell(
                        onTap: () {
                          pickImageFomG(ImageSource.gallery);
                          setState(() {
                            file = false;
                          });
                        },
                        child:
                            Text('Choose Doc', style: TextStyle(fontSize: 11))),
                  ),
                  imageFile != null ||currentImage!=null
                      ? Expanded(
                          child: Container(
                            height: 20,
                            child: Text(
                              imageFile?.split('/').last??currentImage??"",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        )
                      : Text('No file choosen')
                ],
              ),
            ),
            file ? validationCont() : Container(),
           
             dateCont(
                expDate && _expiry==false ? Colors.red : Colors.black,
                expiryDate == null ||_expiry
                    ? 'Expiry Date'
                    : '${CusDateFormat.getDate(expiryDate!)}',
                (date) => setState(() {
                  _expiry? expiryDate=null:
                      expiryDate = date;

                      expDate = false;
                    }),bg: _expiry?MyColors.grey:Colors.transparent),
                     expDate && _expiry==false ?validationCont():Container(),
                      Container(
              margin: EdgeInsets.only(left: 20, top: 25),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10, left: 10),
                    child: Text(
                      'No Expiry',
                      style: TextStyle(color: MyColors.black),
                    ),
                  ),
                  checkboxCont(expiry, onTab: (value) => checkbox(value)),
                ],
              ),
            ),
                     InkWell(
              onTap: () {
            addProjectDetail();

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
        )),
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
   dateCont(Color bordercolor, String text, Function(DateTime) pickedDate,{Color? bg}) {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 25, right: 20),
      padding: EdgeInsets.only(left: 20, right: 10),
      height: 50,
      decoration: BoxDecoration(
        color: bg,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: bordercolor)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            //child: Text('day-mon-year'),
            child: Text(text),
          ),
          InkWell(
            onTap: () async {
              DateTime? date = await showDatePicker(
                  context: context,
                  fieldHintText: 'day-mon-year',
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2025));
              if (date != null) {
                pickedDate(date);

                print(date);
              }
            },
            child: Container(
              child: Icon(Icons.calendar_today),
            ),
          )
        ],
      ),
    );
  }
   checkboxCont(bool ischecked, {Function(bool)? onTab}) {
    return GestureDetector(
      onTap: () => onTab!(!ischecked),
      child: Stack(alignment: Alignment.center, children: [
        Container(
          margin: EdgeInsets.only(right: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(border: Border.all(color: MyColors.black)),
          height: 20,
          width: 18,
        ),
        Container(
          height: 25,
          width: 25,
        ),
        if (ischecked)
          Icon(
            Icons.check,
            color: MyColors.yellow,
          )
      ]),
    );
  }
}