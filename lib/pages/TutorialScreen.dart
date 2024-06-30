//import 'package:buonappetito/pages/DashboardPage.dart';
import 'package:buonappetito/pages/FirstPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Pagina di tutorial 1
class TutorialPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('TUTORIAL PAGE 1'),
    );
  }
}

// Pagina di tutorial 2
class TutorialPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('TUTORIAL PAGE 2'),
    );
  }
}

// Pagina di tutorial 3
class TutorialPage3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('TUTORIAL PAGE 3'),
    );
  }
}

// Schermata principale del tutorial con navigazione
class TutorialScreen extends StatefulWidget {
  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  List<Widget> _pages = [
    TutorialPage1(),
    TutorialPage2(),
    TutorialPage3(),
  ];

  void _onSkip() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenTutorial', true);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => FirstPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
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
              ),
            ElevatedButton(
              onPressed: _onSkip,
              child: Text('Salta'),
            ),
            if (_currentPage < _pages.length - 1)
              ElevatedButton(
                onPressed: () {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                },
                child: Text('Avanti'),
              ),
          ],
        ),
      ),
    );
  }
}

// HomePage di esempio
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Text('Benvenuto nella Home Page!'),
      ),
    );
  }
}
