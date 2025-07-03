enum Status {
  D,
  N,
  R,
  V,
}

extension StatusExt on Status {
  String get label {
    switch (this) {
      case Status.D:
        return 'Disponível';
      case Status.N:
        return 'Novo';
      case Status.R:
        return 'Reservado';
      case Status.V:
        return 'Vendido';
    }
  }
}
