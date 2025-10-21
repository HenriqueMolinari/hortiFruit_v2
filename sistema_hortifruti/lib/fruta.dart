class Fruta {
  int? id;
  String nome;
  double precoPorKg;
  double quantidadeEstoque;

  Fruta({
    this.id,
    required this.nome,
    required this.precoPorKg,
    this.quantidadeEstoque = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'preco_por_kg': precoPorKg,
      'quantidade_estoque': quantidadeEstoque,
    };
  }

  static Fruta fromMap(Map<String, dynamic> map) {
    return Fruta(
      id: map['id'],
      nome: map['nome'],
      precoPorKg: map['preco_por_kg'] is double 
          ? map['preco_por_kg'] 
          : (map['preco_por_kg'] as num).toDouble(),
      quantidadeEstoque: map['quantidade_estoque'] is double
          ? map['quantidade_estoque']
          : (map['quantidade_estoque'] as num).toDouble(),
    );
  }

  @override
  String toString() {
    return 'Fruta: $nome | Preço: R\$$precoPorKg/kg | Estoque: ${quantidadeEstoque}kg';
  }
}