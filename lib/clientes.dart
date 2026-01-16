import 'package:flutter/material.dart';
import 'addclient.dart';
import 'appControler.dart';

class Cliente extends StatefulWidget {
  @override
  State<Cliente> createState() => _ClienteState();
}

class _ClienteState extends State<Cliente> {
  String _searchQuery = ''; // Texto da pesquisa

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clientes'),
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
        future: Appcontroler.instance.readData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar dados'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum cliente encontrado'));
          } else {
            // Filtra a lista de clientes usando a função do controlador
            var filteredClientes = Appcontroler.instance
                .filtrarClientes(snapshot.data!, _searchQuery);

            return ListView.builder(
              itemCount: filteredClientes.length,
              itemBuilder: (context, index) {
                var cliente = filteredClientes[index];
                return Card(
                  child: ListTile(
                    key: ValueKey(cliente['cpf']),
                    title: Text(cliente['name'] ?? 'Sem nome'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email......: ' + (cliente['email'] ?? 'Sem email')),
                        Text('Endereço: ' + (cliente['endereco'] ?? 'Sem endereço')),
                        Text('Telefone.: ' + (cliente['numero'] != null ? cliente['numero'].toString() : 'Sem telefone'))
                      ]
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext modalContext) { // Use modalContext aqui
              return AdicionarCliente(
                onClienteAdicionado: () async {
                  await Appcontroler.instance.readData();
                  setState(() {}); 
                },
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
