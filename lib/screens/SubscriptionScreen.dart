import 'package:Sweeper/Modal/AllCardListrPoJo.dart';
import 'package:Sweeper/ProviderClass/SubscriptionProvider.dart';
import 'package:Sweeper/util/Common.dart';
import 'package:Sweeper/util/ConstantsText.dart';
import 'package:Sweeper/widgets/cardinputvalidation.dart';
import 'package:Sweeper/widgets/commonButton.dart';
import 'package:Sweeper/widgets/payment_function.dart';
import 'package:Sweeper/widgets/paymentcard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:Sweeper/Modal/SubscriptionPlanPojo.dart';


class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {

  var numberController = new TextEditingController();
  var _paymentCard = PaymentCard();
  var monthController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  var _autoValidate = false;

  @override
  void initState() {
    StripeService.init();
    _paymentCard.type = CardType.Others;
    numberController.addListener(_getCardTypeFrmNumber);
    Provider.of<SubscriptionPlanProvider>(context, listen: false).loading = false;
    Provider.of<SubscriptionPlanProvider>(context, listen: false).allCardLoading = false;
    Provider.of<SubscriptionPlanProvider>(context, listen: false).subscriptionPlan(context);
    Provider.of<SubscriptionPlanProvider>(context, listen: false).allCardList(context);
    super.initState();
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
        centerTitle: true,
        title: Text(
          'Subscription',
          style:
          TextStyle(fontSize: 20, fontWeight: FontWeight.w600,
              color: Colors.black),
        ),
      ),
      bottomSheet: Consumer<SubscriptionPlanProvider>(
        builder: (context, modal, child){
          return Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            height: Common.displayHeight(context) *0.1,
            width: Common.displayWidth(context) * 1,
            child: CommonButton(title: "BUY", onTap: (){
              if(modal.isSelectedValue == 0){
                Common.showSnackBar("You have selected free plan, Please select premium plan.", context, Colors.red);
              }else if(modal.isSelectedCard == -1){
                Common.showSnackBar("Please select card.", context, Colors.red);
              }else{
                Provider.of<SubscriptionPlanProvider>(context, listen: false)
                    .payment(context, modal.cardId.toString(), "1", modal.selectedPlanId.toString());
              }
            }),
          );
        },
      ),
      body: Container(
        color: Colors.white,
        height: Common.displayHeight(context),
        width: Common.displayWidth(context),
        child: Column(
          children: [
            Container(
              color: Colors.white,
              height: Common.displayHeight(context) *0.6,
              width: Common.displayWidth(context) * 1,
              child: Consumer<SubscriptionPlanProvider>(
                  builder: (BuildContext context, modal, Widget? child) {
                    return modal.loading
                        ? modal.subscriptionPlansData.data !=null &&
                        modal.subscriptionPlansData.data!.length > 0
                        ? ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: modal.subscriptionPlansData.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)
                            ),
                            padding: EdgeInsets.all(16),
                            child: _subsCard(
                                modal.subscriptionPlansData.data![index], index),
                          );
                        })
                        : Center(
                      child: new Text(
                        'No Subscription Plans Available',
                        style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                        : Common.loadingIndicator(Colors.blue);
                  }),
            ),
           Common.sizeBoxHeight(10),
            Text("Cards",
                style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold),),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<SubscriptionPlanProvider>(
                    builder: (BuildContext context, modal, Widget? child) {
                      return modal.allCardLoading
                          ? modal.allCardsData.data !=null &&
                          modal.allCardsData.data!.data!.length > 0
                          ? Container(
                        height: Common.displayHeight(context) * 0.15,
                            child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: modal.allCardsData.data!.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                                child: _card(
                                    modal.allCardsData.data!.data![index], index),
                              );
                            }),
                          )
                          : Center(
                            child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'No Card Available',
                                  style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                          : Common.loadingIndicator(Colors.blue);
                    }),
                InkWell(
                  onTap: (){
                    _paymentMethodBottomSheet(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    height: Common.displayHeight(context) *0.07,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.add_circle_outline),
                        Text("Add card", style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold
                        ),)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _subsCard(Datum data, int i) {
    return Consumer<SubscriptionPlanProvider>(
      builder: (context, modal, child){
        return InkWell(
          onTap: () {
            modal.selectPlan(i);
          },
          child: Container(
            decoration: BoxDecoration(
                color: modal.isSelectedValue ==
                    i ? Colors.blue : Colors.white,
                borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: modal.isSelectedValue ==
                    i ? Colors.white : Colors.black,
              )
            ),
            padding: EdgeInsets.only(
                left: 20, top: 10, bottom: 10),
            alignment: Alignment.centerLeft,
            height: MediaQuery.of(context)
                .size
                .height *
                0.18,
            width: MediaQuery.of(context)
                .size
                .width *
                1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star_border,size: 25,color: modal.isSelectedValue == i
                          ? Colors.white : Colors.black,),
                        Common.sizeBoxHeight(5),
                        Text(
                          i == 0 ? "Basic" : 'Premium',
                          style: TextStyle(
                              color: modal.isSelectedValue == i
                                  ? Colors.white : Colors.black,
                            fontWeight:
                            FontWeight.w700,
                            fontSize:
                            MediaQuery.of(context)
                                .size
                                .width *
                                0.042,

                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        modal.selectPlan(i);
                      },
                      icon: modal.isSelectedValue ==
                          i
                          ? Icon(
                          Icons
                              .check_circle,
                          size: 25,
                          color: Colors.white)
                          : Icon(
                          Icons
                              .radio_button_unchecked,
                          size: 25,
                          color: Colors.blue),
                    )
                  ],
                ),
                Text(
                  modal.subscriptionPlansData
                      .data![i].title !=
                      null
                      ? modal
                      .subscriptionPlansData
                      .data![i]
                      .title
                      .toString()
                      : '',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight:
                      FontWeight.w700,
                      fontSize:
                      MediaQuery.of(context)
                          .size
                          .width *
                          0.042,
                  ),
                ),
                Container(
                  width: Common.displayWidth(context) * 0.6,
                  child: Text(
                    modal.subscriptionPlansData
                        .data![i].description !=
                        null
                        ? modal
                        .subscriptionPlansData
                        .data![i]
                        .description
                        .toString()
                        : '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight:
                        FontWeight.w400,
                        fontSize:
                        MediaQuery.of(context)
                            .size
                            .width *
                            0.04),
                  ),
                ),
                Text(
                  modal.subscriptionPlansData
                      .data![i].price !=
                      null
                      ? "\$"+modal
                      .subscriptionPlansData
                      .data![i]
                      .price
                      .toString()
                      : '',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight:
                    FontWeight.w700,
                    fontSize:
                    MediaQuery.of(context)
                        .size
                        .width *
                        0.042,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _card(CardData data, int i) {
    return Consumer<SubscriptionPlanProvider>(
      builder: (context, modal, child){
        return InkWell(
          onTap: () {
            modal.selectCard(i);
          },
          child: Card(
            elevation: 5.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  data.brand != null
                      ? Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        data.brand
                            .toString(),
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                      : Text(''),
                  Center(
                    child: Text(
                        data.last4 != null
                            ? 'XXXX XXXX XXXX ' +
                            data.last4
                                .toString()
                            : ''),
                  ),
                  IconButton(
                    icon: modal.isSelectedCard == i
                        ? Icon(Icons.radio_button_checked,
                        color: Colors.blue)
                        : Icon(Icons.radio_button_unchecked,
                        color: Colors.grey),
                    onPressed: () {
                      modal.selectCard(i);
                    },
                  ),
                ],
              )),
        );
      },
    );
  }

  // Show add cart bottom sheet
  _paymentMethodBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              height: Common.displayHeight(context) * 0.7,
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: Column(
                  children: [
                    Common.sizeBoxHeight(10),
                    _paymentText(),
                    Common.sizeBoxHeight(15),
                    _cardNumber(),
                    _cardCvvAndValidDate(),
                    Common.sizeBoxHeight(20),
                    _payButton(),
                  ],
                ),
              ),
            ),
          );
        });
  }

// Payment Text
  _paymentText() {
    return Text(
      'PAYMENT',
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: Common.displayWidth(context) * 0.05,
        color: Colors.black,
      ),
    );
  }

  // Card
  _cardNumber() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Card Number',
          ),
          Common.sizeBoxHeight(5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.credit_card_outlined,
                size: 40,
                color: Colors.grey[700],
              ),
              Common.sizeBoxHeight(10),
              Flexible(
                flex: 1,
                child: TextFormField(
                  onSaved: (String? value) {
                    _paymentCard.number = CardUtils.getCleanedNumber(value!);
                    setState(() {
                      _paymentCard.number = value;
                    });
                  },
                  onChanged: (String? val) {
                    final val = TextSelection.collapsed(
                        offset: numberController.text.length);
                    numberController.selection = val;
                  },
                  controller: numberController,
                  validator: CardUtils.validateCardNum,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    new LengthLimitingTextInputFormatter(19),
                    new CardNumberInputFormatter(),
                  ],
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.black87),
                  cursorColor: Colors.black,
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 10),
                    counterText: '',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    hintText: 'XXXX XXXX XXXX XXXX',
                    focusedBorder: _inputBorder,
                    enabledBorder: _inputBorder,
                    border: _inputBorder,
                    focusedErrorBorder: _inputBorder,
                    fillColor: Colors.grey[300],
                    errorBorder: _inputBorder,
                    errorStyle: TextStyle(color: Colors.red, fontSize: 14.0),
                    filled: true,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // card cvv or card valid date
  _cardCvvAndValidDate() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CVV',
                style: _cardHeadTextStyle(),
              ),
              Common.sizeBoxHeight(5),
              Container(
                width: Common.displayWidth(context) * 0.43,
                child: TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    new LengthLimitingTextInputFormatter(4),
                  ],
                  // validator: CardUtils.validateCVV,
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    setState(() {
                      _paymentCard.cvv = int.parse(value!);
                    });
                  },
                  style: const TextStyle(color: Colors.black87),
                  cursorColor: Colors.black,
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 10),
                    counterText: '',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    hintText: 'XXX',
                    focusedBorder: _inputBorder,
                    enabledBorder: _inputBorder,
                    border: _inputBorder,
                    focusedErrorBorder: _inputBorder,
                    fillColor: Colors.grey[300],
                    errorBorder: _inputBorder,
                    filled: true,
                    errorStyle: TextStyle(color: Colors.red, fontSize: 14.0),
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Month/Year',
                style: _cardHeadTextStyle(),
              ),
              Common.sizeBoxHeight(5),
              Container(
                width: Common.displayWidth(context) * 0.43,
                child: TextFormField(
                  // validator: CardUtils.validateDate,
                  keyboardType: TextInputType.number,
                  controller: monthController,
                  onSaved: (value) {
                    List<int> expiryDate = CardUtils.getExpiryDate(value!);
                    setState(() {
                      _paymentCard.month = expiryDate[0];
                      _paymentCard.year = expiryDate[1];
                    });
                  },
                  onChanged: (String? val) {
                    final val = TextSelection.collapsed(
                        offset: monthController.text.length);
                    monthController.selection = val;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    new LengthLimitingTextInputFormatter(4),
                    CardMonthInputFormatter()
                  ],
                  style: const TextStyle(color: Colors.black87),
                  cursorColor: Colors.black,
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 10),
                    counterText: '',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    hintText: 'MM/YY',
                    focusedBorder: _inputBorder,
                    enabledBorder: _inputBorder,
                    border: _inputBorder,
                    focusedErrorBorder: _inputBorder,
                    fillColor: Colors.grey[300],
                    errorBorder: _inputBorder,
                    filled: true,
                    errorStyle: TextStyle(color: Colors.red, fontSize: 14.0),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Payment Button
  _payButton() {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      color: Colors.blue,
      onPressed: () {
        validate();
      },
      child: !isLoading
          ? Text(
        'Save',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          // fontFamily: FontFamily.Roboto_Regular,
          fontSize: Common.displayWidth(context) * 0.05,
          color: Colors.white,
        ),
      )
          : Common.loadingIndicator(Colors.white),
      height: Common.displayHeight(context) * 0.07,
      minWidth: Common.displayWidth(context) * 0.4,
    );
  }

  _cardHeadTextStyle() {
    return TextStyle(
      fontSize: Common.displayWidth(context) * 0.040,
      fontWeight: FontWeight.w400,
    );
  }

  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(numberController.text);
    CardType cardType = CardUtils.getCardTypeFrmNumber(input);
    setState(() {
      this._paymentCard.type = cardType;
    });
  }

  void validate() async {
    try {
      final FormState? form = _formKey.currentState;
      if (!form!.validate()) {
        setState(() {
          _autoValidate = true;
        });
      } else {
        form.save();
        Navigator.pop(context);
        Common.showLoading(context);
        var response = await StripeService.payWithNewCard(
          cardNo: _paymentCard.number!.trim(),
          expMonth: _paymentCard.month,
          expYear: _paymentCard.year,
        );
        if (response != null) {
          if (response.success!)
          {
            print('card token:  ${response.tokeId}');
            Provider.of<SubscriptionPlanProvider>(context, listen: false)
              .addCard(context, response.tokeId!);
          } else if(response.success==false)
          {
            Common.hideLoading(context);
            Common.showSnackBar(response.message!, context,
                Colors.red);
          } else {
            Common.hideLoading(context);
            Common.showSnackBar(ConstantsText.somethingWrongError, context,
                Colors.red);
          }
        } else {
          Common.hideLoading(context);
          Common.showSnackBar(ConstantsText.somethingWrongError, context,
              Colors.red);
        }
      }
    } catch (exception) {
      Common.hideLoading(context);
      throw exception;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    numberController.removeListener(_getCardTypeFrmNumber);
    numberController.dispose();
    super.dispose();
  }


// input border style
  OutlineInputBorder _inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0),
    // borderSide: BorderSide(color: Color.grey[200], width: 1.0),
  );

}
