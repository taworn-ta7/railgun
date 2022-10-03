import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
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
import '../../ui/custom_app_bar.dart';

/// ChangePasswordPage class.
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordState();
}

/// _ChangePasswordState internal class.
class _ChangePasswordState extends State<ChangePasswordPage> {
  static final log = Logger('ChangePasswordPage');
  static final appShare = AppShare.instance();

  // widgets
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _currentPasswordText;
  late TextEditingController _newPasswordText;
  late TextEditingController _confirmPasswordText;
  late bool _obscureCurrentPassword;
  late bool _obscureNewPassword;
  late bool _obscureConfirmPassword;

  @override
  void initState() {
    super.initState();
    _currentPasswordText = TextEditingController();
    _newPasswordText = TextEditingController();
    _confirmPasswordText = TextEditingController();
    _obscureCurrentPassword = true;
    _obscureNewPassword = true;
    _obscureConfirmPassword = true;
    log.fine("$this initState()");
  }

  @override
  void dispose() {
    log.fine("$this dispose()");
    _confirmPasswordText.dispose();
    _newPasswordText.dispose();
    _currentPasswordText.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------------------

  /// Built widget tree.
  @override
  Widget build(BuildContext context) {
    final tr = t.changePasswordPage;

    return Scaffold(
      appBar: CustomAppBar(
        title: tr.title,
      ),
      body: BackDrop(
        asset: 'assets/backdrops/12-profile-password.png',
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Styles.around(
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // current password
                  TextFormField(
                    decoration: InputDecoration(
                      border: Styles.inputBorder(),
                      labelText: tr.currentPassword,
                      prefixIcon: const Icon(Icons.lock_rounded),
                      suffixIcon: GestureDetector(
                        onTap: () => setState(() {
                          _obscureCurrentPassword = !_obscureCurrentPassword;
                        }),
                        child: Icon(_obscureCurrentPassword
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
                    obscureText: _obscureCurrentPassword,
                    controller: _currentPasswordText,
                  ),
                  Styles.betweenVertical(),

                  // new password
                  TextFormField(
                    decoration: InputDecoration(
                      border: Styles.inputBorder(),
                      labelText: tr.newPassword,
                      prefixIcon: const Icon(Icons.lock_rounded),
                      suffixIcon: GestureDetector(
                        onTap: () => setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        }),
                        child: Icon(_obscureNewPassword
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
                    obscureText: _obscureNewPassword,
                    controller: _newPasswordText,
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
                      () => value == _newPasswordText.text
                          ? null
                          : t.validator.isSamePasswords,
                    ]),
                    obscureText: _obscureConfirmPassword,
                    controller: _confirmPasswordText,
                  ),
                  Styles.betweenVertical(),

                  // ok
                  ElevatedButton.icon(
                    icon: const Icon(Icons.update),
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

  /// Saves data.
  Future<void> _save() async {
    final client = appShare.client;

    // calls REST
    final RestResult? rest = await ServiceRunner.execute(
      context,
      () async {
        return await services.profileChangePassword(
          client,
          currentPassword: _currentPasswordText.text,
          newPassword: _newPasswordText.text,
          confirmPassword: _confirmPasswordText.text,
        );
      },
    );
    if (rest == null || !rest.ok) return;

    // sign-out
    if (mounted) await MessageBox.info(context, t.changePasswordPage.confirm);
    if (mounted) appShare.signOut(context);
  }
}
