// @dart=2.9

import 'package:flexirol_app/src/pages/bancaria.dart';
import 'package:flexirol_app/src/pages/cuenta.dart';
import 'package:flexirol_app/src/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flexirol_app/src/bloc/provider.dart';
import 'package:flexirol_app/src/pages/login_page.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flexirol_app/src/preferencias_usuario/preferencias_usuario.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final prefs = new PreferenciasUsuario();
    print("token en el principal:");
    print (prefs.token);



    return Provider(

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FlexiRol App',
        initialRoute: 'login',
        routes: {
          'login' : ( BuildContext context ) => LoginPage(),
          'navigationbar' : ( BuildContext context ) => MyBottomNavigationBar(),
          'dashboard'  : ( BuildContext context ) => Dashboard(),
          'bancaria'  : ( BuildContext context ) => Bancaria(),
          'cuenta'  : ( BuildContext context ) => Usuario(),


        },
        theme: ThemeData(
          primaryColor: Colors.blueAccent,
        ),
      ),
    );
      
  }
}


class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _initializeTimer();
  }
  void _initializeTimer() {
    if (_timer != null) {
      _timer.cancel();
    }

    _timer = Timer(const Duration(seconds: 300), _logOutUser);
  }

  void _logOutUser() async {
    _timer?.cancel();
    _timer = null;

    // Popping all routes and pushing welcome screen
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs?.clear();
    print("token limpio");

    final _prefs = new PreferenciasUsuario();
    _prefs.token = "porborrar";

    print(_prefs.token);

    Navigator.pushReplacementNamed(context, 'login');

  }

  void _handleUserInteraction([_]) {
    _initializeTimer();
  }

 @override

  PageController _pageController = PageController();
  List<Widget> _screens = [
    Dashboard(),Bancaria(),Usuario(),
  ];
  int _selectedIndex = 0;
  void _onpagechanged(int index){
    setState(() {
      _selectedIndex = index;
    });
  }
  void _itemtapped(int selectedIndex){
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
     onTap: _handleUserInteraction,
     onPanDown: _handleUserInteraction,
     child:Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onpagechanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
      //   fixedColor : Colors.cyan,
         iconSize: 30.0,
         selectedItemColor: Colors.black45,
         unselectedItemColor: Colors.black45,
         selectedFontSize: 15.0,
         unselectedFontSize: 15.0,
        showUnselectedLabels: true ,

        onTap: _itemtapped,

        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard,color: _selectedIndex == 0 ? Colors.blueAccent : Colors.grey,),
              label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: Icon(Icons.business,color: _selectedIndex == 1 ? Colors.blueAccent : Colors.grey,),
              label: 'Bancaria'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle, color: _selectedIndex == 2 ? Colors.blueAccent : Colors.grey,),
              label: 'Usuario')

        ],
      ),

    ),
     );
  }
}

