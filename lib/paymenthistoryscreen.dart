import 'dart:async';
import 'dart:convert';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:goldenbread/order.dart';
import 'package:goldenbread/orderdetailscreen.dart';
import 'package:http/http.dart' as http;
import 'user.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'dart:io';
import 'package:carousel_pro/carousel_pro.dart';

class PaymentHistoryScreen extends StatefulWidget {
  final User user;

  const PaymentHistoryScreen({Key key, this.user}) : super(key: key);

  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  List _paymentdata;
  TextEditingController _paymentController = new TextEditingController();
  String titlecenter = "Loading payment history...";
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  var parsedDate;
  double screenHeight, screenWidth;
  @override
  void initState() {
    super.initState();
    _loadPaymentHistory();
  }

  @override
  Widget build(BuildContext context) {
    Widget image_carousel = new Container(
      height: 200,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('assets/images/b1.jpg'),
          AssetImage('assets/images/b2.jpg'),
          AssetImage('assets/images/b3.jpg'),
          AssetImage('assets/images/b4.jpg'),
          AssetImage('assets/images/b5.jpg'),
        ],
        autoplay: true,
      ),
    );
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Payment History'),
      ),
      body: Center(
        child: Column(children: <Widget>[
          image_carousel,
          Card(
            color: Colors.white,
            elevation: 5,
            child: Container(
              height: screenHeight / 12,
              margin: EdgeInsets.fromLTRB(20, 2, 20, 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Flexible(
                      child: Container(
                    height: 30,
                    child: TextField(
                        autofocus: false,
                        controller: _paymentController,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.search,
                              color: Colors.red[400],
                            ),
                            border: OutlineInputBorder())),
                  )),
                  Flexible(
                      child: MaterialButton(
                          color: Colors.white,
                          onPressed: () => {
                                _sortPaymentHistoryByDate(
                                    _paymentController.text)
                              },
                          elevation: 5,
                          child: Text(
                            "Search Payment",
                            style: TextStyle(color: Colors.black),
                          ))),
                ],
              ),
            ),
          ),
          Text(
            "Payment History",
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          _paymentdata == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(
                  titlecenter,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ))))
              : Expanded(
                  child: ListView.builder(

                      //Step 6: Count the data
                      itemCount: _paymentdata == null ? 0 : _paymentdata.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                          child: InkWell(
                            onTap: () => loadOrderDetails(index),
                            child: Card(
                              color: Colors.white,
                              elevation: 10,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        (index + 1).toString(),
                                        style: TextStyle(color: Colors.black),
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        "RM " + _paymentdata[index]['total'],
                                        style: TextStyle(color: Colors.black),
                                      )),
                                  Expanded(
                                      flex: 4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            _paymentdata[index]['orderid'],
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          Text(
                                            _paymentdata[index]['billid'],
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      )),
                                  Expanded(
                                    child: Text(
                                      f.format(DateTime.parse(
                                          _paymentdata[index]['date'])),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    flex: 3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      })),
        ]),
      ),
    );
  }

  Future<void> _loadPaymentHistory() async {
    String urlLoadJobs =
        "https://seriouslaa.com/goldenbread/php/load_paymenthistory.php";
    await http
        .post(urlLoadJobs, body: {"email": widget.user.email}).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          _paymentdata = null;
          titlecenter = "No Previous Payment";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          _paymentdata = extractdata["payment"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  loadOrderDetails(int index) {
    Order order = new Order(
        billid: _paymentdata[index]['billid'],
        orderid: _paymentdata[index]['orderid'],
        total: _paymentdata[index]['total'],
        dateorder: _paymentdata[index]['date']);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => OrderDetailScreen(
                  order: order,
                )));
  }

  void _sortPaymentHistoryByDate(String date) {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs =
          "https://seriouslaa.com/goldenbread/php/load_paymenthistory.php";
      http
          .post(urlLoadJobs, body: {
            "date": date.toString(),
          })
          .timeout(const Duration(seconds: 4))
          .then((res) {
            if (res.body == "nodata") {
              Toast.show("Payment not found", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              pr.dismiss();
              FocusScope.of(context).requestFocus(new FocusNode());
              return;
            }
            setState(() {
              var extractdata = json.decode(res.body);
              _paymentdata = extractdata["payment"];
              FocusScope.of(context).requestFocus(new FocusNode());

              pr.dismiss();
            });
          })
          .catchError((err) {
            pr.dismiss();
          });
      pr.dismiss();
    } on TimeoutException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } on SocketException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }
}
