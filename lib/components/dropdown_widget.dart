import 'package:flutter/material.dart';

class DropdownWidget extends StatelessWidget {
  final List? itemList;
  final Function? onChanged;
  final String? onchangevalue;
  final String? hinttext;

  const DropdownWidget(
      {Key? key,
      this.itemList,
      this.onChanged,
      this.onchangevalue,
      this.hinttext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), border: Border.all()),
      margin: EdgeInsets.only(left: 20, top: 30, right: 20),
      child: DropdownButtonFormField(
        isExpanded: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
            filled: false,
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey[800]),
            hintText: '$hinttext',
            fillColor: Colors.white),
        onChanged: (value) => onChanged,
        items: itemList!
            .map((itemTitle) =>
                DropdownMenuItem(value: itemTitle, child: Text('$itemTitle')))
            .toList(),
      ),
    );
  }
}
