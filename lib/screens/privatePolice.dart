import 'package:Sweeper/ProviderClass/UserAuthProvider.dart';
import 'package:Sweeper/util/Common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class PrivatePolicy extends StatefulWidget {
  const PrivatePolicy({Key? key}) : super(key: key);

  @override
  _PrivatePolicyState createState() => _PrivatePolicyState();
}

class _PrivatePolicyState extends State<PrivatePolicy> {

  @override
  void initState() {
    Provider.of<UserAuthProvider>(context, listen: false).privacyPolicy(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserAuthProvider>(
      builder: (context, modal, child){
        return modal.privacyLoading
            ? modal.privacyPolicyData.data !=null
            ?  Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                color: Colors.black,
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              title: Text(modal.privacyPolicyData.data!.title !=null
                  ? modal.privacyPolicyData.data!.title.toString()
                  : "",style: TextStyle(color: Colors.black),),
              backgroundColor: Colors.white,
            ),
            backgroundColor: Colors.white,
            body: Container(
              padding: EdgeInsets.only(top: 16,left: 16,right: 16),
              height: Common.displayHeight(context),
              width: Common.displayWidth(context),
              child: Text(modal.privacyPolicyData.data!.description !=null
                  ? modal.privacyPolicyData.data!.description!.replaceFirst("<p>", "").replaceAll("</p>", "").toString()
                  : "Privacy Policy"),
            ))
            : SizedBox()
            : Common.loadingIndicator(Colors.blue);
      },
    );
  }
}

