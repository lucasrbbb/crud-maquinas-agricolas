import 'package:crud_maquinas_agricolas/models/maquina.dart';
import 'package:crud_maquinas_agricolas/models/marca.dart';
import 'package:crud_maquinas_agricolas/models/status.dart';
import 'package:crud_maquinas_agricolas/models/tipo.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MaquinaItem extends StatelessWidget {
  final Maquina maquina;
  final Map<int, Marca> marcas;
  final Map<int, Tipo> tipos;
  final VoidCallback? onTap;

  const MaquinaItem({
    Key? key,
    required this.maquina,
    required this.marcas,
    required this.tipos,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final marca = marcas[maquina.idMarca];
    final tipo = tipos[maquina.idTipo];

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Icon(Icons.directions_car_filled),
        title: Text(maquina.descricao),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Marca: ${marca?.nome}'),
                Text('Tipo: ${tipo?.descricao}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ano: ${maquina.anoFabricacao}'),
                Text('Valor: R\$ ${maquina.valor.toStringAsFixed(2)}'),
              ],
            ),

            Text('Proprietário: ${maquina.nomeProprietario}'),
            Text('Contato: ${maquina.contatoProprietario}'),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  maquina.status.label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 16,
                  ),
                ),
                Text('Criado em: ${DateFormat('dd/MM/yyyy HH:mm').format(maquina.anoInclusao)}'),
              ],
            ),
          ],
        ),
        trailing: Icon(Icons.more_vert),
        onTap: onTap,
      ),
    );
  }
}
