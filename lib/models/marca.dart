class Marca {
  int _id;
  String _nome;

  Marca(this._id, this._nome);

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  Map<String, dynamic> toJson() => {
    'nome': nome,
  };

  factory Marca.fromJson(Map<String, dynamic> json) => Marca(
    json['id'],
    json['nome'],
  );

  @override
  String toString() {
    return 'Marca{id: $_id, nome: $_nome}';
  }

}