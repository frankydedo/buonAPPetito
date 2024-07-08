// ignore_for_file: must_be_immutable

import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CategoriaIcon extends StatefulWidget {

  void Function()? onPressed;
  int showNumber;

  CategoriaIcon({super.key, required this.onPressed, required this.showNumber});

  @override
  State<CategoriaIcon> createState() => _CategoriaIconState();
}

class _CategoriaIconState extends State<CategoriaIcon> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ColorsProvider>(builder: (context, colorsModel, _) {
      return Stack(
        children: [
            IconButton(
              onPressed: widget.onPressed,
              icon: Icon(Icons.list_rounded, color: colorsModel.coloreSecondario, size: 35,),
            ),

            widget.showNumber < 10 ?

            Positioned(
              left: 28,
              child: SizedBox(
                height: 22,
                width: 22,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorsModel.coloreTitoli,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Center(
                    child: Text(
                      widget.showNumber.toString(),
                      style: GoogleFonts.encodeSans(
                        color: colorsModel.isLightMode ? Colors.white : Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                ),
              ),
            )

            :
          widget.showNumber > 99 ?

            Positioned(
              left: 18,
              child: SizedBox(
                height: 22,
                width: 33,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorsModel.coloreTitoli,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Center(
                    child: Text(
                      "99+",
                      style: GoogleFonts.encodeSans(
                        color: colorsModel.isLightMode ? Colors.white : Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                ),
              ),
            )

            :

            Positioned(
              left: 22,
              child: SizedBox(
                height: 22,
                width: 28,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorsModel.coloreTitoli,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Center(
                    child: Text(
                      widget.showNumber.toString(),
                      style: GoogleFonts.encodeSans(
                        color: colorsModel.isLightMode ? Colors.white : Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                ),
              ),
            ),  
        ],
      );
    });
  }
}