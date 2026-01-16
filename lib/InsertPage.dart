import 'package:flutter/material.dart';

class Insertpage extends StatefulWidget {
  @override
  State<StatefulWidget> createState(){
    return _InsertPageState();
  }
}



class _InsertPageState extends State<Insertpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Codigo de Barras',
                    border: OutlineInputBorder()
                  ),
                  keyboardType: TextInputType.number,
                )
              ],
                        ),
            ),
                    )
      )
    );
  }

}