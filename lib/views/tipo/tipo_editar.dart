import 'package:crud_maquinas_agricolas/models/tipo.dart';
import 'package:crud_maquinas_agricolas/services/tipo_service.dart';
import 'package:flutter/material.dart';

class TipoEditarView extends StatefulWidget {
  final Tipo tipo;
  const TipoEditarView({Key? key, required this.tipo}) : super(key: key);

  @override
  State<TipoEditarView> createState() => _TipoEditarViewState();
}

class _TipoEditarViewState extends State<TipoEditarView> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _descricaoController = TextEditingController();

  bool loading = true;

  //ao iniciar
  @override
  void initState() {
    super.initState();

    _descricaoController = TextEditingController(
      text: widget.tipo.descricao,
    );
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
        widget.tipo.id,
        _descricaoController.text,
      );

      print('Objeto atualizado: $tipo');

      await update(tipo);

    } catch (e) {
      print('Erro ao gerar objeto: $e');
    }
  }

  //salvar
  Future<void> update(Tipo tipo) async {
    try {
      var tipoService = TipoService();

      await tipoService.update(tipo);

      if (mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Sucesso'),
            content: const Text('Tipo editada com sucesso!'),
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
      print('Erro ao editar tipo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Tipo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Informe a descrição' : null,
              ),

              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text('Editar'),
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