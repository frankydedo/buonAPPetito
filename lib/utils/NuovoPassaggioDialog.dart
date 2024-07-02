import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NuovoPassaggioDialog extends StatefulWidget {
  final String msg;

  const NuovoPassaggioDialog({Key? key, required this.msg}) : super(key: key);

  @override
  _NuovoPassaggioDialogState createState() => _NuovoPassaggioDialogState();
}

class _NuovoPassaggioDialogState extends State<NuovoPassaggioDialog> {
  String? provPassaggio;
  bool enableQuantita = true; 

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorsProvider, RicetteProvider>(
      builder: (context, colorsModel, ricetteModel, _) {
        return AlertDialog(
          backgroundColor: colorsModel.dialogBackgroudColor,
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
                  widget.msg,
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
                            return "Completare campo";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          provPassaggio = value;
                        },
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                        decoration: InputDecoration(
                          hoverColor: colorsModel.coloreSecondario,
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: colorsModel.coloreSecondario)
                          ),
                          hintText: "Quantità cadauno"
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
                          String nuovoPassaggio = provPassaggio!;
                          Navigator.pop(context, nuovoPassaggio);
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
