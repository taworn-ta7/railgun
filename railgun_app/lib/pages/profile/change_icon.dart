import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:railgun_client_dart/railgun_client_dart.dart';
import 'package:railgun_client_dart/railgun_client_services.dart' as services;
import 'package:file_picker/file_picker.dart';
import '../../i18n/strings.g.dart';
import '../../widgets/back_drop.dart';
import '../../widgets/image_chooser.dart';
import '../../services/service_runner.dart';
import '../../services/app_share.dart';
import '../../styles.dart';
import '../../pages.dart';
import '../../ui/custom_app_bar.dart';

/// ChangeIconPage class.
class ChangeIconPage extends StatefulWidget {
  const ChangeIconPage({Key? key}) : super(key: key);

  @override
  State<ChangeIconPage> createState() => _ChangeIconState();
}

/// _ChangeIconState internal class.
class _ChangeIconState extends State<ChangeIconPage> {
  static final log = Logger('ChangeIconPage');
  static final appShare = AppShare.instance();

  // widgets
  final _formKey = GlobalKey<FormState>();
  late bool _imageEditing;
  late PlatformFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _imageEditing = false;
    _imageFile = null;
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
    final tr = t.changeIconPage;

    return WillPopScope(
      onWillPop: _beforeBack,
      child: Scaffold(
        appBar: CustomAppBar(
          title: tr.title,
        ),
        body: BackDrop(
          asset: 'assets/backdrops/10-profile-icon.png',
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Styles.around(
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // icon
                    Text(
                      tr.icon,
                      style: Styles.titleTextStyle(),
                    ),
                    ImageChooser(
                      width: 128,
                      height: 128,
                      asset: 'assets/default-profile-icon.png',
                      bits: appShare.authen.icon,
                      onUpload: (file) {
                        _imageEditing = true;
                        _imageFile = file;
                      },
                      onReset: () {
                        _imageEditing = true;
                        _imageFile = null;
                      },
                      onRevert: () {
                        _imageEditing = false;
                      },
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

  /// Before leaving page.
  Future<bool> _beforeBack() async {
    final isChanged = _imageEditing;
    return Pages.beforeBack(context, isChanged);
  }

  // ----------------------------------------------------------------------

  /// Saves data.
  Future<void> _save() async {
    final client = appShare.client;

    if (_imageEditing) {
      if (_imageFile != null) {
        log.finest("image upload");

        // prepares uploading file
        final path = _imageFile!.name;
        final mime = lookupMimeType(path, headerBytes: _imageFile!.bytes);
        final file = http.MultipartFile.fromBytes(
          'image',
          _imageFile!.bytes!,
          filename: _imageFile!.name,
          contentType: MediaType.parse(mime ?? ''),
        );

        // uploads
        final RestResult? rest = await ServiceRunner.execute(
          context,
          () async {
            return await services.profileUploadIcon(
              client,
              file: file,
            );
          },
        );
        if (rest == null || !rest.ok) return;
        appShare.authen.updateIcon(_imageFile!.bytes!);
      } else {
        log.finest("image reset");

        // calls REST
        final RestResult? rest = await ServiceRunner.execute(
          context,
          () async {
            return await services.profileDeleteIcon(
              client,
            );
          },
        );
        if (rest == null || !rest.ok) return;
        appShare.authen.updateIcon(null);
      }
    }

    // go back
    if (mounted) Navigator.pop(context, true);
  }
}
