import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CambiaNomeDialog extends StatefulWidget {

  const CambiaNomeDialog({Key? key}) : super(key: key);

  @override
  _CambiaNomeDialogState createState() => _CambiaNomeDialogState();
}

class _CambiaNomeDialogState extends State<CambiaNomeDialog> {
  String? provNome;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorsProvider, RicetteProvider>(
      builder: (context, colorsModel, ricetteModel, _) {
        return AlertDialog(
          backgroundColor: colorsModel.backgroudColor,
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // icona [?]
                Icon(
                  Icons.help_outline,
                  color: colorsModel.coloreSecondario,
                  size: 70,
                ),
                SizedBox(height: 20),

                // testo richiesta
                Text(
                  "Inserisci il tuo nome",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colorsModel.textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                SizedBox(height: 20),

                // form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // passaggio
                      TextFormField(
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Inserire nome";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          provNome = value;
                        },
                        style: TextStyle(
                          color: colorsModel.textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'nuovo nome',
                          fillColor: colorsModel.coloreSecondario,
                          hintStyle: TextStyle(color: Colors.grey)
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // tasti
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                    // tasto annulla

                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Annulla",
                        style: TextStyle(
                          color: colorsModel.coloreSecondario,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // tasto fatto
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          String nuovoNome = provNome!;
                          Navigator.pop(context, nuovoNome);
                        }
                      }, 
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, 
                        backgroundColor: colorsModel.coloreSecondario,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        elevation: 5,
                        shadowColor: Colors.black,
                      ),                          
                      child: Text(
                        "Fatto",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
