import 'package:flutter/material.dart';
import 'package:karting_app/presentation/placeholder.dart';
import 'package:karting_app/presentation/placeholder2.dart';
import 'package:karting_app/presentation/user_role_managment.dart';

class BottomNav extends StatefulWidget {
  final Function(int) currentIndex;
  final List<String> roles;

  const BottomNav({super.key, required this.currentIndex, required this.roles});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late PageController? _pageController;
  int currentIndex = 0;
  List<BottomNavigationBarItem> bottomNavBarItems = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    bottomNavBarItems = [];

    if (widget.roles.contains('Escritor')) {
      bottomNavBarItems.add(
        const BottomNavigationBarItem(
          icon: Icon(Icons.car_rental),
          label: 'Karting',
        ),
      );
    }

    if (widget.roles.contains('Lector')) {
      bottomNavBarItems.add(
        const BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Consulta',
        ),
      );
    }

    if (widget.roles.contains('Administrador')) {
      bottomNavBarItems.add(
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Usuarios',
        ),
      );
    }

    final bool shouldBuildNavBar = bottomNavBarItems.length > 1;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        children: [
          if (widget.roles.contains('Escritor')) const PlaceHolder1(),
          if (widget.roles.contains('Lector')) const PlaceHolder2(),
          if (widget.roles.contains('Administrador'))
            const UserRoleManagement(),
        ],
      ),
      bottomNavigationBar: shouldBuildNavBar
          ? BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (int i) {
                setState(() {
                  currentIndex = i;
                  widget.currentIndex(i);
                  _pageController!.animateToPage(
                    i,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                });
              },
              backgroundColor: Colors.white,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.grey,
              iconSize: 30,
              type: BottomNavigationBarType.fixed,
              items: bottomNavBarItems,
            )
          : null,
    );
  }
}
