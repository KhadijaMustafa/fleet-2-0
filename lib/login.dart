import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';
import 'package:xtreme_fleet/dashboard/dashboard.dart';
import 'package:xtreme_fleet/resources/app_data.dart';
import 'package:xtreme_fleet/signup.dart';

import 'package:xtreme_fleet/utilities/my_assets.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
import 'package:http/http.dart' as http;
import 'package:xtreme_fleet/utilities/my_navigation.dart';

class Login extends StatefulWidget {
  Login({
    Key? key,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loading = true;
  bool _rememberMe = false;
  bool get rememberMe => _rememberMe;
  checkbox(bool value) {
    print(value);
    _rememberMe = value;
    setState(() {});
  }

  bool _show = true;
  bool get show => _show;
  passShow() {
    _show = !_show;
    print(_show);
    setState(() {});
  }

  bool log = false;
  bool pass = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final OneContext _context = OneContext.instance;

  loginApi() async {
    try {
      if (emailController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: MyColors.bgred,
          content: Text(
            'Username required',
          ),
          duration: Duration(seconds: 1),
        ));
      } else if (passController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: MyColors.bgred,
          content: Text(' Password required'),
          duration: Duration(seconds: 1),
        ));
      }
      // else if (emailController.text.isEmpty ||
      //     passController.text.isEmpty ) {
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //       backgroundColor: MyColors.bgred,
      //       content: Text('Username or Password')));
      // }
      else if (emailController.text != 'user' ||
          passController.text != 'user') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: MyColors.bgred,
          content: Text('Invalid username or password'),
          duration: Duration(milliseconds: 500),
        ));
      } else if (emailController.text == 'user' &&
          passController.text == 'user') {
        _context.showProgressIndicator(
            circularProgressIndicatorColor: Color.fromARGB(255, 98, 61, 12));
        Map body = {
          'type': 'UserManagement_ValidateCredenial',
          'value': {
            'Email': emailController.text.trim(),
            'Password': passController.text.trim(),
            'Language': 'en-US',
          }
        };
        print(body);
        var response = await http.post(
            Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process/'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(body));
        _context.hideProgressIndicator();

        print(response.statusCode);
        print(response.body);
        var decode = json.decode(response.body);
        print(decode);
        if (response.statusCode == 200) {
          if (decode['Value'] == null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: MyColors.bgred,
                content: Text('Invalid Credentails.')));
            return null;
          }

          print(decode);
          print(decode['Value']);
          print('<<<<<<<<<>>>>>>>>>>>>>>>>>');

          var dodecode = json.decode(decode['Value'])["username"];
          print(dodecode);

          print('<<<<<<<<<>>>>>>>>>>>>>>>>>');

          return json.decode(decode['Value']);
        }
        //  else {
        //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //       backgroundColor: MyColors.bgred,
        //       content: Text('Invalid username or password')));
        // }
      }
    } catch (e) {
      _context.hideProgressIndicator();

      print(e);
      print('ssssssssssssssssss');
      return null;
    }
  }

  userLogin() async {
    FocusManager.instance.primaryFocus?.unfocus();
    print('false??????????????');
    var response = await loginApi();
    print(response);
    if (response == null) {
      return Text('Invalid Login');
    } else {
      AppData.instance.setUserData(response);
      print('cccccccccccccccccccc');
      MyNavigation().push(context, Dashboard());
    }
  }

  @override
  Widget build(BuildContext context) {
    //AuthProvider _authpro = Provider.of(context, listen: false);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: width,
          height: height,
          padding: EdgeInsets.symmetric(
            horizontal: 30,
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(MyAssets.bgImage), fit: BoxFit.fill),
          ),
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.only(top: 50),
                  height: 50,
                  child: Image.asset(MyAssets.whitelogo)),
              Container(
                margin: EdgeInsets.only(top: 130),
                child: Column(
                  children: [
                    textFieldCont('Username', 'Username', Icons.person, false,
                        emailController),
                    textFieldCont(
                      'Password',
                      'Password',
                      show ? Icons.visibility : Icons.visibility_off,
                      show,
                      passController,
                      onPassShowHide: () => passShow(), //.trim()
                    ),
                  ],
                ),
              ),
              // Container(
              //   margin: EdgeInsets.symmetric(vertical: 8),
              //   child: Row(
              //     children: [
              //       checkboxCont(rememberMe, onTab: (value) => checkbox(value)),
              //       Container(
              //         child: Text(
              //           'Remember me',
              //           style: TextStyle(color: MyColors.yellow),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              InkWell(
                onTap: () => userLogin(),
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 30),
                  height: 40,
                  width: width,
                  decoration: BoxDecoration(color: MyColors.yellow),
                  child: Text(
                    'Log In',
                    style: TextStyle(
                        color: MyColors.red,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              // textCont('Forgot Password ?'),
              // Container(
              //     child: Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     textCont('Do not have account? '),
              //     textCont('SignUp'),
              //   ],
              // )),
            ],
          ),
        ),
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
          decoration: BoxDecoration(
              border: Border.all(
                  color: ischecked ? MyColors.red : MyColors.yellow)),
          height: 20,
          width: 20,
        ),
        Container(
          height: 25,
          width: 25,
        ),
        if (ischecked)
          Icon(
            Icons.check,
            color: MyColors.red,
          )
      ]),

      //  Container(
      //   margin: EdgeInsets.only(right: 10),
      //   alignment: Alignment.center,
      //   decoration: BoxDecoration(
      //       border: Border.all(
      //           color: ischecked ? MyColors.red : MyColors.yellow)),
      //   height: 20,
      //   width: 20,
      //   child: Stack(alignment: Alignment.center, children: [
      //     Container(
      //       height: 10,
      //     ),
      //     if (ischecked)
      //       Icon(
      //         Icons.check,
      //         color: MyColors.red,
      //       )
      //   ]),
      // ),
    );
  }

  textCont(String text) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 10),
      child: Text(text),
    );
  }

  textFieldCont(
    String label,
    String hint,
    IconData icon,
    bool secure,
    TextEditingController controller, {
    Function? onPassShowHide,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      height: 60,
      decoration: BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              label,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 35,
            child: TextFormField(
              controller: controller,
              cursorColor: Colors.black,
              obscureText: secure,
              decoration: InputDecoration(
                focusColor: MyColors.yellow,
                hintText: hint,
                hintStyle: TextStyle(color: MyColors.yellow, fontSize: 12),
                suffixIcon: GestureDetector(
                  onTap: () => onPassShowHide!(),
                  child: Icon(
                    icon,
                    color: MyColors.yellow,
                    size: 18,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: MyColors.yellow,
                )),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: MyColors.yellow,
                )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
