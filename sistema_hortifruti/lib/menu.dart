import 'dart:io';
import 'fruta.dart';
import 'comprador.dart';
import 'mercado.dart';
import 'mercado_service.dart';

class Menu {
  final MercadoService mercadoService;

  Menu(this.mercadoService);

  void exibirMenu() {
    print('''
🍎 SACOLÃO DO ZÉ 🍌

1. 🏪 Cadastrar Mercado
2. 👤 Cadastrar Comprador
3. 🍓 Cadastrar Nova Fruta
4. 🛒 Cadastrar Nova Venda
5. 📋 Listar Frutas
6. 👥 Listar Compradores
7. 🏪 Listar Mercados
8. 🔄 Popular Frutas Iniciais
0. 🚪 Sair
''');
  }

  Future<void> executar() async {
    bool sair = false;

    while (!sair) {
      exibirMenu();
      stdout.write('👉 Escolha uma opção: ');
      var opcao = stdin.readLineSync();

      switch (opcao) {
        case '1':
          await _cadastrarMercado();
          break;
        case '2':
          await _cadastrarComprador();
          break;
        case '3':
          await _cadastrarFruta();
          break;
        case '4':
          await _realizarVenda();
          break;
        case '5':
          await _listarFrutas();
          break;
        case '6':
          await _listarCompradores();
          break;
        case '7':
          await _listarMercados();
          break;
        case '8':
          await mercadoService.popularFrutasIniciais();
          break;
        case '0':
          sair = true;
          print('👋 Até logo! Obrigado por usar o Sacolão do Zé!');
          break;
        default:
          print('❌ Opção inválida! Tente novamente.');
      }

      if (!sair) {
        print('\nPressione Enter para continuar...');
        stdin.readLineSync();
      }
    }
  }

  Future<void> _cadastrarMercado() async {
    print('\n🏪 CADASTRAR MERCADO');
    stdout.write('Nome do mercado: ');
    var nome = stdin.readLineSync() ?? '';
    
    stdout.write('Endereço: ');
    var endereco = stdin.readLineSync() ?? '';
    
    stdout.write('Telefone: ');
    var telefone = stdin.readLineSync() ?? '';

    if (nome.isNotEmpty) {
      var mercado = Mercado(
        nome: nome,
        endereco: endereco,
        telefone: telefone,
      );
      await mercadoService.inserirMercado(mercado);
    } else {
      print('❌ Nome do mercado é obrigatório!');
    }
  }

  Future<void> _cadastrarComprador() async {
    print('\n👤 CADASTRAR COMPRADOR');
    stdout.write('Nome do comprador: ');
    var nome = stdin.readLineSync() ?? '';
    
    stdout.write('Email: ');
    var email = stdin.readLineSync() ?? '';
    
    stdout.write('Telefone: ');
    var telefone = stdin.readLineSync() ?? '';

    if (nome.isNotEmpty) {
      var comprador = Comprador(
        nome: nome,
        email: email,
        telefone: telefone,
      );
      await mercadoService.inserirComprador(comprador);
    } else {
      print('❌ Nome do comprador é obrigatório!');
    }
  }

  Future<void> _cadastrarFruta() async {
    print('\n🍓 CADASTRAR NOVA FRUTA');
    stdout.write('Nome da fruta: ');
    var nome = stdin.readLineSync() ?? '';
    
    stdout.write('Preço por kg (ex: 15.00): ');
    var precoInput = stdin.readLineSync() ?? '';
    
    stdout.write('Quantidade em estoque (kg): ');
    var estoqueInput = stdin.readLineSync() ?? '';

    try {
      var preco = double.parse(precoInput);
      var estoque = double.parse(estoqueInput);

      if (nome.isNotEmpty && preco > 0) {
        var fruta = Fruta(
          nome: nome,
          precoPorKg: preco,
          quantidadeEstoque: estoque,
        );
        await mercadoService.inserirFruta(fruta);
      } else {
        print('❌ Dados inválidos!');
      }
    } catch (e) {
      print('❌ Erro ao processar dados: $e');
    }
  }

  Future<void> _realizarVenda() async {
    print('\n🛒 REALIZAR VENDA');

    // Listar compradores
    var compradores = await mercadoService.listarCompradores();
    if (compradores.isEmpty) {
      print('❌ Nenhum comprador cadastrado!');
      return;
    }

    print('\n👥 COMPRADORES:');
    for (var i = 0; i < compradores.length; i++) {
      print('${i + 1}. ${compradores[i].nome}');
    }

    stdout.write('Selecione o comprador (número): ');
    var compradorIndex = int.tryParse(stdin.readLineSync() ?? '') ?? 0;
    if (compradorIndex < 1 || compradorIndex > compradores.length) {
      print('❌ Comprador inválido!');
      return;
    }

    // Listar mercados
    var mercados = await mercadoService.listarMercados();
    if (mercados.isEmpty) {
      print('❌ Nenhum mercado cadastrado!');
      return;
    }

    print('\n🏪 MERCADOS:');
    for (var i = 0; i < mercados.length; i++) {
      print('${i + 1}. ${mercados[i].nome}');
    }

    stdout.write('Selecione o mercado (número): ');
    var mercadoIndex = int.tryParse(stdin.readLineSync() ?? '') ?? 0;
    if (mercadoIndex < 1 || mercadoIndex > mercados.length) {
      print('❌ Mercado inválido!');
      return;
    }

    // Listar frutas
    var frutas = await mercadoService.listarFrutas();
    if (frutas.isEmpty) {
      print('❌ Nenhuma fruta cadastrada!');
      return;
    }

    print('\n🍎 FRUTAS DISPONÍVEIS:');
    for (var i = 0; i < frutas.length; i++) {
      print('${i + 1}. ${frutas[i]}');
    }

    stdout.write('Selecione a fruta (número): ');
    var frutaIndex = int.tryParse(stdin.readLineSync() ?? '') ?? 0;
    if (frutaIndex < 1 || frutaIndex > frutas.length) {
      print('❌ Fruta inválida!');
      return;
    }

    stdout.write('Quantidade (kg): ');
    var quantidadeInput = stdin.readLineSync() ?? '';
    var quantidade = double.tryParse(quantidadeInput) ?? 0;

    if (quantidade <= 0) {
      print('❌ Quantidade inválida!');
      return;
    }

    var compradorId = compradores[compradorIndex - 1].id!;
    var mercadoId = mercados[mercadoIndex - 1].id!;
    var frutaId = frutas[frutaIndex - 1].id!;

    await mercadoService.registrarVenda(
      compradorId,
      mercadoId,
      frutaId,
      quantidade,
    );
  }

  Future<void> _listarFrutas() async {
    print('\n🍎 LISTA DE FRUTAS:');
    var frutas = await mercadoService.listarFrutas();
    if (frutas.isEmpty) {
      print('Nenhuma fruta cadastrada.');
    } else {
      for (var fruta in frutas) {
        print(fruta);
      }
    }
  }

  Future<void> _listarCompradores() async {
    print('\n👥 LISTA DE COMPRADORES:');
    var compradores = await mercadoService.listarCompradores();
    if (compradores.isEmpty) {
      print('Nenhum comprador cadastrado.');
    } else {
      for (var comprador in compradores) {
        print(comprador);
      }
    }
  }

  Future<void> _listarMercados() async {
    print('\n🏪 LISTA DE MERCADOS:');
    var mercados = await mercadoService.listarMercados();
    if (mercados.isEmpty) {
      print('Nenhum mercado cadastrado.');
    } else {
      for (var mercado in mercados) {
        print(mercado);
      }
    }
  }
}