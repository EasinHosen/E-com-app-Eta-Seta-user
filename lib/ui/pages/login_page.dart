import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etaseta_user/ui/pages/launcher_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/auth_services.dart';
import '../../models/user_model.dart';
import '../../providers/user_provider.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login_page';

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  bool isObscure = true;
  bool isNewUser = false;

  String errMsg = '';

  final form_key = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: form_key,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Eta-Seta',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    isNewUser
                        ? const Text('Welcome new user!')
                        : const Text('Welcome user'),
                    const SizedBox(
                      height: 30,
                    ),
                    Visibility(
                      visible: isNewUser ? true : false,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Name is required!';
                              }
                              return null;
                            },
                            controller: nameController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: 'Full name',
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Please enter a valid phone number!';
                              }
                              return null;
                            },
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: 'Phone number',
                              prefixIcon: Icon(Icons.phone),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    TextFormField(
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'This field cannot be empty';
                        }
                        return null;
                      },
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'This field cannot be empty';
                        } else if (val.length < 6) {
                          return 'Password is too short';
                        }
                        return null;
                      },
                      controller: passwordController,
                      obscureText: isObscure,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: (isObscure
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility)),
                          onPressed: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: authenticate,
                        child: isNewUser
                            ? const Text('Register')
                            : const Text('Login'),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isNewUser
                            ? const Text('Want to log in?')
                            : const Text('New user?'),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                isNewUser = !isNewUser;
                              });
                            },
                            child: const Text('Click here!'))
                      ],
                    ),
                    Visibility(
                      visible: isNewUser ? false : true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Forgot password?'),
                          TextButton(
                              onPressed: () {},
                              child: const Text('Click here!'))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('You can also continue with'),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: _googleSignIn,
                          child: Image.asset(
                            'assets/images/google-icon.png',
                            height: 24,
                            width: 24,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Text('OR'),
                        const SizedBox(
                          width: 8,
                        ),
                        InkWell(
                          onTap: () {
                            print('Facebook');
                          },
                          child: Image.asset(
                            'assets/images/facebook-icon.png',
                            height: 24,
                            width: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      errMsg,
                      style: TextStyle(color: Theme.of(context).errorColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  authenticate() async {
    if (form_key.currentState!.validate()) {
      bool status;
      try {
        if (isNewUser) {
          status = await AuthService.register(nameController.text,
              emailController.text, passwordController.text);
          // await AuthService.sendVerificationEmail();
          final userModel = UserModel(
            name: nameController.text,
            mobile: phoneController.text,
            uid: AuthService.user!.uid,
            email: AuthService.user!.email!,
            creationTime:
                Timestamp.fromDate(AuthService.user!.metadata.creationTime!),
          );
          await Provider.of<UserProvider>(context, listen: false)
              .addUser(userModel);
          Navigator.pushReplacementNamed(context, LauncherPage.routeName);
        } else {
          status = await AuthService.login(
              emailController.text, passwordController.text);
        }
        if (status) {
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, LauncherPage.routeName);
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          errMsg = e.message!;
        });
      }
    }
  }

  void _googleSignIn() {
    AuthService.signInWithGoogle().then((value) async {
      if (value.user != null) {
        final userModel = UserModel(
          name: value.user!.displayName ?? 'User',
          mobile: value.user!.phoneNumber,
          image: value.user!.photoURL,
          uid: value.user!.uid,
          email: value.user!.email!,
          creationTime: Timestamp.fromDate(value.user!.metadata.creationTime!),
        );
        if (value.additionalUserInfo!.isNewUser == true) {
          await Provider.of<UserProvider>(context, listen: false)
              .addUser(userModel);
        }
        Navigator.pushReplacementNamed(context, LauncherPage.routeName);
      }
    }).onError((error, _) {
      setState(() {
        errMsg = error.toString();
      });
    });
  }
}
