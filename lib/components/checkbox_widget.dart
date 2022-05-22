import 'package:flutter/material.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
class CheckboxWidget extends StatelessWidget {
  final bool? ischecked;
  final Function? onTab;

  const CheckboxWidget({Key? key,this.ischecked,this.onTab}) : super(key: key,);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
      onTap: () => onTab!(ischecked),
      child: Stack(alignment: Alignment.center, children: [
        Container(
          margin: EdgeInsets.only(right: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(
                  color:  MyColors.yellow)),
          height: 20,
          width: 20,
        ),
        Container(
          height: 25,
          width: 25,
        ),
        if (ischecked!)
          Icon(
            Icons.check,
            color: MyColors.red,
          )
      ]),),


    );
  }
}