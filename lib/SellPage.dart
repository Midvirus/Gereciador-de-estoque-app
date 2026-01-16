import 'package:flutter/material.dart';

class Sellpage extends StatefulWidget{
  @override
  State<StatefulWidget> createState(){
  return SellpageState();
  }
}

class SellpageState extends State<Sellpage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: 
      Center(
        child: Padding(padding: const EdgeInsets.all(70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network('https://static.vecteezy.com/system/resources/previews/023/986/911/original/tinder-app-logo-tinder-app-logo-transparent-tinder-app-icon-transparent-free-free-png.png'),
              Text('Location Changer', style: TextStyle(fontSize: 30)),
              Text('Plugin app for Tinder', style: TextStyle(fontSize: 20)),
              Container(height: 30,),
              ElevatedButton(
              
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,

                ),
                onPressed: (){

                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                    child: Text('Login with Facebook', style: TextStyle( color: Colors.white), textAlign: TextAlign.center,)
                )
              )
            ],
          )
        )
      )
    );
  }
}