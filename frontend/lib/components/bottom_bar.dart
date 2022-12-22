import 'package:ac/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class BottomBar extends StatefulWidget {
  final List<Widget> _pages;
  const BottomBar(List<Widget> pages, {super.key}) : _pages = pages;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _pageIndex = 0;

  void _onItemTapped(int index) {
    print("Tapped on item $index");
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget._pages[_pageIndex],
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: colors.main.crust,
          ),
          child: BottomNavigationBar(
            currentIndex: _pageIndex,
            onTap: _onItemTapped,
            elevation: 10,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: colors.main.subtext1,
            unselectedItemColor: colors.main.overlay1,
            type: BottomNavigationBarType.shifting,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Iconsax.gameboy4),
                  activeIcon: Icon(Iconsax.gameboy5),
                  label: "Devices"),
              // BottomNavigationBarItem(
              //     icon: Icon(Iconsax.chart_square),
              //     activeIcon: Icon(Iconsax.chart_square5),
              //     label: "Chart"),
              // BottomNavigationBarItem(
              //     icon: Icon(Icons.settings_outlined),
              //     activeIcon: Icon(Icons.settings),
              //     label: "Settings"),
            ],
          ),
        ));
  }
}
