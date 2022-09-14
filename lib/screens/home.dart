import 'package:finance/model/firebaseservice.dart';
import 'package:finance/screens/addValue.dart';
import 'package:finance/screens/budget.dart';
import 'package:finance/screens/dashboard.dart';
import 'package:finance/screens/saving.dart';
import 'package:finance/screens/setting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({Key? key}) : super(key: key);

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  int currentIndex = 0;

  final screens = [
    Dashboard(),
    Saving(),
    AddValue(),
    const Budget(),
    Setting()
  ];
  void loginCheck() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
        Navigator.pushNamedAndRemoveUntil(
            context, "/register", (route) => false);
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  void initState() {
    loginCheck();
    API().addCollection();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // body: IndexedStack(
    //   index: currentIndex,
    //   children: screens,
    // ),
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: screens[currentIndex],

        // BAR 1
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: Colors.transparent,
            labelTextStyle: MaterialStateProperty.all(TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.grey[900])),
          ),
          child: NavigationBar(
            height: 60,
            backgroundColor: const Color.fromARGB(255, 238, 250, 255),
            elevation: 0,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            selectedIndex: currentIndex,
            onDestinationSelected: (index) {
              if (index == 2) {
                showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    barrierColor: Colors.transparent,
                    context: context,
                    enableDrag: true,
                    isScrollControlled: true,
                    builder: (_) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            )),
                        child: const AddValue(),
                      );
                    });
              } else {
                setState(() {
                  currentIndex = index;
                });
              }
            },
            destinations: const [
              NavigationDestination(
                  icon: Icon(FontAwesomeIcons.house),
                  selectedIcon:
                      Icon(FontAwesomeIcons.house, color: Colors.blueAccent),
                  label: "Home"),
              NavigationDestination(
                  icon: Icon(
                    FontAwesomeIcons.piggyBank,
                  ),
                  selectedIcon: Icon(FontAwesomeIcons.piggyBank,
                      color: Colors.blueAccent),
                  label: "Saving"),
              NavigationDestination(
                  icon: Icon(FontAwesomeIcons.circlePlus),
                  selectedIcon: Icon(FontAwesomeIcons.circlePlus,
                      color: Colors.blueAccent),
                  label: "Add Value"),
              NavigationDestination(
                  icon: Icon(FontAwesomeIcons.chartSimple),
                  selectedIcon: Icon(FontAwesomeIcons.chartSimple,
                      color: Colors.blueAccent),
                  label: "Budget"),
              NavigationDestination(
                  icon: Icon(FontAwesomeIcons.gear),
                  selectedIcon:
                      Icon(FontAwesomeIcons.gear, color: Colors.blueAccent),
                  label: "Setting"),
            ],
          ),
        ),

        // // BAR 2
        // bottomNavigationBar: BottomNavigationBar(
        //   // backgroundColor: Colors.grey[900],
        //   // selectedItemColor: Colors.grey[100],
        //   // unselectedItemColor: Colors.grey[500],
        //   // showUnselectedLabels: false,
        //   currentIndex: currentIndex,
        //   // type: BottomNavigationBarType.fixed,
        //   onTap: (index) => setState(() {
        //     currentIndex = index;
        //   }),
        //   items: const [
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.home),
        //         label: "Home",
        //         backgroundColor: Colors.green),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.favorite),
        //         label: "Saving",
        //         backgroundColor: Colors.blue),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.chat),
        //         label: "Budget",
        //         backgroundColor: Colors.teal),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.settings),
        //         label: "Setting",
        //         backgroundColor: Colors.red),
        //   ],
        // ),
      ),
    );
  }
}
