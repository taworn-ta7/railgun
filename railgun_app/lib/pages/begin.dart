import 'dart:async';
import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:railgun_client_dart/railgun_client_models.dart' as models;
import 'package:shared_preferences/shared_preferences.dart';
import '../i18n/strings.g.dart';
import '../validators/validate.dart';
import '../widgets/back_drop.dart';
import '../services/localization.dart';
import '../services/app_share.dart';
import '../styles.dart';
import '../embed.dart';
import '../pages.dart';
import '../pages/members/sign_up.dart';
import '../pages/members/forgot_password.dart';

/// BeginPage class.
class BeginPage extends StatefulWidget {
  const BeginPage({Key? key}) : super(key: key);

  @override
  State<BeginPage> createState() => _BeginState();
}

/// _BeginState internal class.
class _BeginState extends State<BeginPage> {
  static final log = Logger('BeginPage');
  static final appShare = AppShare.instance();

  // widgets
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailText;
  late TextEditingController _passwordText;
  late bool _obscurePassword;
  late bool _isRememberChecked;
  late Timer _initTimer;

  @override
  void initState() {
    super.initState();
    _emailText = TextEditingController();
    _passwordText = TextEditingController();
    _obscurePassword = true;
    _isRememberChecked = false;
    _initTimer = Timer(const Duration(), _handleInit);
    log.fine("$this initState()");
  }

  @override
  void dispose() {
    log.fine("$this dispose()");
    _initTimer.cancel();
    _passwordText.dispose();
    _emailText.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------------------

  /// Built widget tree.
  @override
  Widget build(BuildContext context) {
    final tr = t.beginPage;
    final localization = Localization.instance();

    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/app.png'),
        title: Text(tr.title),
        actions: [
          // Thai language
          IconButton(
            icon: Image.asset('assets/locales/th.png'),
            tooltip: t.switchLocale.th,
            onPressed: () => setState(
              () => localization.change(context, 'th'),
            ),
          ),

          // English language
          IconButton(
            icon: Image.asset('assets/locales/en.png'),
            tooltip: t.switchLocale.en,
            onPressed: () => setState(
              () => localization.change(context, 'en'),
            ),
          ),
        ],
      ),
      body: BackDrop(
        asset: 'assets/backdrops/00-begin.png',
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
                      counterText: "",
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
                      counterText: "",
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

                  Row(
                    children: [
                      // remember sign-in
                      Checkbox(
                        value: _isRememberChecked,
                        onChanged: (value) => setState(() {
                          _isRememberChecked = value!;
                        }),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            style: Styles.linkButton(),
                            child: Text(tr.remember),
                            onPressed: () => setState(() {
                              _isRememberChecked = !_isRememberChecked;
                            }),
                          ),
                        ),
                      ),

                      // forgot password
                      TextButton(
                        style: Styles.linkButton(),
                        child: Text(tr.forgotPassword),
                        onPressed: () => _forgotPassword(),
                      ),
                    ],
                  ),
                  Styles.betweenVertical(),

                  // sign-in
                  ElevatedButton.icon(
                    icon: const Icon(Icons.login),
                    label: Styles.buttonPadding(Text(tr.ok)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _signIn();
                      }
                    },
                  ),
                  Styles.betweenVertical(),

                  // - or -
                  Container(
                    alignment: Alignment.center,
                    child: Text(tr.or),
                  ),
                  Styles.betweenVertical(),

                  // sign-up
                  ElevatedButton.icon(
                    icon: const Icon(Icons.app_registration),
                    label: Styles.buttonPadding(Text(tr.signUp)),
                    onPressed: () {
                      _signUp();
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

  /// Go to sign-up page.
  Future<void> _signUp() async {
    await Pages.switchPage(context, const SignUpPage());
  }

  /// Go to forgot password page.
  Future<void> _forgotPassword() async {
    await Pages.switchPage(
      context,
      ForgotPasswordPage(
        email: _emailText.text,
      ),
    );
  }

  /// Sign-in to system.
  Future<void> _signIn() async {
    // sign-in
    if (!await appShare.signIn(
      context,
      email: _emailText.text.trim(),
      password: _passwordText.text,
    )) return;

    // saves sign-in
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('member.remember', _isRememberChecked);
    if (_isRememberChecked) {
      await prefs.setString('member.email', _emailText.text);
      await prefs.setString('member.password', _passwordText.text);
    } else {
      await prefs.remove('member.email');
      await prefs.remove('member.password');
    }

    // switch page
    if (mounted) await Navigator.pushNamed(context, Pages.dashboard);
  }

  // ----------------------------------------------------------------------

  /// A time-consuming initialization.
  Future<void> _handleInit() async {
    if (!kIsWeb) {
      {
        final res = await http.get(Embed.url(''));
        log.finer(
            "${res.request?.method} ${res.request?.url} ${res.statusCode}");
        log.finer("body: ${res.body}");
      }

      {
        final res = await http.post(Embed.url('echo/ECHO'));
        log.finer(
            "${res.request?.method} ${res.request?.url} ${res.statusCode}");
        log.finer("body: ${res.body}");
      }

      {
        final res = await http.post(Embed.url(''));
        log.finer(
            "${res.request?.method} ${res.request?.url} ${res.statusCode}");
        log.finer("body: ${res.body}");
      }
    }

    // load previous session
    final prefs = await SharedPreferences.getInstance();
    _isRememberChecked = prefs.getBool('member.remember') ?? false;
    if (_isRememberChecked) {
      _emailText.text = prefs.getString('member.email') ?? '';
      _passwordText.text = prefs.getString('member.password') ?? '';
    }
    setState(() {});

    // check last sign-in
    if (_isRememberChecked) {
      final signin = prefs.getBool('member.signin') ?? false;
      if (signin) {
        // automatically sign-in
        // ignore: use_build_context_synchronously
        if (!await appShare.signIn(
          context,
          email: _emailText.text.trim(),
          password: _passwordText.text,
        )) return;

        // switch page
        if (mounted) await Navigator.pushNamed(context, Pages.dashboard);
      }
    }
  }
}
