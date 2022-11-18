import 'package:ac/colors.dart';
import 'package:ac/components/bottom_bar.dart';
import 'package:ac/pages/charts.dart';
import 'package:ac/pages/devices.dart';
import 'package:ac/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
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
      const Center(child: Text("Settings")),
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
