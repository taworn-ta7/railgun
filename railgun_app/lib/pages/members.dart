import 'dart:async';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:railgun_client_dart/railgun_client_dart.dart';
import 'package:railgun_client_dart/railgun_client_models.dart' as models;
import 'package:railgun_client_dart/railgun_client_services.dart' as services;
import '../i18n/strings.g.dart';
import '../widgets/back_drop.dart';
import '../widgets/paginator.dart';
import '../services/service_runner.dart';
import '../services/app_share.dart';
import '../pages.dart';
import '../ui/custom_app_bar.dart';
import '../ui/custom_drawer.dart';
import './member_edit.dart';

/// MembersPage class.
class MembersPage extends StatefulWidget {
  const MembersPage({Key? key}) : super(key: key);

  @override
  State<MembersPage> createState() => _MembersState();
}

/// _MembersState internal class.
class _MembersState extends State<MembersPage> {
  static final log = Logger('MembersPage');
  static final appShare = AppShare.instance();

  // data
  final items = <models.MemberIcon>[];

  // page
  int _pageCount = 0;
  int _pageIndex = 0;

  // order
  final tr = t.membersPage.sortBy;
  final Map<String, String> _orderingMap = {
    '': t.membersPage.sortBy.id,
    'email+': t.membersPage.sortBy.emailAsc,
    'email-': t.membersPage.sortBy.emailDesc,
    'created+': t.membersPage.sortBy.signUpAsc,
    'created-': t.membersPage.sortBy.signUpDesc,
  };
  String _orderingSelected = '';

  // search
  String _searchText = '';

  // trash
  bool _isTrashed = false;

  // initial timer handler
  late Timer _initTimer;

  // loading icon in background, with items[_loadingIndex]
  int _loadingIndex = 0;

  // loading background handler
  Timer? _loadTimer;

  @override
  void initState() {
    super.initState();
    _initTimer = Timer(const Duration(), _handleInit);
    _loadTimer = null;
    log.fine("$this initState()");
  }

  @override
  void dispose() {
    log.fine("$this dispose()");
    _loadTimer?.cancel();
    _initTimer.cancel();
    super.dispose();
  }

  // ----------------------------------------------------------------------

  /// Built widget tree.
  @override
  Widget build(BuildContext context) {
    final tr = t.membersPage;

    return Scaffold(
      appBar: CustomAppBar(
        title: tr.title,
        searchBox: true,
        onSearchTextChanged: (text) {
          setState(() {
            _searchText = text;
            _pageIndex = 0;
          });
          _refresh();
        },
      ),
      drawer: const CustomDrawer(),
      body: BackDrop(
        asset: 'assets/backdrops/30-members.png',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
                children: [
                  // ordering
                  Flexible(
                    flex: 1,
                    child: DropdownButton<String>(
                      isExpanded: true,
                      items: _orderingMap
                          .map((value, text) {
                            return MapEntry(
                              value,
                              DropdownMenuItem<String>(
                                value: value,
                                child: Text(text),
                              ),
                            );
                          })
                          .values
                          .toList(),
                      value: _orderingSelected,
                      onChanged: (value) {
                        setState(() {
                          _orderingSelected = value ??= '';
                        });
                        _refresh();
                      },
                    ),
                  ),

                  // trash only
                  IconButton(
                    icon: Icon(_isTrashed ? Icons.delete : Icons.description),
                    tooltip: tr.trash,
                    onPressed: () => setState(() {
                      _isTrashed = !_isTrashed;
                      _refresh();
                    }),
                  ),
                ],
              ),
            ),

            // list view
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: ListView(
                  children: items.map((item) {
                    return ListTile(
                      leading: item.icon == null
                          ? Image.asset('assets/default-profile-icon.png')
                          : Image.memory(item.icon!),
                      title: Text(item.member.email),
                      subtitle: Text(item.member.name),
                      trailing: Icon((item.member.disabled != null) ||
                              (item.member.resigned != null)
                          ? Icons.disabled_by_default
                          : Icons.run_circle),
                      onTap: () => _editItem(item),
                    );
                  }).toList(),
                ),
              ),
            ),

            // paginator
            Container(
              alignment: Alignment.bottomLeft,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: Colors.grey),
                ),
              ),
              child: Paginator(
                pageIndex: _pageIndex,
                pageCount: _pageCount,
                onPageRefresh: (pageIndex, pageCount) {
                  _pageIndex = pageIndex;
                  _refresh();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------

  Future<void> _handleInit() async {
    await _refresh();
  }

  Future<void> _refresh() async {
    final client = appShare.client;

    // calls REST
    final RestResult? rest = await ServiceRunner.execute(
      context,
      () async {
        return await services.membersList(
          client,
          queryPage: QueryPage(
            page: _pageIndex,
            order: _orderingSelected,
            search: _searchText,
            trash: _isTrashed,
          ).toQueryMap(),
        );
      },
    );
    if (rest == null || !rest.ok) return;

    // gets result
    items.clear();
    items.addAll(services.toMemberIconIterable(rest, log));

    // updates pagination
    final pagination = services.toPagination(rest, log);
    _pageIndex = pagination.pageIndex;
    _pageCount = pagination.pageCount;

    // refresh UI
    setState(() {});

    // loads icons in background
    _loadingIndex = 0;
    _loadTimer = Timer(const Duration(milliseconds: 1), _handleLoad);
  }

  Future<void> _handleLoad() async {
    if (_loadingIndex < items.length) {
      final client = appShare.client;
      final item = items[_loadingIndex];

      final rest = await services.membersGetIcon(
        client,
        email: item.member.email,
      );
      if (rest.ok) {
        setState(() {
          item.icon = rest.res!.bodyBytes;
        });
      }
      _loadingIndex++;
      _loadTimer = Timer(const Duration(milliseconds: 1), _handleLoad);
    }
  }

  // ----------------------------------------------------------------------

  Future<void> _editItem(models.MemberIcon o) async {
    final client = appShare.client;

    // calls REST
    models.Member? member;
    final RestResult? rest = await ServiceRunner.execute(
      context,
      () async {
        final rest = await services.membersGet(
          client,
          email: o.member.email,
        );
        if (rest.ok) {
          member = models.Member.fromJson(rest.json!['member']);
        }
        return rest;
      },
    );
    if (rest == null || !rest.ok) return;

    // opens editing page
    if (mounted) {
      final answer = await Pages.switchPage(
        context,
        MemberEditPage(item: member!, icon: o.icon),
      );
      if (answer != null) {
        _refresh();
      }
    }
  }
}
