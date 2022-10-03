import 'dart:async';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:railgun_client_dart/railgun_client_dart.dart';
import 'package:railgun_client_dart/railgun_client_models.dart' as models;
import 'package:railgun_client_dart/railgun_client_services.dart' as services;
import '../../i18n/strings.g.dart';
import '../../validators/validate.dart';
import '../../widgets/back_drop.dart';
import '../../widgets/message_box.dart';
import '../../services/service_runner.dart';
import '../../services/app_share.dart';
import '../../styles.dart';

/// ForgotPasswordPage class.
class ForgotPasswordPage extends StatefulWidget {
  final String email;

  const ForgotPasswordPage({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordState();
}

/// _ForgotPasswordState internal class.
class _ForgotPasswordState extends State<ForgotPasswordPage> {
  static final log = Logger('ForgotPasswordPage');
  static final appShare = AppShare.instance();

  // widgets
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailText;

  @override
  void initState() {
    super.initState();
    _emailText = TextEditingController(text: widget.email);
    log.fine("$this initState()");
  }

  @override
  void dispose() {
    log.fine("$this dispose()");
    _emailText.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------------------

  /// Built widget tree.
  @override
  Widget build(BuildContext context) {
    final tr = t.forgotPasswordPage;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.title),
      ),
      body: BackDrop(
        asset: 'assets/backdrops/02-forgot.png',
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Styles.around(
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // email
                  TextFormField(
                    decoration: InputDecoration(
                      border: Styles.inputBorder(),
                      labelText: tr.email,
                      prefixIcon: const Icon(Icons.email),
                    ),
                    maxLength: models.Member.emailMax,
                    keyboardType: TextInputType.emailAddress,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'[ \t]')),
                    ],
                    validator: (value) => checkValidate([
                      () => FieldValidators.checkEmail(value),
                    ]),
                    controller: _emailText,
                  ),
                  Styles.betweenVertical(),

                  // send email
                  ElevatedButton.icon(
                    icon: const Icon(Icons.send),
                    label: Styles.buttonPadding(Text(tr.ok)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _sendEmail();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------

  /// Sends email service.
  Future<void> _sendEmail() async {
    final client = appShare.client;

    // calls REST
    final RestResult? rest = await ServiceRunner.execute(
      context,
      () async {
        return await services.membersPasswordReset(
          client,
          email: _emailText.text.trim(),
        );
      },
    );
    if (rest == null || !rest.ok) return;
    final item = services.toMemberReset(rest);
    log.finer("reset: $item");

    // reminds member to check mail
    if (mounted) await MessageBox.info(context, t.forgotPasswordPage.check);
    if (mounted) Navigator.pop(context);
  }
}
