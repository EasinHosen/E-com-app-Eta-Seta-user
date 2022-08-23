import 'package:flutter/material.dart';

class PhoneVerificationPage extends StatelessWidget {
  PhoneVerificationPage({Key? key}) : super(key: key);
  final txtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: txtController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Enter phone number',
                  filled: true,
                  fillColor: Colors.white
                ),
              ),
              ElevatedButton(onPressed: (){}, child: Text('Verify'),),
            ],
          ),
        ),
      ),
    );
  }
}
