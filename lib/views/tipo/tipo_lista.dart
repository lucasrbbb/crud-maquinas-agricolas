import 'package:crud_maquinas_agricolas/models/tipo.dart';
import 'package:crud_maquinas_agricolas/services/tipo_service.dart';
import 'package:crud_maquinas_agricolas/views/tipo/tipo_cadastrar.dart';
import 'package:crud_maquinas_agricolas/views/tipo/tipo_editar.dart';
import 'package:crud_maquinas_agricolas/views/tipo/tipo_item.dart';
import 'package:crud_maquinas_agricolas/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class TipoListaView extends StatefulWidget {
  const TipoListaView({super.key});

  @override
  State<TipoListaView> createState() => _TipoListaViewState();
}

//principal vai tudo aqui
class _TipoListaViewState extends State<TipoListaView> {
  //variaveis globais
  List<Tipo> listaTipos = [];
  bool loading = true;

  //ao iniciar
  @override
  void initState() {
    super.initState();
    carregarDados();
  }

//classes
  Future<void> carregarDados() async {
    setState(() {
      loading = true;
    });

    try {
      //cria os serviços
      var tipoService = TipoService();

      // carrega listas da API
      var listaTipos = await tipoService.getAll();


      // logcat
      for (var m in listaTipos) {
        print('Tipo carregada: $m');
      }

      setState(() {
        this.listaTipos = listaTipos;
        loading = false;
      });
    } catch (e) {
      print('Erro ao carregar dados: $e');
      setState(() {
        loading = false;
      });
    }
  }

  //excluir
  Future<void> excluirTipo(int id) async {
    try {
      var tipoService = TipoService();
      await tipoService.delete(id);
      await carregarDados();
    } catch (e) {
      print('Erro ao deletar tipo: $e');
    }
  }

  //front
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tipos'),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: listaTipos.length,
        itemBuilder: (context, index) {
          final tipo = listaTipos[index];
          return TipoItem(
            tipo: tipo,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Escolha uma ação'),
                  content: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton.icon(
                        icon: Icon(Icons.edit),
                        label: Text('Editar'),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TipoEditarView(tipo: tipo),
                            ),
                          );
                          print('Editar ${tipo.id}');
                        },
                      ),
                      Spacer(),
                      ElevatedButton.icon(
                        icon: Icon(Icons.delete),
                        label: Text('Excluir'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          //mostra caixa para pedir se tem certeza
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Tem certeza que deseja excluir?'),
                              content:
                              ElevatedButton.icon(
                                icon: Icon(Icons.delete),
                                label: Text('Deletar'),
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await excluirTipo(tipo.id);
                                  print('Deletar ${tipo.id}');
                                },
                              ),
                              actions: [
                                TextButton(
                                  child: Text('Cancelar'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          );
                          print('Excluir ${tipo.id}');
                        },
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      child: Text('Cancelar'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TipoCadastroView()),
          ).then((value) {
            if (value == true) {
              carregarDados();
            }
          });
        },
      ),
    );
  }
}
