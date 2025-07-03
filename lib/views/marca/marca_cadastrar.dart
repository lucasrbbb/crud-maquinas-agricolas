import 'package:crud_maquinas_agricolas/models/marca.dart';
import 'package:crud_maquinas_agricolas/services/marca_service.dart';
import 'package:flutter/material.dart';

class MarcaCadastroView extends StatefulWidget {
  const MarcaCadastroView({super.key});

  @override
  State<MarcaCadastroView> createState() => _MarcaCadastroViewState();
}

class _MarcaCadastroViewState extends State<MarcaCadastroView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  
  bool loading = true;

  //ao iniciar
  @override
  void initState() {
    super.initState();
    
  }
  
  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  //gerarObjeto
  Future<void> gerarObjeto() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final marca = Marca(
        0,
        _nomeController.text,
      );

      print('Objeto gerado: $marca');

      await salvar(marca);

    } catch (e) {
      print('Erro ao gerar objeto: $e');
    }
  }

  //salvar
  Future<void> salvar(Marca marca) async {
    try {
      var marcaService = MarcaService();

      await marcaService.create(marca);

      if (mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Sucesso'),
            content: const Text('Marca salva com sucesso!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );

        Navigator.of(context).pop(true);
      }
    } catch (e) {
      print('Erro ao salvar marca: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Marca'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Informe o nome da marca' : null,
              ),

              const SizedBox(height: 16),

              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Salvar'),
                onPressed: () async {
                  await gerarObjeto();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
