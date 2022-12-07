import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'helpers/util.dart';
import 'helpers/validation.dart';
import 'package:sapphire_yssantamaria_application/helpers/session.dart' as session;

final _storage = FlutterSecureStorage();

final GlobalKey<State> _keyLoader = new GlobalKey<State>();

class LoginScreen extends StatefulWidget {
  createState() {
    return LoginScreenState();
  }
}

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("Handling a background message: ${message.messageId}");
}

class LoginScreenState extends State<LoginScreen> with Validation {
  final formKey = GlobalKey<FormState>();
  String messageTitle = "Empty";
  String notificationAlert = "alert";

  String email = '';
  String password = '';
  String deviceToken = "";
  String type_ = "";
  bool isSubmited = false;

  Widget build(context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(40),
            child: Center(
                child: Form(
                    key: formKey,
                    child: Column(children: [
                      Image.asset("logo.png", width: 153.0, height: 152.0),
                      emailField(),
                      passwordField(),
                      loginButton(),
                      Container(
                          margin: const EdgeInsets.only(top: 8.0),
                          child: const Align(alignment: Alignment.topRight, child: Text("Lupa password ")))
                    ]))))
      ],
    ));
  }

  // Widget Email
  Widget emailField() {
    return TextFormField(
      decoration: const InputDecoration(
          hintStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal), hintText: "No Anggota"),
      validator: validateEmail,
      keyboardType: TextInputType.number,
      onSaved: (String value) {
        email = value;
      },
    );
  }

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();

      FirebaseMessaging messaging = FirebaseMessaging.instance;
      String token = await messaging.getToken();

      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        log('User granted permission');
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        log('User granted provisional permission');
      } else {
        log('User declined or has not accepted permission');
      }
      setState(() {
        deviceToken = token.toString();
      });

      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        log("message recieved : " + message.notification.toString());

        RemoteNotification notification = message.notification;
        AndroidNotification android = message.notification.android;
        if (notification != null && android != null) {
          log("hascode : " + notification.hashCode.toString());
          log("title : " + notification.title.toString());
          log("body : " + notification.body.toString());
        }
      });
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        log('Message clicked!');
        setState(() {
          type_ = message.data['type'].toString();
        });
        checkLogin();
      });
    } catch (e) {
      log("initializeFlutterFire : " + e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    initializeFlutterFire();
    checkLogin();
  }

  void checkLogin() async {
    // check session login
    _storage.readAll().then((result) {
      if (result['token'] != null) {
        setState(() {
          session.token = result['token'];
        });

        getData('/user/check-token').then((res) {
          if (res.data['message'] == 'success') {
            setProfile(res.data);
            checkRedirect();
          } else
            _storage.deleteAll();
        });
      }
    });
  }

  void checkRedirect() {
    Navigator.of(context).pushNamed('/home');
  }

  // Widget Password
  Widget passwordField() {
    return Container(
        margin: EdgeInsets.only(top: 5),
        child: TextFormField(
          obscureText: true,
          // validator: validatePassword,
          decoration: const InputDecoration(
              hintStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal), hintText: "Password"),
          onSaved: (String value) {
            password = value;
          },
        ));
  }

  void displayDialog(context, title, message) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Row(children: [
            Container(margin: const EdgeInsets.only(right: 10.0), child: Icon(Icons.warning, color: Colors.amber[800])),
            Text(title)
          ]),
          content: Text(message, style: const TextStyle(fontWeight: FontWeight.normal))));

  void setProfile(data) {
    setState(() {
      session.noForm = data['data']['no_form'].toString();
      session.noAnggota = data['data']['no_anggota'].toString();
      session.noKtp = data['data']['no_ktp'].toString();
      session.name_ = data['data']['name'].toString();
      session.namaKta = data['data']['name_kta'];
      session.email = data['data']['email'];
      session.telepon = data['data']['telepon'].toString();
      session.umur = data['data']['umur'].toString();
      session.tanggalLahir = data['data']['tanggal_lahir'].toString();
      session.jenisKelamin = data['data']['jenis_kelamin'].toString();
      session.tanggalAktif = data['data']['tanggal_aktif'].toString();
      session.kota = data['data']['kota'].toString();
      session.alamat = data['data']['alamat'].toString();
    });
  }

  // Widget Button
  Widget loginButton() {
    return Container(
        margin: const EdgeInsets.only(top: 20),
        child: ButtonTheme(
            minWidth: double.infinity,
            height: 35.0,
            child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      setState(() {
                        isSubmited = true;
                      });
                      formKey.currentState.save();
                      log('Submit login');

                      submitLogin('/auth-login', {"email": email, "password": password, "device_token": deviceToken})
                          .then((result) {
                        if (result.data != null) {
                          var data = result.data;
                          if (data['status'].toString() == '200') {
                            _storage.write(key: "token", value: data['data']['token']);
                            setProfile(data);
                            checkRedirect();
                          } else {
                            displayDialog(
                                context, "Gagal", "No Anggota / Password anda salah, silahkan dicoba kembali.");
                          }
                        }
                        setState(() {
                          isSubmited = false;
                        });
                      });
                    }
                  },
                  child: (isSubmited
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ))
                      : const Text('Login', style: TextStyle(color: Colors.white))),
                ))));
  }
}
