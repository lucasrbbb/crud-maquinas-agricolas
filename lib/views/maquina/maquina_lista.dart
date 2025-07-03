import 'package:crud_maquinas_agricolas/models/maquina.dart';
import 'package:crud_maquinas_agricolas/models/marca.dart';
import 'package:crud_maquinas_agricolas/models/tipo.dart';
import 'package:crud_maquinas_agricolas/services/maquina_service.dart';
import 'package:crud_maquinas_agricolas/services/marca_service.dart';
import 'package:crud_maquinas_agricolas/services/tipo_service.dart';
import 'package:crud_maquinas_agricolas/views/maquina/maquina_cadastrar.dart';
import 'package:crud_maquinas_agricolas/views/maquina/maquina_editar.dart';
import 'package:crud_maquinas_agricolas/views/maquina/maquina_item.dart';
import 'package:crud_maquinas_agricolas/widgets/app_drawer.dart';
import 'package:crud_maquinas_agricolas/widgets/filtro_drawer.dart';
import 'package:flutter/material.dart';

class MaquinaListaView extends StatefulWidget {
  const MaquinaListaView({super.key});

  @override
  State<MaquinaListaView> createState() => _MaquinaListaViewState();
}

//principal vai tudo aqui
class _MaquinaListaViewState extends State<MaquinaListaView> {
  //variaveis globais
  List<Maquina> listaMaquinas = [];
  Map<int, Marca> marcas = {};
  Map<int, Tipo> tipos = {};
  bool loading = true;
  var maquinaService = MaquinaService();

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
      var tipoService = TipoService();

      // carrega listas da API
      var listaMaquinas = await maquinaService.getAll();
      var listaMarcas = await marcaService.getAll();
      var listaTipos = await tipoService.getAll();

      // cria os mapas para acesso rápido por id
      var mapaMarcas = { for (var m in listaMarcas) m.id : m };
      var mapaTipos = { for (var t in listaTipos) t.id : t };

      // ogcat
      for (var m in listaMaquinas) {
        print('Máquina carregada: $m');
      }

      setState(() {
        this.listaMaquinas = listaMaquinas;
        this.marcas = mapaMarcas;
        this.tipos = mapaTipos;
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
  Future<void> excluirMaquina(int id) async {
    try {
      var maquinaService = MaquinaService();
      await maquinaService.delete(id);
      await carregarDados();
    } catch (e) {
      print('Erro ao deletar maquina: $e');
    }
  }

  //front
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Máquinas'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.tune),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: FiltroDrawer(
        marcas: marcas.values.toList(),
        tipos: tipos.values.toList(),
        onAplicar: (filtro) async {
          var lista = await maquinaService.getAll(filtro: filtro);
          setState(() {
            listaMaquinas = lista;
          });
        },
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: listaMaquinas.length,
        itemBuilder: (context, index) {
          final maquina = listaMaquinas[index];
          return MaquinaItem(
            maquina: maquina,
            marcas: marcas,
            tipos: tipos,
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
                              builder: (context) => MaquinaEditarView(maquina: maquina),
                            ),
                          ).then((value) {
                            if (value == true) {
                              carregarDados();
                            }
                          });
                          print('Editar ${maquina.id}');
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
                                      await excluirMaquina(maquina.id);
                                      print('Deletar ${maquina.id}');
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
                          print('Excluir ${maquina.id}');
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
            MaterialPageRoute(
              builder: (context) => const MaquinaCadastroView(),
            ),
          );
        },
      ),
    );
  }
}


