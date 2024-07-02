import 'package:buonappetito/utils/ConfermaDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
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

  void _aggiungiElementoAllaLista(String elemento, int index) {
    _listKey.currentState?.insertItem(index);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorsProvider, RicetteProvider>(
      builder: (context, colorsModel, ricetteModel, _) {
        List<String> carrello = ricetteModel.carrelloInvertito;

        Future showConfermaDialog(BuildContext context, String domanda) {
          return showDialog(
            context: context,
            builder: (context) => ConfermaDialog(domanda: domanda,),
          );
        }

        return Scaffold(
          backgroundColor: colorsModel.backgroudColor,
          appBar: AppBar(
            backgroundColor: colorsModel.backgroudColor,
            iconTheme: IconThemeData(
              color: colorsModel.coloreSecondario,
              size: 28.0,
            ),
            title: Text(
              carrello.isEmpty ? '' : 'CARRELLO',
              style: GoogleFonts.encodeSans(
                color: colorsModel.coloreTitoli,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          body: carrello.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: IconButton(
                            onPressed: () {
                              if (ricetteModel.elementiCancellatiCarrello.isNotEmpty) {
                                ricetteModel.ripristinaCancellaizioneCarrello();
                                setState(() {
                                  _aggiungiElementoAllaLista(ricetteModel.carrello.last, 0);
                                });
                              }
                            },
                            icon: Icon(
                              Icons.undo_rounded,
                              color: ricetteModel.elementiCancellatiCarrello.isNotEmpty ? colorsModel.coloreSecondario : Colors.grey.withOpacity(.5),
                              size: 30,
                            ),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                    Spacer(flex: 1),
                    Column(
                      children: [
                        Icon(
                          Icons.remove_shopping_cart_rounded,
                          color: Colors.grey,
                          size: 80,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Il tuo carrello è vuoto',
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
                          'Aggiungi gli ingredienti da acquistare\nper vederli qui.',
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
                    Spacer(flex: 2)
                  ],
                )
              : Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: IconButton(
                            onPressed: () {
                              if (ricetteModel.elementiCancellatiCarrello.isNotEmpty) {
                                ricetteModel.ripristinaCancellaizioneCarrello();
                                setState(() {
                                  _aggiungiElementoAllaLista(ricetteModel.carrello.last, 0);
                                });
                              }
                            },
                            icon: Icon(
                              Icons.undo_rounded,
                              color: ricetteModel.elementiCancellatiCarrello.isNotEmpty ? colorsModel.coloreSecondario : Colors.grey.withOpacity(.5),
                              size: 30,
                            ),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GestureDetector(
                            onTap: () async {
                              bool conferma = await showConfermaDialog(context, "Sicuro di eliminare tutti gli elementi dal carrello?");
                              if (conferma) {
                                setState(() {
                                  ricetteModel.rimuoviTuttoDalCarrello();
                                });
                              }
                            },
                            child: Text(
                              "Rimuovi tutto",
                              style: GoogleFonts.encodeSans(
                                color: colorsModel.coloreSecondario,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AnimatedList(
                          key: _listKey,
                          initialItemCount: carrello.length,
                          itemBuilder: (context, index, animation) {
                            if (index >= carrello.length) return Container(); // Controllo per evitare RangeError
                            final item = carrello[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10, right: 0, left: 4, top: 5),
                              child: Slidable(
                                endActionPane: ActionPane(
                                  motion: DrawerMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) {
                                        if (index >= carrello.length) return; // Controllo aggiuntivo per evitare RangeError
                                        setState(() {
                                          ricetteModel.rimuoviIngredienteDalCarrello(item);
                                        });
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      icon: Icons.check_rounded,
                                      backgroundColor: Colors.green,
                                    ),
                                  ],
                                ),
                                child: Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: colorsModel.tileBackGroudColor,
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
                                              style: GoogleFonts.encodeSans(
                                                color: colorsModel.textColor,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600,
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
                              )
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
