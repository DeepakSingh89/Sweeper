import 'package:Sweeper/ProviderClass/UserAuthProvider.dart';
import 'package:Sweeper/util/Common.dart';
import 'package:Sweeper/util/ConstantsText.dart';
import 'package:Sweeper/util/validation.dart';
import 'package:flutter/material.dart';
import 'package:Sweeper/widgets/commonButton.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  bool _obscureText3 = true;

  var oldPasswordTextCtrl = TextEditingController();
  var newPasswordTextCtrl = TextEditingController();
  var reEnterNewPasswordTextCtrl = TextEditingController();

 late  FocusNode oldPasswordFocus =   FocusNode();
  late  FocusNode newPasswordFocus =   FocusNode();
  late  FocusNode reEnterNewPasswordFocus =   FocusNode();

  @override
  void initState() {
    super.initState();
    // optional add a delay before the focus happens.


  }
  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    oldPasswordFocus.dispose();
    newPasswordFocus.dispose();
    reEnterNewPasswordFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      body: Container(
       // color: Colors.white,
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Change Password',style: TextStyle(fontSize: 26,fontWeight: FontWeight.w600),),
              SizedBox(height: MediaQuery.of(context).size.height*.15,),
             _oldPasswordTextField(),SizedBox(height: 28,),
             _newPasswordTextField(),SizedBox(height: 28,),
             _reEnterNewTextField(),
              SizedBox(height: MediaQuery.of(context).size.height*.20,),
              CommonButton(title: 'Submit', onTap: (){
                Common.removeFocus(context);
                if (oldPasswordTextCtrl.text.isEmpty) {
                Common.showSnackBar(
               "Please Enter Old Password", context, Colors.red);
                } else if (oldPasswordTextCtrl.text.length < 8) {
                Common.showSnackBar(
                ConstantsText.passMinLength, context, Colors.red);
                }  else if (!Validator.isValidPassword(oldPasswordTextCtrl.text.trim())) {
                Common.showSnackBar(
                ConstantsText.passwordLength, context, Colors.red);
                }else if (newPasswordTextCtrl.text.isEmpty) {
                  Common.showSnackBar(
                      "Please Enter New Password.", context, Colors.red);
                } else if (newPasswordTextCtrl.text.length < 8) {
                  Common.showSnackBar(
                      ConstantsText.passMinLength, context, Colors.red);
                }  else if (!Validator.isValidPassword(newPasswordTextCtrl.text.trim())) {
                  Common.showSnackBar(
                      ConstantsText.passwordLength, context, Colors.red);
                }else if (reEnterNewPasswordTextCtrl.text.isEmpty) {
                  Common.showSnackBar(
                      "Please Enter Confirm Password", context, Colors.red);
                } else if (reEnterNewPasswordTextCtrl.text.length < 8) {
                  Common.showSnackBar(
                      ConstantsText.passMinLength, context, Colors.red);
                }  else if (!Validator.isValidPassword(reEnterNewPasswordTextCtrl.text.trim())) {
                  Common.showSnackBar(
                      ConstantsText.passwordLength, context, Colors.red);
                } else{
                  Provider.of<UserAuthProvider>(context, listen: false)
                      .changePassword(oldPasswordTextCtrl.text, newPasswordTextCtrl.text,
                      reEnterNewPasswordTextCtrl.text, context);
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  // Old Password Text Field
  _oldPasswordTextField(){
    return TextFormField(
      obscureText: _obscureText1,
      maxLength: 15,
      keyboardType: TextInputType.visiblePassword,

      controller: oldPasswordTextCtrl,
      decoration: InputDecoration(
        suffixIcon: _obscureText1
            ? GestureDetector(
          onTap: () {
            Common.removeFocus(context);
            _toggle1();
          },
          child: Icon(
            Icons.visibility_off,
            color: Colors.grey[500],
          ),
        )
            : GestureDetector(
          onTap: () {
            Common.removeFocus(context);
            _toggle1();
          },
          child: Icon(
            Icons.visibility,
            color: Colors.grey[500],
          ),
        ),
        counterText: '',
        border: OutlineInputBorder(),
        hintText: "Old Password",
      ),
    );
  }

  // Enter New Password Text Field
  _newPasswordTextField(){
    return TextFormField(
      obscureText: _obscureText2,
      maxLength: 15,
      keyboardType: TextInputType.visiblePassword,

      controller: newPasswordTextCtrl,
      decoration: InputDecoration(
        suffixIcon: _obscureText2
            ? GestureDetector(
          onTap: () {
            Common.removeFocus(context);
            _toggle2();
          },
          child: Icon(
            Icons.visibility_off,
            color: Colors.grey[500],
          ),
        )
            : GestureDetector(
          onTap: () {
            Common.removeFocus(context);
            _toggle2();
          },
          child: Icon(
            Icons.visibility,
            color: Colors.grey[500],
          ),
        ),
        counterText: '',
        border: OutlineInputBorder(),
        hintText: "New Password",
      ),
    );
  }

  // Re-Enter New Password Text Field
  _reEnterNewTextField(){
    return TextFormField(
      obscureText: _obscureText3,
      maxLength: 15,
      keyboardType: TextInputType.visiblePassword,
      controller: reEnterNewPasswordTextCtrl,

      decoration: InputDecoration(
        suffixIcon: _obscureText3
            ? GestureDetector(
          onTap: () {
            Common.removeFocus(context);
            _toggle3();
          },
          child: Icon(
            Icons.visibility_off,
            color: Colors.grey[500],
          ),
        )
            : GestureDetector(
          onTap: () {
            Common.removeFocus(context);
            _toggle3();
          },
          child: Icon(
            Icons.visibility,
            color: Colors.grey[500],
          ),
        ),
        counterText: '',
        border: OutlineInputBorder(),
        hintText: "Confirm Password",
      ),
    );
  }

  void _toggle1() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }
  void _toggle2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }
  void _toggle3() {
    setState(() {
      _obscureText3 = !_obscureText3;
    });
  }


}
