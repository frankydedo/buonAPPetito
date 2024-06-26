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
          backgroundColor: Colors.white,
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // icona [?]
                Icon(
                  Icons.help_outline,
                  color: colorsModel.getColoreSecondario(),
                  size: 70,
                ),
                SizedBox(height: 20),

                // testo richiesta
                Text(
                  widget.msg,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
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
                          border: OutlineInputBorder(),
                          hintText: 'Passaggio',
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
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        width: 130,
                        decoration: BoxDecoration(
                          color: colorsModel.getColoreSecondario(),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 1.5,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "ANNULLA",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // tasto fatto
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState?.validate() ?? false) {
                            String nuovoPassaggio = provPassaggio!;
                            Navigator.pop(context, nuovoPassaggio);
                          }
                      },
                      child: Container(
                        width: 130,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorsModel.getColoreSecondario(),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 1.5,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "FATTO",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
