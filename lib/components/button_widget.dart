import 'package:flutter/material.dart';
class ButtonWidget extends StatelessWidget {
  final String? text;
  final double? size;
  final FontWeight? fontWeight;
  final Color? textcolor;
  final double? height;
  final double? width;
  final Color? bgcolor;
  final BoxBorder? border;
  final BorderRadius? borderradius;
  const ButtonWidget({Key? key,this.size,this.text,this.fontWeight,this.textcolor,this.bgcolor,this.border,this.borderradius,this.height,this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgcolor,
        border: border,
        borderRadius: borderradius,
        
      ),
      child: Text('$text',style: TextStyle(color: textcolor,fontSize: size,fontWeight: fontWeight),),
    );
  }
}