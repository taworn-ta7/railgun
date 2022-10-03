import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../i18n/strings.g.dart';
import '../widgets/message_box.dart';
import '../widgets/search_bar.dart';
import '../services/app_share.dart';
import '../pages.dart';
import '../pages/profile/change_icon.dart';
import '../pages/profile/change_name.dart';
import '../pages/profile/change_password.dart';

enum TopRightMenu {
  changeIcon,
  changeName,
  changePassword,
  signOut,
}

/// A customized AppBar.
class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool withMoreMenu;
  final void Function(TopRightMenu menu, Object? result)? onResult;
  final bool searchBox;
  final void Function(String value)? onSearchTextChanged;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.withMoreMenu = false,
    this.onResult,
    this.searchBox = false,
    this.onSearchTextChanged,
  }) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  static final appShare = AppShare.instance();

  late TextEditingController _searchText;

  @override
  void initState() {
    super.initState();
    _searchText = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _searchText.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------------------

  /// Built widget tree.
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
      actions: _buildActionList(context),
    );
  }

  /// Built popup menu button list.
  Widget _buildPopupMenu(BuildContext context) {
    final tr = t.appBar;
    return PopupMenuButton(
      icon: _buildImage(context),

      // item list
      itemBuilder: (context) {
        List<PopupMenuEntry<TopRightMenu>> list = [];
        if (widget.withMoreMenu) {
          // changes icon
          list.add(PopupMenuItem(
            value: TopRightMenu.changeIcon,
            child: ListTile(
              leading: const Icon(Icons.face),
              title: Text(tr.changeIcon),
            ),
          ));

          // changes name
          list.add(PopupMenuItem(
            value: TopRightMenu.changeName,
            child: ListTile(
              leading: const Icon(Icons.face),
              title: Text(tr.changeName),
            ),
          ));

          // changes password
          list.add(PopupMenuItem(
            value: TopRightMenu.changePassword,
            child: ListTile(
              leading: const Icon(Icons.password),
              title: Text(tr.changePassword),
            ),
          ));
        }

        // sign-out
        list.add(PopupMenuItem(
          value: TopRightMenu.signOut,
          child: ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: Text(tr.quit),
          ),
        ));
        return list;
      },

      // events
      onSelected: (value) async {
        if (value == TopRightMenu.changeIcon) {
          // changes icon
          final answer = await Pages.switchPage(
            context,
            const ChangeIconPage(),
          );
          if (answer != null) {
            widget.onResult?.call(TopRightMenu.changeIcon, answer);
          }
        } else if (value == TopRightMenu.changeName) {
          // changes name
          final answer = await Pages.switchPage(
            context,
            const ChangeNamePage(),
          );
          if (answer != null) {
            widget.onResult?.call(TopRightMenu.changeName, answer);
          }
        } else if (value == TopRightMenu.changePassword) {
          // changes password
          await Pages.switchPage(
            context,
            const ChangePasswordPage(),
          );
        }

        // sign-out
        else if (value == TopRightMenu.signOut) {
          final answer = await MessageBox.question(
            context,
            t.question.areYouSureToQuit,
            MessageBoxOptions(
              button0Negative: true,
            ),
          );
          if (answer == true) {
            // ignore: use_build_context_synchronously
            appShare.signOut(context);
          }
        }
      },
    );
  }

  /// Built search button.
  Widget _buildSearchButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.search),
      tooltip: t.searchBar.open,
      onPressed: () => Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: SearchBar(
            searchText: _searchText,
            onChanged: (text) => widget.onSearchTextChanged?.call(text),
          ),
        ),
      ),
    );
  }

  /// Built search box and popup menu.
  List<Widget> _buildActionList(BuildContext context) {
    final actions = <Widget>[];
    if (widget.searchBox) {
      actions.add(_buildSearchButton(context));
    }
    actions.add(_buildPopupMenu(context));
    return actions;
  }

  /// Built image.
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
