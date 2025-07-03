class Tipo {
  int _id;
  String _descricao;

  Tipo(this._id, this._descricao);

  String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  Map<String, dynamic> toJson() => {
    'descricao': descricao,
  };

  factory Tipo.fromJson(Map<String, dynamic> json) => Tipo(
    json['id'],
    json['descricao'],
  );

  @override
  String toString() {
    return 'Tipo{id: $_id, descricao: $_descricao}';
  }

}