import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isSubmitting,_obscureText = true;
  String _email, _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Log In'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  _showTitle(),
                  _showEmailInput(),
                  _showPasswordInput(),
                  _showFormActions(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _showTitle() {
    return Text('Login',
        style: Theme.of(context).textTheme.headline
    );
  }


  Widget _showEmailInput() {
    return Padding(
      padding: EdgeInsets.only(
          top: 20.0
      ),
      child: TextFormField(
        onSaved: (val) => _email = val,
        validator: (val) => !val.contains('@') ? 'Invalid Email' : null,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Email',
          hintText: 'Enter a valid email',
          icon: Icon(Icons.mail,
            color: Colors.grey,
          ),
        ),
      ),

    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: EdgeInsets.only(
          top: 20.0
      ),
      child: TextFormField(
        onSaved: (val) => _password = val,
        obscureText: _obscureText,
        validator: (val) => val.length < 6 ? 'Username too short' : null,
        decoration: InputDecoration(
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() => _obscureText = !_obscureText);

            },
            child: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
            ),
          ),
          border: OutlineInputBorder(),
          labelText: 'Password',
          hintText: 'Enter password, min length 6',
          icon: Icon(Icons.lock,
            color: Colors.grey,
          ),
        ),
      ),

    );
  }

  Widget _showFormActions() {
    return Padding(
      padding: EdgeInsets.only(
          top: 20.0
      ),
      child: Column(
        children: <Widget>[
          _isSubmitting == true ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
          ) : RaisedButton(
            child: Text(
              'Submit',
              style: Theme.of(context).textTheme.body1.copyWith(
                color: Colors.black,
              ),
            ),
            elevation: 8.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            color: Theme.of(context).primaryColor,
            onPressed: () => _submit(),
          ),
          FlatButton(
            child: Text('New user? Register'),
            onPressed: () => Navigator.pushReplacementNamed(context, '/register'),
          )
        ],
      ),
    );
  }

  void _submit() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      print('Email: $_email, Password: $_password');
      _registerUser();
    }
  }

  void _registerUser() async {
    setState(() {
      _isSubmitting = true;
    });
    http.Response response =
    await http.post('https://pure-mountain-29084.herokuapp.com/api/rest-auth/login/', body: {
      "email": _email,
      "password": _password,
    });

    final responseData = json.decode(response.body);
    print(responseData);
    if (response.statusCode == 200) {
      setState(() {
        _isSubmitting = false;
      });
//      print(responseData);
      _storeUserData(responseData);
      _showSuccessSnack();
      _redirectUser();
    } else {
      setState(() {
        _isSubmitting = false;
      });
      _showErrorSnack();
    }

  }

  void _storeUserData(responseData) async {
//  The server sends back data once logged in
//  {
//    "key": "b48f7159adeebaa24e9b34e468847273b135ac0f"
//  }
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> user = responseData;
    print(user);
    user['email'] = _email;
    print(user);
    prefs.setString('user', json.encode(user));
//    prefs.setString('email', json.encode(_email));


  }

  void _showErrorSnack() {
    final snackbar = SnackBar(
      content: Text(
        'Something went wrong with the Login',
        style: TextStyle(color: Colors.red),
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  void _showSuccessSnack() {
    final snackbar = SnackBar(
      content: Text(
        'User $_email successfully logged in',
        style: TextStyle(color: Colors.green),
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
    _formKey.currentState.reset();
  }

  void _redirectUser() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/');
    });

  }

}