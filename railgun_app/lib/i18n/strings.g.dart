
/*
 * Generated file. Do not edit.
 *
 * Locales: 2
 * Strings: 250 (125.0 per locale)
 *
 * Built on 2022-10-01 at 06:48 UTC
 */

import 'package:flutter/widgets.dart';

const AppLocale _baseLocale = AppLocale.en;
AppLocale _currLocale = _baseLocale;

/// Supported locales, see extension methods below.
///
/// Usage:
/// - LocaleSettings.setLocale(AppLocale.en) // set locale
/// - Locale locale = AppLocale.en.flutterLocale // get flutter locale from enum
/// - if (LocaleSettings.currentLocale == AppLocale.en) // locale check
enum AppLocale {
	en, // 'en' (base locale, fallback)
	th, // 'th'
}

/// Method A: Simple
///
/// No rebuild after locale change.
/// Translation happens during initialization of the widget (call of t).
///
/// Usage:
/// String a = t.someKey.anotherKey;
/// String b = t['someKey.anotherKey']; // Only for edge cases!
_StringsEn _t = _currLocale.translations;
_StringsEn get t => _t;

/// Method B: Advanced
///
/// All widgets using this method will trigger a rebuild when locale changes.
/// Use this if you have e.g. a settings page where the user can select the locale during runtime.
///
/// Step 1:
/// wrap your App with
/// TranslationProvider(
/// 	child: MyApp()
/// );
///
/// Step 2:
/// final t = Translations.of(context); // Get t variable.
/// String a = t.someKey.anotherKey; // Use t variable.
/// String b = t['someKey.anotherKey']; // Only for edge cases!
class Translations {
	Translations._(); // no constructor

	static _StringsEn of(BuildContext context) {
		final inheritedWidget = context.dependOnInheritedWidgetOfExactType<_InheritedLocaleData>();
		if (inheritedWidget == null) {
			throw 'Please wrap your app with "TranslationProvider".';
		}
		return inheritedWidget.translations;
	}
}

class LocaleSettings {
	LocaleSettings._(); // no constructor

	/// Uses locale of the device, fallbacks to base locale.
	/// Returns the locale which has been set.
	static AppLocale useDeviceLocale() {
		final locale = AppLocaleUtils.findDeviceLocale();
		return setLocale(locale);
	}

	/// Sets locale
	/// Returns the locale which has been set.
	static AppLocale setLocale(AppLocale locale) {
		_currLocale = locale;
		_t = _currLocale.translations;

		// force rebuild if TranslationProvider is used
		_translationProviderKey.currentState?.setLocale(_currLocale);

		return _currLocale;
	}

	/// Sets locale using string tag (e.g. en_US, de-DE, fr)
	/// Fallbacks to base locale.
	/// Returns the locale which has been set.
	static AppLocale setLocaleRaw(String rawLocale) {
		final locale = AppLocaleUtils.parse(rawLocale);
		return setLocale(locale);
	}

	/// Gets current locale.
	static AppLocale get currentLocale {
		return _currLocale;
	}

	/// Gets base locale.
	static AppLocale get baseLocale {
		return _baseLocale;
	}

	/// Gets supported locales in string format.
	static List<String> get supportedLocalesRaw {
		return AppLocale.values
			.map((locale) => locale.languageTag)
			.toList();
	}

	/// Gets supported locales (as Locale objects) with base locale sorted first.
	static List<Locale> get supportedLocales {
		return AppLocale.values
			.map((locale) => locale.flutterLocale)
			.toList();
	}
}

/// Provides utility functions without any side effects.
class AppLocaleUtils {
	AppLocaleUtils._(); // no constructor

	/// Returns the locale of the device as the enum type.
	/// Fallbacks to base locale.
	static AppLocale findDeviceLocale() {
		final String? deviceLocale = WidgetsBinding.instance.window.locale.toLanguageTag();
		if (deviceLocale != null) {
			final typedLocale = _selectLocale(deviceLocale);
			if (typedLocale != null) {
				return typedLocale;
			}
		}
		return _baseLocale;
	}

	/// Returns the enum type of the raw locale.
	/// Fallbacks to base locale.
	static AppLocale parse(String rawLocale) {
		return _selectLocale(rawLocale) ?? _baseLocale;
	}
}

// context enums

// interfaces generated as mixins

// translation instances

late _StringsEn _translationsEn = _StringsEn.build();
late _StringsTh _translationsTh = _StringsTh.build();

// extensions for AppLocale

extension AppLocaleExtensions on AppLocale {

	/// Gets the translation instance managed by this library.
	/// [TranslationProvider] is using this instance.
	/// The plural resolvers are set via [LocaleSettings].
	_StringsEn get translations {
		switch (this) {
			case AppLocale.en: return _translationsEn;
			case AppLocale.th: return _translationsTh;
		}
	}

	/// Gets a new translation instance.
	/// [LocaleSettings] has no effect here.
	/// Suitable for dependency injection and unit tests.
	///
	/// Usage:
	/// final t = AppLocale.en.build(); // build
	/// String a = t.my.path; // access
	_StringsEn build() {
		switch (this) {
			case AppLocale.en: return _StringsEn.build();
			case AppLocale.th: return _StringsTh.build();
		}
	}

	String get languageTag {
		switch (this) {
			case AppLocale.en: return 'en';
			case AppLocale.th: return 'th';
		}
	}

	Locale get flutterLocale {
		switch (this) {
			case AppLocale.en: return const Locale.fromSubtags(languageCode: 'en');
			case AppLocale.th: return const Locale.fromSubtags(languageCode: 'th');
		}
	}
}

extension StringAppLocaleExtensions on String {
	AppLocale? toAppLocale() {
		switch (this) {
			case 'en': return AppLocale.en;
			case 'th': return AppLocale.th;
			default: return null;
		}
	}
}

// wrappers

GlobalKey<_TranslationProviderState> _translationProviderKey = GlobalKey<_TranslationProviderState>();

class TranslationProvider extends StatefulWidget {
	TranslationProvider({required this.child}) : super(key: _translationProviderKey);

	final Widget child;

	@override
	_TranslationProviderState createState() => _TranslationProviderState();

	static _InheritedLocaleData of(BuildContext context) {
		final inheritedWidget = context.dependOnInheritedWidgetOfExactType<_InheritedLocaleData>();
		if (inheritedWidget == null) {
			throw 'Please wrap your app with "TranslationProvider".';
		}
		return inheritedWidget;
	}
}

class _TranslationProviderState extends State<TranslationProvider> {
	AppLocale locale = _currLocale;

	void setLocale(AppLocale newLocale) {
		setState(() {
			locale = newLocale;
		});
	}

	@override
	Widget build(BuildContext context) {
		return _InheritedLocaleData(
			locale: locale,
			child: widget.child,
		);
	}
}

class _InheritedLocaleData extends InheritedWidget {
	final AppLocale locale;
	Locale get flutterLocale => locale.flutterLocale; // shortcut
	final _StringsEn translations; // store translations to avoid switch call

	_InheritedLocaleData({required this.locale, required Widget child})
		: translations = locale.translations, super(child: child);

	@override
	bool updateShouldNotify(_InheritedLocaleData oldWidget) {
		return oldWidget.locale != locale;
	}
}

// pluralization feature not used

// helpers

final _localeRegex = RegExp(r'^([a-z]{2,8})?([_-]([A-Za-z]{4}))?([_-]?([A-Z]{2}|[0-9]{3}))?$');
AppLocale? _selectLocale(String localeRaw) {
	final match = _localeRegex.firstMatch(localeRaw);
	AppLocale? selected;
	if (match != null) {
		final language = match.group(1);
		final country = match.group(5);

		// match exactly
		selected = AppLocale.values
			.cast<AppLocale?>()
			.firstWhere((supported) => supported?.languageTag == localeRaw.replaceAll('_', '-'), orElse: () => null);

		if (selected == null && language != null) {
			// match language
			selected = AppLocale.values
				.cast<AppLocale?>()
				.firstWhere((supported) => supported?.languageTag.startsWith(language) == true, orElse: () => null);
		}

		if (selected == null && country != null) {
			// match country
			selected = AppLocale.values
				.cast<AppLocale?>()
				.firstWhere((supported) => supported?.languageTag.contains(country) == true, orElse: () => null);
		}
	}
	return selected;
}

// translations

// Path: <root>
class _StringsEn {

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsEn.build();

	/// Access flat map
	dynamic operator[](String key) => _flatMap[key];

	// Internal flat map initialized lazily
	late final Map<String, dynamic> _flatMap = _buildFlatMap();

	late final _StringsEn _root = this; // ignore: unused_field

	// Translations
	String get app => 'Railgun';
	late final _StringsSwitchLocaleEn switchLocale = _StringsSwitchLocaleEn._(_root);
	late final _StringsCommonEn common = _StringsCommonEn._(_root);
	late final _StringsQuestionEn question = _StringsQuestionEn._(_root);
	late final _StringsValidatorEn validator = _StringsValidatorEn._(_root);
	late final _StringsErrorEn error = _StringsErrorEn._(_root);
	late final _StringsMessageBoxEn messageBox = _StringsMessageBoxEn._(_root);
	late final _StringsWaitBoxEn waitBox = _StringsWaitBoxEn._(_root);
	late final _StringsImageChooserEn imageChooser = _StringsImageChooserEn._(_root);
	late final _StringsSearchBarEn searchBar = _StringsSearchBarEn._(_root);
	late final _StringsPaginatorEn paginator = _StringsPaginatorEn._(_root);
	late final _StringsServiceRunnerEn serviceRunner = _StringsServiceRunnerEn._(_root);
	late final _StringsAppBarEn appBar = _StringsAppBarEn._(_root);
	late final _StringsDrawerUiEn drawerUi = _StringsDrawerUiEn._(_root);
	late final _StringsBeginPageEn beginPage = _StringsBeginPageEn._(_root);
	late final _StringsSignUpPageEn signUpPage = _StringsSignUpPageEn._(_root);
	late final _StringsForgotPasswordPageEn forgotPasswordPage = _StringsForgotPasswordPageEn._(_root);
	late final _StringsDashboardPageEn dashboardPage = _StringsDashboardPageEn._(_root);
	late final _StringsChangeIconPageEn changeIconPage = _StringsChangeIconPageEn._(_root);
	late final _StringsChangeNamePageEn changeNamePage = _StringsChangeNamePageEn._(_root);
	late final _StringsChangePasswordPageEn changePasswordPage = _StringsChangePasswordPageEn._(_root);
	late final _StringsMembersPageEn membersPage = _StringsMembersPageEn._(_root);
	late final _StringsMemberEditPageEn memberEditPage = _StringsMemberEditPageEn._(_root);
	late final _StringsSettingsPageEn settingsPage = _StringsSettingsPageEn._(_root);
}

// Path: switchLocale
class _StringsSwitchLocaleEn {
	_StringsSwitchLocaleEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get en => 'Change Language to English';
	String get th => 'Change Language to ไทย';
}

// Path: common
class _StringsCommonEn {
	_StringsCommonEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get close => 'Close';
	String get ok => 'OK';
	String get cancel => 'Cancel';
	String get yes => 'Yes';
	String get no => 'No';
	String get retry => 'Retry';
	String get name => 'Name';
	String get value => 'Value';
	String get create => 'Create';
	String get createMore => 'Create...';
	String get update => 'Save';
	String get updateMore => 'Save...';
	String get remove => 'Delete';
	String get removeMore => 'Delete...';
}

// Path: question
class _StringsQuestionEn {
	_StringsQuestionEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get areYouSureToQuit => 'Are you sure to exit this program?';
	String get areYouSureToDelete => 'Are you sure to delete this item?';
	String get areYouSureToLeave => 'Are you sure to leave without save data?';
}

// Path: validator
class _StringsValidatorEn {
	_StringsValidatorEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String isMinInt({required Object min}) => 'Please input as integer, minimum >= $min.';
	String isMaxInt({required Object max}) => 'Please input as integer, maximum <= $max.';
	String get isPositiveInt => 'Please input as positive integer.';
	String get isPositiveOrZeroInt => 'Please input as positive integer or zero.';
	String get isNegativeInt => 'Please input as negative integer.';
	String get isNegativeOrZeroInt => 'Please input as negative integer or zero.';
	String isMinFloat({required Object min}) => 'Please input as floating-point, minimum >= $min.';
	String isMaxFloat({required Object max}) => 'Please input as floating-point, maximum <= $max.';
	String get isPositiveFloat => 'Please input as positive floating-point.';
	String get isPositiveOrZeroFloat => 'Please input as positive floating-point or zero.';
	String get isNegativeFloat => 'Please input as negative floating-point.';
	String get isNegativeOrZeroFloat => 'Please input as negative floating-point or zero.';
	String get isMoney => 'Please input as money.';
	String isMinLength({required Object min}) => 'Please input length >= $min.';
	String isMaxLength({required Object max}) => 'Please input length <= $max.';
	String get isEmail => 'Please input as email.';
	String get isSamePasswords => 'Password and confirm password must be equal.';
}

// Path: error
class _StringsErrorEn {
	_StringsErrorEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get e400 => 'You send request incorrect parameters!';
	String get e401 => 'You are unauthorized!';
	String get e402 => 'Your payment is required!';
	String get e403 => 'You are forbidden!';
	String get e404 => 'Data not found!';
	String get e405 => 'Method not allowed!';
	String get e406 => 'Not acceptable!';
	String get e418 => 'I\'m a teapot!';
	String unknown({required Object statusCode}) => 'HTTP error, status code=$statusCode!';
}

// Path: messageBox
class _StringsMessageBoxEn {
	_StringsMessageBoxEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get info => 'Information';
	String get warning => 'Warning';
	String get error => 'Error';
	String get question => 'Question';
}

// Path: waitBox
class _StringsWaitBoxEn {
	_StringsWaitBoxEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get message => 'Please wait...';
}

// Path: imageChooser
class _StringsImageChooserEn {
	_StringsImageChooserEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get upload => 'Upload';
	String get reset => 'Reset';
	String get revert => 'Revert';
}

// Path: searchBar
class _StringsSearchBarEn {
	_StringsSearchBarEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get open => 'Open search...';
	String get hint => 'Search...';
}

// Path: paginator
class _StringsPaginatorEn {
	_StringsPaginatorEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get first => 'Go to first page.';
	String get previous => 'Go to previous page.';
	String get next => 'Go to next page.';
	String get last => 'Go to last page.';
	String get go => 'Go';
}

// Path: serviceRunner
class _StringsServiceRunnerEn {
	_StringsServiceRunnerEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get message => 'Network error!';
}

// Path: appBar
class _StringsAppBarEn {
	_StringsAppBarEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get changeIcon => 'Change Icon';
	String get changeName => 'Change Name';
	String get changePassword => 'Change Password';
	String get quit => 'Exit';
}

// Path: drawerUi
class _StringsDrawerUiEn {
	_StringsDrawerUiEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Hello';
	String get home => 'Home';
	String get members => 'Members';
	String get settings => 'Settings';
	String get quit => 'Exit';
}

// Path: beginPage
class _StringsBeginPageEn {
	_StringsBeginPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => '${_root.app}';
	String get email => 'Email';
	String get password => 'Password';
	String get remember => 'Remember Sign-in';
	String get forgotPassword => 'Forgot password?';
	String get ok => 'Sign In';
	String get or => '- or -';
	String get signUp => 'Sign Up';
}

// Path: signUpPage
class _StringsSignUpPageEn {
	_StringsSignUpPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Sign Up';
	String get email => 'Email';
	String get password => 'Password';
	String get confirmPassword => 'Confirm Password';
	String get ok => 'Register';
	String get confirm => 'Please confirm the sign-up by email!';
}

// Path: forgotPasswordPage
class _StringsForgotPasswordPageEn {
	_StringsForgotPasswordPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Forgot Password';
	String get email => 'Email';
	String get ok => 'Send Email';
	String get check => 'Please check email for your instruction!';
}

// Path: dashboardPage
class _StringsDashboardPageEn {
	_StringsDashboardPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Dashboard';
	String get role => 'Role';
	String get locale => 'Locale';
	String get name => 'Name';
	String get signup => 'Sign-up';
}

// Path: changeIconPage
class _StringsChangeIconPageEn {
	_StringsChangeIconPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Change Icon';
	String get icon => 'Current Icon';
	String get ok => 'Change Icon';
}

// Path: changeNamePage
class _StringsChangeNamePageEn {
	_StringsChangeNamePageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Change Name';
	String get name => 'Current Name';
	String get ok => 'Change Name';
}

// Path: changePasswordPage
class _StringsChangePasswordPageEn {
	_StringsChangePasswordPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Change Password';
	String get currentPassword => 'Current Password';
	String get newPassword => 'New Password';
	String get confirmPassword => 'Confirm New Password';
	String get ok => 'Change Password';
	String get confirm => 'You have to sign-out, then sign-in again with new password!';
}

// Path: membersPage
class _StringsMembersPageEn {
	_StringsMembersPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Member List';
	late final _StringsMembersPageSortByEn sortBy = _StringsMembersPageSortByEn._(_root);
	String get trash => 'Resigned';
}

// Path: memberEditPage
class _StringsMemberEditPageEn {
	_StringsMemberEditPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String title({required Object name}) => 'Edit $name';
	String get role => 'Role';
	String get locale => 'Locale';
	String get name => 'Name';
	String get disabled => 'Disabled';
	String get resigned => 'Resigned';
	String get signup => 'Sign-up';
	String get disable => 'Disable';
	String get ok => 'Save';
}

// Path: settingsPage
class _StringsSettingsPageEn {
	_StringsSettingsPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Settings';
	String get locale => 'Change Locale';
	String get color => 'Change Color Theme';
}

// Path: membersPage.sortBy
class _StringsMembersPageSortByEn {
	_StringsMembersPageSortByEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get id => 'Id';
	String get emailAsc => 'Email ASC';
	String get emailDesc => 'Email DESC';
	String get signUpAsc => 'Sign-up ASC';
	String get signUpDesc => 'Sign-up DESC';
}

// Path: <root>
class _StringsTh implements _StringsEn {

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsTh.build();

	/// Access flat map
	@override dynamic operator[](String key) => _flatMap[key];

	// Internal flat map initialized lazily
	@override late final Map<String, dynamic> _flatMap = _buildFlatMap();

	@override late final _StringsTh _root = this; // ignore: unused_field

	// Translations
	@override String get app => 'ปืนราง';
	@override late final _StringsSwitchLocaleTh switchLocale = _StringsSwitchLocaleTh._(_root);
	@override late final _StringsCommonTh common = _StringsCommonTh._(_root);
	@override late final _StringsQuestionTh question = _StringsQuestionTh._(_root);
	@override late final _StringsValidatorTh validator = _StringsValidatorTh._(_root);
	@override late final _StringsErrorTh error = _StringsErrorTh._(_root);
	@override late final _StringsMessageBoxTh messageBox = _StringsMessageBoxTh._(_root);
	@override late final _StringsWaitBoxTh waitBox = _StringsWaitBoxTh._(_root);
	@override late final _StringsImageChooserTh imageChooser = _StringsImageChooserTh._(_root);
	@override late final _StringsSearchBarTh searchBar = _StringsSearchBarTh._(_root);
	@override late final _StringsPaginatorTh paginator = _StringsPaginatorTh._(_root);
	@override late final _StringsServiceRunnerTh serviceRunner = _StringsServiceRunnerTh._(_root);
	@override late final _StringsAppBarTh appBar = _StringsAppBarTh._(_root);
	@override late final _StringsDrawerUiTh drawerUi = _StringsDrawerUiTh._(_root);
	@override late final _StringsBeginPageTh beginPage = _StringsBeginPageTh._(_root);
	@override late final _StringsSignUpPageTh signUpPage = _StringsSignUpPageTh._(_root);
	@override late final _StringsForgotPasswordPageTh forgotPasswordPage = _StringsForgotPasswordPageTh._(_root);
	@override late final _StringsDashboardPageTh dashboardPage = _StringsDashboardPageTh._(_root);
	@override late final _StringsChangeIconPageTh changeIconPage = _StringsChangeIconPageTh._(_root);
	@override late final _StringsChangeNamePageTh changeNamePage = _StringsChangeNamePageTh._(_root);
	@override late final _StringsChangePasswordPageTh changePasswordPage = _StringsChangePasswordPageTh._(_root);
	@override late final _StringsMembersPageTh membersPage = _StringsMembersPageTh._(_root);
	@override late final _StringsMemberEditPageTh memberEditPage = _StringsMemberEditPageTh._(_root);
	@override late final _StringsSettingsPageTh settingsPage = _StringsSettingsPageTh._(_root);
}

// Path: switchLocale
class _StringsSwitchLocaleTh implements _StringsSwitchLocaleEn {
	_StringsSwitchLocaleTh._(this._root);

	@override final _StringsTh _root; // ignore: unused_field

	// Translations
	@override String get en => 'สลับภาษาเป็น English';
	@override String get th => 'สลับภาษาเป็น ไทย';
}

// Path: common
class _StringsCommonTh implements _StringsCommonEn {
	_StringsCommonTh._(this._root);

	@override final _StringsTh _root; // ignore: unused_field

	// Translations
	@override String get close => 'ปิด';
	@override String get ok => 'ตกลง';
	@override String get cancel => 'ยกเลิก';
	@override String get yes => 'ใช่';
	@override String get no => 'ไม่ใช่';
	@override String get retry => 'ลองใหม่';
	@override String get name => 'ชื่อ';
	@override String get value => 'ค่า';
	@override String get create => 'สร้าง';
	@override String get createMore => 'สร้าง...';
	@override String get update => 'บันทึก';
	@override String get updateMore => 'บันทึก...';
	@override String get remove => 'ลบ';
	@override String get removeMore => 'ลบ...';
}

// Path: question
class _StringsQuestionTh implements _StringsQuestionEn {
	_StringsQuestionTh._(this._root);

	@override final _StringsTh _root; // ignore: unused_field

	// Translations
	@override String get areYouSureToQuit => 'คุณแน่ใจที่จะออกจากโปรแกรมนี้หรือไม่?';
	@override String get areYouSureToDelete => 'คุณแน่ใจที่จะลบข้อมูลนี้หรือไม่?';
	@override String get areYouSureToLeave => 'คุณแน่ใจที่จะออกจากหน้านี้โดยไม่เซฟข้อมูล?';
}

// Path: validator
class _StringsValidatorTh implements _StringsValidatorEn {
	_StringsValidatorTh._(this._root);

	@override final _StringsTh _root; // ignore: unused_field

	// Translations
	@override String isMinInt({required Object min}) => 'กรอกข้อมูล เป็นเลขจำนวนเต็ม, อย่างน้อย >= $min.';
	@override String isMaxInt({required Object max}) => 'กรอกข้อมูล เป็นเลขจำนวนเต็ม, อย่างมาก <= $max.';
	@override String get isPositiveInt => 'กรอกข้อมูล เป็นเลขจำนวนเต็มบวก';
	@override String get isPositiveOrZeroInt => 'กรอกข้อมูล เป็นเลขจำนวนเต็มบวกหรือศูนย์';
	@override String get isNegativeInt => 'กรอกข้อมูล เป็นเลขจำนวนเต็มลบ';
	@override String get isNegativeOrZeroInt => 'กรอกข้อมูล เป็นเลขจำนวนเต็มลบหรือศูนย์';
	@override String isMinFloat({required Object min}) => 'กรอกข้อมูล เป็นเลขจำนวนทศนิยม, อย่างน้อย >= $min.';
	@override String isMaxFloat({required Object max}) => 'กรอกข้อมูล เป็นเลขจำนวนทศนิยม, อย่างมาก <= $max.';
	@override String get isPositiveFloat => 'กรอกข้อมูล เป็นเลขจำนวนทศนิยมบวก';
	@override String get isPositiveOrZeroFloat => 'กรอกข้อมูล เป็นเลขจำนวนทศนิยมบวกหรือศูนย์';
	@override String get isNegativeFloat => 'กรอกข้อมูล เป็นเลขจำนวนทศนิยมลบ';
	@override String get isNegativeOrZeroFloat => 'กรอกข้อมูล เป็นเลขจำนวนทศนิยมลบหรือศูนย์';
	@override String get isMoney => 'กรอกข้อมูล เป็นเลขจำนวนเงิน.';
	@override String isMinLength({required Object min}) => 'กรอกข้อมูล ความยาว >= $min';
	@override String isMaxLength({required Object max}) => 'กรอกข้อมูล ความยาว <= $max';
	@override String get isEmail => 'กรอกข้อมูล เป็นอีเมล';
	@override String get isSamePasswords => 'รหัสผ่าน และ ยืนยันรหัสผ่าน ต้องเหมือนกัน';
}

// Path: error
class _StringsErrorTh implements _StringsErrorEn {
	_StringsErrorTh._(this._root);

	@override final _StringsTh _root; // ignore: unused_field

	// Translations
	@override String get e400 => 'คุณส่งค่าพารามิเตอร์ไม่ถูกต้อง!';
	@override String get e401 => 'คุณไม่มีสิทธิเข้าถึงข้อมูล!';
	@override String get e402 => 'คุณต้องชำระเงิน!';
	@override String get e403 => 'คุณไม่ได้รับอนุญาต!';
	@override String get e404 => 'ไม่พบข้อมูล!';
	@override String get e405 => 'วิธีการไม่ได้รับอนุญาต!';
	@override String get e406 => 'ไม่สามารถยอมรับได้!';
	@override String get e418 => 'ฉันคือกาน้ำชา!';
	@override String unknown({required Object statusCode}) => 'เกิดข้อผิดพลาดจาก HTTP, สถานะ $statusCode!';
}

// Path: messageBox
class _StringsMessageBoxTh implements _StringsMessageBoxEn {
	_StringsMessageBoxTh._(this._root);

	@override final _StringsTh _root; // ignore: unused_field

	// Translations
	@override String get info => 'ข้อมูลข่าวสาร';
	@override String get warning => 'แจ้งเตือน';
	@override String get error => 'เกิดข้อผิดพลาด';
	@override String get question => 'คำถาม';
}

// Path: waitBox
class _StringsWaitBoxTh implements _StringsWaitBoxEn {
	_StringsWaitBoxTh._(this._root);

	@override final _StringsTh _root; // ignore: unused_field

	// Translations
	@override String get message => 'โปรดรอสักครู่...';
}

// Path: imageChooser
class _StringsImageChooserTh implements _StringsImageChooserEn {
	_StringsImageChooserTh._(this._root);

	@override final _StringsTh _root; // ignore: unused_field

	// Translations
	@override String get upload => 'อัพโหลด';
	@override String get reset => 'รีเซ็ต';
	@override String get revert => 'ย้อนกลับ';
}

// Path: searchBar
class _StringsSearchBarTh implements _StringsSearchBarEn {
	_StringsSearchBarTh._(this._root);

	@override final _StringsTh _root; // ignore: unused_field

	// Translations
	@override String get open => 'เปิดการค้นหา...';
	@override String get hint => 'ค้นหา...';
}

// Path: paginator
class _StringsPaginatorTh implements _StringsPaginatorEn {
	_StringsPaginatorTh._(this._root);

	@override final _StringsTh _root; // ignore: unused_field

	// Translations
	@override String get first => 'ไปยังหน้าแรก';
	@override String get previous => 'ไปยังหน้าที่แล้ว';
	@override String get next => 'ไปยังหน้าถัดไป';
	@override String get last => 'ไปยังหน้าสุดท้าย';
	@override String get go => 'ไป';
}

// Path: serviceRunner
class _StringsServiceRunnerTh implements _StringsServiceRunnerEn {
	_StringsServiceRunnerTh._(this._root);

	@override final _StringsTh _root; // ignore: unused_field

	// Translations
	@override String get message => 'เกิดข้อผิดพลาดบนเน็ตเวิร์ค!';
}

// Path: appBar
class _StringsAppBarTh implements _StringsAppBarEn {
	_StringsAppBarTh._(this._root);

	@override final _StringsTh _root; // ignore: unused_field

	// Translations
	@override String get changeIcon => 'เปลื่อน Icon';
	@override String get changeName => 'เปลี่ยนชื่อ';
	@override String get changePassword => 'เปลี่ยนรหัสผ่าน';
	@override String get quit => 'ออกจากระบบ';
}

// Path: drawerUi
class _StringsDrawerUiTh implements _StringsDrawerUiEn {
	_StringsDrawerUiTh._(this._root);

	@override final _StringsTh _root; // ignore: unused_field

	// Translations
	@override String get title => 'สวัสดี';
	@override String get home => 'เริ่มต้น';
	@override String get members => 'สมาชิก';
	@override String get settings => 'การตั้งค่า';
	@override String get quit => 'ออกจากระบบ';
}

// Path: beginPage
class _StringsBeginPageTh implements _StringsBeginPageEn {
	_StringsBeginPageTh._(this._root);

	@override final _StringsTh _root; // ignore: unused_field

	// Translations
	@override String get title => '${_root.app}';
	@override String get email => 'อีเมล';
	@override String get password => 'รหัสผ่าน';
	@override String get remember => 'จำรหัสผ่าน';
	@override String get forgotPassword => 'ลืมรหัสผ่าน?';
	@override String get ok => 'เข้าสู่ระบบ';
	@override String get or => '- หรือ -';
	@override String get signUp => 'สมัครสมาชิก';
}

// Path: signUpPage
class _StringsSignUpPageTh implements _StringsSignUpPageEn {
	_StringsSignUpPageTh._(this._root);

	@override final _StringsTh _root; // ignore: unused_field

	// Translations
	@override String get title => 'สมัครสมาชิก';
	@override String get email => 'อีเมล';
	@override String get password => 'รหัสผ่าน';
	@override String get confirmPassword => 'ยืนยันรหัสผ่าน';
	@override String get ok => 'ลงทะเบียน';
	@override String get confirm => 'โปรดยืนยันการสมัครสมาชิกทางอีเมล!';
}

// Path: forgotPasswordPage
class _StringsForgotPasswordPageTh implements _StringsForgotPasswordPageEn {
	_StringsForgotPasswordPageTh._(this._root);

	@override final _StringsTh _root; // ignore: unused_field

	// Translations
	@override String get title => 'ลืมรหัสผ่าน';
	@override String get email => 'อีเมล';
	@override String get ok => 'ส่งอีเมล';
	@override String get check => 'โปรดเช็คอีเมลสำหรับคำแนะนำต่อไป!';
}

// Path: dashboardPage
class _StringsDashboardPageTh implements _StringsDashboardPageEn {
	_StringsDashboardPageTh._(this._root);

	@override final _StringsTh _root; // ignore: unused_field

	// Translations
	@override String get title => 'กระดานของคุณ';
	@override String get role => 'ประเภท';
	@override String get locale => 'ภาษา';
	@override String get name => 'ชื่อ';
	@override String get signup => 'สมัครสมาชิก';
}

// Path: changeIconPage
class _StringsChangeIconPageTh implements _StringsChangeIconPageEn {
	_StringsChangeIconPageTh._(this._root);

	@override final _StringsTh _root; // ignore: unused_field

	// Translations
	@override String get title => 'เปลี่ยนรูป Icon';
	@override String get icon => 'Icon ปัจจุบัน';
	@override String get ok => 'เปลี่ยนรูป Icon';
}

// Path: changeNamePage
class _StringsChangeNamePageTh implements _StringsChangeNamePageEn {
	_StringsChangeNamePageTh._(this._root);

	@override final _StringsTh _root; // ignore: unused_field

	// Translations
	@override String get title => 'เปลี่ยนชื่อ';
	@override String get name => 'ชื่อปัจจุบัน';
	@override String get ok => 'เปลี่ยนชื่อ';
}

// Path: changePasswordPage
class _StringsChangePasswordPageTh implements _StringsChangePasswordPageEn {
	_StringsChangePasswordPageTh._(this._root);

	@override final _StringsTh _root; // ignore: unused_field

	// Translations
	@override String get title => 'เปลื่อนรหัสผ่าน';
	@override String get currentPassword => 'รหัสผ่านปัจจุบัน';
	@override String get newPassword => 'รหัสผ่านใหม่';
	@override String get confirmPassword => 'ยืนยันรหัสผ่านใหม่';
	@override String get ok => 'เปลี่ยนรหัสผ่าน';
	@override String get confirm => 'คุณต้องออกจากระบบ แล้วเข้าระบบใหม่ ด้วยรหัสผ่านใหม่!';
}

// Path: membersPage
class _StringsMembersPageTh implements _StringsMembersPageEn {
	_StringsMembersPageTh._(this._root);

	@override final _StringsTh _root; // ignore: unused_field

	// Translations
	@override String get title => 'รายชื่อสมาชิก';
	@override late final _StringsMembersPageSortByTh sortBy = _StringsMembersPageSortByTh._(_root);
	@override String get trash => 'ลาออกจากระบบ';
}

// Path: memberEditPage
class _StringsMemberEditPageTh implements _StringsMemberEditPageEn {
	_StringsMemberEditPageTh._(this._root);

	@override final _StringsTh _root; // ignore: unused_field

	// Translations
	@override String title({required Object name}) => 'แก้ไข $name';
	@override String get role => 'ประเภท';
	@override String get locale => 'ภาษา';
	@override String get name => 'ชื่อ';
	@override String get disabled => 'ถูกปิดการทำงาน';
	@override String get resigned => 'ลาออกจากระบบ';
	@override String get signup => 'สมัครสมาชิก';
	@override String get disable => 'ปิดการทำงาน';
	@override String get ok => 'บันทึก';
}

// Path: settingsPage
class _StringsSettingsPageTh implements _StringsSettingsPageEn {
	_StringsSettingsPageTh._(this._root);

	@override final _StringsTh _root; // ignore: unused_field

	// Translations
	@override String get title => 'การตั้งค่า';
	@override String get locale => 'เปลี่ยนภาษา';
	@override String get color => 'เปลี่ยนธีมสี';
}

// Path: membersPage.sortBy
class _StringsMembersPageSortByTh implements _StringsMembersPageSortByEn {
	_StringsMembersPageSortByTh._(this._root);

	@override final _StringsTh _root; // ignore: unused_field

	// Translations
	@override String get id => 'Id';
	@override String get emailAsc => 'อีเมล น้อยไปมาก';
	@override String get emailDesc => 'อีเมล มากไปน้อย';
	@override String get signUpAsc => 'วันที่สมัคร น้อยไปมาก';
	@override String get signUpDesc => 'วันที่สมัคร มากไปน้อย';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.

extension on _StringsEn {
	Map<String, dynamic> _buildFlatMap() {
		return <String, dynamic>{
			'app': 'Railgun',
			'switchLocale.en': 'Change Language to English',
			'switchLocale.th': 'Change Language to ไทย',
			'common.close': 'Close',
			'common.ok': 'OK',
			'common.cancel': 'Cancel',
			'common.yes': 'Yes',
			'common.no': 'No',
			'common.retry': 'Retry',
			'common.name': 'Name',
			'common.value': 'Value',
			'common.create': 'Create',
			'common.createMore': 'Create...',
			'common.update': 'Save',
			'common.updateMore': 'Save...',
			'common.remove': 'Delete',
			'common.removeMore': 'Delete...',
			'question.areYouSureToQuit': 'Are you sure to exit this program?',
			'question.areYouSureToDelete': 'Are you sure to delete this item?',
			'question.areYouSureToLeave': 'Are you sure to leave without save data?',
			'validator.isMinInt': ({required Object min}) => 'Please input as integer, minimum >= $min.',
			'validator.isMaxInt': ({required Object max}) => 'Please input as integer, maximum <= $max.',
			'validator.isPositiveInt': 'Please input as positive integer.',
			'validator.isPositiveOrZeroInt': 'Please input as positive integer or zero.',
			'validator.isNegativeInt': 'Please input as negative integer.',
			'validator.isNegativeOrZeroInt': 'Please input as negative integer or zero.',
			'validator.isMinFloat': ({required Object min}) => 'Please input as floating-point, minimum >= $min.',
			'validator.isMaxFloat': ({required Object max}) => 'Please input as floating-point, maximum <= $max.',
			'validator.isPositiveFloat': 'Please input as positive floating-point.',
			'validator.isPositiveOrZeroFloat': 'Please input as positive floating-point or zero.',
			'validator.isNegativeFloat': 'Please input as negative floating-point.',
			'validator.isNegativeOrZeroFloat': 'Please input as negative floating-point or zero.',
			'validator.isMoney': 'Please input as money.',
			'validator.isMinLength': ({required Object min}) => 'Please input length >= $min.',
			'validator.isMaxLength': ({required Object max}) => 'Please input length <= $max.',
			'validator.isEmail': 'Please input as email.',
			'validator.isSamePasswords': 'Password and confirm password must be equal.',
			'error.e400': 'You send request incorrect parameters!',
			'error.e401': 'You are unauthorized!',
			'error.e402': 'Your payment is required!',
			'error.e403': 'You are forbidden!',
			'error.e404': 'Data not found!',
			'error.e405': 'Method not allowed!',
			'error.e406': 'Not acceptable!',
			'error.e418': 'I\'m a teapot!',
			'error.unknown': ({required Object statusCode}) => 'HTTP error, status code=$statusCode!',
			'messageBox.info': 'Information',
			'messageBox.warning': 'Warning',
			'messageBox.error': 'Error',
			'messageBox.question': 'Question',
			'waitBox.message': 'Please wait...',
			'imageChooser.upload': 'Upload',
			'imageChooser.reset': 'Reset',
			'imageChooser.revert': 'Revert',
			'searchBar.open': 'Open search...',
			'searchBar.hint': 'Search...',
			'paginator.first': 'Go to first page.',
			'paginator.previous': 'Go to previous page.',
			'paginator.next': 'Go to next page.',
			'paginator.last': 'Go to last page.',
			'paginator.go': 'Go',
			'serviceRunner.message': 'Network error!',
			'appBar.changeIcon': 'Change Icon',
			'appBar.changeName': 'Change Name',
			'appBar.changePassword': 'Change Password',
			'appBar.quit': 'Exit',
			'drawerUi.title': 'Hello',
			'drawerUi.home': 'Home',
			'drawerUi.members': 'Members',
			'drawerUi.settings': 'Settings',
			'drawerUi.quit': 'Exit',
			'beginPage.title': '${_root.app}',
			'beginPage.email': 'Email',
			'beginPage.password': 'Password',
			'beginPage.remember': 'Remember Sign-in',
			'beginPage.forgotPassword': 'Forgot password?',
			'beginPage.ok': 'Sign In',
			'beginPage.or': '- or -',
			'beginPage.signUp': 'Sign Up',
			'signUpPage.title': 'Sign Up',
			'signUpPage.email': 'Email',
			'signUpPage.password': 'Password',
			'signUpPage.confirmPassword': 'Confirm Password',
			'signUpPage.ok': 'Register',
			'signUpPage.confirm': 'Please confirm the sign-up by email!',
			'forgotPasswordPage.title': 'Forgot Password',
			'forgotPasswordPage.email': 'Email',
			'forgotPasswordPage.ok': 'Send Email',
			'forgotPasswordPage.check': 'Please check email for your instruction!',
			'dashboardPage.title': 'Dashboard',
			'dashboardPage.role': 'Role',
			'dashboardPage.locale': 'Locale',
			'dashboardPage.name': 'Name',
			'dashboardPage.signup': 'Sign-up',
			'changeIconPage.title': 'Change Icon',
			'changeIconPage.icon': 'Current Icon',
			'changeIconPage.ok': 'Change Icon',
			'changeNamePage.title': 'Change Name',
			'changeNamePage.name': 'Current Name',
			'changeNamePage.ok': 'Change Name',
			'changePasswordPage.title': 'Change Password',
			'changePasswordPage.currentPassword': 'Current Password',
			'changePasswordPage.newPassword': 'New Password',
			'changePasswordPage.confirmPassword': 'Confirm New Password',
			'changePasswordPage.ok': 'Change Password',
			'changePasswordPage.confirm': 'You have to sign-out, then sign-in again with new password!',
			'membersPage.title': 'Member List',
			'membersPage.sortBy.id': 'Id',
			'membersPage.sortBy.emailAsc': 'Email ASC',
			'membersPage.sortBy.emailDesc': 'Email DESC',
			'membersPage.sortBy.signUpAsc': 'Sign-up ASC',
			'membersPage.sortBy.signUpDesc': 'Sign-up DESC',
			'membersPage.trash': 'Resigned',
			'memberEditPage.title': ({required Object name}) => 'Edit $name',
			'memberEditPage.role': 'Role',
			'memberEditPage.locale': 'Locale',
			'memberEditPage.name': 'Name',
			'memberEditPage.disabled': 'Disabled',
			'memberEditPage.resigned': 'Resigned',
			'memberEditPage.signup': 'Sign-up',
			'memberEditPage.disable': 'Disable',
			'memberEditPage.ok': 'Save',
			'settingsPage.title': 'Settings',
			'settingsPage.locale': 'Change Locale',
			'settingsPage.color': 'Change Color Theme',
		};
	}
}

extension on _StringsTh {
	Map<String, dynamic> _buildFlatMap() {
		return <String, dynamic>{
			'app': 'ปืนราง',
			'switchLocale.en': 'สลับภาษาเป็น English',
			'switchLocale.th': 'สลับภาษาเป็น ไทย',
			'common.close': 'ปิด',
			'common.ok': 'ตกลง',
			'common.cancel': 'ยกเลิก',
			'common.yes': 'ใช่',
			'common.no': 'ไม่ใช่',
			'common.retry': 'ลองใหม่',
			'common.name': 'ชื่อ',
			'common.value': 'ค่า',
			'common.create': 'สร้าง',
			'common.createMore': 'สร้าง...',
			'common.update': 'บันทึก',
			'common.updateMore': 'บันทึก...',
			'common.remove': 'ลบ',
			'common.removeMore': 'ลบ...',
			'question.areYouSureToQuit': 'คุณแน่ใจที่จะออกจากโปรแกรมนี้หรือไม่?',
			'question.areYouSureToDelete': 'คุณแน่ใจที่จะลบข้อมูลนี้หรือไม่?',
			'question.areYouSureToLeave': 'คุณแน่ใจที่จะออกจากหน้านี้โดยไม่เซฟข้อมูล?',
			'validator.isMinInt': ({required Object min}) => 'กรอกข้อมูล เป็นเลขจำนวนเต็ม, อย่างน้อย >= $min.',
			'validator.isMaxInt': ({required Object max}) => 'กรอกข้อมูล เป็นเลขจำนวนเต็ม, อย่างมาก <= $max.',
			'validator.isPositiveInt': 'กรอกข้อมูล เป็นเลขจำนวนเต็มบวก',
			'validator.isPositiveOrZeroInt': 'กรอกข้อมูล เป็นเลขจำนวนเต็มบวกหรือศูนย์',
			'validator.isNegativeInt': 'กรอกข้อมูล เป็นเลขจำนวนเต็มลบ',
			'validator.isNegativeOrZeroInt': 'กรอกข้อมูล เป็นเลขจำนวนเต็มลบหรือศูนย์',
			'validator.isMinFloat': ({required Object min}) => 'กรอกข้อมูล เป็นเลขจำนวนทศนิยม, อย่างน้อย >= $min.',
			'validator.isMaxFloat': ({required Object max}) => 'กรอกข้อมูล เป็นเลขจำนวนทศนิยม, อย่างมาก <= $max.',
			'validator.isPositiveFloat': 'กรอกข้อมูล เป็นเลขจำนวนทศนิยมบวก',
			'validator.isPositiveOrZeroFloat': 'กรอกข้อมูล เป็นเลขจำนวนทศนิยมบวกหรือศูนย์',
			'validator.isNegativeFloat': 'กรอกข้อมูล เป็นเลขจำนวนทศนิยมลบ',
			'validator.isNegativeOrZeroFloat': 'กรอกข้อมูล เป็นเลขจำนวนทศนิยมลบหรือศูนย์',
			'validator.isMoney': 'กรอกข้อมูล เป็นเลขจำนวนเงิน.',
			'validator.isMinLength': ({required Object min}) => 'กรอกข้อมูล ความยาว >= $min',
			'validator.isMaxLength': ({required Object max}) => 'กรอกข้อมูล ความยาว <= $max',
			'validator.isEmail': 'กรอกข้อมูล เป็นอีเมล',
			'validator.isSamePasswords': 'รหัสผ่าน และ ยืนยันรหัสผ่าน ต้องเหมือนกัน',
			'error.e400': 'คุณส่งค่าพารามิเตอร์ไม่ถูกต้อง!',
			'error.e401': 'คุณไม่มีสิทธิเข้าถึงข้อมูล!',
			'error.e402': 'คุณต้องชำระเงิน!',
			'error.e403': 'คุณไม่ได้รับอนุญาต!',
			'error.e404': 'ไม่พบข้อมูล!',
			'error.e405': 'วิธีการไม่ได้รับอนุญาต!',
			'error.e406': 'ไม่สามารถยอมรับได้!',
			'error.e418': 'ฉันคือกาน้ำชา!',
			'error.unknown': ({required Object statusCode}) => 'เกิดข้อผิดพลาดจาก HTTP, สถานะ $statusCode!',
			'messageBox.info': 'ข้อมูลข่าวสาร',
			'messageBox.warning': 'แจ้งเตือน',
			'messageBox.error': 'เกิดข้อผิดพลาด',
			'messageBox.question': 'คำถาม',
			'waitBox.message': 'โปรดรอสักครู่...',
			'imageChooser.upload': 'อัพโหลด',
			'imageChooser.reset': 'รีเซ็ต',
			'imageChooser.revert': 'ย้อนกลับ',
			'searchBar.open': 'เปิดการค้นหา...',
			'searchBar.hint': 'ค้นหา...',
			'paginator.first': 'ไปยังหน้าแรก',
			'paginator.previous': 'ไปยังหน้าที่แล้ว',
			'paginator.next': 'ไปยังหน้าถัดไป',
			'paginator.last': 'ไปยังหน้าสุดท้าย',
			'paginator.go': 'ไป',
			'serviceRunner.message': 'เกิดข้อผิดพลาดบนเน็ตเวิร์ค!',
			'appBar.changeIcon': 'เปลื่อน Icon',
			'appBar.changeName': 'เปลี่ยนชื่อ',
			'appBar.changePassword': 'เปลี่ยนรหัสผ่าน',
			'appBar.quit': 'ออกจากระบบ',
			'drawerUi.title': 'สวัสดี',
			'drawerUi.home': 'เริ่มต้น',
			'drawerUi.members': 'สมาชิก',
			'drawerUi.settings': 'การตั้งค่า',
			'drawerUi.quit': 'ออกจากระบบ',
			'beginPage.title': '${_root.app}',
			'beginPage.email': 'อีเมล',
			'beginPage.password': 'รหัสผ่าน',
			'beginPage.remember': 'จำรหัสผ่าน',
			'beginPage.forgotPassword': 'ลืมรหัสผ่าน?',
			'beginPage.ok': 'เข้าสู่ระบบ',
			'beginPage.or': '- หรือ -',
			'beginPage.signUp': 'สมัครสมาชิก',
			'signUpPage.title': 'สมัครสมาชิก',
			'signUpPage.email': 'อีเมล',
			'signUpPage.password': 'รหัสผ่าน',
			'signUpPage.confirmPassword': 'ยืนยันรหัสผ่าน',
			'signUpPage.ok': 'ลงทะเบียน',
			'signUpPage.confirm': 'โปรดยืนยันการสมัครสมาชิกทางอีเมล!',
			'forgotPasswordPage.title': 'ลืมรหัสผ่าน',
			'forgotPasswordPage.email': 'อีเมล',
			'forgotPasswordPage.ok': 'ส่งอีเมล',
			'forgotPasswordPage.check': 'โปรดเช็คอีเมลสำหรับคำแนะนำต่อไป!',
			'dashboardPage.title': 'กระดานของคุณ',
			'dashboardPage.role': 'ประเภท',
			'dashboardPage.locale': 'ภาษา',
			'dashboardPage.name': 'ชื่อ',
			'dashboardPage.signup': 'สมัครสมาชิก',
			'changeIconPage.title': 'เปลี่ยนรูป Icon',
			'changeIconPage.icon': 'Icon ปัจจุบัน',
			'changeIconPage.ok': 'เปลี่ยนรูป Icon',
			'changeNamePage.title': 'เปลี่ยนชื่อ',
			'changeNamePage.name': 'ชื่อปัจจุบัน',
			'changeNamePage.ok': 'เปลี่ยนชื่อ',
			'changePasswordPage.title': 'เปลื่อนรหัสผ่าน',
			'changePasswordPage.currentPassword': 'รหัสผ่านปัจจุบัน',
			'changePasswordPage.newPassword': 'รหัสผ่านใหม่',
			'changePasswordPage.confirmPassword': 'ยืนยันรหัสผ่านใหม่',
			'changePasswordPage.ok': 'เปลี่ยนรหัสผ่าน',
			'changePasswordPage.confirm': 'คุณต้องออกจากระบบ แล้วเข้าระบบใหม่ ด้วยรหัสผ่านใหม่!',
			'membersPage.title': 'รายชื่อสมาชิก',
			'membersPage.sortBy.id': 'Id',
			'membersPage.sortBy.emailAsc': 'อีเมล น้อยไปมาก',
			'membersPage.sortBy.emailDesc': 'อีเมล มากไปน้อย',
			'membersPage.sortBy.signUpAsc': 'วันที่สมัคร น้อยไปมาก',
			'membersPage.sortBy.signUpDesc': 'วันที่สมัคร มากไปน้อย',
			'membersPage.trash': 'ลาออกจากระบบ',
			'memberEditPage.title': ({required Object name}) => 'แก้ไข $name',
			'memberEditPage.role': 'ประเภท',
			'memberEditPage.locale': 'ภาษา',
			'memberEditPage.name': 'ชื่อ',
			'memberEditPage.disabled': 'ถูกปิดการทำงาน',
			'memberEditPage.resigned': 'ลาออกจากระบบ',
			'memberEditPage.signup': 'สมัครสมาชิก',
			'memberEditPage.disable': 'ปิดการทำงาน',
			'memberEditPage.ok': 'บันทึก',
			'settingsPage.title': 'การตั้งค่า',
			'settingsPage.locale': 'เปลี่ยนภาษา',
			'settingsPage.color': 'เปลี่ยนธีมสี',
		};
	}
}
