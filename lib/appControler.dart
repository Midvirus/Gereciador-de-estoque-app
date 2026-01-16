// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Appcontroler extends ChangeNotifier {
  static Appcontroler instance = Appcontroler(); // Instância única (singleton)
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isDark = false;

  /// Alterna entre temas claro e escuro
  void changeThema() {
    isDark = !isDark;
    notifyListeners();
  }

  /// Retorna a cor baseada no tema atual
  Color changeColor() {
    return isDark ? Colors.amber : const Color.fromARGB(255, 252, 239, 199);
  }

  /// Adiciona um produto ao Firestore
  Future<void> addProduto(Map<String, dynamic> produto, String cod) async {
  try {
    DocumentSnapshot docSnapshot = await _firestore.collection('Produtos').doc(cod).get();
    if (docSnapshot.exists) {
      print('Erro: Produto já cadastrado');   
      throw Exception('Produto já cadastrado');
    }
    await _firestore.collection('Produtos').doc(cod).set(produto);
    print('Produto adicionado com sucesso!');
  } catch (e) {
    print('Erro ao adicionar produto: $e');
    rethrow; // Repassa o erro caso queira tratá-lo em outro lugar
  }
} 

  /// Adiciona um cliente ao Firestore com CPF como nome do documento
Future<void> addClient(Map<String, dynamic> cliente, String cpf) async {
  try {
    // Valida o CPF antes de verificar duplicação
    if (!validarCpf(cpf)) {
      print('Erro: CPF inválido');
      throw Exception('CPF inválido');
    }

    // Verifica se o CPF já está cadastrado
    DocumentSnapshot docSnapshot = await _firestore.collection('Clientes').doc(cpf).get();
    if (docSnapshot.exists) {
      print('Erro: CPF já cadastrado');   
      throw Exception('CPF já cadastrado');
    }

    // Adiciona o cliente com o CPF como nome do documento
    await _firestore.collection('Clientes').doc(cpf).set(cliente);
    print('Cliente adicionado com sucesso!');
  } catch (e) {
    print('Erro ao adicionar cliente: $e');
    throw Exception('Erro ao adicionar cliente: $e');
  }
}

 Future<List<Map<String, dynamic>>> readProduct() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('Produtos').orderBy('nome').get();

      List<Map<String, dynamic>> prodData = querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();

      print(prodData);
      return prodData;
    } catch (e) {
      print('Erro ao ler dados: $e');
      return [];
    }
  }

  /// Lê os dados dos clientes do Firestore
  Future<List<Map<String, dynamic>>> readData() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('Clientes').orderBy('name').get();

      List<Map<String, dynamic>> usersData = querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();

      print(usersData);
      return usersData;
    } catch (e) {
      print('Erro ao ler dados: $e');
      return [];
    }
  }

List<Map<String, dynamic>> filtrarProdutos(
      List<Map<String, dynamic>> produtos, String query) {
    if (query.isEmpty) return produtos; // Retorna todos se a query for vazia

    return produtos.where((produto) {
      final nomeProduto = (produto['nome'] as String).toLowerCase();
      return nomeProduto.contains(query.toLowerCase());
    }).toList();
  }

  void attQuant(String cod, Map<String, dynamic> prod) async{
    await _firestore.collection('Produtos').doc(cod).update(prod);
  }

  /// Função que filtra clientes com base na query
  List<Map<String, dynamic>> filtrarClientes(
      List<Map<String, dynamic>> clientes, String query) {
    if (query.isEmpty) return clientes; // Retorna todos se a query for vazia

    return clientes.where((cliente) {
      final nomeCliente = (cliente['name'] as String).toLowerCase();
      return nomeCliente.contains(query.toLowerCase());
    }).toList();
  }

  /// Capitaliza a primeira letra de uma string
  String capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  /// Capitaliza a primeira letra de cada palavra
  String capitalizeEachWord(String input) {
    return input
        .split(' ')
        .map((word) => capitalize(word))
        .join(' ');
  }
}

/// Valida o CPF de acordo com o algoritmo oficial
bool validarCpf(String cpf) {
  // Remove caracteres não numéricos
  cpf = cpf.replaceAll(RegExp(r'\D'), '');

  // Verifica se o CPF tem 11 dígitos
  if (cpf.length != 11) return false;

  // Verifica se todos os dígitos são iguais (ex.: 111.111.111-11 é inválido)
  if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) return false;

  // Cálculo do primeiro dígito verificador
  int soma = 0;
  for (int i = 0; i < 9; i++) {
    soma += int.parse(cpf[i]) * (10 - i);
  }
  int resto = (soma * 10) % 11;
  int digito1 = resto == 10 ? 0 : resto;

  // Verifica o primeiro dígito verificador
  if (digito1 != int.parse(cpf[9])) return false;

  // Cálculo do segundo dígito verificador
  soma = 0;
  for (int i = 0; i < 10; i++) {
    soma += int.parse(cpf[i]) * (11 - i);
  }
  resto = (soma * 10) % 11;
  int digito2 = resto == 10 ? 0 : resto;

  // Verifica o segundo dígito verificador
  return digito2 == int.parse(cpf[10]);
}
