import 'package:flutter/material.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';

class FileAttachment extends StatefulWidget {
  String? image;
  FileAttachment({Key? key, this.image}) : super(key: key);

  @override
  State<FileAttachment> createState() => _FileAttachmentState();
}

class _FileAttachmentState extends State<FileAttachment> {
  var url = '';
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.yellow,
      ),
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          children: [
            Center(
              child: Container(
                height: height - 200,
                width: width - 100,
                margin: EdgeInsets.symmetric(vertical: 100),
                child: Image.network(
                  'https://fleet.xtremessoft.com/UploadFile/' + '${widget.image}',
                  fit: BoxFit.contain,
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
