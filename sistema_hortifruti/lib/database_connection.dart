import 'package:mysql1/mysql1.dart';
import 'database_config.dart';

class DatabaseConnection {
  final DatabaseConfig config;

  DatabaseConnection(this.config);

  Future<MySqlConnection> getConnection() async {
    try {
      final connection = await MySqlConnection.connect(ConnectionSettings(
        host: config.host,
        port: config.porta,
        user: config.usuario,
        password: config.senha,
        db: config.dbName,
      ));
      print('✅ Conexão estabelecida com Sucesso!');
      return connection;
    } catch (e) {
      print('❌ Erro ao conectar: $e');
      rethrow;
    }
  }
}