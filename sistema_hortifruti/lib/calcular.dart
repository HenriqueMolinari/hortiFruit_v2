class Calcular {
  static double calcularValorCompra(double precoPorKg, double quantidadeKg) {
    return precoPorKg * quantidadeKg;
  }

  static void exibirResumoCompra(
      String fruta, double quantidade, double precoUnitario, double total) {
    print('\n📋 RESUMO DA COMPRA:');
    print('🍎 Fruta: $fruta');
    print('⚖️  Quantidade: ${quantidade}kg');
    print('💰 Preço por kg: R\$$precoUnitario');
    print('💵 Total: R\$${total.toStringAsFixed(2)}');
  }
}