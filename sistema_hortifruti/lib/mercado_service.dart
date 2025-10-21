import 'fruta.dart';
import 'comprador.dart';
import 'mercado.dart';
import 'calcular.dart';
import 'database_connection.dart';

class MercadoService {
  final DatabaseConnection dbConnection;

  MercadoService(this.dbConnection);

  // Método para criar as tabelas
  Future<void> criarTabelas() async {
    final connection = await dbConnection.getConnection();
    try {
      // Tabela de mercados
      await connection.query('''
        CREATE TABLE IF NOT EXISTS mercados (
          id INT AUTO_INCREMENT PRIMARY KEY,
          nome VARCHAR(100) NOT NULL,
          endereco TEXT,
          telefone VARCHAR(20),
          data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      ''');

      // Tabela de compradores
      await connection.query('''
        CREATE TABLE IF NOT EXISTS compradores (
          id INT AUTO_INCREMENT PRIMARY KEY,
          nome VARCHAR(100) NOT NULL,
          email VARCHAR(100),
          telefone VARCHAR(20),
          data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      ''');

      // Tabela de frutas
      await connection.query('''
        CREATE TABLE IF NOT EXISTS frutas (
          id INT AUTO_INCREMENT PRIMARY KEY,
          nome VARCHAR(100) NOT NULL,
          preco_por_kg DECIMAL(10,2) NOT NULL,
          quantidade_estoque DECIMAL(10,2) DEFAULT 0
        )
      ''');

      // Tabela de vendas
      await connection.query('''
        CREATE TABLE IF NOT EXISTS vendas (
          id INT AUTO_INCREMENT PRIMARY KEY,
          comprador_id INT NOT NULL,
          mercado_id INT NOT NULL,
          fruta_id INT NOT NULL,
          quantidade_kg DECIMAL(10,2) NOT NULL,
          preco_unitario DECIMAL(10,2) NOT NULL,
          valor_total DECIMAL(10,2) NOT NULL,
          data_venda TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          
          FOREIGN KEY (comprador_id) REFERENCES compradores(id),
          FOREIGN KEY (mercado_id) REFERENCES mercados(id),
          FOREIGN KEY (fruta_id) REFERENCES frutas(id)
        )
      ''');

      print('✅ Tabelas criadas/verificadas com sucesso!');
    } catch (e) {
      print('❌ Erro ao criar tabelas: $e');
      rethrow;
    } finally {
      await connection.close();
    }
  }

  // FRUTAS
  Future<void> inserirFruta(Fruta fruta) async {
    final connection = await dbConnection.getConnection();
    try {
      await connection.query(
        'INSERT INTO frutas (nome, preco_por_kg, quantidade_estoque) VALUES (?, ?, ?)',
        [fruta.nome, fruta.precoPorKg, fruta.quantidadeEstoque],
      );
      print('✅ Fruta "${fruta.nome}" inserida com sucesso!');
    } catch (e) {
      print('❌ Erro ao inserir fruta: $e');
    } finally {
      await connection.close();
    }
  }

  Future<List<Fruta>> listarFrutas() async {
    final connection = await dbConnection.getConnection();
    try {
      final resultados = await connection.query('SELECT * FROM frutas');
      return resultados.map((row) => Fruta.fromMap(row.fields)).toList();
    } catch (e) {
      print('❌ Erro ao listar frutas: $e');
      return [];
    } finally {
      await connection.close();
    }
  }

  Future<Fruta?> buscarFrutaPorId(int id) async {
    final connection = await dbConnection.getConnection();
    try {
      final resultado = await connection.query(
        'SELECT * FROM frutas WHERE id = ?',
        [id],
      );
      if (resultado.isNotEmpty) {
        return Fruta.fromMap(resultado.first.fields);
      }
      return null;
    } catch (e) {
      print('❌ Erro ao buscar fruta: $e');
      return null;
    } finally {
      await connection.close();
    }
  }

  // COMPRADORES
  Future<void> inserirComprador(Comprador comprador) async {
    final connection = await dbConnection.getConnection();
    try {
      await connection.query(
        'INSERT INTO compradores (nome, email, telefone) VALUES (?, ?, ?)',
        [comprador.nome, comprador.email, comprador.telefone],
      );
      print('✅ Comprador "${comprador.nome}" cadastrado com sucesso!');
    } catch (e) {
      print('❌ Erro ao inserir comprador: $e');
    } finally {
      await connection.close();
    }
  }

  Future<List<Comprador>> listarCompradores() async {
    final connection = await dbConnection.getConnection();
    try {
      final resultados = await connection.query('SELECT * FROM compradores');
      return resultados.map((row) => Comprador.fromMap(row.fields)).toList();
    } catch (e) {
      print('❌ Erro ao listar compradores: $e');
      return [];
    } finally {
      await connection.close();
    }
  }

  // MERCADOS
  Future<void> inserirMercado(Mercado mercado) async {
    final connection = await dbConnection.getConnection();
    try {
      await connection.query(
        'INSERT INTO mercados (nome, endereco, telefone) VALUES (?, ?, ?)',
        [mercado.nome, mercado.endereco, mercado.telefone],
      );
      print('✅ Mercado "${mercado.nome}" cadastrado com sucesso!');
    } catch (e) {
      print('❌ Erro ao inserir mercado: $e');
    } finally {
      await connection.close();
    }
  }

  Future<List<Mercado>> listarMercados() async {
    final connection = await dbConnection.getConnection();
    try {
      final resultados = await connection.query('SELECT * FROM mercados');
      return resultados.map((row) => Mercado.fromMap(row.fields)).toList();
    } catch (e) {
      print('❌ Erro ao listar mercados: $e');
      return [];
    } finally {
      await connection.close();
    }
  }

  // VENDAS
  Future<void> registrarVenda(int compradorId, int mercadoId, int frutaId, double quantidadeKg) async {
    final connection = await dbConnection.getConnection();
    try {
      final fruta = await buscarFrutaPorId(frutaId);
      if (fruta == null) {
        print('❌ Fruta não encontrada!');
        return;
      }

      final valorTotal = Calcular.calcularValorCompra(fruta.precoPorKg, quantidadeKg);

      await connection.query(
        'INSERT INTO vendas (comprador_id, mercado_id, fruta_id, quantidade_kg, preco_unitario, valor_total) VALUES (?, ?, ?, ?, ?, ?)',
        [compradorId, mercadoId, frutaId, quantidadeKg, fruta.precoPorKg, valorTotal],
      );

      print('✅ Venda registrada com sucesso!');
      Calcular.exibirResumoCompra(fruta.nome, quantidadeKg, fruta.precoPorKg, valorTotal);
    } catch (e) {
      print('❌ Erro ao registrar venda: $e');
    } finally {
      await connection.close();
    }
  }

  // Popular frutas iniciais
  Future<void> popularFrutasIniciais() async {
    final frutas = [
      Fruta(nome: 'Banana', precoPorKg: 15.00, quantidadeEstoque: 100),
      Fruta(nome: 'Maçã', precoPorKg: 12.50, quantidadeEstoque: 80),
      Fruta(nome: 'Laranja', precoPorKg: 8.00, quantidadeEstoque: 120),
      Fruta(nome: 'Uva', precoPorKg: 18.00, quantidadeEstoque: 60),
      Fruta(nome: 'Manga', precoPorKg: 10.00, quantidadeEstoque: 70),
      Fruta(nome: 'Abacaxi', precoPorKg: 7.50, quantidadeEstoque: 50),
      Fruta(nome: 'Melancia', precoPorKg: 5.00, quantidadeEstoque: 30),
      Fruta(nome: 'Morango', precoPorKg: 25.00, quantidadeEstoque: 40),
      Fruta(nome: 'Pera', precoPorKg: 14.00, quantidadeEstoque: 90),
      Fruta(nome: 'Kiwi', precoPorKg: 30.00, quantidadeEstoque: 20),
    ];

    for (var fruta in frutas) {
      try {
        await inserirFruta(fruta);
      } catch (e) {
        // Ignora erros de duplicação
      }
    }
  }
}