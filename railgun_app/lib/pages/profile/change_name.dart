import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:railgun_client_dart/railgun_client_dart.dart';
import 'package:railgun_client_dart/railgun_client_models.dart' as models;
import 'package:railgun_client_dart/railgun_client_services.dart' as services;
import '../../i18n/strings.g.dart';
import '../../validators/validate.dart';
import '../../widgets/back_drop.dart';
import '../../services/service_runner.dart';
import '../../services/app_share.dart';
import '../../styles.dart';
import '../../pages.dart';
import '../../ui/custom_app_bar.dart';

/// ChangeNamePage class.
class ChangeNamePage extends StatefulWidget {
  const ChangeNamePage({Key? key}) : super(key: key);

  @override
  State<ChangeNamePage> createState() => _ChangeNameState();
}

/// _ChangeNameState internal class.
class _ChangeNameState extends State<ChangeNamePage> {
  static final log = Logger('ChangeNamePage');
  static final appShare = AppShare.instance();

  // widgets
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameText;

  @override
  void initState() {
    super.initState();
    _nameText = TextEditingController(text: appShare.authen.member!.name);
    log.fine("$this initState()");
  }

  @override
  void dispose() {
    log.fine("$this dispose()");
    _nameText.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------------------

  /// Built widget tree.
  @override
  Widget build(BuildContext context) {
    final tr = t.changeNamePage;

    return WillPopScope(
      onWillPop: _beforeBack,
      child: Scaffold(
        appBar: CustomAppBar(
          title: tr.title,
        ),
        body: BackDrop(
          asset: 'assets/backdrops/11-profile-name.png',
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Styles.around(
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // name
                    TextFormField(
                      decoration: InputDecoration(
                        border: Styles.inputBorder(),
                        labelText: tr.name,
                        prefixIcon: const Icon(Icons.face),
                      ),
                      maxLength: models.Member.nameMax,
                      keyboardType: TextInputType.name,
                      validator: (value) => checkValidate([
                        () => FieldValidators.checkMinLength(value, 1),
                      ]),
                      controller: _nameText,
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
      ),
    );
  }

  // ----------------------------------------------------------------------

  /// Confirms before leave page.
  Future<bool> _beforeBack() async {
    final isChanged = _nameText.text != appShare.authen.member!.name;
    return Pages.beforeBack(context, isChanged);
  }

  // ----------------------------------------------------------------------

  /// Saves data.
  Future<void> _save() async {
    final client = appShare.client;

    // calls REST
    final RestResult? rest = await ServiceRunner.execute(
      context,
      () async {
        return await services.profileChangeName(
          client,
          name: _nameText.text,
        );
      },
    );
    if (rest == null || !rest.ok) return;
    final item = services.toMember(rest, log);

    // updates client member
    appShare.authen.updateMember(item);

    // goes back
    if (mounted) Navigator.pop(context, true);
  }
}
