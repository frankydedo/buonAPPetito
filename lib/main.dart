// ignore_for_file: deprecated_member_use, unused_import

import 'package:buonappetito/models/Ricetta.dart';
import 'package:buonappetito/pages/CarrelloPage.dart';
import 'package:buonappetito/pages/CategoriaPage.dart';
import 'package:buonappetito/pages/DashboardPage.dart';
import 'package:buonappetito/pages/FirstPage.dart';
import 'package:buonappetito/pages/ImpostazioniPage.dart';
import 'package:buonappetito/pages/NuovaRicettaPage.dart';
import 'package:buonappetito/pages/PreferitiPage.dart';
import 'package:buonappetito/pages/RicettaPage.dart';
import 'package:buonappetito/pages/SearchPage.dart';
import 'package:buonappetito/providers/DifficultyProvider.dart';
import 'package:buonappetito/providers/TimeProvider.dart';
import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  final appDocsDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocsDir.path);
 // Hive.registerAdapter(CategoriaAdapter());
 // Hive.registerAdapter(RicettaAdapter());

  await Hive.openBox<Ricetta>('Recipes');
  await Hive.openBox('Colors');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ColorsProvider()),
        ChangeNotifierProvider(create: (_) => RicetteProvider()),
        ChangeNotifierProvider(create: (_) => DifficultyProvider()),
        ChangeNotifierProvider(create: (_) => Timeprovider()),
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

    Future.microtask(() {
      final colorsProvider = Provider.of<ColorsProvider>(context, listen: false);
      colorsProvider.initLightMode(context);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    if(Provider.of<ColorsProvider>(context, listen: false).temaAttuale == "Sistema Operativo"){
      final colorsProvider = Provider.of<ColorsProvider>(context, listen: false);
      colorsProvider.updateLightMode(context);
    }
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
        // themeMode: colorsModel.temaAttuale=="Sistema Operativo"? ThemeMode.system : ThemeMode.light, // Modalità scura non ancora disponibile
        // theme: ThemeData(
        //   scaffoldBackgroundColor: colorsModel.backgroudColor,
        //   datePickerTheme: DatePickerThemeData(
        //     backgroundColor: colorsModel.backgroudColor,
        //     todayForegroundColor: MaterialStatePropertyAll(Colors.blue[900]),
        //   ),
        //   drawerTheme: DrawerThemeData(
        //     backgroundColor: colorsModel.backgroudColor,
        //   ),
        //   appBarTheme: AppBarTheme(
        //     color: colorsModel.backgroudColor,
        //     iconTheme: IconThemeData(
        //       color: colorsModel.coloreSecondario,
        //       size: 28.0,
        //     ),
        //   ),
        //   bottomNavigationBarTheme: BottomNavigationBarThemeData(
        //     backgroundColor: colorsModel.backgroudColor,
        //     selectedItemColor: colorsModel.coloreSecondario,
        //     unselectedItemColor: colorsModel.coloreSecondario,
        //     selectedIconTheme: IconThemeData(
        //       size: 30,
        //       opacity: 1,
        //     ),
        //     unselectedIconTheme: IconThemeData(
        //       size: 25,
        //       opacity: .5,
        //     ),
        //     selectedLabelStyle: TextStyle(
        //       fontSize: 18,
        //       fontWeight: FontWeight.bold,
        //     ),
        //     unselectedLabelStyle: TextStyle(
        //       fontSize: 13,
        //       fontWeight: FontWeight.normal,
        //     ),
        //   ),
        // ),
        // darkTheme: ThemeData(
        //   scaffoldBackgroundColor: Colors.grey[850],
        //   datePickerTheme: DatePickerThemeData(
        //     backgroundColor: Colors.grey[850],
        //     todayForegroundColor: MaterialStatePropertyAll(Colors.blue[900]),
        //   ),
        //   drawerTheme: DrawerThemeData(
        //     backgroundColor: Colors.grey[850],
        //   ),
        //   appBarTheme: AppBarTheme(
        //     color: Colors.grey[850],
        //     iconTheme: IconThemeData(
        //       color: Colors.grey,
        //       size: 28.0,
        //     ),
        //   ),
        //   bottomNavigationBarTheme: BottomNavigationBarThemeData(
        //     backgroundColor: colorsModel.getBackgroudColor(context),
        //     selectedItemColor: colorsModel.coloreSecondario,
        //     unselectedItemColor: colorsModel.coloreSecondario,
        //     selectedIconTheme: IconThemeData(
        //       size: 30,
        //       opacity: 1,
        //     ),
        //     unselectedIconTheme: IconThemeData(
        //       size: 25,
        //       opacity: .5,
        //     ),
        //     selectedLabelStyle: TextStyle(
        //       fontSize: 18,
        //       fontWeight: FontWeight.bold,
        //     ),
        //     unselectedLabelStyle: TextStyle(
        //       fontSize: 13,
        //       fontWeight: FontWeight.normal,
        //     ),
        //   ),
        // ),
        // theme: ThemeData(
        //   inputDecorationTheme: InputDecorationTheme(
        //   focusedBorder: OutlineInputBorder(
        //     borderSide: BorderSide(color: colorsModel.coloreSecondario, width: 2.0),
        //   ),
        //   enabledBorder: OutlineInputBorder(
        //     borderSide: BorderSide(color: colorsModel.coloreSecondario, width: 1.0),
        //   ),
        //   ),
        // ),
        home: FirstPage(),
        routes: {
          '/firstpage': (context) => FirstPage(),
          '/dashboardpage': (context) => DashboardPage(),
          '/searchpage': (context) => SearchPage(),
          '/preferitipage': (context) => PreferitiPage(),
          '/impostazionipage': (context) => ImpostazioniPage(),
          '/nuovaricettapage': (context) => NuovaRicettaPage(),
          '/carrellopage': (context) => CarrelloPage(),
          '/categoriapage': (context) => CategoriaPage(),
        },
      );
    });
  }
}
