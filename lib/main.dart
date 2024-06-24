// ignore_for_file: deprecated_member_use

import 'package:buonappetito/pages/DashboardPage.dart';
import 'package:buonappetito/pages/FirstPage.dart';
import 'package:buonappetito/pages/ImpostazioniPage.dart';
import 'package:buonappetito/pages/PreferitiPage.dart';
import 'package:buonappetito/pages/SearchPage.dart';
import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ColorsProvider()),
        ChangeNotifierProvider(create: (_) => RicetteProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Logica di inizializzazione
    print('App initialized');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Logica di pulizia
    print('App disposed');
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        print('App is inactive');
        break;
      case AppLifecycleState.paused:
        print('App is paused');
        break;
      case AppLifecycleState.resumed:
        print('App is resumed');
        break;
      case AppLifecycleState.detached:
        print('App is detached');
        break;
      case AppLifecycleState.hidden:
        print('App is hidden');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorsProvider, RicetteProvider>(builder: (context, colorsModel, ricetteModel, _) {
      return MaterialApp(
        title: 'buonAPPetito',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light, // Modalità scura non ancora disponibile
        theme: ThemeData(
          scaffoldBackgroundColor: colorsModel.getColorePrimario(context),
          datePickerTheme: DatePickerThemeData(
            backgroundColor: colorsModel.getColorePrimario(context),
            todayForegroundColor: MaterialStatePropertyAll(Colors.blue[900]),
          ),
          drawerTheme: DrawerThemeData(
            backgroundColor: colorsModel.getColorePrimario(context),
          ),
          appBarTheme: AppBarTheme(
            color: colorsModel.getColorePrimario(context),
            iconTheme: IconThemeData(
              color: colorsModel.getColoreSecondario(),
              size: 28.0,
            ),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: colorsModel.getColorePrimario(context),
            selectedItemColor: colorsModel.getColoreSecondario(),
            unselectedItemColor: colorsModel.getColoreSecondario(),
            selectedIconTheme: IconThemeData(
              size: 30,
              opacity: 1,
            ),
            unselectedIconTheme: IconThemeData(
              size: 25,
              opacity: .5,
            ),
            selectedLabelStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        darkTheme: ThemeData(
          scaffoldBackgroundColor: Colors.grey[850],
          datePickerTheme: DatePickerThemeData(
            backgroundColor: Colors.grey[850],
            todayForegroundColor: MaterialStatePropertyAll(Colors.blue[900]),
          ),
          drawerTheme: DrawerThemeData(
            backgroundColor: Colors.grey[850],
          ),
          appBarTheme: AppBarTheme(
            color: Colors.grey[850],
            iconTheme: IconThemeData(
              color: Colors.grey,
              size: 28.0,
            ),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.grey[850],
            selectedItemColor: Colors.grey,
            unselectedItemColor: Colors.grey,
            selectedIconTheme: IconThemeData(
              size: 30,
              opacity: 1,
            ),
            unselectedIconTheme: IconThemeData(
              size: 25,
              opacity: .5,
            ),
            selectedLabelStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        home: FirstPage(),
        routes: {
          '/firstpage': (context) => FirstPage(),
          '/dashboardpage': (context) => DashboardPage(),
          '/searchpage': (context) => SearchPage(),
          '/preferitipage': (context) => PreferitiPage(),
          '/impostazionipage': (context) => ImpostazioniPage(),
        },
      );
    });
  }
}
