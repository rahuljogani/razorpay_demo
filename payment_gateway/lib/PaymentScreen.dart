import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen>
{
  var _formkey = GlobalKey<FormState>();

  TextEditingController _amount = TextEditingController();

  var price;

  Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }


  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    var id = response.paymentId;
    print(id);
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, toastLength: Toast.LENGTH_SHORT);
  }




  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Payment Screen"),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(18.0),
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
            width: MediaQuery.of(context).size.width,
            height: 250,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(color: Colors.blueGrey,offset: Offset(2.0,2.0)),
              ]
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () async {
                          setState(() {
                            price =15;
                          });
                          _amount.text = price.toString();
                        },
                        child: Container(
                          height: 50,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.purpleAccent,
                          ),
                          child: Center(
                            child: Text("Diamond",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _amount,
                            keyboardType: TextInputType.phone,
                            autofocus: true,
                            decoration: InputDecoration(
                              fillColor: Colors.black12,
                              filled: true,
                              isDense: true,
                              labelText: "Enter Amount",
                              labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.w400),
                              hintText: "Enter Payment Amount",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value){
                              if(value.isEmpty)
                                {
                                  return "Please Enter Amount";
                                }
                              return null;
                            }
                          ),

                          InkWell(
                            onTap: () async {
                              var amount = _amount.text.toString();
                              var options = {
                                'key': 'rzp_test_On36mOrt3zdasY',
                                'amount': amount,
                                'name': 'Acme Corp.',
                                'description': 'Gold Biscuits',
                                'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
                                'external': {
                                  'wallets': ['paytm']
                                }
                              };

                              try {
                                _razorpay.open(options);
                              } catch (e) {
                                debugPrint('Error: e');
                              }

                              print("Amount :"+amount);

                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 15.0),
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: Center(
                               child: Text("Pay Amount",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 18.0),)
                              ),
                              decoration: BoxDecoration(
                                color: Colors.indigo.shade400,
                                borderRadius: BorderRadius.circular(20.0)
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}