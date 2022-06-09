import 'package:blogapp/constants.dart';
import 'package:blogapp/models/api_response.dart';
import 'package:blogapp/models/user.dart';
import 'package:blogapp/screens/register.dart';
import 'package:blogapp/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formkey = GlobalKey();
  TextEditingController textEmail = TextEditingController();
  TextEditingController textPassword = TextEditingController();
  bool loading = false;

  void _loginUser() async {
    APIResponse response = await login(textEmail.text, textPassword.text);
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('token', user.token.toString());
    await preferences.setString('userId', user.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: Form(
          key: formkey,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: ListView(
              children: [
                TextFormField(
                    controller: textEmail,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) =>
                        val!.isEmpty ? 'Invalid email address' : null,
                    decoration: kInputDecoration('Email')),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: textPassword,
                  obscureText: true,
                  validator: (val) => val!.isEmpty ? 'Password required' : null,
                  decoration: kInputDecoration('Password'),
                ),
                const SizedBox(
                  height: 20,
                ),
                loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                              _loginUser();
                            });
                          }
                        },
                        child: const Text('Submit'),
                      ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Dont have an account '),
                    GestureDetector(
                      child: const Text(
                        'Register',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => Register()),
                            (route) => false);
                      },
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }
}
