import 'package:Sweeper/ProviderClass/UserAuthProvider.dart';
import 'package:Sweeper/util/Common.dart';
import 'package:Sweeper/util/ConstantsText.dart';
import 'package:Sweeper/util/validation.dart';
import 'package:flutter/material.dart';
import 'package:Sweeper/widgets/commonButton.dart';
import 'package:provider/provider.dart';

class ForgotChangePass extends StatefulWidget {
  const ForgotChangePass({Key? key}) : super(key: key);

  @override
  _ForgotChangePassState createState() => _ForgotChangePassState();
}

class _ForgotChangePassState extends State<ForgotChangePass> {
  var oldPasswordTextCtrl = TextEditingController();
  var newPasswordTextCtrl = TextEditingController();
  var reEnterNewPasswordTextCtrl = TextEditingController();
  bool _obscureText1 = true;
  bool _obscureText2 = true;
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
        color: Colors.white,
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Forgot Password',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .15,
              ),
              _oldPasswordTextField(),
              SizedBox(
                height: 28,
              ),
              _newPasswordTextField(),
              SizedBox(
                height: 28,
              ),
              _reEnterNewTextField(),
              SizedBox(
                height: MediaQuery.of(context).size.height * .20,
              ),
              CommonButton(
                  title: 'Submit',
                  onTap: () {
                    if (oldPasswordTextCtrl.text.trim().isEmpty) {
                      Common.showSnackBar(
                          "Please Enter Otp.".toString(), context, Colors.red);
                    }
                    if (newPasswordTextCtrl.text.isEmpty) {
                      Common.showSnackBar(
                          "Please Enter New Password.", context, Colors.red);
                    } else if (newPasswordTextCtrl.text.length < 8) {
                      Common.showSnackBar(
                          ConstantsText.passMinLength, context, Colors.red);
                    } else if (!Validator.isValidPassword(
                        newPasswordTextCtrl.text.trim())) {
                      Common.showSnackBar(
                          ConstantsText.passwordLength, context, Colors.red);
                    } else if (reEnterNewPasswordTextCtrl.text.isEmpty) {
                      Common.showSnackBar(
                          "Please Re-Enter Password", context, Colors.red);
                    } else if (reEnterNewPasswordTextCtrl.text.length < 8) {
                      Common.showSnackBar(
                          ConstantsText.passMinLength, context, Colors.red);
                    } else if (!Validator.isValidPassword(
                        reEnterNewPasswordTextCtrl.text.trim())) {
                      Common.showSnackBar(
                          ConstantsText.passwordLength, context, Colors.red);
                    } else {
                      Provider.of<UserAuthProvider>(context, listen: false)
                          .forgotToPass(
                              oldPasswordTextCtrl.text,
                              newPasswordTextCtrl.text,
                              reEnterNewPasswordTextCtrl.text,
                              context);
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  // Old Password Text Field
  _oldPasswordTextField() {
    return TextFormField(
      maxLength: 6,
      keyboardType: TextInputType.number,
      controller: oldPasswordTextCtrl,
      decoration: InputDecoration(
        counterText: '',
        border: OutlineInputBorder(),
        hintText: "Enter Code",
      ),
    );
  }

  // Enter New Password Text Field
  _newPasswordTextField() {
    return TextFormField(
      obscureText: _obscureText1,
      maxLength: 15,
      keyboardType: TextInputType.visiblePassword,
      controller: newPasswordTextCtrl,
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
        hintText: "New Password",
      ),
    );
  }

  // Re-Enter New Password Text Field
  _reEnterNewTextField() {
    return TextFormField(
      obscureText: _obscureText2,
      maxLength: 15,
      keyboardType: TextInputType.visiblePassword,
      controller: reEnterNewPasswordTextCtrl,
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
        hintText: "Re-enter New Password",
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

}
