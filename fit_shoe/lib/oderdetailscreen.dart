import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import 'order.dart';
import 'package:http/http.dart' as http;
 
//void main() => runApp(OrderDetailScreen());
 
class OrderDetailScreen extends StatefulWidget {
  final Order order;
  const OrderDetailScreen({Key key,this.order}):super(key:key);
  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  List _orderdetails;

  String titlecenter = "order details is LOADING";
  double screenHeight,screenWidth;

  @override
  void initState(){
    super.initState();
    _loadOrderDetails();
  }
  @override
  Widget build(BuildContext context) {
    screenHeight=MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.purple[200],
          title: Text('Order Details', style:TextStyle(color:Colors.black),
      ),),
      body: Center(
        child: Column(children: <Widget>[
          Text(
            "Order Details",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          _orderdetails == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(
                  titlecenter,
                  style: TextStyle(
                      color: Colors.blue[300],
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ))))
              : Expanded(
                  child: ListView.builder(
                      //Step 6: Count the data
                      itemCount:
                          _orderdetails == null ? 0 : _orderdetails.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                            child: InkWell(
                                onTap: null,
                                child: Card(
                                  elevation: 10,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            (index + 1).toString(),
                                          )),
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                            _orderdetails[index]['id'],
                                          )),
                                      Expanded(
                                          flex: 4,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                _orderdetails[index]['name'],
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                _orderdetails[index]
                                                    ['cquantity'],
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          )),
                                      Expanded(
                                        child: Text(
                                          _orderdetails[index]['price'],
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        flex: 3,
                                      ),
                                    ],
                                  ),
                                )));
                      }))
        ]),
      ),
    );
  }

  _loadOrderDetails() async {
    String urlLoadJobs =
        "http://minemp98.com/fitshoe/php/load_carthistory.php";
    await http.post(urlLoadJobs, body: {
      "orderid": widget.order.orderid,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          _orderdetails = null;

          titlecenter = "No Previous Payment";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          _orderdetails = extractdata["carthistory"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }
}
