import '../lib/menu.dart';
import '../lib/database_config.dart';
import '../lib/database_connection.dart';
import '../lib/mercado_service.dart';

void main() async {
  print('''
================ 🍎 SACOLÃO DO ZÉ 🍌 ================                 
============= Sistema de Gerenciamento ===============
  ''');

  try {
    // Configuração do banco
    final config = DatabaseConfig(
      host: 'localhost',
      porta: 3306,
      usuario: 'root',
      senha: 'unifeob@123',
      dbName: 'sistema_hortifruit',
    );

    // Inicializar serviços
    final dbConnection = DatabaseConnection(config);
    final mercadoService = MercadoService(dbConnection);
    
    // Criar tabelas e executar menu
    await mercadoService.criarTabelas();
    
    final menu = Menu(mercadoService);
    await menu.executar();
    
  } catch (e) {
    print('❌ Erro ao iniciar o sistema: $e');
  }
}