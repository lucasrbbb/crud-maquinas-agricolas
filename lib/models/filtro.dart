import 'package:crud_maquinas_agricolas/models/status.dart';

class Filtro {
  double _valorDe;
  double _valorAte;
  Status _status;
  int _idTipo;
  int _idMarca;

  Filtro(this._valorDe, this._valorAte, this._status, this._idTipo, this._idMarca);

  int get idMarca => _idMarca;

  set idMarca(int value) {
    _idMarca = value;
  }

  int get idTipo => _idTipo;

  set idTipo(int value) {
    _idTipo = value;
  }

  Status get status => _status;

  set status(Status value) {
    _status = value;
  }

  double get valorAte => _valorAte;

  set valorAte(double value) {
    _valorAte = value;
  }

  double get valorDe => _valorDe;

  set valorDe(double value) {
    _valorDe = value;
  }

  @override
  String toString() {
    return 'Filtro{valorDe: $_valorDe, valorAte: $_valorAte, '
        'status: ${_status.name}, idTipo: $_idTipo, idMarca: $_idMarca}';
  }
}
