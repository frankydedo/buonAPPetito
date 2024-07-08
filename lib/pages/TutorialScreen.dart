import 'dart:io';

import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:buonappetito/utils/IconButtonCircolareFoto.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:buonappetito/pages/FirstPage.dart'; // Aggiunto import di UsernamePage

class TutorialScreen extends StatefulWidget {
  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  String? username;

  void _onSkip() async {
    await _setTutorialSeen(); // Salva il flag come visto il tutorial
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => FirstPage()),
    );
  }

  // Funzione per salvare il flag "seenTutorial" in SharedPreferences
  Future<void> _setTutorialSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenTutorial', true);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      // Utilizziamo una GestureDetector per disabilitare lo swipe sulla UsernamePage
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragUpdate: (_) {}, // Consuma gli eventi di swipe orizzontale
        child: UsernamePage(
          onConfirm: (value) {
            setState(() {
              username = value;
            });
          },
          onNextPage: () {
            if (username == null || username!.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Inserisci nome utente valido')),
              );
            } else {
              _onSkip();
            }
          },
        ),
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: _pages,
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(width: 100.0),
                if (_currentPage == 0 && (username == null || username!.isEmpty))
                  SizedBox(width: 100.0) // Disabilita il pulsante "Salta" se il nome utente non è inserito
                else
                  ElevatedButton(
                    onPressed: _onSkip,
                    child: Text('Salta'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UsernamePage extends StatefulWidget {
  final ValueChanged<String> onConfirm;
  final VoidCallback onNextPage;

  UsernamePage({required this.onConfirm, required this.onNextPage});

  @override
  _UsernamePageState createState() => _UsernamePageState();
}

class _UsernamePageState extends State<UsernamePage> {
  final TextEditingController _controller = TextEditingController();
  String? error;
  String percorsoImmagine = 'assets/images/logoAPPetito-1024.png';

  Future<void> pickImageFromCamera() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image == null) return;

    String imagePath = await saveImage(image.path);
    setState(() {
      percorsoImmagine = imagePath;
    });
  }

  Future<void> pickImageFromGallery() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;

    String imagePath = await saveImage(image.path);
    setState(() {
      percorsoImmagine = imagePath;
    });
  }

  Future<String> saveImage(String imagePath) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String saveDirPath = path.join(appDocDir.path, 'foto_piatti_gz');

    final Directory saveDir = Directory(saveDirPath);
    if (!await saveDir.exists()) {
      await saveDir.create(recursive: true);
    }

    final String fileName = path.basename(imagePath);
    final String newPath = path.join(saveDirPath, fileName);

    final File newImage = await File(imagePath).copy(newPath);

    return newImage.path;
  }

  void _confirmUsername() {
    if (_controller.text.isEmpty) {
      setState(() {
        error = 'Inserisci nome utente valido';
      });
    } else {
      setState(() {
        error = null;
      });
      widget.onConfirm(_controller.text);
      widget.onNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorsModel = Provider.of<ColorsProvider>(context);
    final ricetteModel = Provider.of<RicetteProvider>(context);

    return Scaffold(
      backgroundColor: colorsModel.backgroudColor,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SizedBox(height: 150),
            Text(
              'Benvenuto in buonAPPetito',
              textAlign: TextAlign.center,
              style: GoogleFonts.encodeSans(
                color: colorsModel.coloreTitoli,
                fontSize: 30,
                fontWeight: FontWeight.w800
              )
            ),
            SizedBox(height: 130),
            Text(
              'Inserisci il tuo nome',
              textAlign: TextAlign.center,
              style: GoogleFonts.encodeSans(
                color: colorsModel.coloreTitoli,
                fontSize: 25,
                fontWeight: FontWeight.w600
              )
            ),

            //nome e foto profilo
             
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButtonCircolareFoto(
                    onPressed: () {},
                    coloreBordo: colorsModel.coloreSecondario,
                    percorsoImmagine: percorsoImmagine, 
                    raggio: 55,
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.done,
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.top,
                      style: TextStyle(
                        color: colorsModel.textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Nome utente',
                        errorText: error,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        hintStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 80),

            // tasti per la selezione della foto profilo

            Text(
              'Scegli la tua foto profilo',
              textAlign: TextAlign.center,
              style: GoogleFonts.encodeSans(
                color: colorsModel.coloreTitoli,
                fontSize: 25,
                fontWeight: FontWeight.w600
              )
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => pickImageFromCamera(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorsModel.coloreSecondario,
                      foregroundColor: Colors.white
                    ),
                    child: Icon(Icons.camera_alt),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => pickImageFromGallery(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorsModel.coloreSecondario,
                      foregroundColor: Colors.white
                    ),
                    child: Icon(Icons.photo_library),
                  ),
                ],
              ),
            ),

              Spacer(),

              // tasto conferma

              Padding(
                padding: const EdgeInsets.only(bottom: 12.0, top: 12, right: 30, left:30),
                child: ElevatedButton(
                  onPressed: (){
                    ricetteModel.cambiaNomeProfilo(_controller.text);
                    ricetteModel.cambiaFotoProfilo(percorsoImmagine);
                    _confirmUsername();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorsModel.coloreSecondario
                  ),
                  child: Padding(
                  padding: const EdgeInsets.only(bottom: 6.0, top: 6, right: 30, left:30),
                    child: Text(
                      "Conferma",
                      style: GoogleFonts.encodeSans(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  )
                ),
              ),
          ],
        ),
      ),
    );
  }
}
