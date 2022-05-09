import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:xtreme_fleet/dashboard/emp_exp_report.dart';
import 'package:xtreme_fleet/dashboard/employee_expense.dart';
import 'package:xtreme_fleet/dashboard/veh_exp_report.dart';
import 'package:xtreme_fleet/dashboard/vehicle_expense.dart';
import 'package:xtreme_fleet/dashboard/vehicle_supplier.dart';
import 'package:xtreme_fleet/utilities/my_assets.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
import 'package:xtreme_fleet/utilities/my_navigation.dart';

class MenuScreen extends StatefulWidget {
  MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String? dropDownValue;
  List<String> account = [
    'Vehicle Expense',
    'Employee Expense',
  ];

  // List<Map<String, dynamic>> menue = [
  //   {'title': 'Dashboard', 'icon': Icons.timer},
  //   {'title': 'Company Document', 'icon': Icons.document_scanner_outlined},
  //   {'title': 'Employee', 'icon': Icons.person_add_alt_1_outlined},
  //   {'title': 'Customer', 'icon': Icons.person},
  //   {'title': 'Vehicle Supplier', 'icon': Icons.person_add},
  //   {'title': 'Vehicle', 'icon': Icons.car_rental_outlined},
  //   {'title': 'Project', 'icon': Icons.production_quantity_limits},
  // ];
  @override
  Widget build(BuildContext context) {
    return Drawer(
        //backgroundColor: Colors.black,
        child: Container(
      // margin: EdgeInsets.only(left: 15),
      //,
      child: Column(
        children: [
          Container(
            height: 80,
            color: MyColors.yellow,
            // margin: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, top: 10),
                  height: 40,
                  child: Image.asset(MyAssets.whitelogo),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 40,
                    margin: EdgeInsets.only(right: 15, top: 10),
                    alignment: Alignment.topRight,
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              MyNavigation().push(context, VehicleSupplier());
            },
            child: Container(
              child: menuCont(Icons.person_add, 'Vehicle Supplier',
                  EdgeInsets.only(left: 10, top: 20), FontWeight.bold,16),
            ),
          ),
          //////
          ExpansionTile(
          
             iconColor: MyColors.black,
             collapsedIconColor: MyColors.black,
              expandedAlignment: Alignment.center,
              leading: Icon(
                FontAwesomeIcons.fileCode,
                color: Colors.black,
                size: 20,
              ),
              title: Align(
                  alignment: const Alignment(-1.3, 0),
                  child: Text('Account',
                      style: TextStyle(
                          fontSize: 16,
                          color: MyColors.black,
                          fontWeight: FontWeight.bold))),
              children: [
                InkWell(
                  onTap: () {
                    MyNavigation().push(context, VehicleExpense());
                  },
                  child: Container(
                    child: menuCont(FontAwesomeIcons.car, 'Vehicle Expense',
                        EdgeInsets.only(left: 50, top: 10), FontWeight.w400,14),
                  ),
                ),
                InkWell(
                  onTap: () {
                    MyNavigation().push(context, EmployeeExpense());
                  },
                  child: Container(
                    child: menuCont(Icons.person, 'Employee Expense',
                        EdgeInsets.only(left: 50, top: 10), FontWeight.w400,14),
                  ),
                ),
                InkWell(
                  onTap: () {
                    MyNavigation().push(context, VehicleExpenseReport());
                  },
                  child: Container(
                    child: menuCont(
                        FontAwesomeIcons.list,
                        'Vehicle Expense Report',
                        EdgeInsets.only(left: 50, top: 10),
                        FontWeight.w400,14),
                  ),
                ),
                InkWell(
                  onTap: () {
                    MyNavigation().push(context, EmployeeExpenseReport());
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 30),
                    child: menuCont(
                        FontAwesomeIcons.list,
                        'Employee Expense Report',
                        EdgeInsets.only(left: 50, top: 10),
                        FontWeight.w400,14),
                  ),
                ),
              ]),
        ],
      ),
    ));
  }

  menuCont(
      IconData, String text, EdgeInsetsGeometry margen, FontWeight fontWeight,double size) {
    return Container(
      margin: margen,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 17),
            child: Icon(IconData, size: 20, color: MyColors.black),
          ),
          Expanded(
            child: Container(
              child: Text(
                text,
                style: TextStyle(
                    fontSize: size,
                    fontWeight: fontWeight,
                    color: MyColors.black),
              ),
            ),
          )
        ],
      ),
    );
  }
}
