import 'package:flutter/material.dart';
import 'package:railgun_client_dart/railgun_client_dart.dart';
import '../i18n/strings.g.dart';
import '../helpers/http_error.dart';
import '../widgets/message_box.dart';
import '../widgets/wait_box.dart';
import './localization.dart';

/// Calls service helper.
class ServiceRunner {
  static Future<RestResult?> execute(
    BuildContext context,
    Future<RestResult> Function() task,
  ) async {
    while (true) {
      // run and wait
      final result = await WaitBox.show<RestResult>(context, task);
      if (result.ok) {
        return result;
      }

      // gets error message
      late String message;
      if (result.error == null) {
        message = t.serviceRunner.message;
      } else {
        message = HttpError.get(
            result.error!, Localization.instance().current.languageCode);
      }

      // shows question dialog box
      final answer = await MessageBox.show(
        context: context,
        message: message,
        caption: t.messageBox.warning,
        options: MessageBoxOptions(
          type: MessageBoxType.retryCancel,
          titleColor: Colors.orange,
          barrierDismissible: true,
          button1Negative: true,
        ),
      );
      if (answer == null || answer == false) {
        return null;
      }
    }
  }
}
