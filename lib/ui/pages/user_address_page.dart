import 'package:etaseta_user/auth/auth_services.dart';
import 'package:etaseta_user/models/address_model.dart';
import 'package:etaseta_user/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class UserAddressPage extends StatefulWidget {
  static const String routeName = '/user_address_page';
  const UserAddressPage({Key? key}) : super(key: key);

  @override
  State<UserAddressPage> createState() => _UserAddressPageState();
}

class _UserAddressPageState extends State<UserAddressPage> {
  final addressController = TextEditingController();
  final zipCodeController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  late UserProvider userProvider;

  bool isFirst = true;

  String? area, city;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (isFirst) {
      userProvider = Provider.of<UserProvider>(context);
      userProvider.getAllCities();
      isFirst = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    addressController.dispose();
    zipCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set address'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Street Address'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Street address is required!';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: zipCodeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Zip code'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Zip code is required!';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            DropdownButtonFormField<String>(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a city';
                }
                return null;
              },
              value: city,
              hint: const Text('Select city'),
              items: userProvider.cityList
                  .map((e) => DropdownMenuItem<String>(
                      value: e.name, child: Text(e.name)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  city = value!;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownButtonFormField<String>(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select area';
                }
                return null;
              },
              value: area,
              hint: const Text('Select area'),
              items: userProvider
                  .getAreaByCity(city)
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  area = value!;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(onPressed: _saveAddress, child: const Text('Save')),
          ],
        ),
      ),
    );
  }

  void _saveAddress() {
    if (formKey.currentState!.validate()) {
      EasyLoading.show(status: 'Saving address...');
      final addressM = AddressModel(
          streetAddress: addressController.text,
          area: area!,
          city: city!,
          zipCode: int.parse(zipCodeController.text));
      userProvider.updateProfile(
          AuthService.user!.uid, {'address': addressM.toMap()}).then((value) {
        EasyLoading.dismiss();
        Navigator.pop(context);
      }).catchError((err) {
        EasyLoading.dismiss();
        throw err;
      });
    }
  }
}
