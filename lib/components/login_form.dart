import 'dart:convert';

import 'package:my_doctor/components/button.dart';
import 'package:my_doctor/main.dart';
import 'package:my_doctor/models/auth_model.dart';
import 'package:my_doctor/providers/dio_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/config.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool obsecurePass = true;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Config.PrimaryColor,
            decoration: const InputDecoration(
              hintText: 'Email Address',
              labelText: 'Email',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.email_outlined),
              prefixIconColor: Config.PrimaryColor,
            ),
          ),
          Config.spaceSmall,
          TextFormField(
            controller: _passController,
            keyboardType: TextInputType.visiblePassword,
            cursorColor: Config.PrimaryColor,
            obscureText: obsecurePass,
            decoration: InputDecoration(
                hintText: 'Password',
                labelText: 'Password',
                alignLabelWithHint: true,
                prefixIcon: const Icon(Icons.lock_outline),
                prefixIconColor: Config.PrimaryColor,
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obsecurePass = !obsecurePass;
                      });
                    },
                    icon: obsecurePass
                        ? const Icon(
                            Icons.visibility_off_outlined,
                            color: Colors.black38,
                          )
                        : const Icon(
                            Icons.visibility_outlined,
                            color: Config.PrimaryColor,
                          ))),
          ),
          Config.spaceSmall,
          Consumer<AuthModel>(
            builder: (context, auth, child) {
              return Button(
                width: double.infinity,
                title: 'Sign In',
                onPressed: () async {
                  //login here
                  final token = await DioProvider()
                      .getToken(_emailController.text, _passController.text);

                  if (token) {
                    //auth.loginSuccess(); //update login status
                    //rediret to main page

                    //grab user data here
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    final tokenValue = prefs.getString('token') ?? '';

                    if (tokenValue.isNotEmpty && tokenValue != '') {
                      //get user data
                      final response = await DioProvider().getUser(tokenValue);
                      if (response != null) {
                        setState(() {
                          //json decode
                          Map<String, dynamic> appointment = {};
                          final user = json.decode(response);

                          //check if any appointment today
                          for (var doctorData in user['doctor']) {
                            //if there is appointment return for today

                            if (doctorData['appointments'] != null) {
                              appointment = doctorData;
                            }
                          }

                          auth.loginSuccess(user, appointment);
                          MyApp.navigatorKey.currentState!.pushNamed('main');
                        });
                      }
                    }
                  }
                },
                disable: false,
              );
            },
          )
        ],
      ),
    );
  }
}