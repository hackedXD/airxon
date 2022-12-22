import 'package:ac/colors.dart';
import 'package:ac/components/bottom_bar.dart';
import 'package:ac/pages/charts.dart';
import 'package:ac/pages/devices.dart';
import 'package:ac/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  try {
    final userCredential = await FirebaseAuth.instance.signInAnonymously();
    print("Signed in with temporary account.");
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "operation-not-allowed":
        print("Anonymous auth hasn't been enabled for this project.");
        break;
      default:
        print("Unknown error.");
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      const HomePage(),
      const DevicesPage(),
      const ChartsPage(),
      // const Center(child: Text("Settings")),
    ];

    return MaterialApp(
      title: 'AC App',
      theme: ThemeData(
        colorScheme: colorScheme,
        canvasColor: colors.main.base,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        // textTheme: GoogleFonts.barlowTextTheme()
      ),
      home: BottomBar(pages),
      debugShowCheckedModeBanner: false,
    );
  }
}
