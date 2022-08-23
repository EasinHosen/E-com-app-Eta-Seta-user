import 'package:etaseta_user/utils/helper_function.dart';
import 'package:flutter/material.dart';

import '../auth/auth_services.dart';
import '../ui/pages/launcher_page.dart';
import '../ui/pages/profile_page.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = AuthService.user!;
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: user.displayName == null || user.displayName!.isEmpty
                ? const Text('User')
                : Text(user.displayName!),
            accountEmail: Text(user.email!),
            currentAccountPicture: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.black12,
              backgroundImage: user.photoURL == null || user.photoURL!.isEmpty
                  ? Image.asset('assets/images/person.png').image
                  : NetworkImage(user.photoURL!),
            ),
          ),
          // ListTile(
          //   onTap: () {
          //     Navigator.pushReplacementNamed(context, UserListPage.routeName);
          //   },
          //   leading: Icon(Icons.people),
          //   title: Text('Users'),
          // ),
          // ListTile(
          //   onTap: () {
          //     Navigator.pushReplacementNamed(context, ProductPage.routeName);
          //   },
          //   leading: const Icon(Icons.shop),
          //   title: const Text('Products'),
          // ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, ProfilePage.routeName);
            },
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
          ),
          ListTile(
            onTap: () async {
              await AuthService.logout();
              showMsg(context, 'Logged out');
              Navigator.pushReplacementNamed(context, LauncherPage.routeName);
            },
            leading: Icon(Icons.logout),
            title: Text('Logout'),
          )
        ],
      ),
    );
  }
}
