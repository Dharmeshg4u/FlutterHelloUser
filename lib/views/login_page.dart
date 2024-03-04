import 'package:flutter/material.dart';
import 'package:flutter_hello_user/viewmodels/auth_viewmodel.dart';
import 'package:flutter_hello_user/utils/routes.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '';
  String password = '';
  bool loading = false;
  String? error;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 22),
                  Image.asset("assets/images/ic_login.png"),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextFormField(
                          onChanged: (value) => email = value,
                          decoration: const InputDecoration(
                            hintText: "Enter Email",
                            labelText: "Email",
                          ),
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return "Email cannot be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          onChanged: (value) => password = value,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: "Enter Password",
                            labelText: "Password",
                          ),
                          validator: (value) {
                            if (value != null) {
                              if (value.isEmpty) {
                                return "Password cannot be empty";
                              } else if (value.length < 6) {
                                return "Password length should be at least 6";
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 42),
                        ElevatedButton(
                          onPressed: loading
                              ? null
                              : () {
                                  if (_formKey.currentState != null &&
                                      _formKey.currentState!.validate()) {
                                    FocusScope.of(context).unfocus();
                                    setState(() {
                                      loading = true;
                                    });
                                    Provider.of<AuthViewModel>(context,
                                            listen: false)
                                        .signInWithEmailAndPassword(
                                            email, password)
                                        .then((_) => Navigator.pushNamed(
                                            context, AppRoute.homeRoute))
                                        .whenComplete(() => setState(() {
                                              loading = false;
                                            }))
                                        .catchError((error) {
                                      setState(() {
                                        loading = false;
                                        this.error = error.toString();
                                      });
                                      // Display error message for a few seconds
                                      Future.delayed(const Duration(seconds: 5),
                                          () {
                                        setState(() {
                                          this.error = null;
                                        });
                                      });

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(error.toString()),
                                          duration: const Duration(seconds: 2),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    });
                                  }
                                },
                          style: TextButton.styleFrom(
                              minimumSize: const Size(150, 50)),
                          child: loading
                              ? const CircularProgressIndicator()
                              : const Text("Login"),
                        ),
                        const SizedBox(height: 42),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, AppRoute.signupRoute);
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "Don't have an account? ",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                              children: [
                                TextSpan(
                                  text: "Sign up now!",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (error != null)
                          Text(
                            error!,
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
