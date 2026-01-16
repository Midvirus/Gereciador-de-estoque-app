import 'package:flutter/material.dart';
import 'appControler.dart';

class AdicionarCliente extends StatefulWidget {
  final VoidCallback onClienteAdicionado;

  AdicionarCliente({required this.onClienteAdicionado});

  @override
  State<AdicionarCliente> createState() => _AdicionarClienteState();
}

class _AdicionarClienteState extends State<AdicionarCliente> {
  final _nameController = TextEditingController();
  final _cpfController = TextEditingController();
  final _numeroController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 16.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.0, // Ajusta para o teclado
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Faz o modal se ajustar ao conteúdo
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _cpfController,
              decoration: InputDecoration(labelText: 'CPF'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _numeroController,
              decoration: InputDecoration(labelText: 'Número'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _enderecoController,
              decoration: InputDecoration(labelText: 'Endereço'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String nome = _nameController.text;
                String cpf = _cpfController.text;
                String endereco = _enderecoController.text;
                String email = _emailController.text;
                int? numero = int.tryParse(_numeroController.text);

                if (nome.isNotEmpty &&
                    cpf.isNotEmpty &&
                    endereco.isNotEmpty &&
                    email.isNotEmpty &&
                    numero != null) {
                  try {
                    await Appcontroler.instance.addClient({
                      'cpf': cpf,
                      'name': Appcontroler.instance.capitalizeEachWord(nome),
                      'numero': numero,
                      'endereco': endereco,
                      'email': email,
                    }, cpf);

                    // Atualiza a lista após o cliente ser adicionado
                    widget.onClienteAdicionado();
                    
                    // Fecha apenas o modal de adição
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao adicionar cliente: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Preencha todos os campos')),
                  );
                }
              },
              child: Text('Adicionar Cliente'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cpfController.dispose();
    _numeroController.dispose();
    _enderecoController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
