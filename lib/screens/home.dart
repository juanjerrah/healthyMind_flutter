import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hm/screens/forms/diario_form.dart';
import 'package:hm/screens/diario_list_page.dart';
import 'package:hm/screens/forms/humor_form_page.dart';
import 'package:hm/screens/settings_page.dart';

import '../globals/color.dart';
import 'humor_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final screens = [
      DiarioListPage(),
      DiarioListPage(),
      HumorListPage(),
      const SettingsPage(),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cor,
        title: const Text("HealthyMind"),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        actions: currentIndex != 1
            ? const [
                FaIcon(
                  FontAwesomeIcons.filter,
                  color: Colors.white,
                ),
                SizedBox(width: 20),
                FaIcon(
                  FontAwesomeIcons.magnifyingGlass,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: screens[currentIndex],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: currentIndex == 0
            ? navigateToDiarioFormPage
            : navigateToHumorFormPage,
        tooltip: 'Increment',
        backgroundColor: cor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,

        onTap: (index) => setState(() {
          currentIndex = index;
        }),

        unselectedItemColor: Colors.white70,
        // type: BottomNavigationBarType.fixed,
        // backgroundColor: Colors.green,
        items: [
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.book),
            label: 'Diário',
            backgroundColor: cor,
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.userPlus),
            label: 'Usuários',
            backgroundColor: cor,
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.brain),
            label: 'Humor',
            backgroundColor: cor,
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.gear),
            label: 'Settings',
            backgroundColor: cor,
          ),
        ],
      ),
    );
  }

  Future<void> navigateToDiarioFormPage() async {
    final route = MaterialPageRoute(
      builder: (context) => DiarioForm(),
    );
    await Navigator.push(context, route);
    // setState(() {
    //   isLoading = true;
    // });
    // fetchTodo();
  }

  Future<void> navigateToHumorFormPage() async {
    final route = MaterialPageRoute(
      builder: (context) => HumorForm(),
    );
    await Navigator.push(context, route);
    // setState(() {
    //   isLoading = true;
    // });
    // fetchTodo();
  }
}
