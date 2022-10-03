import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import '../app.dart';

/// ThemeManager service singleton class.
class ThemeManager {
  static ThemeManager? _instance;

  static ThemeManager instance() {
    _instance ??= ThemeManager();
    return _instance!;
  }

  // ----------------------------------------------------------------------

  static final log = Logger('ThemeManager');

  /// Constructor.
  ThemeManager();

  /// Material color list.
  static List<MaterialColor> list = [
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.blueGrey,
  ];

  /// Current theme.
  MaterialColor get current => list[_index];
  int _index = 0;

  /// Changes current theme.
  void change(BuildContext context, int index) {
    if (index < 0 || index >= list.length) return;

    if (_index != index) {
      _index = index;
      log.info("change theme to $_index");

      App.refresh(context);
    }
  }
}
