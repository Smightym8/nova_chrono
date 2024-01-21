abstract class DatabaseProvider {
  get database;

  Future<void> initDatabase();
  Future<void> closeDatabase();
  Future<void> deleteDatabase();
}