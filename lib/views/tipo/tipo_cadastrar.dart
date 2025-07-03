import 'package:crud_maquinas_agricolas/models/tipo.dart';
import 'package:crud_maquinas_agricolas/services/tipo_service.dart';
import 'package:flutter/material.dart';

class TipoCadastroView extends StatefulWidget {
  const TipoCadastroView({super.key});

  @override
  State<TipoCadastroView> createState() => _TipoCadastroViewState();
}

class _TipoCadastroViewState extends State<TipoCadastroView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _descricaoController = TextEditingController();

  bool loading = true;

  //ao iniciar
  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    _descricaoController.dispose();
    super.dispose();
  }

  //gerarObjeto
  Future<void> gerarObjeto() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final tipo = Tipo(
        0,
        _descricaoController.text,
      );

      print('Objeto gerado: $tipo');

      await salvar(tipo);

    } catch (e) {
      print('Erro ao gerar objeto: $e');
    }
  }

  //salvar
  Future<void> salvar(Tipo tipo) async {
    try {
      var tipoService = TipoService();

      await tipoService.create(tipo);

      if (mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Sucesso'),
            content: const Text('Tipo salva com sucesso!'),
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
      print('Erro ao salvar tipo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Tipo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Informe o descricao da tipo' : null,
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
