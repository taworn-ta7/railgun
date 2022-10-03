import 'package:flutter/material.dart';
import '../i18n/strings.g.dart';
import '../services/theme_manager.dart';
import '../services/app_share.dart';
import '../styles.dart';
import '../pages.dart';

/// A customized Drawer.
class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  static final appShare = AppShare.instance();

  @override
  Widget build(BuildContext context) {
    final tr = t.drawerUi;
    final themeManager = ThemeManager.instance();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: themeManager.current,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // icon
                _buildImage(context),
                Styles.betweenVertical(),

                // name
                ListTile(
                  title: Text(tr.title),
                  subtitle: Text(appShare.authen.member?.name ?? ''),
                ),
              ],
            ),
          ),

          // home
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(tr.home),
            onTap: () {
              Navigator.pop(context);
              Navigator.popAndPushNamed(context, Pages.dashboard);
            },
          ),

          // members
          ListTile(
            leading: const Icon(Icons.group),
            title: Text(tr.members),
            onTap: () {
              Navigator.pop(context);
              Navigator.popAndPushNamed(context, Pages.members);
            },
          ),

          // settings
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(tr.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.popAndPushNamed(context, Pages.settings);
            },
          ),

          // quits
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: Text(tr.quit),
            onTap: () {
              appShare.signOut(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final icon = appShare.authen.icon;
    if (icon != null) {
      return Image.memory(
        icon,
        width: 64,
        height: 64,
        fit: BoxFit.contain,
      );
    } else {
      return Image.asset(
        'assets/default-profile-icon.png',
        width: 64,
        height: 64,
        fit: BoxFit.contain,
      );
    }
  }
}
