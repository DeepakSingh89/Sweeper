import 'package:flutter/material.dart';
import 'package:Sweeper/ProviderClass/UserAuthProvider.dart';
import 'package:Sweeper/screens/ForgotChangePass.dart';
import 'package:Sweeper/util/Common.dart';
import 'package:Sweeper/util/ConstantsText.dart';
import 'package:Sweeper/util/validation.dart';
import 'package:Sweeper/widgets/commonButton.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {


  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  var emailTextCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Forgot Password',style: TextStyle(fontSize: 32),),
              SizedBox(height: 20,),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 80),
                  child: Text('Enter email associated with your account',
                    textAlign: TextAlign.center,style: TextStyle(
                        color: Colors.grey
                    ),)),
              SizedBox(height: MediaQuery.of(context).size.height*.25,),
              _emailTextField(),
              SizedBox(height: MediaQuery.of(context).size.height*.25,),
              CommonButton(title: 'Send OTP', onTap: (){
                Common.removeFocus(context);
                if(emailTextCtrl.text.isEmpty){
                  Common.showSnackBar(ConstantsText.enterEmail, context, Colors.red);
                }else if (!Validator.isValidEmail(emailTextCtrl.text.trim())) {
                  Common.showSnackBar(
                      ConstantsText.enterValidEmail, context, Colors.red);
                }else{
                  Provider.of<UserAuthProvider>(context, listen: false)
                      .forgotSendCode(emailTextCtrl.text, context);
                }
              }),

            ],
          ),
        ),
      ),
    );
  }

  // Email Text Field
  _emailTextField(){
    return TextFormField(
      maxLength: 30,
      keyboardType: TextInputType.emailAddress,
      controller: emailTextCtrl,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        counterText: '',
        hintText: "Email",
      ),
    );
  }

}
