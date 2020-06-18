import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _username, _email, _password;
  bool _isSubmitting, _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Register'),
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
                  _showUsernameInput(),
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
    return Text('Register', style: Theme.of(context).textTheme.headline);
  }

  Widget _showUsernameInput() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: TextFormField(
        onSaved: (val) => _username = val,
        validator: (val) => val.length < 6 ? 'Username too short' : null,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Username',
          hintText: 'Enter username, min length 6',
          icon: Icon(
            Icons.face,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: TextFormField(
        onSaved: (val) => _email = val,
        validator: (val) => !val.contains('@') ? 'Invalid Email' : null,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Email',
          hintText: 'Enter a valid email',
          icon: Icon(
            Icons.mail,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
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
          icon: Icon(
            Icons.lock,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _showFormActions() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
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
            child: Text('Existing user? Login'),
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          )
        ],
      ),
    );
  }

  void _submit() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      print('Username: $_username, Email: $_email, Password: $_password');
      _registerUser();
    }
  }

  void _registerUser() async {
    setState(() {
      _isSubmitting = true;
    });
    http.Response response =
        await http.post('http://192.168.1.99:9000/api/users/', body: {
      "email": _email,
      "username": _username,
      "password": _password,
    });

    final responseData = json.decode(response.body);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        _isSubmitting = false;
      });
      print(responseData);
//    To me it looks like the data isn't persistent so why store it after registering
//    The token isn't sent back until login so I'll redirect a new user there
//      _storeUserData(responseData);
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
//  The server sends back data once registered
//  {"id":10,"email":"flutter4@gmail.com","username":"flutter4"}
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> user = responseData;
//  Getting rid of the id since it's not needed
    user.remove('id');
    print(user);
    prefs.setString('user', json.encode(user));

  }

  void _showErrorSnack() {
    final snackbar = SnackBar(
      content: Text(
        'That username or email already exists',
        style: TextStyle(color: Colors.red),
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
    }

  void _showSuccessSnack() {
    final snackbar = SnackBar(
      content: Text(
        'User $_username successfully created!',
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
