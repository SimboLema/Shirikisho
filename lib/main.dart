import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
// import 'package:shirikisho/debug_mode_error.dart';
import 'package:shirikisho/helpers/dependency_injector.dart';
import 'package:shirikisho/providers/MkopoManagementProvider.dart';
import 'package:shirikisho/screen/SplashScreen.dart';
import 'package:shirikisho/screen/driver/RegisterDriverScreen.dart';
import 'package:shirikisho/services/auth_service.dart';
import 'package:shirikisho/store/AppStore.dart';
import 'package:shirikisho/utils/AppTheme.dart';
import 'package:shirikisho/utils/DataGenerator.dart';
import 'package:shirikisho/utils/WAConstants.dart';
import 'firebase_options.dart';
// import 'dart:io' show Platform;

AppStore appStore = AppStore();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestorm,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  // await FirebaseMessaging.instance.requestPermission(provisional: true);

  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      0,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          priority: Priority.high,
          importance: Importance.max,
          icon: "app_icon",
          channelShowBadge: true,
          largeIcon: DrawableResourceAndroidBitmap("ic_stat_ic_notification"),
        ),
      ),
    );
  }
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  // // previent all print statements from showing in release mode
  // if (kDebugMode || kReleaseMode) {
  //   debugPrint = (String? message, {int? wrapWidth}) {};
  // }

  // // prevent all flutter error logs from showing in release mode
  // FlutterError.onError = (FlutterErrorDetails details) {
  //   if (!kReleaseMode || kReleaseMode) {
  //     //if in debug mode will show else block
  //     FlutterError.dumpErrorToConsole(details);
  //   }
  // };

  // await SentryFlutter.init(
  //   (options) {
  //     options.dsn =
  //         'https://d36d5d55125196133b9a6de7b67fbb1b@o4508149773303808.ingest.de.sentry.io/4508851866304592';
  //     // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
  //     // We recommend adjusting this value in production.
  //     options.tracesSampleRate = 1.0;
  //     // The sampling rate for profiling is relative to tracesSampleRate
  //     // Setting to 1.0 will profile 100% of sampled transactions:
  //     // Note: Profiling alpha is available for iOS and macOS since SDK version 7.12.0
  //     options.profilesSampleRate = 1.0;

  //     // Adds request headers and IP for users,
  //     // visit: https://docs.sentry.io/platforms/flutter/data-management/data-collected/ for more info
  //     options.sendDefaultPii = true;
  //     options.debug = false;
  //   },
  //   appRunner: () async {

  WidgetsFlutterBinding.ensureInitialized();

  await initialize(aLocaleLanguageList: languageList());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessaging.instance.subscribeToTopic("global");

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  //

  Future<void> buildSingleNotification(title, body) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'Channel ID',
      'Channel title',
      priority: Priority.high,
      importance: Importance.max,
      icon: "ic_stat_ic_notification",
      channelShowBadge: true,
      largeIcon: DrawableResourceAndroidBitmap("app_icon"),
    );

    NotificationDetails notificationDetail =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0, title, body, notificationDetail);
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      buildSingleNotification(
          message.notification!.title, message.notification!.body);
    }
  });

  // print('User granted permission: ${settings.authorizationStatus}');

  appStore.toggleDarkMode(value: getBoolAsync(isDarkModeOnPref));

  defaultToastGravityGlobal = ToastGravity.BOTTOM;

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp(
      // isDeveloperModeEnabled: isDevModeEnabled,
      ));
  DependencyInjection.init();
  // },
  // );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  // final bool isDeveloperModeEnabled;
  // const MyApp({Key? key, required this.isDeveloperModeEnabled})
  //     : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    super.initState();

    setupFlutterNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (context) => Mkopomanagementprovider(),
        )
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shirikisho App${!isMobile ? ' ${platformName()}' : ''}',
        // home: kReleaseMode && widget.isDeveloperModeEnabled
        //     ? ErrorScreen()
        //     : WASplashScreen(),

        home: WASplashScreen(),
        // home: ErrorScreen(),
        // home: RegisterDriverScreen(),
        // home: BimaChomboApplicationScreen(),
        theme: !appStore.isDarkModeOn
            ? AppThemeData.lightTheme
            : AppThemeData.darkTheme,
        navigatorKey: navigatorKey,
        scrollBehavior: SBehavior(),
        supportedLocales: LanguageDataModel.languageLocales(),
        localeResolutionCallback: (locale, supportedLocales) => locale,
      ),
    );
  }
}

Future<void> showPermissionExplanationDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap a button to close
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('We Need Notification Permissions'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                  'To keep you updated with important information, we need to request notification permissions.'),
              Text(
                  'This will allow us to send you notifications directly in your device.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}
