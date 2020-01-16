import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trash_app/providers/auth.dart';
import 'package:package_info/package_info.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

enum AuthMode { Signup, Login }

class _AuthScreenState extends State<AuthScreen> {
  AuthMode _authMode = AuthMode.Signup;
  final _formKey = GlobalKey<FormState>();
  final _textPassword = TextEditingController();
  DateTime _dateTime;
  

  Map<String, dynamic> _authData = {
    'firstname': null,
    'lastname': null,
    'phoneNumber': null,
    'birthdate': null,
    'androidVersion': null,
    'email': '',
    'password': '',
  };


  _getUserAndroidVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    
   _authData['androidVersion'] = packageInfo.version;
    
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }
  @override
  void initState() {
   
    super.initState();
  }

  void _submit() {}

  void authenticate(BuildContext context) async {
    final _auth = Provider.of<Auth>(context);
    await  _getUserAndroidVersion();

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (_authMode == AuthMode.Signup) {
        _auth.register(
            firstname: _authData['firstname'],
            lastname: _authData['lastname'],
            email: _authData['email'],
            password: _authData['password'],
            birthdate: _authData['birthdate'],
            androidVersion: _authData['androidVersion'],
            phoneNumber: _authData['phoneNumber']);
      } else {
        _auth.login(_authData['email'], _authData['password']);
      }

      print(_authData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authenticate'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Fistname'),
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'Firstname is required';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      _authData['firstname'] = value;
                    },
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Lastname'),
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'Lastname is required';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      _authData['lastname'] = value;
                    },
                  ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (!EmailValidator.validate(value)) {
                      return 'Email invalid';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  controller: _textPassword,
                  obscureText: true,
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return 'Password is required';
                    }
                    if (value.trim().length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Confirm password'),
                    obscureText: true,
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'Confirm Password is required';
                      }
                      if (value != _textPassword.text) {
                        return 'Password doen\'t match';
                      }

                      return null;
                    },
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Phone'),
                    keyboardType: TextInputType.phone,
                    onSaved: (value) {
                      _authData['phoneNumber'] = value;
                    },
                  ),
              
                SizedBox(
                  height: 30,
                ),
                if (_authMode == AuthMode.Signup)
                  GestureDetector(
                    child: Text(
                      'Choose your birthdate',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    onTap: () {
                      showDatePicker(
                              context: context,
                              initialDate: _dateTime == null
                                  ? DateTime.now()
                                  : _dateTime,
                              firstDate: DateTime(1960),
                              lastDate: DateTime(2060))
                          .then((date) {
                        setState(() {
                          _dateTime = date;
                          _authData['birthdate'] = date;
                        });
                      });
                    },
                  ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: RaisedButton(
                    child: Text(
                        _authMode == AuthMode.Signup ? 'Sign up' : 'Login'),
                    onPressed: () {
                      authenticate(context);
                    },
                  ),
                ),
                Center(
                  child: FlatButton(
                    child: Text(
                      _authMode == AuthMode.Signup ? 'Sign up' : 'Login',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onPressed: () {
                      _switchAuthMode();
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
