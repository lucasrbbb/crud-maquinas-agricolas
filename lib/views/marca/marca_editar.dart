import 'package:crud_maquinas_agricolas/models/marca.dart';
import 'package:crud_maquinas_agricolas/services/marca_service.dart';
import 'package:flutter/material.dart';

class MarcaEditarView extends StatefulWidget {
  final Marca marca;
  const MarcaEditarView({Key? key, required this.marca}) : super(key: key);

  @override
  State<MarcaEditarView> createState() => _MarcaEditarViewState();
}

class _MarcaEditarViewState extends State<MarcaEditarView> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nomeController = TextEditingController();

  bool loading = true;

  //ao iniciar
  @override
  void initState() {
    super.initState();

    _nomeController = TextEditingController(
      text: widget.marca.nome,
    );
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
        widget.marca.id,
        _nomeController.text,
      );

      print('Objeto atualizado: $marca');

      await update(marca);

    } catch (e) {
      print('Erro ao gerar objeto: $e');
    }
  }

  //salvar
  Future<void> update(Marca marca) async {
    try {
      var marcaService = MarcaService();

      await marcaService.update(marca);

      if (mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Sucesso'),
            content: const Text('Marca editada com sucesso!'),
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
      print('Erro ao editar marca: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Marca'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
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
