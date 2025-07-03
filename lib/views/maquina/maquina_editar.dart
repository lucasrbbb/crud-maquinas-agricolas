import 'package:crud_maquinas_agricolas/models/maquina.dart';
import 'package:crud_maquinas_agricolas/models/marca.dart';
import 'package:crud_maquinas_agricolas/models/status.dart';
import 'package:crud_maquinas_agricolas/models/tipo.dart';
import 'package:crud_maquinas_agricolas/services/maquina_service.dart';
import 'package:crud_maquinas_agricolas/services/marca_service.dart';
import 'package:crud_maquinas_agricolas/services/tipo_service.dart';
import 'package:flutter/material.dart';

class MaquinaEditarView extends StatefulWidget {
  final Maquina maquina;
  const MaquinaEditarView({Key? key, required this.maquina}) : super(key: key);

  @override
  State<MaquinaEditarView> createState() => _MaquinaEditarViewState();
}

class _MaquinaEditarViewState extends State<MaquinaEditarView> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _descricaoController = TextEditingController();
  late TextEditingController _anoFabricacaoController = TextEditingController();
  late TextEditingController _valorController = TextEditingController();
  late TextEditingController _nomeProprietarioController = TextEditingController();
  late TextEditingController _contatoProprietarioController = TextEditingController();
  late TextEditingController _percentualComissaoController = TextEditingController();

  Status? _status;
  Tipo? _tipo;
  Marca? _marca;


  Map<int, Marca> marcas = {};
  Map<int, Tipo> tipos = {};
  bool loading = true;

  //ao iniciar
  @override
  void initState() {
    super.initState();

    _descricaoController = TextEditingController(
      text: widget.maquina.descricao,
    );

    _anoFabricacaoController = TextEditingController(
      text: widget.maquina.anoFabricacao.toString(),
    );

    _valorController = TextEditingController(
      text: widget.maquina.valor.toString(),
    );

    _nomeProprietarioController = TextEditingController(
      text: widget.maquina.nomeProprietario,
    );

    _contatoProprietarioController = TextEditingController(
      text: widget.maquina.contatoProprietario,
    );

    _percentualComissaoController = TextEditingController(
      text: widget.maquina.percentualComissao.toString(),
    );

    _status = widget.maquina.status;

    carregarDados();
  }

  Future<void> carregarDados() async {
    setState(() {
      loading = true;
    });

    try {
      //cria os serviços
      var marcaService = MarcaService();
      var tipoService = TipoService();

      // carrega listas da API
      var listaMarcas = await marcaService.getAll();
      var listaTipos = await tipoService.getAll();

      // cria os mapas para acesso por id
      var mapaMarcas = { for (var m in listaMarcas) m.id : m };
      var mapaTipos = { for (var t in listaTipos) t.id : t };

      setState(() {
        this.marcas = mapaMarcas;
        this.tipos = mapaTipos;

        if (tipos.isNotEmpty) {
          _tipo = widget.maquina != null
              ? mapaTipos[widget.maquina.idTipo]
              : tipos.values.first;
        }

        if (marcas.isNotEmpty) {
          _marca = widget.maquina != null
              ? mapaMarcas[widget.maquina.idMarca]
              : marcas.values.first;
        }

        loading = false;
      });
    } catch (e) {
      print('Erro ao carregar dados: $e');
      setState(() {
        loading = false;
      });
    }
  }


  @override
  void dispose() {
    _descricaoController.dispose();
    _anoFabricacaoController.dispose();
    _valorController.dispose();
    _nomeProprietarioController.dispose();
    _contatoProprietarioController.dispose();
    _percentualComissaoController.dispose();
    super.dispose();
  }

  //gerarObjeto
  Future<void> gerarObjeto() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final maquina = Maquina(
        widget.maquina.id,
        _tipo!.id,
        _marca!.id,
        widget.maquina.anoInclusao,
        _descricaoController.text,
        int.tryParse(_anoFabricacaoController.text) ?? 0,
        double.tryParse(_valorController.text) ?? 0.0,
        _nomeProprietarioController.text,
        _contatoProprietarioController.text,
        double.tryParse(_percentualComissaoController.text) ?? 0.0,
        _status!,
      );

      print('Objeto atualizado: $maquina');

      await update(maquina);

    } catch (e) {
      print('Erro ao gerar objeto: $e');
    }
  }

  //salvar
  Future<void> update(Maquina maquina) async {
    try {
      var maquinaService = MaquinaService();

      await maquinaService.update(maquina);

      await carregarDados();

      if (mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Sucesso'),
            content: const Text('Máquina editada com sucesso!'),
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
      print('Erro ao editar máquina: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Máquina'),
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
              TextFormField(
                controller: _anoFabricacaoController,
                decoration: const InputDecoration(labelText: 'Ano Fabricação'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value == null || value.isEmpty ? 'Informe o ano' : null,
              ),
              TextFormField(
                controller: _valorController,
                decoration: const InputDecoration(labelText: 'Valor'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value == null || value.isEmpty ? 'Informe o valor' : null,
              ),
              TextFormField(
                controller: _nomeProprietarioController,
                decoration: const InputDecoration(labelText: 'Nome Proprietário'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Informe o proprietário' : null,
              ),
              TextFormField(
                controller: _contatoProprietarioController,
                decoration: const InputDecoration(labelText: 'Contato Proprietário'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Informe o contato' : null,
              ),
              TextFormField(
                controller: _percentualComissaoController,
                decoration: const InputDecoration(labelText: 'Percentual Comissão'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value == null || value.isEmpty ? 'Informe a comissão' : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<Tipo>(
                value: _tipo,
                decoration: InputDecoration(labelText: 'Tipo'),
                items: tipos.values.map((tipo) {
                  return DropdownMenuItem<Tipo>(
                    value: tipo,
                    child: Text(tipo.descricao),
                  );
                }).toList(),
                onChanged: (Tipo? novoTipo) {
                  if (novoTipo != null) {
                    setState(() {
                      _tipo = novoTipo;
                    });
                  }
                },
              ),

              DropdownButtonFormField<Marca>(
                value: _marca,
                decoration: InputDecoration(labelText: 'Tipo'),
                items: marcas.values.map((marca) {
                  return DropdownMenuItem<Marca>(
                    value: marca,
                    child: Text(marca.nome),
                  );
                }).toList(),
                onChanged: (Marca? novaMarca) {
                  if (novaMarca != null) {
                    setState(() {
                      _marca = novaMarca;
                    });
                  }
                },
              ),

              DropdownButtonFormField<Status>(
                value: _status,
                decoration: InputDecoration(labelText: 'Status'),
                items: Status.values.map((status) {
                  return DropdownMenuItem<Status>(
                    value: status,
                    child: Text(status.label),
                  );
                }).toList(),
                onChanged: (Status? novoStatus) {
                  if (novoStatus != null) {
                    setState(() {
                      _status = novoStatus;
                    });
                  }
                },
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
