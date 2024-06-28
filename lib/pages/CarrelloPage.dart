import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarrelloPage extends StatefulWidget {
  const CarrelloPage({Key? key}) : super(key: key);

  @override
  State<CarrelloPage> createState() => _CarrelloPageState();
}

class _CarrelloPageState extends State<CarrelloPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorsProvider, RicetteProvider>(
      builder: (context, colorsModel, ricetteModel, _) {
        List<String> carrello = ricetteModel.getCarrello();
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Il tuo carrello',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'CustomFont',
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: colorsModel.getColoreSecondario()),
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(child: Image.asset('assets/images/logo_arancio.png')),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8),
                  child: ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, '/firstpage');
                    },
                    leading: Icon(Icons.home_rounded, color: colorsModel.getColoreSecondario()),
                    title: Text(
                      "HOME",
                      style: TextStyle(color: colorsModel.getColoreSecondario(), fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8),
                  child: ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, '/carrellopage');
                    },
                    leading: Icon(Icons.shopping_cart_rounded, color: colorsModel.getColoreSecondario()),
                    title: Text(
                      "CARRELLO",
                      style: TextStyle(color: colorsModel.getColoreSecondario(), fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8),
                  child: ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, '/impostazionipage');
                    },
                    leading: Icon(Icons.settings_rounded, color: colorsModel.getColoreSecondario()),
                    title: Text(
                      "IMPOSTAZIONI",
                      style: TextStyle(color: colorsModel.getColoreSecondario(), fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
          body: AnimatedList(
            key: _listKey,
            initialItemCount: carrello.length,
            itemBuilder: (context, index, animation) {
              final item = carrello[index];
              return _buildItem(context, item, animation, index, ricetteModel, colorsModel);
            },
          ),
        );
      },
    );
  }

  Widget _buildItem(BuildContext context, String item, Animation<double> animation, int index, RicetteProvider ricetteModel, ColorsProvider colorsModel) {
    return SizeTransition(
      sizeFactor: animation,
      axis: Axis.vertical,
      child: Dismissible(
        key: Key(item), // Key univoca per ogni elemento
        direction: DismissDirection.startToEnd, // Cambia direzione di swipe
        background: Container(
          color: Colors.red, // Colore di sfondo quando si fa lo swipe
          child: Align(
            alignment: Alignment.centerLeft, // Allinea l'icona a sinistra
            child: Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ),
        ),
        onDismissed: (direction) {
          // Rimuove l'elemento dal provider quando viene swipato
          ricetteModel.rimuoviElementoCarrello(item);
          _listKey.currentState!.removeItem(index, (context, animation) => Container(), duration: Duration(milliseconds: 300));
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Aumenta il margine
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Aumenta il padding
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2), // Semi-trasparente
            borderRadius: BorderRadius.circular(15), // Aumenta il raggio di bordo
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 20, // Aumenta la dimensione del testo
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Colore del testo nero
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.black), // Icona di un cestino nero
                onPressed: () {
                  // Rimuove l'elemento quando viene premuto il pulsante
                  ricetteModel.rimuoviElementoCarrello(item);
                  _listKey.currentState!.removeItem(index, (context, animation) => Container(), duration: Duration(milliseconds: 300));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
