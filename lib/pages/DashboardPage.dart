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

  int paginaAttivaCarosello =0;

  @override
  Widget build(BuildContext context) {

    final PageController _controllerCarosello = PageController(initialPage: 0);

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Consumer2<ColorsProvider, RicetteProvider>(builder: (context, colorsModel, ricetteModel, _) {
      List <Ricetta> ricetteCarosello = ricetteModel.generaRicetteCarosello();
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
                      height: screenHeight *0.45,
                      width: screenWidth *0.95,
                      child: PageView.builder(
                        controller: _controllerCarosello,
                        onPageChanged: (value){
                          setState(() {
                            paginaAttivaCarosello = value;
                          });
                        },
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return CaroselloTile(ricetta: ricetteCarosello.elementAt(index));
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
                          children: List <Widget>.generate(
                            ricetteCarosello.length,
                            (index)=> Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: InkWell(
                                onTap: (){
                                  _controllerCarosello.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                },
                                child: CircleAvatar(
                                  radius: 5,
                                  backgroundColor: paginaAttivaCarosello==index ?  colorsModel.coloreSecondario : colorsModel.coloreSecondario.withOpacity(.4),
                                ),
                              ),
                            )
                      
                          )
                        ),
                      ),
                    )

                  ]
                ),
                
              )
            ],
          ),
        )
      );
    });
  }
}