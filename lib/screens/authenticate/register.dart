import 'package:flutter/material.dart';
import 'package:flutterprojects/services/auth.dart';
import 'package:flutterprojects/shared/loading.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _authService = AuthService();

  String _email = '';
  String _password = '';
  String _error = '';
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return _loading ? Loading() : Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        elevation: 0.0,
        title: Text('Register'),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () {
                widget.toggleView();
              },
              icon: Icon(Icons.person),
              label: Text('Sign In'))
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter your username',
                  ),
                  onChanged: (val) {
                    setState(() => _email = val);
                  },
                  validator: Validators.compose([
                    Validators.required('Please enter email'),
                    Validators.email('Invalid email address'),
                  ]),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Enter your password'),
                  obscureText: true,
                  onChanged: (val) {
                    setState(() => _password = val);
                  },
                  validator: Validators.compose([
                    Validators.required('Please enter password'),
                    Validators.minLength(
                        8, 'Password shortest than 8 not allowed'),
                    Validators.patternString(
                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                        'Invalid Password')
                  ]),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RaisedButton(
                      color: Colors.green[400],
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _loading= true;
                          dynamic result = await _authService
                              .registerWithEmailAndPassword(_email, _password);
                          if (result == null) {
                            setState(() {
                              _loading = false;
                              _error = 'please suplly a valid email or pasword';
                            });
                          }
                        }
                      },
                      child: Text('Register',
                          style: TextStyle(color: Colors.white)),
                    ),
                    RaisedButton(
                      color: Colors.green[400],
                      onPressed: () async {
                        _formKey.currentState.reset();
                        // clear login and password field
                      },
                      child:
                          Text('Clear', style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),SizedBox(height: 12.0),
                Text(
                  _error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                ),
              ],
            ),
        ),
      ),
    );
  }
}
