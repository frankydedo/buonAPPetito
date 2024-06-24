import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});


  @override
  State<SearchPage> createState() => _SearchPageState();
}


class _SearchPageState extends State<SearchPage> {

TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorsProvider,RicetteProvider>(builder: (context,colorsModel,ricetteModel,_)
    {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
           margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
           child: TextField(
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Looking for...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                //borderSide: BorderSide(color: colorsModel.getColoreSecondario()),
                borderSide: BorderSide(color: colorsModel.getColoreSecondario()),
              )
            )
            )
          )
         
        ],
      ),
    );
    });
  }
}