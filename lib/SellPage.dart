import 'package:flutter/material.dart';
import 'appControler.dart';

class Sellpage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SellpageState();
  }
}

class SellpageState extends State<Sellpage> {
  Map<String, dynamic>? clienteSelecionado;
  List<Map<String, dynamic>> carrinho = [];
  double totalVenda = 0.0;

  // Calcula o valor total somando (preço * quantidade selecionada) de cada item
  void atualizarTotal() {
    setState(() {
      totalVenda = carrinho.fold(0, (sum, item) => sum + (item['precoVenda'] * item['quantidadeVenda']));
    });
  }

  // Finaliza a venda e abate as quantidades no stock do Firestore
  void finalizarVenda() async {
    if (carrinho.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("O carrinho está vazio!")));
      return;
    }

    try {
      for (var item in carrinho) {
        String codigo = item['codigoBarras'];
        // Calcula a nova quantidade subtraindo o que foi vendido do stock atual
        int novaQuant = (item['quantidade'] as int) - (item['quantidadeVenda'] as int);
        
        item['quantidade'] = novaQuant;
        // Remove o campo temporário de controle da venda antes de enviar para o Firestore
        var dadosParaAtualizar = Map<String, dynamic>.from(item);
        dadosParaAtualizar.remove('quantidadeVenda');
        
        Appcontroler.instance.attQuant(codigo, dadosParaAtualizar);
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Venda concluída com sucesso!")));
      setState(() {
        carrinho.clear();
        clienteSelecionado = null;
        totalVenda = 0.0;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erro ao finalizar venda: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nova Venda')),
      body: Column(
        children: [
          // Seleção opcional de cliente
          ListTile(
            leading: Icon(Icons.person),
            title: Text(clienteSelecionado == null ? "Cliente não identificado (Venda Avulsa)" : "Cliente: ${clienteSelecionado!['name']}"),
            trailing: TextButton(
              onPressed: _modalSelecaoCliente,
              child: Text(clienteSelecionado == null ? "Selecionar" : "Alterar"),
            ),
          ),
          Divider(),
          
          // Lista de itens no carrinho com controle de quantidade
          Expanded(
            child: carrinho.isEmpty 
              ? Center(child: Text("Nenhum item adicionado"))
              : ListView.builder(
                  itemCount: carrinho.length,
                  itemBuilder: (context, index) {
                    var item = carrinho[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        title: Text(item['nome']),
                        subtitle: Text("Un: R\$ ${item['precoVenda'].toStringAsFixed(2)} | Subtotal: R\$ ${(item['precoVenda'] * item['quantidadeVenda']).toStringAsFixed(2)}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                setState(() {
                                  if (item['quantidadeVenda'] > 1) {
                                    item['quantidadeVenda']--;
                                  } else {
                                    carrinho.removeAt(index);
                                  }
                                  atualizarTotal();
                                });
                              },
                            ),
                            Text("${item['quantidadeVenda']}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: Icon(Icons.add_circle_outline),
                              onPressed: () {
                                setState(() {
                                  if (item['quantidadeVenda'] < item['quantidade']) {
                                    item['quantidadeVenda']++;
                                    atualizarTotal();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Limite de stock atingido")));
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          ),
          
          // Painel inferior com total e botões de ação
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Geral:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("R\$ ${totalVenda.toStringAsFixed(2)}", style: TextStyle(fontSize: 22, color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.search),
                        label: Text("Adicionar Item"),
                        onPressed: _modalSelecaoProduto,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                        onPressed: finalizarVenda,
                        child: Text("Finalizar Venda"),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Modal para escolher clientes
  void _modalSelecaoCliente() {
    showModalBottomSheet(
      context: context,
      builder: (context) => FutureBuilder<List<Map<String, dynamic>>>(
        future: Appcontroler.instance.readData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, i) => ListTile(
              leading: Icon(Icons.person_outline),
              title: Text(snapshot.data![i]['name']),
              onTap: () {
                setState(() => clienteSelecionado = snapshot.data![i]);
                Navigator.pop(context);
              },
            ),
          );
        },
      ),
    );
  }

  void _modalSelecaoProduto() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: Appcontroler.instance.readProduct(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, i) {
                var prod = snapshot.data![i];
                return ListTile(
                  title: Text(prod['nome']),
                  subtitle: Text("Stock: ${prod['quantidade']} | R\$ ${prod['precoVenda']}"),
                  onTap: () {
                    setState(() {
                      // Verifica se o produto já está no carrinho para apenas aumentar a quantidade
                      int indexExistente = carrinho.indexWhere((item) => item['codigoBarras'] == prod['codigoBarras']);
                      
                      if (indexExistente != -1) {
                        if (carrinho[indexExistente]['quantidadeVenda'] < prod['quantidade']) {
                          carrinho[indexExistente]['quantidadeVenda']++;
                        }
                      } else {
                        var novoItem = Map<String, dynamic>.from(prod);
                        novoItem['quantidadeVenda'] = 1;
                        carrinho.add(novoItem);
                      }
                      atualizarTotal();
                    });
                    Navigator.pop(context);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}