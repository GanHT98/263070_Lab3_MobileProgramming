import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fit_shoe/loginscreen.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
//import 'package:email_validator/email_validator.dart';

void main() => runApp(RegisterScreen());
class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  
  double screenHeight;
  bool _isChecked = false;
  String urlRegister = "https://minemp98.com/fitshoe/php/register_user.php";
  TextEditingController _nameEditingController = new TextEditingController();
  TextEditingController _emailEditingController = new TextEditingController();
  TextEditingController _phoneditingController = new TextEditingController();
  TextEditingController _passEditingController = new TextEditingController();
  String name;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
          body: Stack(
            children: <Widget>[
              upperHalf(context),
              lowerHalf(context),
              pageTitle(),
            ],
          ),
    );
  }

  Widget upperHalf(BuildContext context) {
    return Container(
      height: screenHeight / 2,
      child: Image.asset(
        'assets/images/login.jpg',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget lowerHalf(BuildContext context) {
    return Container(
      height: 600,
      margin: EdgeInsets.only(top: screenHeight / 3.5),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: <Widget>[
          Card(
            elevation: 10,
            child:Form(
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.teal[800],
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextField(
                      controller: _nameEditingController,
                      inputFormatters: [WhitelistingTextInputFormatter(RegExp("[a-zA-Z]")),
                      BlacklistingTextInputFormatter(RegExp("[0-9]"))],
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color:Colors.teal[800]),
                        labelText: 'Name',
                        hintText: "Enter Your Name",
                        errorText: _validateName(_nameEditingController.text),
                        icon: Icon(Icons.person, color: Colors.teal[800]),
                      )),
                  TextField(
                      controller: _emailEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color:Colors.teal[800]),
                        labelText: 'Email',
                        hintText: 'exp: abc@gmail.com',
                        errorText: _validateEmail(_emailEditingController.text),
                        //errorStyle: TextStyle(color:Colors.),
                        icon: Icon(Icons.email, color: Colors.teal[800]),
                        
                      )),
                  TextField(
                      controller: _phoneditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color:Colors.teal[800]),
                        labelText: 'Phone',
                        hintText: 'eg: xxx-xxxxxxx/xxxxxxxxxx',
                        errorText: _validatePhone(_phoneditingController.text),
                        icon: Icon(Icons.phone, color: Colors.teal[800]),
                        
                      )),
                  TextField(
                    controller: _passEditingController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color:Colors.teal[800]),
                      labelText: 'Password',
                      hintText: 'Enter more than 5 character',
                      errorText: _validatePassword(_passEditingController.text),    
                      icon: Icon(Icons.lock, color: Colors.teal[800],),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Checkbox(
                        value: _isChecked,
                        onChanged: (bool value) {
                          _onChange(value);
                        },
                      ),
                      GestureDetector(
                        onTap: _showEULA,
                        child: Text('I Agree to Terms  ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal[800])),          
                      ),
                      MaterialButton(                     
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 115,
                        height: 30,
                        child: Text('Register'),
                        color: Colors.red[400],
                        textColor: Colors.white,
                        elevation: 10,
                        onPressed: _onRegister,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Already register? ", style: TextStyle(fontSize: 16.0)),
              GestureDetector(
                onTap: _loginScreen,
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget pageTitle() {
    return Container(
      color: Colors.grey[600],
      margin: EdgeInsets.only(top: 60),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.shop,
            size: 40,
            color: Colors.white,
          ),
          Text(
            " FIT SHOE",
            style: TextStyle(
                fontSize: 36, color: Colors.white, fontWeight: FontWeight.w900),
          )
        ],
      ),
    );
  }

  void _onRegister() {
    String name = _nameEditingController.text;
    String email = _emailEditingController.text;
    String phone = _phoneditingController.text;
    String password = _passEditingController.text;

    showDialog(context: context,
                 builder: (BuildContext context){
                   return AlertDialog(
                     title:new Text("Register"),
                     content: new Container(
                       height:50,
                       child:Column(children: <Widget>[
                         Text("Confirm to create account?"),
                       ],)

                     ),
                      actions: <Widget>[
                        new FlatButton(
                          child:new Text('Yes'),
                          onPressed: (){
                            Navigator.of(context).pop();
    if (!_isChecked) {
      Toast.show("Please Accept Term", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }else{
        _account(name,email,phone,password);
      }}
        ),
                  new FlatButton(
                  child: new Text('No'),
                  onPressed: (){
                  Navigator.of(context).pop();
                })
                      ]);
                 });
                 }
      void _account(String name,email,phone,password){
      http.post(urlRegister, body: {
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
    }).then((res) {
      //if(res.body=="success"){
      print(res.body);
      if (res.body.contains("success") ) {
        Navigator.pop(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen()));
                
        Toast.show("Registration success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        Toast.show("Registration failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }
               
  void _loginScreen() {
    Navigator.pop(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
      //savepref(value);
    });
  }

  void _showEULA() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("EULA"),
          content: new Container(
            height: screenHeight / 2,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new SingleChildScrollView(
                    child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              //fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                            text:
                                "This End-User License Agreement is a legal agreement between you and mimnemp98 This EULA agreement governs your acquisition and use of our FITSHOE software (Software) directly from minemp98 or indirectly through a minemp98 authorized reseller or distributor (a Reseller).Please read this EULA agreement carefully before completing the installation process and using the FITSHOE software. It provides a license to use the FITSHOE software and contains warranty information and liability disclaimers. If you register for a free trial of the FITSHOE software, this EULA agreement will also govern that trial. By clicking accept or installing and/or using the MY.GROCERY software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement. If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.This EULA agreement shall apply only to the Software supplied by minemp98 herewith regardless of whether other software is referred to or described herein. The terms also apply to any Slumberjer updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply. This EULA was created by EULA Template for MY.GROCERY. Slumberjer shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of minemp98. minemp98 reserves the right to grant licences to use the Software to third parties"
                            //children: getSpan(),
                            )),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
String _validateName(String value){
  if(value.isEmpty){
    return "Enter Name";
  }
  if(value.length < 4 )
    return 'should more than 4 word & not contain number';
  else 
   return null;
   }

String _validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  String _validatePassword(String value) {
     if(value.isEmpty){
       return "Enter Password";
  }
     if(value.length < 5 )
     return "should more then 5 character";
  else 
   return null;
   }

String _validatePhone(String value) {
String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
RegExp regExp = new RegExp(patttern);
if (value.length == 0) {
      return 'Please enter phone number';
}
else if (!regExp.hasMatch(value)) {
      return 'Please enter valid phone number';
}
return null;
}            
