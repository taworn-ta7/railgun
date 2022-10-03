import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import '../i18n/strings.g.dart';
import '../helpers/formatter.dart';
import '../widgets/back_drop.dart';
import '../services/app_share.dart';
import '../styles.dart';
import '../ui/custom_app_bar.dart';
import '../ui/custom_drawer.dart';

/// DashboardPage class.
class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardState();
}

/// _DashboardState internal class.
class _DashboardState extends State<DashboardPage> {
  static final log = Logger('DashboardPage');
  static final appShare = AppShare.instance();

  @override
  void initState() {
    super.initState();
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
    final tr = t.dashboardPage;
    final member = appShare.authen.member!;

    return Scaffold(
      appBar: CustomAppBar(
        title: tr.title,
        withMoreMenu: true,
        onResult: (menu, result) => setState(() {}),
      ),
      drawer: const CustomDrawer(),
      body: BackDrop(
        asset: 'assets/backdrops/09-dashboard.png',
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
                Text(member.email, style: Styles.titleTextStyle()),
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
                      DataCell(Text(member.role)),
                    ]),
                    DataRow(cells: <DataCell>[
                      DataCell(Text(tr.locale)),
                      DataCell(Text(member.locale)),
                    ]),
                    DataRow(cells: <DataCell>[
                      DataCell(Text(tr.name)),
                      DataCell(Text(member.name)),
                    ]),
                    DataRow(cells: <DataCell>[
                      DataCell(Text(tr.signup)),
                      DataCell(Text(
                          Formatter.dateTimeFormat.format(member.created!))),
                    ]),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final icon = appShare.authen.icon;
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
}
