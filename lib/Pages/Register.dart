import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:malazgirt/Managment/Navigator/Navigation.dart';
import 'package:malazgirt/Managment/service/auth/fire/authService.dart';
import 'package:malazgirt/Pages/Home.dart';
import 'package:malazgirt/Pages/Login.dart';
import 'package:malazgirt/widget/Authitems/authfield.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formkey = GlobalKey<FormState>();
  bool load = false;
  final _aservice = AuthService();
  String username = "";
  String email = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return load
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          )
        : Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Container()),
                  const Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Sign up",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Create a account and start Discussing!",
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Form(
                      key: formkey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Can't be null";
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  setState(() {
                                    username = value;
                                  });
                                }
                              },
                              decoration: InputField(
                                  const Icon(
                                    Icons.person_2,
                                    color: Colors.black,
                                  ),
                                  "Username"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Can't be null";
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  setState(() {
                                    email = value;
                                  });
                                }
                              },
                              decoration: InputField(
                                  const Icon(
                                    Icons.email,
                                    color: Colors.black,
                                  ),
                                  "E-mail"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Can't be nsull";
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  setState(() {
                                    password = value;
                                  });
                                }
                              },
                              obscureText: true,
                              decoration: InputField(
                                  const Icon(
                                    Icons.lock,
                                    color: Colors.black,
                                  ),
                                  "Password"),
                            ),
                          ),
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black),
                        onPressed: () {
                          register();
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Register",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 20),
                            ),
                          ],
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 1,
                        color: Colors.grey,
                      ),
                      const Text("    or    "),
                      Container(
                        width: 100,
                        height: 1,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("sign up with"),
                    ],
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        /*image: const DecorationImage(
                      
                      
                      image: NetworkImage(
                          
                          "https://companieslogo.com/img/orig/GOOG-0ed88f7c.png?t=1633218227")),*/
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20)),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Image(
                          image: NetworkImage(
                              "https://companieslogo.com/img/orig/GOOG-0ed88f7c.png?t=1633218227")),
                    ),
                  ),
                  Expanded(child: Container()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Do Have an Account? ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigate.NavigatePage(false, const Login(), context);
                        },
                        child: const Text(
                          "Login!",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          );
  }

  register() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        load = true;
      });
      bool gir = await _aservice.register(
        username,
        email,
        password,
      );
      if (gir == true) {
        // ignore: use_build_context_synchronously
        Navigate.NavigatePage(false, const Home(), context);
        setState(() {
          load = false;
        });
      } else {
        setState(() {
          load = false;
        });
        // ignore: use_build_context_synchronously
        ElegantNotification.error(description: const Text("Error")).show(context);
      }
    }
  }
}
