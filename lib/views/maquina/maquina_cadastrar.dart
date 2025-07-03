import 'package:crud_maquinas_agricolas/models/maquina.dart';
import 'package:crud_maquinas_agricolas/models/marca.dart';
import 'package:crud_maquinas_agricolas/models/status.dart';
import 'package:crud_maquinas_agricolas/models/tipo.dart';
import 'package:crud_maquinas_agricolas/services/maquina_service.dart';
import 'package:crud_maquinas_agricolas/services/marca_service.dart';
import 'package:crud_maquinas_agricolas/services/tipo_service.dart';
import 'package:flutter/material.dart';

class MaquinaCadastroView extends StatefulWidget {
  const MaquinaCadastroView({super.key});

  @override
  State<MaquinaCadastroView> createState() => _MaquinaCadastroViewState();
}

class _MaquinaCadastroViewState extends State<MaquinaCadastroView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _anoFabricacaoController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _nomeProprietarioController = TextEditingController();
  final TextEditingController _contatoProprietarioController = TextEditingController();
  final TextEditingController _percentualComissaoController = TextEditingController();

  Status _status = Status.N;
  Tipo? _tipo;
  Marca? _marca;


  Map<int, Marca> marcas = {};
  Map<int, Tipo> tipos = {};
  bool loading = true;

  //ao iniciar
  @override
  void initState() {
    super.initState();
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

      // cria os mapas para acesso rápido por id
      var mapaMarcas = { for (var m in listaMarcas) m.id : m };
      var mapaTipos = { for (var t in listaTipos) t.id : t };

      setState(() {
        this.marcas = mapaMarcas;
        this.tipos = mapaTipos;

        if (tipos.isNotEmpty) {
          _tipo = tipos.values.first;
        }

        if (marcas.isNotEmpty) {
          _marca = marcas.values.first;
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
        0,
        _tipo!.id,
        _marca!.id,
        DateTime.now(),
        _descricaoController.text,
        int.tryParse(_anoFabricacaoController.text) ?? 0,
        double.tryParse(_valorController.text) ?? 0.0,
        _nomeProprietarioController.text,
        _contatoProprietarioController.text,
        double.tryParse(_percentualComissaoController.text) ?? 0.0,
        _status,
      );

      print('Objeto gerado: $maquina');

      await salvar(maquina);

    } catch (e) {
      print('Erro ao gerar objeto: $e');
    }
  }

  //salvar
  Future<void> salvar(Maquina maquina) async {
    try {
      var maquinaService = MaquinaService();

      await maquinaService.create(maquina);

      await carregarDados();

      if (mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Sucesso'),
            content: const Text('Máquina salva com sucesso!'),
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

        Navigator.of(context).pop();
      }
    } catch (e) {
      print('Erro ao salvar máquina: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Máquina'),
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

