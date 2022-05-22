import 'package:flutter/material.dart';
import 'package:xtreme_fleet/components/button_widget.dart';
import 'package:xtreme_fleet/components/dropdown_widget.dart';
import 'package:xtreme_fleet/components/text_widget.dart';
import 'package:xtreme_fleet/components/textfield_widget.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';

class TestComponent extends StatefulWidget {
  TestComponent({Key? key}) : super(key: key);

  @override
  State<TestComponent> createState() => _TestComponentState();
}

class _TestComponentState extends State<TestComponent> {
  List<String> item=['arif','asad','amin'];
  var name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.only(top: 30),
        alignment: Alignment.center,
        child: SingleChildScrollView(
            child: Column(
          children: [
            Container(child:  TextWidget(
              text: 'TextComponent',
              textcolor: MyColors.black,
              size: 18,
              fontWeight: FontWeight.bold,
            ),),
            Container(
              margin: EdgeInsets.only(top: 15),
              child:  ButtonWidget(
              bgcolor: MyColors.yellow,
              size: 16,
              text: 'Click button',
              height: 40,
              width: 200,
              borderradius: BorderRadius.circular(20),
              textcolor: Colors.white,
            ),),

           TextFieldWidget(onChanged: (value){
             setState(() {
               
             },);
           },bordercolor: MyColors.bggreen,hinttext: 'Enter your name',border: Border.all(),),
           Container(
             child: DropdownWidget(itemList: item,hinttext: '--select--',onchangevalue: name,onChanged: (value){
               setState(() {
                 name=value;
               },);
             }),
           )
           
          ],
        )),
      ),
    );
  }
}
