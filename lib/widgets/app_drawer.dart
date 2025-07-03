import 'package:flutter/material.dart';
import 'package:crud_maquinas_agricolas/views/maquina/maquina_lista.dart';
import 'package:crud_maquinas_agricolas/views/tipo/tipo_lista.dart';
import 'package:crud_maquinas_agricolas/views/marca/marca_lista.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.directions_car_filled),
            title: const Text('Máquinas'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MaquinaListaView()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Tipos'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => TipoListaView()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.factory),
            title: const Text('Marcas'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MarcaListaView()),
              );
            },
          ),
        ],
      ),
    );
  }
}
