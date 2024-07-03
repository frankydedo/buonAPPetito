// ignore_for_file: must_be_immutable, deprecated_member_use

import 'dart:io';

import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;


class FotoProfiloDialog extends StatefulWidget {

  FotoProfiloDialog({super.key});

  @override
  State<FotoProfiloDialog> createState() => _FotoProfiloDialogState();
}

class _FotoProfiloDialogState extends State<FotoProfiloDialog> {

  String previewFoto = "";

  @override
  void initState() {
    super.initState();
    previewFoto = Provider.of<RicetteProvider>(context, listen: false).percorsoFotoProfilo;
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

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

    Future<void> pickImageFromCamera() async {
      final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) return;

      String imagePath = await saveImage(image.path);
      setState(() {
        previewFoto = imagePath;
      });
    }

    Future<void> pickImageFromGallery() async {
      final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      String imagePath = await saveImage(image.path);
      setState(() {
        previewFoto = imagePath;
      });
    }

    return Consumer2<ColorsProvider, RicetteProvider>(
      builder: (context, colorsModel, ricetteModel, _) {
        return 
        WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            return false;
          },
          child: 
          AlertDialog(
            backgroundColor: colorsModel.dialogBackgroudColor,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                
                Row(
                  children: [
                    IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      }, 
                      icon: Icon(Icons.arrow_back_ios_new_rounded, color: colorsModel.coloreSecondario, size: 30,)
                    )
                  ],
                ),
            
                // foto profilo
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      previewFoto,
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Spacer(),

                      // carica dalla camera
                      ElevatedButton(
                        onPressed: () async {
                          await pickImageFromCamera().then((_){
                            setState(() {});
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorsModel.coloreSecondario,
                        ),
                        child: Icon(Icons.camera_alt_rounded, color: Colors.white, size: 25),
                      ),
                      SizedBox(width: 30),

                      //carica dalla galleria
                      ElevatedButton(
                        onPressed: () async {
                          await pickImageFromGallery().then((_){
                            setState(() {});
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorsModel.coloreSecondario,
                        ),
                        child: Icon(Icons.photo_library_rounded, color: Colors.white, size: 25),
                      ),
                      Spacer()
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Spacer(),

                      // carica dalla camera
                      ElevatedButton(
                        onPressed: () {
                          ricetteModel.cambiaFotoProfilo(previewFoto);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorsModel.coloreSecondario,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                          child: Text(
                            "Salva",
                            style: GoogleFonts.encodeSans(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w700
                            ),
                          ),
                        ),
                      ),

                      Spacer()
                    ],
                  ),
                ),
            
                
                // // tasti
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
            
                //     // tasto annulla
            
                //     GestureDetector(
                //       onTap: (){
                //         Navigator.pop(context, false);
                //       },
                //       child: Text(
                //         "Annulla",
                //         style: TextStyle(
                //           color: colorsModel.coloreSecondario,
                //           fontSize: 20,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ),
            
                //     // tasto fatto
                //     ElevatedButton(
                //       onPressed: () {
                //         Navigator.pop(context, true);
                //       }, 
                //       style: ElevatedButton.styleFrom(
                //         foregroundColor: Colors.white, 
                //         backgroundColor: colorsModel.coloreSecondario,
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(20),
                //         ),
                //         padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                //         elevation: 5,
                //         shadowColor: Colors.black,
                //       ),                          
                //       child: Text(
                //         "Conferma",
                //         style: TextStyle(
                //           fontSize: 20,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ),
                    
                //   ],
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}