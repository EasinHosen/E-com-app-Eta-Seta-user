import 'package:etaseta_user/providers/user_provider.dart';
import 'package:etaseta_user/ui/pages/launcher_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../auth/auth_services.dart';

class PhoneVerificationPage extends StatefulWidget {
  PhoneVerificationPage({Key? key}) : super(key: key);
  static const String routeName = '/phone_verification_page';

  @override
  State<PhoneVerificationPage> createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  bool isCodeSend = false;
  String code = '';
  String vId = '';
  String phoneNumber = '';
  final txtController = TextEditingController();

  late UserProvider userProvider;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    userProvider = Provider.of<UserProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    phoneNumber = ModalRoute.of(context)!.settings.arguments as String ?? '';

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Phone Verification',
                  style: Theme.of(context).textTheme.headline5),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: txtController..text = phoneNumber,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                    hintText: 'Enter phone number',
                    filled: true,
                    fillColor: Colors.white),
              ),
              const SizedBox(
                height: 10,
              ),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Pinput(
                    enabled: isCodeSend,
                    length: 6,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
                    onChanged: (value) {
                      code = value;
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: isCodeSend ? null : _sendOtp,
                // onPressed: () {},
                child: const Text('Send otp'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: isCodeSend ? _verifyNumber : null,
                // onPressed: () {},
                child: const Text('Verify code'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendOtp() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+88$phoneNumber',
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        vId = verificationId;
        setState(() {
          isCodeSend = true;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void _verifyNumber() async {
    try {
      await userProvider
          .updateProfile(AuthService.user!.uid, {'mobileVerified': true});

      PhoneAuthCredential credential =
          PhoneAuthProvider.credential(verificationId: vId, smsCode: code);

      await FirebaseAuth.instance.signInWithCredential(credential);

      await AuthService.user!.delete();
      await FirebaseAuth.instance.signOut();
      EasyLoading.showToast('Please log in again to continue...');
      Navigator.pushReplacementNamed(context, LauncherPage.routeName);
    } catch (e) {
      rethrow;
    }
  }
}
