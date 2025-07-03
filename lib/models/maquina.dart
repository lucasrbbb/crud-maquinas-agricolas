import 'package:crud_maquinas_agricolas/models/status.dart';
import 'package:intl/intl.dart';

class Maquina {
  int _id;
  int _idTipo;
  int _idMarca;
  DateTime _anoInclusao;
  String _descricao;
  int _anoFabricacao;
  double _valor;
  String _nomeProprietario;
  String _contatoProprietario;
  double _percentualComissao;
  Status _status;

  Maquina(this._id, this._idTipo, this._idMarca, this._anoInclusao, this._descricao,
      this._anoFabricacao, this._valor, this._nomeProprietario,
      this._contatoProprietario, this._percentualComissao, this._status);


  int get idTipo => _idTipo;

  set idTipo(int value) {
    _idTipo = value;
  }

  int get idMarca => _idMarca;

  set idMarca(int value) {
    _idMarca = value;
  }

  DateTime get anoInclusao => _anoInclusao;

  set anoInclusao(DateTime value) {
    _anoInclusao = value;
  }

  String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }

  int get anoFabricacao => _anoFabricacao;

  set anoFabricacao(int value) {
    _anoFabricacao = value;
  }

  double get valor => _valor;

  set valor(double value) {
    _valor = value;
  }

  String get nomeProprietario => _nomeProprietario;

  set nomeProprietario(String value) {
    _nomeProprietario = value;
  }

  String get contatoProprietario => _contatoProprietario;

  set contatoProprietario(String value) {
    _contatoProprietario = value;
  }

  double get percentualComissao => _percentualComissao;

  set percentualComissao(double value) {
    _percentualComissao = value;
  }

  Status get status => _status;

  set status(Status value) {
    _status = value;
  }


  int get id => _id;

  set id(int value) {
    _id = value;
  }

  Map<String, dynamic> toJson() => {
    'idMarca': _idMarca,
    'idTipo': _idTipo,
    'anoFabricacao': _anoFabricacao,
    'contatoProprietario': _contatoProprietario,
    'dataInclusao': formatarData(anoInclusao),
    'descricao': _descricao,
    'nomeProprietario': _nomeProprietario,
    'percentualComissao': _percentualComissao,
    'status': _status.name,
    'valor': _valor,
  };

  factory Maquina.fromJson(Map<String, dynamic> json) => Maquina(
    json['id'],
    json['idTipo'],
    json['idMarca'],
    DateTime.parse(json['dataInclusao']),
    json['descricao'],
    json['anoFabricacao'],
    (json['valor'] is int) ? (json['valor'] as int).toDouble() : json['valor'],
    json['nomeProprietario'],
    json['contatoProprietario'],
    json['percentualComissao'],
    Status.values.firstWhere((e) => e.name == json['status']),
  );

  @override
  String toString() {
    return 'Maquina{id: $_id, descricao: $_descricao, anoFabricacao: $_anoFabricacao, valor: $_valor, '
        'nomeProprietario: $_nomeProprietario, contatoProprietario: $_contatoProprietario, '
        'percentualComissao: $_percentualComissao, status: ${_status.name}, '
        'idTipo: $_idTipo, idMarca: $_idMarca, anoInclusao: $_anoInclusao}';
  }

  String formatarData(DateTime dt) {
    final formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(dt);
  }
}