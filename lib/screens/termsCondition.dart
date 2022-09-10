import 'package:Sweeper/ProviderClass/UserAuthProvider.dart';
import 'package:Sweeper/util/Common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TermsCondition extends StatefulWidget {
  const TermsCondition({Key? key}) : super(key: key);

  @override
  _PrivatePolicyState createState() => _PrivatePolicyState();
}

class _PrivatePolicyState extends State<TermsCondition> {

  @override
  void initState() {
    Provider.of<UserAuthProvider>(context, listen: false).termsLoading = false;
    Provider.of<UserAuthProvider>(context, listen: false).termAndCondition(context);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<UserAuthProvider>(
      builder: (context, modal, child){
        return modal.termsLoading
            ? modal.termAndConditionData.data !=null
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
              title: Text(modal.termAndConditionData.data!.title !=null
                  ? modal.termAndConditionData.data!.title.toString()
                  : "",style: TextStyle(color: Colors.black),),
              backgroundColor: Colors.white,
            ),
            backgroundColor: Colors.white,
            body: Container(
              padding: EdgeInsets.only(top: 16,left: 16,right: 16),
              height: Common.displayHeight(context),
              width: Common.displayWidth(context),
              child: Text(modal.termAndConditionData.data!.description !=null
                  ? modal.termAndConditionData.data!.description!.replaceFirst("<p>", "").replaceAll("</p>", "").toString()
                  : ""),
            ))
            : SizedBox()
            : Common.loadingIndicator(Colors.blue);
      },
    );
  }
}
