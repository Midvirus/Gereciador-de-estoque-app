import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'appControler.dart';

class AddProduto extends StatefulWidget {
  @override
  State<AddProduto> createState() => _AddProdutoPageState();
}

class _AddProdutoPageState extends State<AddProduto> {
  final _nomeController = TextEditingController();
  final _precoVendaController = TextEditingController();
  final _precoCustoController = TextEditingController();
  final _marcaController = TextEditingController();
  final _codigoBarrasController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _tamanhoController = TextEditingController(); // Apenas para Moda

  String? _tipoSelecionado; // Tipo do produto
  bool _isModa = false; // Controla a exibição do campo de tamanho

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo para o Nome do Produto
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome do Produto'),
              ),
              SizedBox(height: 10),

              // Campo para selecionar o Tipo do Produto
              DropdownButtonFormField<String>(
                value: _tipoSelecionado,
                onChanged: (String? novoTipo) {
                  setState(() {
                    _tipoSelecionado = novoTipo;
                    _isModa = novoTipo == 'Moda'; // Exibe campo de tamanho apenas para moda
                  });
                },
                items: ['Perfumaria', 'Beleza', 'Moda']
                    .map((tipo) => DropdownMenuItem(
                          value: tipo,
                          child: Text(tipo),
                        ))
                    .toList(),
                decoration: InputDecoration(labelText: 'Tipo de Produto'),
              ),
              SizedBox(height: 10),

              // Campo para Preço de Venda
              TextField(
                controller: _precoVendaController,
                decoration: InputDecoration(labelText: 'Preço de Venda'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 10),

              // Campo para Preço de Custo
              TextField(
                controller: _precoCustoController,
                decoration: InputDecoration(labelText: 'Preço de Custo'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 10),

              // Campo para Marca
              TextField(
                controller: _marcaController,
                decoration: InputDecoration(labelText: 'Marca'),
              ),
              SizedBox(height: 10),

              // Campo para Código de Barras
              TextField(
                controller: _codigoBarrasController,
                decoration: InputDecoration(labelText: 'Código de Barras'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              SizedBox(height: 10),

              // Campo para Descrição
              TextField(
                controller: _descricaoController,
                decoration: InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
              ),
              SizedBox(height: 10),

              // Campo específico para Moda: Tamanho
              if (_isModa)
                TextField(
                  controller: _tamanhoController,
                  decoration: InputDecoration(labelText: 'Tamanho (Ex: P, M, G)'),
                  textCapitalization: TextCapitalization.characters,
                ),
              SizedBox(height: 20),

              // Botão para adicionar o produto
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    String nome = _nomeController.text;
                    String? tipo = _tipoSelecionado;
                    String precoVenda = _precoVendaController.text;
                    String precoCusto = _precoCustoController.text;
                    String marca = _marcaController.text;
                    String codigoBarras = _codigoBarrasController.text;
                    String descricao = _descricaoController.text;
                    String? tamanho = _isModa ? _tamanhoController.text.toUpperCase() : null;

                    if (nome.isNotEmpty &&
                        tipo != null &&
                        precoVenda.isNotEmpty &&
                        precoCusto.isNotEmpty &&
                        marca.isNotEmpty &&
                        codigoBarras.isNotEmpty) {
                      try {
                        Map<String, dynamic> produto = {
                          'nome': Appcontroler.instance.capitalizeEachWord(nome),
                          'tipo': tipo,
                          'precoVenda': double.parse(precoVenda),
                          'precoCusto': double.parse(precoCusto),
                          'marca': Appcontroler.instance.capitalizeEachWord(marca),
                          'codigoBarras': codigoBarras,
                          'descricao': Appcontroler.instance.capitalize(descricao),
                          'quantidade': 0,
                        };
                        if (_isModa) {
                          produto['tamanho'] = tamanho;
                        }
                        await Appcontroler.instance.addProduto(produto, codigoBarras.toString());
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Produto adicionado com sucesso!')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erro ao adicionar produto: $e')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Preencha todos os campos obrigatórios')),
                      );
                    }
                  },
                  child: Text('Adicionar Produto'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*@override
  void dispose() {
    _nomeController.dispose();
    _precoVendaController.dispose();
    _precoCustoController.dispose();
    _marcaController.dispose();
    _codigoBarrasController.dispose();
    _descricaoController.dispose();
    _tamanhoController.dispose();
    super.dispose();
  }*/
}
