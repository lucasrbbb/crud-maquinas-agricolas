import 'package:crud_maquinas_agricolas/models/marca.dart';
import 'package:flutter/material.dart';

class MarcaItem extends StatelessWidget {
  final Marca marca;
  final VoidCallback? onTap;

  const MarcaItem({
    Key? key,
    required this.marca,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Icon(Icons.factory),
        title: Text(marca.nome),
        trailing: Icon(Icons.more_vert),
        onTap: onTap,
      ),
    );
  }
}
