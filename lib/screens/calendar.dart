import 'package:flutter/material.dart';
import 'package:Sweeper/widgets/commonButton.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'auth/signUp.dart';

class CalendarDatePick extends StatefulWidget {
  const CalendarDatePick({Key? key}) : super(key: key);

  @override
  _CalendorState createState() => _CalendorState();
}

class _CalendorState extends State<CalendarDatePick> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          body: Container(
            margin: EdgeInsets.only(left: 20,right: 20),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height*.2,),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SfDateRangePicker(
                      showNavigationArrow: true,
                      view: DateRangePickerView.month,
                      monthViewSettings: DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*.2,),
                CommonButton(title: 'Login',onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUp()));
                },),
              ],
            ),
          )),
    );
  }
}
