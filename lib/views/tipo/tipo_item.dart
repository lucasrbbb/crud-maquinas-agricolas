import 'package:crud_maquinas_agricolas/models/tipo.dart';
import 'package:flutter/material.dart';

class TipoItem extends StatelessWidget {
  final Tipo tipo;
  final VoidCallback? onTap;

  const TipoItem({
    Key? key,
    required this.tipo,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Icon(Icons.category),
        title: Text(tipo.descricao),
        trailing: Icon(Icons.more_vert),
        onTap: onTap,
      ),
    );
  }
}
