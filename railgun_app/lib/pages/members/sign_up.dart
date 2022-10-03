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
import '../../services/localization.dart';
import '../../services/service_runner.dart';
import '../../services/app_share.dart';
import '../../styles.dart';

/// SignUpPage class.
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpState();
}

/// _SignUpState internal class.
class _SignUpState extends State<SignUpPage> {
  static final log = Logger('SignUpPage');
  static final appShare = AppShare.instance();

  // widgets
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailText;
  late TextEditingController _passwordText;
  late TextEditingController _confirmPasswordText;
  late bool _obscurePassword;
  late bool _obscureConfirmPassword;

  @override
  void initState() {
    super.initState();
    _emailText = TextEditingController();
    _passwordText = TextEditingController();
    _confirmPasswordText = TextEditingController();
    _obscurePassword = true;
    _obscureConfirmPassword = true;
    log.fine("$this initState()");
  }

  @override
  void dispose() {
    log.fine("$this dispose()");
    _confirmPasswordText.dispose();
    _passwordText.dispose();
    _emailText.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------------------

  /// Built widget tree.
  @override
  Widget build(BuildContext context) {
    final tr = t.signUpPage;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.title),
      ),
      body: BackDrop(
        asset: 'assets/backdrops/01-signup.png',
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

                  // password
                  TextFormField(
                    decoration: InputDecoration(
                      border: Styles.inputBorder(),
                      labelText: tr.password,
                      prefixIcon: const Icon(Icons.lock_rounded),
                      suffixIcon: GestureDetector(
                        onTap: () => setState(() {
                          _obscurePassword = !_obscurePassword;
                        }),
                        child: Icon(_obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                    maxLength: models.Member.passwordMax,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) => checkValidate([
                      () => FieldValidators.checkMinLength(
                          value, models.Member.passwordMin),
                      () => FieldValidators.checkMaxLength(
                          value, models.Member.passwordMax),
                    ]),
                    obscureText: _obscurePassword,
                    controller: _passwordText,
                  ),
                  Styles.betweenVertical(),

                  // confirm password
                  TextFormField(
                    decoration: InputDecoration(
                      border: Styles.inputBorder(),
                      labelText: tr.confirmPassword,
                      prefixIcon: const Icon(Icons.lock_rounded),
                      suffixIcon: GestureDetector(
                        onTap: () => setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        }),
                        child: Icon(_obscureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                    maxLength: models.Member.passwordMax,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) => checkValidate([
                      () => FieldValidators.checkMinLength(
                          value, models.Member.passwordMin),
                      () => FieldValidators.checkMaxLength(
                          value, models.Member.passwordMax),
                      () => value == _passwordText.text
                          ? null
                          : t.validator.isSamePasswords,
                    ]),
                    obscureText: _obscureConfirmPassword,
                    controller: _confirmPasswordText,
                  ),
                  Styles.betweenVertical(),

                  // register
                  ElevatedButton.icon(
                    icon: const Icon(Icons.app_registration),
                    label: Styles.buttonPadding(Text(tr.ok)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _save();
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

  /// Saves sign-up form.
  Future<void> _save() async {
    final localization = Localization.instance();
    final client = appShare.client;

    // calls REST
    final RestResult? rest = await ServiceRunner.execute(
      context,
      () async {
        return await services.membersSignUp(
          client,
          email: _emailText.text.trim(),
          password: _passwordText.text,
          confirmPassword: _confirmPasswordText.text,
          locale: localization.current.languageCode,
        );
      },
    );
    if (rest == null || !rest.ok) return;
    final item = services.toMemberSignUp(rest);
    log.finer("sign-up: $item");

    // reminds member to confirm sign-up
    if (mounted) await MessageBox.info(context, t.signUpPage.confirm);
    if (mounted) Navigator.pop(context);
  }
}
