import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/userController.dart';
import '../main.dart';
import '../screens/homepage_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);
  static const routeName = 'auth-screen';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _authKey = GlobalKey<FormState>();
  final passwordFocus = FocusNode();

  String email = "";
  String password = "";

  bool isLoading = false;

  late String tokens;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null) {
          var initializationSettingsAndroid =
              const AndroidInitializationSettings('@mipmap/launcher_icon');
          var iosInitilize = const IOSInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            defaultPresentAlert: true,
            defaultPresentBadge: true,
            defaultPresentSound: true,
          );
          var initializationSettings = InitializationSettings(
              android: initializationSettingsAndroid, iOS: iosInitilize);
          flutterLocalNotificationsPlugin.initialize(
            initializationSettings,
          );

          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: Colors.transparent,
                playSound: true,
                setAsGroupSummary: true,
                sound:
                    const RawResourceAndroidNotificationSound('notification'),
                enableVibration: true,
                importance: Importance.high,
                visibility: NotificationVisibility.public,
                channelShowBadge: true,
              ),
            ),
          );
        }
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
  }

  @override
  void dispose() {
    super.dispose();
    passwordFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: mediaQuery.height * 0.02),
                  child: SizedBox(
                    width: mediaQuery.width * 0.7,
                    child: Image.asset('assets/new_logo.png'),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: mediaQuery.height * 0.00),
                  child: SizedBox(
                    width: mediaQuery.width * 0.9,
                    child: Text(
                      'Welcome to,',
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.indigo.shade800,
                          ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: mediaQuery.height * 0.00,
                      bottom: mediaQuery.width * 0.05),
                  child: SizedBox(
                    width: mediaQuery.width * 0.9,
                    child: Text(
                      'BITS DIGITAL MENU',
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade800,
                          ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: mediaQuery.width * 0.04),
                  child: SizedBox(
                    width: mediaQuery.width * 0.9,
                    child: Text(
                      'Login',
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                            color: Colors.indigo.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: mediaQuery.width * 0.05),
                child: Form(
                  key: _authKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      //Email Address
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: mediaQuery.height * 0.02,
                        ),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Email Address';
                            }
                          },
                          onChanged: (value) {
                            email = value.toString();
                          },
                          onEditingComplete: () {
                            FocusScope.of(context).requestFocus(passwordFocus);
                          },
                          cursorColor: Colors.indigo,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.indigo.shade400,
                            ),
                            labelText: 'Email Address',
                            labelStyle: TextStyle(
                              color: Colors.indigo.shade400,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.indigo.shade100,
                                width: 0.6,
                              ),
                              borderRadius: BorderRadius.circular(
                                20,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.indigo,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(
                                20,
                              ),
                            ),
                            enabled: true,
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(
                                20,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(
                                20,
                              ),
                            ),
                            hintText: 'example@example.com',
                          ),
                        ),
                      ),

                      //Password
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: mediaQuery.height * 0.01),
                        child: TextFormField(
                          focusNode: passwordFocus,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Password';
                            }
                          },
                          onChanged: (value) {
                            password = value.toString();
                          },
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          cursorColor: Colors.indigo,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.indigo.shade400,
                            ),
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              color: Colors.indigo.shade400,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.indigo.shade100,
                                width: 0.6,
                              ),
                              borderRadius: BorderRadius.circular(
                                20,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.indigo,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(
                                20,
                              ),
                            ),
                            enabled: true,
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(
                                20,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(
                                20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      //Forget Password
                      Container(
                        alignment: AlignmentDirectional.bottomEnd,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: mediaQuery.height * 0.01,
                              bottom: mediaQuery.height * 0.07),
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text(
                                    'Forget Password?',
                                    style: TextStyle(
                                      color: Colors.indigo,
                                    ),
                                  ),
                                  content: SizedBox(
                                    height: mediaQuery.height * 0.18,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Contact Developer',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical:
                                                  mediaQuery.height * 0.01),
                                          child: Row(
                                            children: const [
                                              Icon(
                                                Icons.phone,
                                                size: 16,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 8.0),
                                                child: Text(
                                                  '+977-9855011559',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical:
                                                  mediaQuery.height * 0.01),
                                          child: Row(
                                            children: const [
                                              Icon(
                                                Icons.phone,
                                                size: 16,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 8.0),
                                                child: Text(
                                                  '+977-9865042465',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical:
                                                  mediaQuery.height * 0.01),
                                          child: Row(
                                            children: const [
                                              Icon(
                                                Icons.email,
                                                size: 16,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 8.0),
                                                child: Text(
                                                  'mailtobitmap@gmail.com',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'Go Back',
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Text(
                              'Forget Password?',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.indigo.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      //Login Button
                      login(),
                      Padding(
                        padding: EdgeInsets.only(top: mediaQuery.height * 0.08),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'A Premium Product Of',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            GestureDetector(
                              onTap: () => _launchUrl(Uri.parse(
                                  "https://www.bitmapitsolution.com")),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 6.0, bottom: 6.0),
                                child: Image.asset(
                                  'assets/logo.png',
                                  width: mediaQuery.width * 0.24,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _launchUrl(Uri.parse(
                                  "https://www.bitmapitsolution.com")),
                              child: Text(
                                'www.bitmapitsolution.com',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      color: Colors.indigo,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  Consumer login() {
    return Consumer(
      builder: (context, ref, child) {
        return Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.87,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  minimumSize: const Size(
                    50,
                    50,
                  ),
                ),
                onPressed: () async {
                  _authKey.currentState!.save();
                  if (!_authKey.currentState!.validate()) {
                    return;
                  }
                  FirebaseMessaging.instance.getToken().then((token) {
                    setState(() {
                      tokens = token.toString();
                    });
                    print(tokens);
                  }).then((_) {
                    Future<int> status = ref
                        .read(userProvider.notifier)
                        .login(email, password, tokens);
                    status.then((value) {
                      if (value == 201) {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const HomepageScreen(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ),
                        );
                        setState(() {
                          isLoading = false;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                1000,
                              ),
                            ),
                            content: Text(
                              UserController.message,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                        );
                        setState(() {
                          isLoading = false;
                        });
                      }
                    });
                  });

                  SharedPreferences _prefs =
                      await SharedPreferences.getInstance();
                  _prefs.setString('email', email);
                  _prefs.setString('password', password);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.015,
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(
                          color: Colors.grey[100],
                          strokeWidth: 0.8,
                        )
                      : const Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
