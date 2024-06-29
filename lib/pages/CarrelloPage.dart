import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';

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
        List<String> carrello = ricetteModel.carrello;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              carrello.isEmpty ? '' : '',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'CustomFont',
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: colorsModel.getColoreSecondario()),
            elevation: 0, // Aggiunto per avere un look flat
          ),
          backgroundColor: Colors.white, // Sfondo della pagina impostato su bianco
          drawer: Drawer(
            child: ListView(
            children: [
              DrawerHeader(child: Image.asset('assets/images/logo_arancio.png')),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8),
                child: ListTile(
                  onTap:() {Navigator.pushNamed(context, '/firstpage');},
                  leading: Icon(Icons.home_rounded, color: colorsModel.getColoreSecondario()),
                  title: Text("HOME", style: TextStyle(color: colorsModel.getColoreSecondario(), fontWeight: FontWeight.bold),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8),
                child: ListTile(
                  onTap:() {Navigator.pushNamed(context, '/carrellopage');},
                  leading: Icon(Icons.shopping_cart_rounded, color: colorsModel.getColoreSecondario()),
                  title: Text("CARRELLO", style: TextStyle(color: colorsModel.getColoreSecondario(), fontWeight: FontWeight.bold),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8),
                child: ListTile(
                  onTap:() {Navigator.pushNamed(context, '/impostazionipage');},
                  leading: Icon(Icons.settings_rounded, color: colorsModel.getColoreSecondario()),
                  title: Text("IMPOSTAZIONI", style: TextStyle(color: colorsModel.getColoreSecondario(), fontWeight: FontWeight.bold),),
                ),
              ),
            ],
          ),
          ),
          body: carrello.isEmpty
              ? Center(
                  child: Text(
                    'Carrello vuoto...',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : AnimatedList(
                  key: _listKey,
                  initialItemCount: carrello.length,
                  itemBuilder: (context, index, animation) {
                    if (index >= carrello.length) return Container(); // Controllo per evitare RangeError
                    final item = carrello[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10, right: 5, left: 4, top: 5),
                      child: _buildSlidableItem(context, item, index, ricetteModel, colorsModel),
                    );
                  },
                ),
        );
      },
    );
  }

  void _removeItem(int index, RicetteProvider ricetteModel) {
    if (index < 0 || index >= ricetteModel.carrello.length) return; // Controllo per evitare RangeError
    final item = ricetteModel.carrello[index];

    _listKey.currentState!.removeItem(
      index,
      (context, animation) => FadeTransition(
        opacity: animation,
        child: _buildSlidableItem(context, item, index, ricetteModel, context.read<ColorsProvider>()),
      ),
      //duration: Duration(milliseconds: 0),
    );

    ricetteModel.rimuoviElementoCarrello(item);

    // Aggiorna lo stato per riflettere i cambiamenti
    setState(() {});
  }

  Widget _buildSlidableItem(BuildContext context, String item, int index, RicetteProvider ricetteModel, ColorsProvider colorsModel) {
    return Slidable(
      endActionPane: ActionPane(
        motion: DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              if (index >= ricetteModel.carrello.length) return; // Controllo aggiuntivo per evitare RangeError
              _removeItem(index, ricetteModel);
            },
            borderRadius: BorderRadius.circular(20),
            icon: Icons.delete_outline,
            backgroundColor: Colors.red,
          ),
        ],
      ),
      child: Container(
        height: 80,
        margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0, top: 15),
                child: Icon(
                  Icons.shopping_cart,
                  color: Colors.green,
                  size: 32,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 15),
                child: Icon(
                  Icons.keyboard_double_arrow_left_rounded,
                  color: Colors.grey[400],
                  size: 35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
