import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/utilities/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'file:///D:/Udemy/Flutter/Projects/flash-chat-flutter/lib/utilities/shadow_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String routeName = '/registration';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  final _auth = FirebaseAuth.instance;
  String _email;
  String _password;
  bool _showSpinner = false;

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  height: _height * 0.2,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: _height * 0.05,
              ),
              Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: Column(
                  children: <Widget>[
                    CustomTextFormField(
                      onSaved: (value) {
                        _email = value;
                      },
                      validator: emailValidator,
                      keyboardType: TextInputType.emailAddress,
                      hint: 'Enter your email.',
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    CustomTextFormField(
                      onSaved: (value) {
                        _password = value;
                      },
                      validator: (value) => value.isEmpty ? '*Required' : null,
                      obscure: true,
                      hint: 'Enter your password.',
                    ),
                  ],
                ),
              ),
              ShadowButton(
                title: 'Register',
                color: Colors.blueAccent,
                onPressed: () {
                  _validateRegister();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) return '*Required';
    if (!regex.hasMatch(value))
      return '*Enter a valid email';
    else
      return null;
  }

  void _validateRegister() async {
    final FormState form = _formKey.currentState;
    if (_formKey.currentState.validate()) {
      form.save();

      setState(() {
        _showSpinner = true;
      });
      try {
        final newUser = await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        if (newUser != null) {
          Navigator.pushNamed(context, ChatScreen.routeName);
        }
      } catch (error) {
        switch (error.code) {
          case "ERROR_EMAIL_ALREADY_IN_USE":
            {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      elevation: 5.0,
                      title: Text('Registration Error'),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 25.0),
                      content: Container(
                        child: Text('This email is already in use.'),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  });
            }
            break;
          case 'ERROR_WEAK_PASSWORD':
            {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      elevation: 5.0,
                      title: Text('Registration Error'),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 30.0),
                      content: Container(
                        child:
                            Text('Password must be 6 characters long or more.'),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  });
            }
            break;
        }
      } finally {
        setState(() {
          _showSpinner = false;
        });
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
}

//ShadowButton(
//title: 'Register',
//color: Colors.blueAccent,
//onPressed: () async {
//setState(() {
//_showSpinner = true;
//});
//try {
//final newUser = await _auth.createUserWithEmailAndPassword(
//email: _email, password: _password);
//
//if (newUser != null) {
//Navigator.pushNamed(context, ChatScreen.routeName);
//}
//} catch (e) {
//print(e);
//} finally {
//setState(() {
//_showSpinner = false;
//});
//}
//
////                print(_email);
////                print(_password);
////implement registration
//},
//),
