import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:Sweeper/util/Common.dart';
import 'package:Sweeper/util/ConstantsText.dart';
import 'package:Sweeper/util/CustomProference.dart';
import 'package:Sweeper/util/PreferenceKeys.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:Sweeper/ProviderClass/UserAuthProvider.dart';
import 'package:Sweeper/widgets/commonButton.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';


class Profile extends StatefulWidget {
 String? roleType;
 Profile({this.roleType});

  @override
  _PrState createState() => _PrState();
}

class _PrState extends State<Profile> {

  late File userImageFile;
  var nameTextCtrl = TextEditingController();
  String? _value = "Your City";


  File? uploadImageFile;
  String? sendImage;
  @override
  void initState() {
    _getName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Create Profile', style: TextStyle(color: Colors.black),),
        ),
        body: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: MediaQuery
                    .of(context)
                    .size
                    .height * .050,),
                InkWell(
                  onTap: (){
                    Common.removeFocus(context);
                    captureImageBottomSheet(context);
                  },
                  child: Stack(
                    children: [
                      uploadImageFile != null
                          ? Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.0,
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        height: 150,
                        width: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.file(
                            uploadImageFile!,
                            fit: BoxFit.cover,
                            height: 150,
                            width: 150,
                          ),
                        ),
                      )
                          : Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.0,
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              height: 150,
                              width: 150,
                              child: Stack(
                                children: [
                                  Image.asset("assets/images/profile.png"),
                                  Positioned(
                                    bottom: -5,
                                    right: 0,
                                    child: IconButton(
                                        onPressed: () {
                                          Common.removeFocus(context);
                                          captureImageBottomSheet(context);
                                        },
                                        icon: Icon(Icons.add_circle_outline,
                                            size: 30)),
                                  )
                                  // Align(
                                  //     alignment: Alignment.bottomRight,
                                  //     child: Icon(Icons.add_circle_outline,size: 30)),
                                ],
                              )),
                    ],
                  ),
                ),
                Common.sizeBoxHeight(10),
                InkWell(
                  onTap: (){
                    Common.removeFocus(context);
                    captureImageBottomSheet(context);
                  },
                  child: Text('Upload Profile Pic', style: TextStyle(fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black38),),
                ),
                SizedBox(height: MediaQuery
                    .of(context)
                    .size
                    .height * .1,),
                _nameTextField(),
                SizedBox(height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.05,),
                _cityTextField(),
                SizedBox(height: MediaQuery
                    .of(context)
                    .size
                    .height * .1,),
                CommonButton(title: 'CONTINUE', onTap: () async{
                  if(sendImage == null){
                    Common.showSnackBar("Please upload Profile Picture.", context, Colors.red);
                  }else if(nameTextCtrl.text.isEmpty){
                    Common.showSnackBar(ConstantsText.enterName, context, Colors.red);
                  }else if(nameTextCtrl.text.length < 3){
                    Common.showSnackBar(ConstantsText.enterValidName, context, Colors.red);
                  }else if(_value == "Your City"){
                    Common.showSnackBar("Please select Your City.", context, Colors.red);
                  }else{
                    Provider.of<UserAuthProvider>(context, listen: false).createProfile(
                        context,
                        sendImage.toString(),
                        nameTextCtrl.text,
                        _value.toString(),
                      widget.roleType.toString()
                    );
                  }
                }),
              ],
            ),
          ),
        ));
  }


  // Name Text Field
  _nameTextField() {
    return TextFormField(
      maxLength: 15,
      keyboardType: TextInputType.name,
      controller: nameTextCtrl,
      style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold,
          fontSize: MediaQuery.of(context).size.width *0.04
      ),
      decoration: InputDecoration(
        counterText: '',
        border: OutlineInputBorder(),
        hintStyle: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width *0.04
        ),
        hintText: "Persons Name",
      ),
    );
  }


  _getName() async{
    Provider.of<UserAuthProvider>(context, listen: false).cityList(context);
    String name = await CustomPreferences.getPreferences(PrefKeys.saveName);
    setState(() {
      if(name !="null"){
        nameTextCtrl.text = name;
      }
    });
  }

  // City Text Field
  _cityTextField() {
    return InkWell(
      onTap: (){
        cityBottomSheet(context);
      },
      child: Container(
        width: Common.displayHeight(context) *0.9,
        height: Common.displayHeight(context) *0.07,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10,right: 10),
          child: Container(
            alignment: Alignment.centerLeft,
            width: Common.displayWidth(context) * 0.82,
            child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _value.toString(),
                style: TextStyle(
                    color:
                    _value == 'Your City' ? Colors.grey : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.04),
              ),
              Icon(
                Icons.arrow_drop_down_outlined,
                color: Colors.grey,
              )
            ],
          ),
          ),
        ),
      ),
    );
  }
  //convert url to file
  static Future<File> urlToFile(String imageUrl) async {
// generate random number.
    var rng = new Random();
// get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
    String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
// call http.get method and pass imageUrl into it to get response.
    http.Response response = await http.get(Uri.parse(imageUrl));
// write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
    return file;
  }

  Future<void> captureImageBottomSheet(context) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        Common.removeFocus(context);
                        uploadimgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  Center(
                      child: Container(
                          margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
                          height: 0.5,
                          width: MediaQuery.of(context).size.width * 0.58,
                          color: Colors.black)),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      Common.removeFocus(context);
                      uploadimgFromCamera();
                      //     checkPermissionCamera(context);
                      Navigator.of(context).pop();
                    },
                  ),
                  Center(
                      child: Container(
                          margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
                          height: 0.5,
                          width: MediaQuery.of(context).size.width * 0.58,
                          color: Colors.black)),
                  new ListTile(
                    leading: new Icon(Icons.clear),
                    title: new Text('Cancel'),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> uploadimgFromCamera() async {
    File cameraFile = File(await ImagePicker()
        .pickImage(
      source: ImageSource.camera,
      imageQuality: 40,
    ).then((pickedFile) => pickedFile!.path));
    File rotatedImage =
    await FlutterExifRotation.rotateImage(path: cameraFile.path);
    if (mounted) {
      setState(() {
        uploadImageFile = rotatedImage;
        sendImage = base64Encode(uploadImageFile!.readAsBytesSync());
        print("bas64yUrl:  " + sendImage.toString());
      });
    }
  }

  //****************Open Gallery*************//
  Future<void> uploadimgFromGallery() async {
    File gallFile = File(await ImagePicker()
        .pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
    )
        .then((pickedFile) => pickedFile!.path));
    if (mounted) {
      setState(() {
        uploadImageFile = gallFile;
        sendImage = base64Encode(uploadImageFile!.readAsBytesSync());
        print("bas64yUrl:  " + sendImage.toString());
      });
    }
  }

  checkPermissionCamera(BuildContext ctx) async {
    var cameraStatus = await Permission.camera.status;
    print(cameraStatus);

    if (cameraStatus.isGranted) {
      uploadimgFromCamera();
    } else if (cameraStatus.isDenied) {
      askDialog(ctx,
          "In order to add picture, you have to give camera permission to this app!");
    } else if (cameraStatus.isPermanentlyDenied) {
      deniedDialog(ctx, 'You have to enable camera permission to add picture');
    }
  }

  checkPermissionGallery(BuildContext ctx) async {
    var gallStatus = await Permission.storage.status;

    if (gallStatus.isGranted) {
      uploadimgFromGallery();
    } else if (gallStatus.isDenied) {
      askGalleryDialog(ctx,
          "In order to add picture, you have to give storage permission to this app!");
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

  cityBottomSheet(BuildContext context){
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Consumer<UserAuthProvider>(
            builder: (context,modal,child){
              return Container(
                height: MediaQuery.of(context).size.height * 0.65,
                width: MediaQuery.of(context).size.width* 1,
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text("* Select City *", style: TextStyle(color: Colors.black,
                              fontWeight: FontWeight.w700,
                            fontSize: MediaQuery.of(context).size.width *0.045
                          ),),
                        )),
                    Common.sizeBoxHeight(15),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width* 1,
                      child: modal.cityListLoading && modal.cityListData.data !=null
                          ? ListView.separated(
                          itemBuilder: (context, i){
                            return InkWell(
                              onTap: (){
                               setState(() {
                                 _value = modal.cityListData.data![i].cityName.toString();
                               });
                               Navigator.pop(context);
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                                alignment: Alignment.centerLeft,
                                height: MediaQuery.of(context).size.height * 0.05,
                                width: MediaQuery.of(context).size.width* 1,
                                child: Text(modal.cityListData.data![i].cityName !=null
                                ? modal.cityListData.data![i].cityName.toString()
                                : '', style: TextStyle(color: Colors.black,
                                fontWeight: FontWeight.w500,
                                    fontSize: MediaQuery.of(context).size.width *0.04),),
                              ),
                            );
                          },
                          separatorBuilder: (context, i){
                            return Divider(
                              color: Colors.grey,
                              thickness: 1.0,
                            );
                          },
                          itemCount: modal.cityListData.data!.length)
                      : Common.loadingIndicator(Colors.blue),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

}
