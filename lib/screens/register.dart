import 'package:blogapp/constants.dart';
import 'package:blogapp/models/api_response.dart';
import 'package:blogapp/models/user.dart';
import 'package:blogapp/screens/home.dart';
import 'package:blogapp/screens/login.dart';
import 'package:blogapp/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> formkey = GlobalKey();
  bool loading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

  void _registerUser() async {
    APIResponse response = await register(
        nameController.text, emailController.text, passwordController.text);
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = !loading;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.error}')),
      );
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('token', user.token ?? '');
    await preferences.setString('userId', user.id ?? '');
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: ((context) => const Home())),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Screen'),
      ),
      body: Form(
          key: formkey,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: ListView(
              children: [
                TextFormField(
                    controller: nameController,
                    validator: (val) => val!.isEmpty ? 'Invalid Name' : null,
                    decoration: kInputDecoration('Name')),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) =>
                        val!.isEmpty ? 'Invalid email address' : null,
                    decoration: kInputDecoration('Email')),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  validator: (val) =>
                      val!.length < 6 ? 'Required at least 6 characters' : null,
                  decoration: kInputDecoration('Password'),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: passwordConfirmController,
                  obscureText: true,
                  validator: (val) => val != passwordController.text
                      ? 'Confirm password does not match'
                      : null,
                  decoration: kInputDecoration('Confirm Password'),
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
                              loading = !loading;
                              _registerUser();
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
                    const Text('Already have a account '),
                    GestureDetector(
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const Login()),
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
