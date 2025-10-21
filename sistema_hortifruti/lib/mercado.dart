class Mercado {
  int? id;
  String nome;
  String endereco;
  String telefone;

  Mercado({
    this.id,
    required this.nome,
    required this.endereco,
    required this.telefone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'endereco': endereco,
      'telefone': telefone,
    };
  }

  static Mercado fromMap(Map<String, dynamic> map) {
    return Mercado(
      id: map['id'],
      nome: map['nome'],
      endereco: map['endereco'],
      telefone: map['telefone'],
    );
  }

  @override
  String toString() {
    return 'Mercado: $nome | Endereço: $endereco | Telefone: $telefone';
  }
}