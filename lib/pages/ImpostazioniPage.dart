import 'dart:io';

import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:buonappetito/utils/CambiaNomeDialog.dart';
import 'package:buonappetito/utils/FotoProfiloDialog.dart';
import 'package:buonappetito/utils/IconButtonCircolareFoto.dart';
import 'package:buonappetito/utils/SelettoreTemaDialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

class ImpostazioniPage extends StatefulWidget {
  const ImpostazioniPage({super.key});

  @override
  State<ImpostazioniPage> createState() => _ImpostazioniPageState();
}

class _ImpostazioniPageState extends State<ImpostazioniPage> {

  String temaAttuale = "";

  Future<String> saveImage(String imagePath) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String saveDirPath = path.join(appDocDir.path, 'foto_profilo');

    final Directory saveDir = Directory(saveDirPath);
    if (!await saveDir.exists()) {
      await saveDir.create(recursive: true);
    }

    final String fileName = path.basename(imagePath);
    final String newPath = path.join(saveDirPath, fileName);

    final File newImage = await File(imagePath).copy(newPath);

    return newImage.path;
  }
  
  @override
  void initState(){
    super.initState();
    temaAttuale = Provider.of<ColorsProvider>(context, listen: false).temaAttuale;
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    Future showCambiaNomeDialog(BuildContext context) {
      return showDialog(
        context: context,
        builder: (context) => CambiaNomeDialog(),
      );
    }

    Future showSelettoreTemaDialog(BuildContext context) {
      return showDialog(
        context: context,
        builder: (context) => SelettoreTemaDialog(selezione: temaAttuale,),
      );
    }

    Future<void> showFotoProfiloDialog(BuildContext context) {
      return showDialog(
        context: context,
        builder: (context) => FotoProfiloDialog(),
      );
    }

    return Consumer2<ColorsProvider, RicetteProvider>(
      builder: (context, colorsModel, ricetteModel, _) {
        return Scaffold(
          backgroundColor: colorsModel.backgroudColor,
          appBar: AppBar(
            backgroundColor: colorsModel.backgroudColor,
            iconTheme: IconThemeData(
            color: colorsModel.coloreSecondario,
            size: 28.0,
          ),
            title: Text(
              "IMPOSTAZIONI",
              style: GoogleFonts.encodeSans(
                color: colorsModel.coloreTitoli,
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          drawer: Drawer(
            backgroundColor: colorsModel.backgroudColor,
            child: ListView(
              children: [
                DrawerHeader(child: Image.asset('assets/images/logo_arancio.png')),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8),
                  child: ListTile(
                    onTap:() {Navigator.pushNamed(context, '/firstpage');},
                    leading: Icon(Icons.home_rounded, color: colorsModel.coloreSecondario),
                    title: Text("HOME", style: TextStyle(color: colorsModel.coloreSecondario, fontWeight: FontWeight.bold),),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8),
                  child: ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, '/categoriapage');
                    },
                    leading: Icon(Icons.list_outlined,
                    size: 24,
                    color: colorsModel.coloreSecondario),
                    title: Text(
                      "CATEGORIE",
                      style: TextStyle(
                          color: colorsModel.coloreSecondario,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ListTile(
                    onTap:() {Navigator.pushNamed(context, '/impostazionipage');},
                    leading: Icon(Icons.settings_rounded, color: colorsModel.coloreSecondario),
                    title: Text("IMPOSTAZIONI", style: TextStyle(color: colorsModel.coloreSecondario, fontWeight: FontWeight.bold),),
                  ),
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
            
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
            
                      //foto profilo
            
                      IconButtonCircolareFoto(
                        // onPressed: (){
                        //   pickImageFromGallery();
                        // }, 
                        // onLongPress: () {
                        //   pickImageFromCamera();
                        // },
                        onPressed: () {
                          showFotoProfiloDialog(context);
                        },
                        coloreBordo: colorsModel.coloreSecondario,
                        percorsoImmagine: ricetteModel.percorsoFotoProfilo, 
                        raggio: 92
                      ),
            
                      // nome profilo
                      
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: TextButton(
                              onPressed: ()async {
                                String? nome = await showCambiaNomeDialog(context);
                                if(nome != null){
                                  ricetteModel.cambiaNomeProfilo(nome);
                                  setState(() {});
                                }
                              },
                              child: Text(
                                ricetteModel.nomeProfilo,
                                style: GoogleFonts.encodeSans(
                                  color: colorsModel.coloreTitoli,
                                  fontSize: 35,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
            
                SizedBox(
                  height: 30,
                ),
            
                // scelta colore
            
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "COLORE APP",
                      style: GoogleFonts.encodeSans(
                        color: colorsModel.coloreTitoli,
                        fontSize: 22,
                        fontWeight: FontWeight.w800
                      ),
                    ),
                  ),
                ),
            
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: IconButtonCircolareFoto(
                          onPressed: (){
                            colorsModel.setArancioneColoreSecondario();
                            setState(() {});
                          },
                          coloreBordo: Colors.orange.shade600,
                          raggio: 60,
                          percorsoImmagine: 'assets/colori/arancio.png',
                        ),
                      ),
                      Flexible(
                        child: IconButtonCircolareFoto(
                          onPressed: (){
                            colorsModel.setBluColoreSecondario();
                            setState(() {});
                          },
                          coloreBordo: Colors.indigo.shade800,
                          raggio: 60,
                          percorsoImmagine: 'assets/colori/indigo.png',
                        ),
                      ),
                      Flexible(
                        child: IconButtonCircolareFoto(
                          onPressed: (){
                            colorsModel.setViolaColoreSecondario();
                            setState(() {});
                          },
                          coloreBordo: Colors.purple.shade600,
                          raggio: 60,
                          percorsoImmagine: 'assets/colori/viola.png',
                        ),
                      ),
                      Flexible(
                        child: IconButtonCircolareFoto(
                          onPressed: (){
                            colorsModel.setVerdeColoreSecondario();
                            setState(() {});
                          },
                          coloreBordo: Colors.green.shade800,
                          raggio: 60,
                          percorsoImmagine: 'assets/colori/verde.png',
                        ),
                      ),
                    ],
                  ),
                ),
            
                // selettore tema
            
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "TEMA APP",
                      style: GoogleFonts.encodeSans(
                        color: colorsModel.coloreTitoli,
                        fontSize: 22,
                        fontWeight: FontWeight.w800
                      ),
                    ),
                  ),
                ),
            
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: SizedBox(
                    width: screenWidth*0.95,
                    child: ElevatedButton(
                      onPressed: () async{
                        String? temaSelezionato = await showSelettoreTemaDialog(context);
                        if (temaSelezionato != null){
                          setState(() {
                            temaAttuale = temaSelezionato;
                          });
                          if (temaAttuale == "Sistema Operativo"){
                            colorsModel.setTemaAttualeSistemaOperativo(context);
                          }
                          else{
                            colorsModel.setTemaAttualeChiaroScuro(context, temaAttuale);
                          }
                        }
                        setState(() {});
                      }, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorsModel.coloreSecondario,
                      ),
                      child: Text(
                        "TEMA ATTUALE: " +temaAttuale,
                        style: GoogleFonts.encodeSans(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700
                        ),
                      )
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
