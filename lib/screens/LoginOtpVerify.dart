import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:Sweeper/ProviderClass/UserAuthProvider.dart';
import 'package:Sweeper/util/Common.dart';
import 'package:Sweeper/util/ConstantsText.dart';
import 'package:Sweeper/widgets/commonButton.dart';
import 'package:provider/provider.dart';

class LoginOtpVerify extends StatefulWidget {
  int? popupStatus = 0;
  String? email;
  LoginOtpVerify({this.email, this.popupStatus});

  @override
  _LoginOtpVerifyState createState() => _LoginOtpVerifyState();
}

class _LoginOtpVerifyState extends State<LoginOtpVerify> {
  bool rememberMeActive= false;
  var otpTextCtrl = TextEditingController();
  bool doNotAsk = true;
  Timer? timer;
  int _start = 29;
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          if(mounted)
          {
            setState(() {
              timer.cancel();
            });
          }
        } else {
          if(mounted)
          {
            setState(() {
              _start--;
            });
          }
        }
      },
    );
  }

  @override
  void initState() {
    if(widget.popupStatus == 1){
      SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
        _reSendCodePopUp(context, 'Send OTP', 'Otp send to '+ widget.email.toString(), 'Close');
      });
    }
    startTimer();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 130,),
              Text('2 Step Verification',style: TextStyle(fontSize: 32),),
              SizedBox(height: 18,),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(ConstantsText.verificationCode + widget.email.toString(),
                    textAlign: TextAlign.center,style: TextStyle(
                        color: Colors.grey
                    ),)),
              SizedBox(height: MediaQuery.of(context).size.height*.2,),
              _otpTextField(),
              Common.sizeBoxHeight(20),
              _doNotAskAgain(),
              SizedBox(height: MediaQuery.of(context).size.height*.2,),
              RichText(
                  text: TextSpan(
                      style: TextStyle( color: Colors.grey,fontWeight: FontWeight.w500),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Don\'t receive a email? ',
                        ),
                        _start==0 ?   TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              otpTextCtrl.clear();
                              if(mounted)
                              {
                                setState(() {
                                  _start = 29;
                                  startTimer();
                                });
                              }
                              _reSendCodePopUp(context, 'Resend OTP', 'Otp send to '+ widget.email.toString(), 'Close');
                            },
                          style: TextStyle(fontSize: 16,color: Colors.blue, fontWeight: FontWeight.w400),
                          text: 'Resend Code',
                        ) :  TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {},
                          style: TextStyle(color: Colors.blueGrey),
                          text: 'Resend Code',
                        ),
                        _start==0 ? TextSpan(text:'') : TextSpan(text: ' in ''$_start sec'),
                      ])),
              SizedBox(height: 24,),
              CommonButton(title: 'Continue', onTap: (){
                Common.removeFocus(context);
                if(otpTextCtrl.text.isEmpty){
                  Common.showSnackBar(
                      ConstantsText.enterOtp, context, Colors.red);
                }else if(rememberMeActive == false){
                  Provider.of<UserAuthProvider>(context, listen: false)
                      .loginOtpVerify(otpTextCtrl.text, context, "false" );
                }else{
                  Provider.of<UserAuthProvider>(context, listen: false)
                      .loginOtpVerify(otpTextCtrl.text, context, "true");
                }
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => ChangePassword()));
              }),
            ],
          ),
        ),
      ),
    );
  }
  // Otp Text Field
  _otpTextField(){
    return TextFormField(
      maxLength: 6,
      keyboardType: TextInputType.number,
      controller: otpTextCtrl,
      decoration: InputDecoration(
        counterText: '',
        border: OutlineInputBorder(),
        hintText: "Otp",
      ),
    );
  }

  _doNotAskAgain(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        rememberMeActive? GestureDetector(
            onTap: (){
              rememberMeActive=!rememberMeActive;
              setState(() {
              });
            },
            child: Icon(Icons.radio_button_checked,color: Colors.blue,)) :
        GestureDetector(
            onTap: (){
              rememberMeActive=!rememberMeActive;
              setState(() {
              });
            },
            child: Icon(Icons.radio_button_off,color: Colors.blue,)) ,
        Common.sizeBoxWidth(5),
        Text(
          ConstantsText.doNotAskAgain,
          style: TextStyle(fontSize: 17 ,color: Colors.grey),
        ),
      ],
    );
  }

  _reSendCodePopUp(BuildContext context, String title , String dis , String action ) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              contentPadding: EdgeInsets.only(top: 10.0),
              content: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                height: 170,
                child: Column(children: [
                  SizedBox(height: 15,),
                  Text(title, style: TextStyle(color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),),
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text(dis, style: TextStyle(color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,),
                  ),
                  SizedBox(height: 20,),
                  Divider(),

                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Provider.of<UserAuthProvider>(context,listen: false)
                            .resendOtp(widget.email.toString(), context);
                      },
                      child: Text(action, style: TextStyle(color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),)),
                ],),
              )
          );
        });
  }



}
