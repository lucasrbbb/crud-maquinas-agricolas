import 'package:crud_maquinas_agricolas/models/marca.dart';
import 'package:crud_maquinas_agricolas/services/marca_service.dart';
import 'package:crud_maquinas_agricolas/views/marca/marca_cadastrar.dart';
import 'package:crud_maquinas_agricolas/views/marca/marca_editar.dart';
import 'package:crud_maquinas_agricolas/views/marca/marca_item.dart';
import 'package:crud_maquinas_agricolas/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class MarcaListaView extends StatefulWidget {
  const MarcaListaView({super.key});

  @override
  State<MarcaListaView> createState() => _MarcaListaViewState();
}

//principal vai tudo aqui
class _MarcaListaViewState extends State<MarcaListaView> {
  //variaveis globais
  List<Marca> listaMarcas = [];
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
      var marcaService = MarcaService();

      // carrega listas da API
      var listaMarcas = await marcaService.getAll();
      

      // logcat
      for (var m in listaMarcas) {
        print('Marca carregada: $m');
      }

      setState(() {
        this.listaMarcas = listaMarcas;
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
  Future<void> excluirMarca(int id) async {
    try {
      var marcaService = MarcaService();
      await marcaService.delete(id);
      await carregarDados();
    } catch (e) {
      print('Erro ao deletar marca: $e');
    }
  }

  //front
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Marcas'),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: listaMarcas.length,
        itemBuilder: (context, index) {
          final marca = listaMarcas[index];
          return MarcaItem(
            marca: marca,
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
                              builder: (context) => MarcaEditarView(marca: marca),
                            ),
                          ).then((value) {
                            if (value == true) {
                              carregarDados();
                            }
                          });
                          print('Editar ${marca.id}');
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
                                  await excluirMarca(marca.id);
                                  print('Deletar ${marca.id}');
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
                          print('Excluir ${marca.id}');
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
            MaterialPageRoute(builder: (context) => const MarcaCadastroView()),
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
