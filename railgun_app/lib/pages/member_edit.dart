import 'dart:typed_data';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:railgun_client_dart/railgun_client_dart.dart';
import 'package:railgun_client_dart/railgun_client_models.dart' as models;
import 'package:railgun_client_dart/railgun_client_services.dart' as services;
import '../i18n/strings.g.dart';
import '../helpers/formatter.dart';
import '../widgets/back_drop.dart';
import '../services/service_runner.dart';
import '../services/app_share.dart';
import '../styles.dart';
import '../ui/custom_app_bar.dart';

/// MemberEditPage class.
class MemberEditPage extends StatefulWidget {
  final models.Member item;
  final Uint8List? icon;

  const MemberEditPage({
    Key? key,
    required this.item,
    required this.icon,
  }) : super(key: key);

  @override
  State<MemberEditPage> createState() => _MemberEditState();
}

/// _MemberEditState internal class.
class _MemberEditState extends State<MemberEditPage> {
  static final log = Logger('MemberEditPage');
  static final appShare = AppShare.instance();

  // widgets
  final _formKey = GlobalKey<FormState>();
  late bool _isDisabled;

  @override
  void initState() {
    super.initState();
    _isDisabled = widget.item.disabled != null;
    log.fine("$this initState()");
  }

  @override
  void dispose() {
    log.fine("$this dispose()");
    super.dispose();
  }

  // ----------------------------------------------------------------------

  /// Built widget tree.
  @override
  Widget build(BuildContext context) {
    final tr = t.memberEditPage;

    return Scaffold(
      appBar: CustomAppBar(
        title: tr.title(name: widget.item.email),
      ),
      body: BackDrop(
        asset: 'assets/backdrops/31-member-edit.png',
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Styles.around(
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // icon
                  _buildImage(context),
                  Styles.betweenVertical(),

                  // email
                  Text(widget.item.email, style: Styles.titleTextStyle()),
                  Styles.betweenVertical(),

                  // data table
                  DataTable(
                    columns: <DataColumn>[
                      DataColumn(label: Text(t.common.name)),
                      DataColumn(label: Text(t.common.value)),
                    ],
                    rows: <DataRow>[
                      DataRow(cells: <DataCell>[
                        DataCell(Text(tr.role)),
                        DataCell(Text(widget.item.role)),
                      ]),
                      DataRow(cells: <DataCell>[
                        DataCell(Text(tr.locale)),
                        DataCell(Text(widget.item.locale)),
                      ]),
                      DataRow(cells: <DataCell>[
                        DataCell(Text(tr.name)),
                        DataCell(Text(widget.item.name)),
                      ]),
                      DataRow(cells: <DataCell>[
                        DataCell(Text(tr.disabled)),
                        DataCell(Text(widget.item.disabled != null
                            ? Formatter.dateTimeFormat
                                .format(widget.item.disabled!)
                            : '')),
                      ]),
                      DataRow(cells: <DataCell>[
                        DataCell(Text(tr.resigned)),
                        DataCell(Text(widget.item.resigned != null
                            ? Formatter.dateTimeFormat
                                .format(widget.item.resigned!)
                            : '')),
                      ]),
                      DataRow(cells: <DataCell>[
                        DataCell(Text(tr.signup)),
                        DataCell(Text(Formatter.dateTimeFormat
                            .format(widget.item.created!))),
                      ]),
                    ],
                  ),
                  Styles.betweenVertical(),

                  // disabled
                  CheckboxListTile(
                    title: Text(tr.disable),
                    secondary: const Icon(Icons.disabled_by_default),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: _isDisabled,
                    onChanged: (value) => setState(() {
                      _isDisabled = value!;
                    }),
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

  Widget _buildImage(BuildContext context) {
    final icon = widget.icon;
    if (icon != null) {
      return Image.memory(
        icon,
        width: 128,
        height: 128,
        fit: BoxFit.contain,
      );
    } else {
      return Image.asset(
        'assets/default-profile-icon.png',
        width: 128,
        height: 128,
        fit: BoxFit.contain,
      );
    }
  }

  // ----------------------------------------------------------------------

  /// Saves data.
  Future<void> _save() async {
    if (_isDisabled == (widget.item.disabled != null)) {
      Navigator.pop(context);
      return;
    }

    final client = appShare.client;

    // calls REST
    final RestResult? rest = await ServiceRunner.execute(
      context,
      () async {
        return await services.adminMembersDisable(
          client,
          email: widget.item.email,
          disabled: _isDisabled,
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
