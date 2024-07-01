import 'package:flutter/material.dart';
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
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.text.isNotEmpty && error != null) {
        setState(() {
          error = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Benvenuto in buonAPPetito\n      Inserisci il tuo nome',
                style: TextStyle(color: Colors.blue, fontSize: 24,decorationThickness: 20),
              ),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Nome utente',
                  errorText: error,
                ),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: _confirmUsername,
                child: Text('Conferma'),
              ),
              Text(
                '\n\n\nUna volta inserito un nome valido ti \n    sarà mostrato un breve tutorial\n che ti aiuterà con l\'utilizzo dell\'app.\n',
                style: TextStyle(color: Colors.blue, fontSize: 12,decorationThickness: 12),
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