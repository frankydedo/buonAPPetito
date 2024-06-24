import 'package:buonappetito/models/Ricetta.dart';
import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:buonappetito/utils/CaroselloTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Consumer2<ColorsProvider, RicetteProvider>(builder: (context, colorsModel, ricetteModel, _) {
      List <Ricetta> ricetteCarosello = ricetteModel.generaRicetteCarosello();
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: SizedBox(
                  height: screenHeight *0.45,
                  width: screenWidth *0.95,
                  child: PageView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return CaroselloTile(ricetta: ricetteCarosello.elementAt(index));
                    },
                  ),
                ),
              )
            ],
          ),
        )
      );
    });
  }
}