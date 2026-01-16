import 'package:flutter/material.dart';
//import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
//import 'package:share_extend/share_extend.dart';
//import 'package:path_provider/path_provider.dart';
import 'appControler.dart';

class Produto extends StatefulWidget {
  @override
  State<Produto> createState() => _ProdutoState();
}

class _ProdutoState extends State<Produto> {
  String _searchQuery = ''; // Texto da pesquisa

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produtos'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) {
                setState(() {
                  _searchQuery = query; // Atualiza a query de pesquisa
                });
              },
              decoration: InputDecoration(
                hintText: 'Pesquisar...',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: Appcontroler.instance.readProduct(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar dados'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum produto encontrado'));
          } else {
            // Filtra a lista de produtos usando a função do controlador
            var filteredProdutos = Appcontroler.instance.filtrarProdutos(snapshot.data!, _searchQuery);

            return ListView.builder(
              itemCount: filteredProdutos.length,
              itemBuilder: (context, index) {
                var produto = filteredProdutos[index];
                String codigoBarras = produto['codigoBarras'] ?? '0';

                // Criar um controlador para o campo de entrada da quantidade
                TextEditingController quantidadeController = TextEditingController(
                  text: produto['quantidade']?.toString() ?? '0',
                );

                return Card(
                  child: Column(
                    children: [
                      ListTile(
                        key: ValueKey(codigoBarras),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(produto['nome'] ?? 'Sem nome'),
                            IconButton(
                              icon: Icon(Icons.share),
                              onPressed: () => _mostrarDetalhesProduto(context, produto),
                            ),
                          ],
                          ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tipo......: ${produto['tipo']}'),
                            Text('Preço: ${produto['precoVenda']?.toStringAsFixed(2) ?? 'Sem preço de venda'}'),
                            Text('Custo.: ${produto['precoCusto']?.toStringAsFixed(2) ?? 'Sem preço de custo'}'),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  style: IconButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)
                                    ),
                                    backgroundColor: const Color.fromARGB(255, 255, 123, 113),
                                    shadowColor: Colors.black,
                                    elevation: 5,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      int quantidadeAtual = int.tryParse(produto['quantidade'].toString()) ?? 0;
                                      if (quantidadeAtual > 0) {
                                        produto['quantidade'] = quantidadeAtual - 1;
                                        quantidadeController.text = produto['quantidade'].toString();
                                        Appcontroler.instance.attQuant(codigoBarras, produto);
                                      }
                                    });
                                  },
                                ),
                                SizedBox(
                                  width: 7,
                                  child: Align(
                                    alignment: Alignment.center,
                                  )
                                ),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  style: IconButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)
                                    ),
                                    backgroundColor: Colors.lightBlue,
                                    shadowColor: Colors.black,
                                    elevation: 5,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      int quantidadeAtual = int.tryParse(produto['quantidade'].toString()) ?? 0;
                                      produto['quantidade'] = quantidadeAtual + 1;
                                      quantidadeController.text = produto['quantidade'].toString();
                                      Appcontroler.instance.attQuant(codigoBarras, produto);
                                    });
                                  },
                                ),
                              ],
                            ),
                            Row(
                            children: [
                              Text('Qtd: ', style: TextStyle(fontSize: 16)),
                              SizedBox(
                                width: 40,
                                child: TextField(
                                  controller: quantidadeController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(vertical: 5),
                                  ),
                                  onSubmitted: (valor) {
                                    int? novaQuantidade = int.tryParse(valor);
                                    if (novaQuantidade != null && novaQuantidade >= 0) {
                                      setState(() {
                                        produto['quantidade'] = novaQuantidade;
                                        Appcontroler.instance.attQuant(codigoBarras, produto);
                                      });
                                    } else {
                                      // Se a entrada não for válida, restaura o valor original
                                      quantidadeController.text = produto['quantidade'].toString();
                                    }
                                  },
                                ),
                              )
                            ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
  void _mostrarDetalhesProduto(BuildContext context, Map<String, dynamic> produto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalhes do Produto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${produto['nome']} - ${produto['marca'] ?? 'Sem marca'}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              SizedBox(height: 8),
              Text('R\$ ${produto['precoVenda']?.toStringAsFixed(2) ?? 'Sem preço'}', style: TextStyle(fontSize: 20),),
              Text('Descrição: ${produto['descricao'] == null || produto['descricao'] == "" ? 'Sem descrição' : produto['descricao']}'),
              Text('\n ${produto['tipo'] ?? 'Sem tipo'}'),
            ],
          ),
          actions: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.facebook),
                  onPressed: () => compartilhar(produto),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Fechar'),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}

compartilhar(Map<String, dynamic> prod){
  final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);
  /*pdf.addPage(pdfLib.Page(
    pageFormat: PdfPageFormat.a4,
    build: 
    
    ));*/
}


