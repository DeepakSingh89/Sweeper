import 'dart:io';
import 'package:Sweeper/util/Common.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:Sweeper/ProviderClass/UserAuthProvider.dart';
import 'package:Sweeper/screens/editProfile.dart';
import 'package:Sweeper/widgets/commonButton.dart';


class GetProfile extends StatefulWidget {
  const GetProfile({Key? key}) : super(key: key);

  @override
  _PrState createState() => _PrState();
}

class _PrState extends State<GetProfile> {

  late File userImageFile;
  @override
  void initState() {
    Provider.of<UserAuthProvider>(context, listen: false).loading = false;
    // Call Get Profile
    Provider.of<UserAuthProvider>(context, listen: false).profile(context, '', '', '','');
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
        title: Text('Profile',style: TextStyle(color: Colors.black),),
      ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Consumer<UserAuthProvider>(
            builder: (context, modal, child){
              return modal.loading
                  ? modal.profileData.userInfo !=null
                  ? Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height*.050 ,),
                  Container(
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
                        child: FadeInImage(
                            fit: BoxFit.cover,
                            placeholder: AssetImage("assets/images/profile.png"),
                            image: NetworkImage(modal.profileData.userInfo!.profilePic.toString())),
                      )),
                   SizedBox(height: MediaQuery.of(context).size.height*.08 ,),
                  Text(modal.profileData.userInfo!.name !=null
                      ? modal.profileData.userInfo!.name.toString()
                    : '',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black),),
                  SizedBox(height: MediaQuery.of(context).size.height*.010 ,),
                  Text(modal.profileData.userInfo!.email !=null
                      ? modal.profileData.userInfo!.email.toString()
                      : '',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black38),),
                  SizedBox(height: MediaQuery.of(context).size.height*.010 ,),
                  Text(modal.profileData.userInfo!.phone !=null
                      ? modal.profileData.userInfo!.phone.toString()
                      : '',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black38),),
                  SizedBox(height: MediaQuery.of(context).size.height*.05 ,),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*.1),
                    child: CommonButton(title: 'Edit Profile ', onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => EditProfile(
                            userData: modal.profileData.userInfo!,
                          )));
                    }),
                  ),
                ],
              )
              : Center(
                child: Text("No Data Found!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),),
              )
              : Common.loadingIndicator(Colors.blue);
            },
          ),
        ));
  }
}
