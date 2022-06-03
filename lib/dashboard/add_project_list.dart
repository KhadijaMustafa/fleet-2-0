import 'package:flutter/material.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
class AddProjectList extends StatefulWidget {
  AddProjectList({Key? key}) : super(key: key);

  @override
  State<AddProjectList> createState() => _AddProjectListState();
}

class _AddProjectListState extends State<AddProjectList> {
  TextEditingController codeController=TextEditingController();
  TextEditingController nameEngController=TextEditingController();
  TextEditingController nameUrduController=TextEditingController();
  TextEditingController tripController=TextEditingController();
  TextEditingController rateController=TextEditingController();
  DateTime dateFrom = DateTime.now();
  DateTime dateTo = DateTime.now();

  var customer;
  var tosite;
  var fromsite;

  bool code=false;
  bool name=false;
  bool nameurd=false;
  bool trip=false;
  bool rate=false;
  bool fdate=false;
  bool tdate=false;
  bool custo=false;
  bool fsite=false;
  bool tsite=false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.yellow,
        title: Text(
          'Add Project',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(child: Column(
          children: [
              textFieldCont(
                'Code',codeController ,code ? Colors.red : Colors.black,
                onChanged: (value) {
              setState(() {
                code = false;
              });
            }, keyboard: TextInputType.number),
            code ? validationCont() : Container(),

             textFieldCont(
                'Name (English)',nameEngController ,name ? Colors.red : Colors.black,
                onChanged: (value) {
              setState(() {
                name = false;
              });
            }, keyboard: TextInputType.number),
            name ? validationCont() : Container(),

          ],
        )),
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
      ),
    );
  }
}