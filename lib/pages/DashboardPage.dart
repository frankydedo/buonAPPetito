import 'dart:async';

import 'package:buonappetito/models/Ricetta.dart';
import 'package:buonappetito/pages/RicettaPage.dart';
import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:buonappetito/utils/AggiuntiDiRecenteTile.dart';
import 'package:buonappetito/utils/CaroselloTile.dart';
import 'package:buonappetito/utils/FinestraTemporaleDialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  List<Ricetta> aggiuntiDiRecente = [];

  @override
  void initState() {
    super.initState();
    ricetteCarosello = Provider.of<RicetteProvider>(context, listen: false).ricetteCarosello;
    aggiuntiDiRecente = Provider.of<RicetteProvider>(context, listen: false).generaAggiuntiDiRecente();
    if(ricetteCarosello.isNotEmpty){
      startTimer();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _controllerCarosello.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_controllerCarosello.page == ricetteCarosello.length-1) {
        _controllerCarosello.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
      } else {
        _controllerCarosello.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Consumer2<ColorsProvider, RicetteProvider>(
      builder: (context, colorsModel, ricetteModel, _) {

      Future showFinestraTemporaleDialog(BuildContext context) {
        return showDialog(
          context: context,
          builder: (context) => FinestraTemporaleDialog(),
        );
      }

        return Scaffold(
          backgroundColor: colorsModel.backgroudColor,
          body: ricetteModel.ricette.isEmpty?
          Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_box_rounded,
                    color: Colors.grey,
                    size: 80,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Nulla da vedere qui',
                    style: GoogleFonts.encodeSans(
                      textStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Aggiungi la tua prima ricetta\ncliccando il tasto +',
                    style: GoogleFonts.encodeSans(
                      textStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          :
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 12, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "CONSIGLIATI",
                      style: GoogleFonts.encodeSans(
                        color: colorsModel.coloreTitoli,
                        fontSize: 22,
                        fontWeight: FontWeight.w800
                      ),
                    ),
                  ),
                ),
                // carosello
                Center(
                  child: Stack(
                    children: [
                      // tile del carosello
                      SizedBox(
                        height: 420,
                        width: screenWidth * 0.95,
                        child: PageView.builder(
                          controller: _controllerCarosello,
                          onPageChanged: (value) {
                            setState(() {
                              paginaAttivaCarosello = value;
                              _timer!.cancel();
                              startTimer();
                            });
                          },
                          itemCount: ricetteCarosello.length,
                          itemBuilder: (context, index) {
                            Ricetta ric = ricetteCarosello[index];
                            return GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context){return RicettaPage(recipe: ric);})).then((_){
                                  setState(() {
                                    aggiuntiDiRecente = ricetteModel.generaAggiuntiDiRecente();
                                    ricetteCarosello = ricetteModel.generaRicetteCarosello();
                                  });
                                });
                              },
                              child: CaroselloTile(ricetta: ricetteCarosello[index])
                            );
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

                //aggiunti di recente

                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 30, 12, 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "AGGIUNTI DI RECENTE",
                      style: GoogleFonts.encodeSans(
                        color: colorsModel.coloreTitoli,
                        fontSize: 22,
                        fontWeight: FontWeight.w800
                      ),
                    ),
                  ),
                ),

                // tasto per la selezione della finestra temporale in cui visualizzare le ricette  

                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: SizedBox(
                    width: screenWidth*0.95,
                    child: ElevatedButton(
                      onPressed: () async{
                        await showFinestraTemporaleDialog(context);
                        setState(() {
                          aggiuntiDiRecente = ricetteModel.generaAggiuntiDiRecente();
                        });
                      }, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorsModel.coloreSecondario,
                      ),
                      child: Text(
                        ricetteModel.finestraTemporale==1
                        ? ricetteModel.finestraTemporale.toString()+" SETTIMANA"
                        : ricetteModel.finestraTemporale.toString()+" SETTIMANE",
                        style: GoogleFonts.encodeSans(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700
                        ),
                      )
                    ),
                  ),
                ),

                // vista aggiunti di recente

                aggiuntiDiRecente.isEmpty?

                Text(
                  "\nNulla da mostrare qui :)",
                  style: GoogleFonts.encodeSans(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                  ),
                )

                :

                SizedBox(
                  height: 360,
                  width: screenWidth,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        aggiuntiDiRecente.length,
                        (index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                            child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context){return RicettaPage(recipe: aggiuntiDiRecente[index]);})).then((_){
                                  setState(() {});
                                  aggiuntiDiRecente = ricetteModel.generaAggiuntiDiRecente();
                                  ricetteCarosello = ricetteModel.generaRicetteCarosello();
                                });
                              },
                              child: AggiuntiDiRecenteTile(
                                ricetta: aggiuntiDiRecente.elementAt(index),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 4,
                )
              ],
            ),
          ),

          //tasto per l'aggiunta di una nuova ricetta 
          
          floatingActionButton: FloatingActionButton(
            backgroundColor: colorsModel.coloreSecondario,
            child: Icon(Icons.add, color: Colors.white, size: 35),
            onPressed: () {
              Navigator.pushNamed(context, '/nuovaricettapage').then((_){
                setState(() {
                  aggiuntiDiRecente = Provider.of<RicetteProvider>(context, listen: false).generaAggiuntiDiRecente();
                });
              });
            },
          ),
        );
      },
    );
  }
}
