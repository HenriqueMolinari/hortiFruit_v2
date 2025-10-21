class Comprador {
  int? id;
  String nome;
  String email;
  String telefone;

  Comprador({
    this.id,
    required this.nome,
    required this.email,
    required this.telefone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'telefone': telefone,
    };
  }

  static Comprador fromMap(Map<String, dynamic> map) {
    return Comprador(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      telefone: map['telefone'],
    );
  }

  @override
  String toString() {
    return 'Comprador: $nome | Email: $email | Telefone: $telefone';
  }
}