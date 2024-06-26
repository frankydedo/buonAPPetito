import 'dart:async';

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
  final PageController _controllerCarosello = PageController(initialPage: 0);
  Timer? _timer;
  int paginaAttivaCarosello = 0;
  List<Ricetta> ricetteCarosello = [];

  @override
  void initState() {
    super.initState();
    ricetteCarosello =Provider.of<RicetteProvider>(context, listen: false).generaRicetteCarosello();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_controllerCarosello.page == ricetteCarosello.length-1) {
        _controllerCarosello.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      } else {
        _controllerCarosello.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Consumer2<ColorsProvider, RicetteProvider>(
      builder: (context, colorsModel, ricetteModel, _) {

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // carosello
                Center(
                  child: Stack(
                    children: [
                      // tile del carosello
                      SizedBox(
                        height: screenHeight * 0.45,
                        width: screenWidth * 0.95,
                        child: PageView.builder(
                          controller: _controllerCarosello,
                          onPageChanged: (value) {
                            setState(() {
                              paginaAttivaCarosello = value;
                            });
                          },
                          itemCount: ricetteCarosello.length,
                          itemBuilder: (context, index) {
                            return CaroselloTile(ricetta: ricetteCarosello[index]);
                          },
                        ),
                      ),

                      // indicatore di pagina
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List<Widget>.generate(
                              ricetteCarosello.length,
                              (index) => Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: InkWell(
                                  onTap: () {
                                    _controllerCarosello.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                  },
                                  child: CircleAvatar(
                                    radius: 5,
                                    backgroundColor: paginaAttivaCarosello == index ? colorsModel.coloreSecondario : Colors.white.withOpacity(.4),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: colorsModel.getColoreSecondario(),
            child: Icon(Icons.add, color: Colors.white, size: 35),
            onPressed: () {
              Navigator.pushNamed(context, '/nuovaricettapage');
            },
          ),
        );
      },
    );
  }
}
