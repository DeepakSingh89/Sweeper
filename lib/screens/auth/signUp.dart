import 'package:flutter/material.dart';
import 'package:Sweeper/ProviderClass/UserAuthProvider.dart';
import 'package:Sweeper/screens/privatePolice.dart';
import 'package:Sweeper/util/Common.dart';
import 'package:Sweeper/util/ConstantsText.dart';
import 'package:Sweeper/util/validation.dart';
import 'package:Sweeper/widgets/commonButton.dart';
import 'package:Sweeper/widgets/commonText.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isActive = false;
  bool rememberMeActive = true;

  String _singleValue = "Normal User";
  bool _obscureText = true;
  var nameTextCtrl = TextEditingController();
  var emailTextCtrl = TextEditingController();
  var passwordTextCtrl = TextEditingController();
  var numberTextCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final devicewidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: devicewidth,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(
                height: 110,
              ),
              Container(
                height: 130,
                width: 160,
                // clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Image(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Sign up',
                style: TextStyle(
                  fontSize: 28,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "Please sign up to enter the app.",
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(
                height: 20,
              ),
              CustomRadioButton(),
              SizedBox(
                height: 26,
              ),
              _nameTextField(),
              SizedBox(height: 16),
              _emailTextField(),
              SizedBox(height: 16),
              _passwordTextField(),
              SizedBox(height: 16),
              _numberTextField(),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      rememberMeActive
                          ? GestureDetector(
                          onTap: () {
                            rememberMeActive = !rememberMeActive;
                            setState(() {});
                          },
                          child: Icon(
                            Icons.radio_button_checked,
                            color: Colors.blue,
                          ))
                          : GestureDetector(
                          onTap: () {
                            rememberMeActive = !rememberMeActive;
                            setState(() {});
                          },
                          child: Icon(
                            Icons.radio_button_off,
                            color: Colors.blue,
                          )),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .02,
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: (){
                              rememberMeActive = !rememberMeActive;
                              setState(() {});
                            },
                            child: CommonText(
                              title: 'I agree with ',
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              Common.removeFocus(context);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => PrivatePolicy()));
                            },
                            child: CommonText(
                              title: 'Privacy Policy.',
                              color: Colors.blue,
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .05,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 24,
              ),
              CommonButton(
                  title: 'Sign Up',
                  onTap: () {
                    Common.removeFocus(context);
                    if (nameTextCtrl.text.isEmpty) {
                      Common.showSnackBar(
                          ConstantsText.enterName, context, Colors.red);
                    } else if (nameTextCtrl.text.length < 3) {
                      Common.showSnackBar(
                          ConstantsText.enterValidName, context, Colors.red);
                    } else if (!Validator.isValidName(
                        nameTextCtrl.text.trim())) {
                      Common.showSnackBar(
                          "Please enter a valid name.", context, Colors.red);
                    } else if (emailTextCtrl.text.isEmpty) {
                      Common.showSnackBar(
                          ConstantsText.enterEmail, context, Colors.red);
                    } else if (!Validator.isValidEmail(
                        emailTextCtrl.text.trim())) {
                      Common.showSnackBar(
                          ConstantsText.enterValidEmail, context, Colors.red);
                    } else if (passwordTextCtrl.text.isEmpty) {
                      Common.showSnackBar(
                          ConstantsText.enterPass, context, Colors.red);
                    } else if (passwordTextCtrl.text.length < 8) {
                      Common.showSnackBar(
                          ConstantsText.passMinLength, context, Colors.red);
                    }  else if (!Validator.isValidPassword(passwordTextCtrl.text.trim())) {
                      Common.showSnackBar(
                          ConstantsText.passwordLength, context, Colors.red);
                    } else if (numberTextCtrl.text.isEmpty) {
                      Common.showSnackBar(
                          ConstantsText.enterNumber, context, Colors.red);
                    } else if (numberTextCtrl.text.length < 10) {
                      Common.showSnackBar(
                          ConstantsText.enterValidNumber, context, Colors.red);
                    } else if (rememberMeActive == false) {
                      Common.showSnackBar(
                          ConstantsText.agreePrivacy, context, Colors.red);
                    } else {
                      Provider.of<UserAuthProvider>(context, listen: false)
                          .register(
                          nameTextCtrl.text,
                          emailTextCtrl.text,
                          passwordTextCtrl.text,
                          numberTextCtrl.text,
                          context,
                          isActive == false ? "2" : "3"
                      );
                    }
                  }),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account ? ',
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w500),
                  ),
                  GestureDetector(
                    onTap: () {
                      Common.removeFocus(context);
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  // Name Text Field
  _nameTextField() {
    return TextFormField(
      maxLength: 15,
      keyboardType: TextInputType.name,
      inputFormatters: [FilteringTextInputFormatter(RegExp(r"[a-zA-Z]+|\s"), allow: true)],
      controller: nameTextCtrl,
      decoration: InputDecoration(
        counterText: '',
        border: OutlineInputBorder(),
        hintText: "Name",
      ),
    );
  }

  // Email Text Field
  _emailTextField() {
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

  // Password Text Field
  _passwordTextField() {
    return TextFormField(
      obscureText: _obscureText,
      maxLength: 15,
      keyboardType: TextInputType.visiblePassword,
      controller: passwordTextCtrl,
      decoration: InputDecoration(
        suffixIcon: _obscureText
            ? GestureDetector(
          onTap: () {
            Common.removeFocus(context);
            _toggle();
          },
          child: Icon(
            Icons.visibility_off,
            color: Colors.grey[500],
          ),
        )
            : GestureDetector(
          onTap: () {
            Common.removeFocus(context);
            _toggle();
          },
          child: Icon(
            Icons.visibility,
            color: Colors.grey[500],
          ),
        ),
        counterText: '',
        border: OutlineInputBorder(),
        hintText: "Password",
      ),
    );
  }

  // Number Text Field
  _numberTextField() {
    return TextFormField(
      maxLength: 12,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      controller: numberTextCtrl,
      decoration: InputDecoration(
        counterText: '',
        border: OutlineInputBorder(),
        hintText: "Mobile Number",
      ),
    );
  }

  Widget CustomRadioButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isActive == true
            ? GestureDetector(
          onTap: () {
            isActive = false;
            setState(() {});
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.radio_button_off,
                color: Colors.blue,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .02,
              ),
              CommonText(
                title: 'Normal User',
                color: Colors.black,
                fontSize: 14,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .05,
              ),
              Icon(
                Icons.radio_button_checked,
                color: Colors.blue,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .02,
              ),
              CommonText(
                title: 'Driver',
                color: Colors.black,
                fontSize: 14,
              ),
            ],
          ),
        )
            : GestureDetector(
          onTap: () {
            isActive = true;
            setState(() {});
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.radio_button_checked,
                color: Colors.blue,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .02,
              ),
              CommonText(
                title: 'Normal User',
                color: Colors.black,
                fontSize: 14,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .05,
              ),
              Icon(
                Icons.radio_button_off,
                color: Colors.blue,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .02,
              ),
              CommonText(
                title: 'Driver',
                color: Colors.black,
                fontSize: 14,
              ),
            ],
          ),
        )
      ],
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

}
