import 'package:flutter/material.dart';
import 'package:estoqueadmim/InsertPage.dart';
import 'package:estoqueadmim/SellPage.dart';
import 'package:estoqueadmim/appControler.dart';
import 'package:estoqueadmim/clientes.dart';
import 'package:estoqueadmim/inicio.dart';
import 'package:estoqueadmim/loginPage.dart';
import 'package:estoqueadmim/myhomepage.dart';
import 'package:estoqueadmim/produtos.dart';



class AppWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return AnimatedBuilder(animation: Appcontroler.instance, builder: (context, child) {
      return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.red,
          brightness: Appcontroler.instance.isDark ? Brightness.dark : Brightness.light
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => AccessCodeScreen(),
          '/home': (context) => HomePage(),
          '/add': (context) => AddProduto(),
          '/vendas' : (context) => Sellpage(),
          '/cadastro' : (context) => Insertpage(),
          '/cliente' : (context) => Cliente(),
          '/produto' : (context) => Produto(),
        },
      );
    },
    );
  }
}