import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistem_informasi_penjualan/providers/auth_provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late List<MenuSetting> _menu;

  void _goToProfile() => Navigator.pushNamed(context, '/profile');
  void _goToStoreProfile() => Navigator.pushNamed(context, '/storeProfile');
  // void _logOut() {}

  @override
  void initState() {
    super.initState();
    _menu = [
      MenuSetting(Icons.person, 'Profil', _goToProfile),
      MenuSetting(Icons.store, 'Profil Warung', _goToStoreProfile),
      MenuSetting(Icons.account_circle, 'Profil', _goToProfile),
      // MenuSetting(Icons.logout, 'Keluar', _logOut),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Text(authProvider.user?.username?? "Tidak ada user"),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (BuildContext context, index) {
                  return Divider(
                    thickness: 0.8,
                    radius: BorderRadiusGeometry.all(Radius.circular(2)),
                  );
                },
                itemCount: _menu.length,
                itemBuilder: (context, index) {
                  final menu = _menu[index];
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    leading: Icon(menu.icons),
                    title: Text(menu.label),
                    onTap: menu.onTap,
                    trailing: Icon(Icons.keyboard_arrow_right_outlined),
                  );
                },
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                alignment: Alignment.center,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            'Konfirmasi Keluar',
                            style: TextStyle(fontSize: 18),
                          ),
                          content: Text('Apakah anda yakin ingin keluar?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Tidak'),
                            ),
                            TextButton(
                              onPressed: () {
                                context
                                    .read<AuthProvider>().logout();

                                if (context.mounted) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/loginScreen',
                                  );
                                }
                              },
                              child: Text('Ya'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Color.fromARGB(255, 239, 237, 237),
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: [Icon(Icons.logout), Text('Logout')],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// List Menu Setting
class MenuSetting {
  final IconData? icons;
  final String label;
  final VoidCallback onTap;

  MenuSetting(this.icons, this.label, this.onTap);
}
