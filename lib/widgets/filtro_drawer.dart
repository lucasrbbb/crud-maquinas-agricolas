import 'package:flutter/material.dart';
import '../../models/marca.dart';
import '../../models/tipo.dart';
import '../../models/status.dart';
import '../../models/filtro.dart';

class FiltroDrawer extends StatefulWidget {
  final List<Marca> marcas;
  final List<Tipo> tipos;
  final void Function(Filtro filtro) onAplicar;

  const FiltroDrawer({
    super.key,
    required this.marcas,
    required this.tipos,
    required this.onAplicar,
  });

  @override
  State<FiltroDrawer> createState() => _FiltroDrawerState();
}

class _FiltroDrawerState extends State<FiltroDrawer> {
  Status? _status;
  Marca? _marca;
  Tipo? _tipo;
  double? _valorDe;
  double? _valorAte;

  final _valorDeController = TextEditingController();
  final _valorAteController = TextEditingController();

  @override
  void dispose() {
    _valorDeController.dispose();
    _valorAteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Filtros',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<Status>(
              decoration: const InputDecoration(labelText: 'Status'),
              value: _status,
              items: Status.values
                  .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e.label),
              ))
                  .toList(),
              onChanged: (value) => setState(() => _status = value),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<Marca>(
              decoration: const InputDecoration(labelText: 'Marca'),
              value: _marca,
              items: widget.marcas
                  .map((m) => DropdownMenuItem(
                value: m,
                child: Text(m.nome),
              ))
                  .toList(),
              onChanged: (value) => setState(() => _marca = value),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<Tipo>(
              decoration: const InputDecoration(labelText: 'Tipo'),
              value: _tipo,
              items: widget.tipos
                  .map((t) => DropdownMenuItem(
                value: t,
                child: Text(t.descricao),
              ))
                  .toList(),
              onChanged: (value) => setState(() => _tipo = value),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _valorDeController,
              decoration: const InputDecoration(
                labelText: 'Valor de (R\$)',
              ),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _valorAteController,
              decoration: const InputDecoration(
                labelText: 'Valor até (R\$)',
              ),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                final filtro = Filtro(
                  double.tryParse(_valorDeController.text) ?? 0,
                  double.tryParse(_valorAteController.text) ?? 0,
                  _status ?? Status.N,
                  _tipo?.id ?? 0,
                  _marca?.id ?? 0,
                );
                widget.onAplicar(filtro);
                Navigator.of(context).pop();
              },
              child: const Text('Aplicar filtros'),
            ),
          ],
        ),
      ),
    );
  }
}
