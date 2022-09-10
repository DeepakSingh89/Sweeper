import 'package:Sweeper/ProviderClass/AdsProvider.dart';
import 'package:Sweeper/util/Common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final globalScaffoldKey = GlobalKey<ScaffoldState>();

class AdsScreen extends StatefulWidget {
  const AdsScreen({Key? key}) : super(key: key);

  @override
  _AdsScreenState createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalScaffoldKey,
      body: Consumer<AdsProvider>(
          builder: (context, modal, child){
            return modal.loading
                ? modal.adsData.data !=null
                ? Container(
              height: MediaQuery.of(context).size.height * 1,
              width: MediaQuery.of(context).size.width * 1,
              decoration: BoxDecoration(
                  image: modal.adsData.data!.bannerImage !=null
                      ? DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(modal.adsData.data!.bannerImage.toString())
                  )
                      : DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("assets/images/profile.png")
                  )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  modal.start == 0
                      ? Padding(
                    padding: const EdgeInsets.only(top: 10, right: 10),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          onPressed: (){
                            // modal.reset(context);
                            // modal.startTimer(context);
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.close, color: Colors.white,)),
                    ),
                  )
                      : SizedBox(),
                  Text(modal.adsData.data!.title !=null
                      ? modal.adsData.data!.title.toString()
                      : "",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: Colors.white
                    ),),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100)
                      ),
                      alignment: Alignment.center,
                      width: 80,
                      height: 80,
                      child: Text(modal.start == 0 ? "" : modal.start.toString(),
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            color: Colors.white
                        ),),
                    ),
                  ),
                ],
              ),
            )
                : Center(
              child: Text("No Ad."),
            )
                : Common.loadingIndicator(Colors.blue);
          }
      ),
    );
  }
}
