import 'package:Sweeper/ProviderClass/GetLocation.dart';
import 'package:flutter/material.dart';
import 'package:Sweeper/ProviderClass/UserAuthProvider.dart';
import 'package:Sweeper/screens/auth/signUp.dart';
import 'package:Sweeper/screens/forgotPassword.dart';
import 'package:Sweeper/util/Common.dart';
import 'package:Sweeper/util/ConstantsText.dart';
import 'package:Sweeper/util/validation.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:Sweeper/widgets/commonButton.dart';
import 'package:Sweeper/widgets/commonText.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    // TODO: implement initState
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      //checkPermissionGallery(context);
      //checkPermissionCamera(context);
    });
    super.initState();
  }
  var selectedValue = 'animal';
  bool isActive = false;
  bool rememberMeActive = false;

  var emailTextCtrl = TextEditingController();
  var passwordTextCtrl = TextEditingController();
  bool _obscureText = true;
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
              SizedBox(height: 110,),
              Container(
                  height: 130,
                  width: 130,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    //color: Colors.yellow,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Image(image: AssetImage('assets/images/logo.png'),)
              ),
              SizedBox(height: 30,),
              GestureDetector(
                onTap: (){

                },
                child: Text('Login Now',style: TextStyle(
                  fontSize: 28,
                ),),
              ),
              SizedBox(height: 8,),
              Text("Please login to continue using our app.",style: TextStyle(
                  color: Colors.grey
              ),),
              SizedBox(height: 20,),
              customRadioButton(),
              SizedBox(height: 26,),
              _emailTextField(),
              SizedBox(height: 16),
              _passwordTextField(),
              SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                      SizedBox(width: MediaQuery.of(context).size.width*.02,),
                      CommonText(title: 'Remember Me',color: Colors.black,fontSize: 14,),
                      SizedBox(width: MediaQuery.of(context).size.width*.05,),
                    ],
                  ),
                  GestureDetector(
                      onTap: (){
                        Common.removeFocus(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ForgotPassword()));
                      },
                      child: Text('Forgot password?')),
                ],
              ),
              SizedBox(height: 24,),
              CommonButton(title: 'Login',onTap: (){
                Common.removeFocus(context);
                if(emailTextCtrl.text.isEmpty){
                  Common.showSnackBar(ConstantsText.enterEmail, context, Colors.red);
                }else if (!Validator.isValidEmail(emailTextCtrl.text.trim())) {
                  Common.showSnackBar(
                      ConstantsText.enterValidEmail, context, Colors.red);
                }else if(passwordTextCtrl.text.isEmpty){
                  Common.showSnackBar(ConstantsText.enterPass, context, Colors.red);
                } else if (passwordTextCtrl.text.length < 8) {
                  Common.showSnackBar(
                      ConstantsText.passMinLength, context, Colors.red);
                } else if (!Validator.isValidPassword(passwordTextCtrl.text.trim())) {
                  Common.showSnackBar(
                      ConstantsText.passwordLength, context, Colors.red);
                } else{
                  Provider.of<UserAuthProvider>(context, listen: false).
                  login(emailTextCtrl.text, passwordTextCtrl.text, context, isActive == false ? "2" : "3");
                }
              },),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account ? ',
                    style:
                    TextStyle( color: Colors.grey,fontWeight: FontWeight.w500),
                  ),
                  GestureDetector(
                    onTap: (){
                      Common.removeFocus(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignUp()));
                    },
                    child: Text(
                      'Sign Up',
                      style:
                      TextStyle(color: Colors.blue, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }



  _emailTextField(){
    return TextFormField(
      maxLength: 30,
      keyboardType: TextInputType.emailAddress,
      controller: emailTextCtrl,
      decoration: InputDecoration(
        counterText: '',
        border: OutlineInputBorder(),
        hintText: "Email",
      ),
    );
  }

  _passwordTextField(){
    return TextFormField(
      maxLength: 15,
      keyboardType: TextInputType.visiblePassword,
      obscureText: _obscureText,
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

  Widget customRadioButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isActive==true ?   GestureDetector(
          onTap: (){

            isActive=false;
            setState(() {
            });
            print(isActive.toString());
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.radio_button_off,color: Colors.blue,),
              SizedBox(width: MediaQuery.of(context).size.width*.02,),
              CommonText(title: 'Normal User',color: Colors.black,fontSize: 14,),
              SizedBox(width: MediaQuery.of(context).size.width*.05,),
              Icon(Icons.radio_button_checked,color: Colors.blue,),
              SizedBox(width: MediaQuery.of(context).size.width*.02,),
              CommonText(title: 'Driver',color: Colors.black,fontSize: 14,),
            ],
          ),
        ): GestureDetector(
          onTap: (){
            isActive=true;
            setState(() {
            });
            print(isActive.toString());
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.radio_button_checked,color: Colors.blue,),
              SizedBox(width: MediaQuery.of(context).size.width*.02,),
              CommonText(title: 'Normal User',color: Colors.black,fontSize: 14,),

              SizedBox(width: MediaQuery.of(context).size.width*.05,),
              Icon(Icons.radio_button_off,color: Colors.blue,),

              SizedBox(width: MediaQuery.of(context).size.width*.02,),
              CommonText(title: 'Driver',color: Colors.black,fontSize: 14,),

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

  getCurrentLocation()async{
    await Provider.of<GetLocation>(context, listen: false)
        .showlocation(context);
  }


  checkPermissionCamera(BuildContext ctx) async {
    var cameraStatus = await Permission.camera.status;
    print(cameraStatus);

    if (cameraStatus.isGranted) {
    } else if (cameraStatus.isDenied) {
      askDialog(ctx,
          "In upload profile picture, you have to give camera permission to this app!");
    } else if (cameraStatus.isPermanentlyDenied) {
      deniedDialog(ctx, 'You have to enable camera permission to add picture');
    }
  }

  checkPermissionGallery(BuildContext ctx) async {
    var gallStatus = await Permission.storage.status;

    if (gallStatus.isGranted) {}
    else if (gallStatus.isDenied) {
      askGalleryDialog(ctx,
          "In upload profile picture, you have to give storage permission to this app!");
    } else if (gallStatus.isPermanentlyDenied) {
      showGalleryDialog(
          ctx, 'You have to enable storage permission to add picture');
    }
  }

  askDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alert',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold)),
            content: Text(message),
            actions: <Widget>[
              Row(
                children: [
                  Center(
                    child: TextButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.pop(context);
                        req();
                      },
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  void req() async {
    await Permission.camera.request();
  }

  deniedDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alert',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold)),
            content: Text(message),
            actions: <Widget>[
              Center(
                child: TextButton(
                  child: Text('Settings'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    AppSettings.openAppSettings();
                  },
                ),
              )
            ],
          );
        });
  }

  askGalleryDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alert',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold)),
            content: Text(message),
            actions: <Widget>[
              Row(
                children: [
                  Center(
                    child: TextButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.pop(context);
                        gallReq();
                      },
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  void gallReq() async {
    await Permission.storage.request();
  }

  showGalleryDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alert',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold)),
            content: Text(message),
            actions: <Widget>[
              Center(
                child: TextButton(
                  child: Text('Settings'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    AppSettings.openAppSettings();
                  },
                ),
              )
            ],
          );
        });
  }


}


