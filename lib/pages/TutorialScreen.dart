import 'dart:io';

import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:buonappetito/pages/FirstPage.dart';// Aggiunto import di UsernamePage

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
              _pageController.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            }
          },
        ),
      ),
      TutorialPageDashboard(
        onNextPage: () {
          _pageController.nextPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        },
      ),
      TutorialPageSearch(
        onPreviousPage: () {
          _pageController.previousPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        },
        onNextPage: () {
          _pageController.nextPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        },
      ),
      RecipePage1(
        onPreviousPage: () {
          _pageController.previousPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        },
        onSkip: _onSkip,
      ),

      RecipePage2(
        onPreviousPage: () {
          _pageController.previousPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        },
        onSkip: _onSkip,
      ),

      CarrelloPageTutorial(
        onPreviousPage: () {
          _pageController.previousPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        },
        onSkip: _onSkip,
      ),

      PreferitiPageTutorial(
        onPreviousPage: () {
          _pageController.previousPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        },
        onSkip: _onSkip,
      ),

      ImpostazioniPageTutorial(
        onPreviousPage: () {
          _pageController.previousPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        },
        onSkip: _onSkip,
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
                if (_currentPage > 0)
                  ElevatedButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    },
                    child: Text('Indietro'),
                  )
                else
                  SizedBox(width: 100.0), // Spazio vuoto a sinistra (non cliccabile alla prima pagina)
                if (_currentPage > 0)
                  ElevatedButton(
                    onPressed: _currentPage == 0 && (username == null || username!.isEmpty)
                        ? null
                        : _onSkip,
                    child: Text('Salta'),
                  ),
                if (_currentPage < _pages.length - 1 && _currentPage > 0)
                  ElevatedButton(
                    onPressed: _currentPage == 0 && (username == null || username!.isEmpty)
                        ? null
                        : () {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          },
                    child: Text('Avanti'),
                  )
                else if (_currentPage > 0)
                  ElevatedButton(
                    onPressed: _onSkip,
                    child: Text('Fine'),
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
  String? percorsoImmagine; // Percorso dell'immagine selezionata

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

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Benvenuto in buonAPPetito',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blue, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'Inserisci il tuo nome',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blue, fontSize: 24),
              ),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Nome utente',
                  errorText: error,
                ),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => pickImageFromCamera(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorsModel.coloreSecondario,
                    ),
                    child: Icon(Icons.camera_alt),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => pickImageFromGallery(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorsModel.coloreSecondario,
                    ),
                    child: Icon(Icons.photo_library),
                  ),
                ],
              ),
              if (percorsoImmagine != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50), // Forma circolare
                    child: Image.file(
                      File(percorsoImmagine!),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ElevatedButton(
                onPressed: _confirmUsername,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorsModel.coloreSecondario,
                ),
                child: Text('Conferma'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class TutorialPageDashboard extends StatelessWidget {
  final VoidCallback onNextPage;

  TutorialPageDashboard({required this.onNextPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 0, left: 4), // Aggiungi padding qui come fosse una AppBar
          child: Center(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/foto_tutorial/DashboardPageComp.png',
                  ),
                  fit: BoxFit.contain, // Ridimensiona l'immagine per essere visibile interamente
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TutorialPageSearch extends StatelessWidget {
  final VoidCallback onPreviousPage;
  final VoidCallback onNextPage;

  TutorialPageSearch({required this.onPreviousPage, required this.onNextPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 0,top:0 ), // Aggiungi padding qui come fosse una AppBar
          child: Center(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/foto_tutorial/SearchPageComplete.png',
                  ),
                  fit: BoxFit.contain, // Ridimensiona l'immagine per essere visibile interamente
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class RecipePage1 extends StatelessWidget {
  final VoidCallback onPreviousPage;
  final VoidCallback onSkip;

  RecipePage1({required this.onPreviousPage, required this.onSkip});

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 0, left: 4), // Aggiungi padding qui come fosse una AppBar
          child: Center(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/foto_tutorial/NewRecipePart1.png',
                  ),
                  fit: BoxFit.contain, // Ridimensiona l'immagine per essere visibile interamente
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RecipePage2 extends StatelessWidget {
  final VoidCallback onPreviousPage;
  final VoidCallback onSkip;

  RecipePage2({required this.onPreviousPage, required this.onSkip});

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 0, left: 4), // Aggiungi padding qui come fosse una AppBar
          child: Center(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/foto_tutorial/NewRecipePart2.png',
                  ),
                  fit: BoxFit.contain, // Ridimensiona l'immagine per essere visibile interamente
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ImpostazioniPageTutorial extends StatelessWidget {
  final VoidCallback onPreviousPage;
  final VoidCallback onSkip;

  ImpostazioniPageTutorial({required this.onPreviousPage, required this.onSkip});

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 0, left: 4), // Aggiungi padding qui come fosse una AppBar
          child: Center(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/foto_tutorial/ImpostazioniComp.png',
                  ),
                  fit: BoxFit.contain, // Ridimensiona l'immagine per essere visibile interamente
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CarrelloPageTutorial extends StatelessWidget {
  final VoidCallback onPreviousPage;
  final VoidCallback onSkip;

  CarrelloPageTutorial({required this.onPreviousPage, required this.onSkip});

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 0, left: 4), // Aggiungi padding qui come fosse una AppBar
          child: Center(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/foto_tutorial/CarrelloComp.png',
                  ),
                  fit: BoxFit.contain, // Ridimensiona l'immagine per essere visibile interamente
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PreferitiPageTutorial extends StatelessWidget {
  final VoidCallback onPreviousPage;
  final VoidCallback onSkip;

  PreferitiPageTutorial({required this.onPreviousPage, required this.onSkip});

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 0, left: 4), // Aggiungi padding qui come fosse una AppBar
          child: Center(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/foto_tutorial/PreferitiComp.png',
                  ),
                  fit: BoxFit.contain, // Ridimensiona l'immagine per essere visibile interamente
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}