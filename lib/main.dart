import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenwall/authentication_service.dart';
import 'package:zenwall/home.dart';
import 'package:zenwall/log.dart';
import 'firebase_options.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String _title = 'Zenex';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => AuthenticationService(FirebaseAuth.instance)),
        StreamProvider(
            create: (context) =>
                context.read()<AuthenticationService>().authStateChanges,
            initialData: null)
      ],
      child: const MaterialApp(
        title: _title,
        home: AuthenticationWrapper(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const Homescreen();
            } else {
              return const Logscreen();
            }
          }),
    );
  }
}
