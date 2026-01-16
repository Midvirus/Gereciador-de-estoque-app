import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccessCodeScreen extends StatefulWidget {
  @override
  _AccessCodeScreenState createState() => _AccessCodeScreenState();
}

class _AccessCodeScreenState extends State<AccessCodeScreen> {
  final TextEditingController _codeController = TextEditingController();
// O código correto (você pode mudar ou armazenar no Firestore)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insira o código de acesso'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: 'Código de Acesso',
              ),
              obscureText: true, // Oculta o texto por segurança
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _validateAccessCodeFirestore(context);
              },
              child: Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }

 void _validateAccessCodeFirestore(BuildContext context) async {
  // Referência ao Firestore
  var firestore = FirebaseFirestore.instance;

  try {
    // Busca o código de acesso armazenado no Firestore
    var doc = await firestore.collection('access').doc('code').get();

    // Obtenha o código armazenado
    String storedCode = doc['code'];

    // Verifique se o código inserido pelo usuário está correto
    if (_codeController.text == storedCode) {
      // Se o código estiver correto, autentica anonimamente
      _signInAnonymously(context);
    } else {
      // Código incorreto, mostrar mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Código de acesso incorreto!')),
      );
    }
  } catch (e) {
    print('Erro ao acessar o Firestore: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao validar o código. Tente novamente!')),
    );
  }
}


  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      // Fazer login anônimo no Firebase
      await FirebaseAuth.instance.signInAnonymously();
      
      // Navegar para a tela principal (acesso liberado)
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      print('Erro ao fazer login anônimo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao autenticar. Tente novamente!')),
      );
    }
  }
}
