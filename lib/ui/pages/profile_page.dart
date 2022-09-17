import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etaseta_user/ui/pages/phone_verification_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../auth/auth_services.dart';
import '../../models/user_model.dart';
import '../../providers/user_provider.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = '/profile_page';
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final txtController = TextEditingController();
  late UserProvider provider;

  @override
  void dispose() {
    // TODO: implement dispose
    txtController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    provider = Provider.of<UserProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      // drawer: const MainDrawer(),
      body: Center(
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: provider.getUserByUid(AuthService.user!.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userModel = UserModel.fromMap(snapshot.data!.data()!);
              return ListView(
                children: [
                  Center(
                    child: userModel.image == null || userModel.image!.isEmpty
                        ? Image.asset(
                            'assets/images/person.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : CircleAvatar(
                            radius: 60,
                            backgroundImage: Image.network(
                              userModel.image!,
                            ).image,
                          ),
                  ),
                  TextButton.icon(
                      onPressed: _updateImage,
                      icon: const Icon(Icons.camera),
                      label: const Text('Change image')),
                  const Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                  ListTile(
                    title: Text(userModel.name ?? 'No display name'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        showInputDialog('Display name', userModel.name,
                            (value) async {
                          await provider.updateProfile(
                              AuthService.user!.uid, {'name': value});
                          await AuthService.updateDisplayName(value);
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(
                        userModel.mobile != null || userModel.mobile!.isNotEmpty
                            ? userModel.mobile!
                            : 'No number added'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (userModel.mobile != null ||
                            userModel.mobile!.isNotEmpty)
                          Flexible(
                            child: Text(
                              userModel.mobileVerified
                                  ? 'verified'
                                  : 'not verified',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: userModel.mobileVerified
                                      ? Colors.green
                                      : Colors.red),
                            ),
                          ),
                        Flexible(
                          child: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              showInputDialog('Mobile number', userModel.mobile,
                                  (value) {
                                provider.updateProfile(
                                    AuthService.user!.uid, {'mobile': value});
                                provider.updateProfile(AuthService.user!.uid,
                                    {'mobileVerified': false});
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(userModel.email),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        showInputDialog('Email', userModel.email, (value) {
                          provider.updateProfile(
                              AuthService.user!.uid, {'email': value});
                        });
                      },
                    ),
                  ),
                  ListTile(
                    trailing: TextButton(
                      child: Text(
                        'Verify phone',
                        style: userModel.mobileVerified
                            ? const TextStyle(color: Colors.grey)
                            : const TextStyle(color: Colors.green),
                      ),
                      onPressed: () => userModel.mobileVerified
                          ? null
                          : Navigator.pushNamed(
                              context, PhoneVerificationPage.routeName,
                              arguments: userModel.mobile),
                    ),
                  ),
                ],
              );
            }
            if (snapshot.hasError) {
              return const Text('Failed to fetch data!');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  void _updateImage() async {
    final xFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 75);
    if (xFile != null) {
      try {
        final downloadUrl =
            await Provider.of<UserProvider>(context, listen: false)
                .updateImage(xFile);
        await Provider.of<UserProvider>(context, listen: false)
            .updateProfile(AuthService.user!.uid, {'image': downloadUrl});

        await AuthService.updateDisplayImage(downloadUrl);
      } catch (e) {
        throw e;
      }
    }
  }

  showInputDialog(String title, String? value, Function(String) onSaved) {
    txtController.text = value ?? '';
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: txtController,
                  decoration: InputDecoration(
                    hintText: 'Enter $title',
                  ),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () {
                      onSaved(txtController.text);
                      Navigator.pop(context);
                    },
                    child: const Text('Update')),
              ],
            ));
  }
}
