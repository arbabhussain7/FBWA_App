import 'package:football_app/model/player_model.dart';
import 'package:football_app/model/team_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static const String playerTableName = 'PlayerDb';
  static const String teamTableName = 'TeamDb';
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'football_database.db');
    return await openDatabase(
      path,
      version: 4,
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
    );
  }

  static Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $playerTableName (
        s_no INTEGER PRIMARY KEY AUTOINCREMENT,
        p_name TEXT NOT NULL,
        j_number INTEGER NOT NULL UNIQUE,
        p_position TEXT NOT NULL,
        p_img TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE $teamTableName (
        s_no INTEGER PRIMARY KEY AUTOINCREMENT,
        t_name TEXT NOT NULL,
        t_leagues TEXT,
        t_club TEXT NOT NULL,
        t_img TEXT
      )
    ''');
  }

  static Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE $teamTableName (
          s_no INTEGER PRIMARY KEY AUTOINCREMENT,
          t_name TEXT NOT NULL,
          t_league TEXT NOT NULL,
          t_club TEXT NOT NULL,
          t_city TEXT NOT NULL,
          t_img TEXT
        )
      ''');
    }
    if (oldVersion < 3) {
      await db.execute('''
        ALTER TABLE $teamTableName ADD COLUMN t_leagues TEXT
      ''');
    }
    if (oldVersion < 4) {
      await db.execute('''
        CREATE TABLE ${teamTableName}_new (
          s_no INTEGER PRIMARY KEY AUTOINCREMENT,
          t_name TEXT NOT NULL,
          t_leagues TEXT,
          t_club TEXT NOT NULL,
          t_img TEXT
        )
      ''');

      await db.execute('''
        INSERT INTO ${teamTableName}_new (s_no, t_name, t_leagues, t_club, t_img)
        SELECT s_no, t_name, t_leagues, t_club, t_img FROM $teamTableName
      ''');

      await db.execute('DROP TABLE $teamTableName');

      await db.execute(
        'ALTER TABLE ${teamTableName}_new RENAME TO $teamTableName',
      );
    }
  }

  static Future<int> insertPlayer(Player player) async {
    try {
      final db = await database;
      return await db.insert(playerTableName, player.toMap());
    } catch (e) {
      print('Error inserting player: $e');
      throw Exception('Failed to insert player: $e');
    }
  }

  static Future<List<Player>> getAllPlayers() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(playerTableName);
      return List.generate(maps.length, (i) => Player.fromMap(maps[i]));
    } catch (e) {
      print('Error getting players: $e');
      return [];
    }
  }

  static Future<Player?> getPlayerById(int id) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        playerTableName,
        where: 's_no = ?',
        whereArgs: [id],
      );
      if (maps.isNotEmpty) {
        return Player.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      print('Error getting player by ID: $e');
      return null;
    }
  }

  static Future<int> updatePlayer(Player player) async {
    try {
      final db = await database;
      return await db.update(
        playerTableName,
        player.toMap(),
        where: 's_no = ?',
        whereArgs: [player.sNo],
      );
    } catch (e) {
      print('Error updating player: $e');
      throw Exception('Failed to update player: $e');
    }
  }

  static Future<int> deletePlayer(int id) async {
    try {
      final db = await database;
      return await db.delete(
        playerTableName,
        where: 's_no = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error deleting player: $e');
      throw Exception('Failed to delete player: $e');
    }
  }

  static Future<int> insertTeam(Team team) async {
    try {
      final db = await database;
      return await db.insert(teamTableName, team.toMap());
    } catch (e) {
      print('Error inserting team: $e');
      throw Exception('Failed to insert team: $e');
    }
  }

  static Future<List<Team>> getAllTeams() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        teamTableName,
        orderBy: 's_no DESC',
      );
      return List.generate(maps.length, (i) => Team.fromMap(maps[i]));
    } catch (e) {
      print('Error getting teams: $e');
      return [];
    }
  }

  static Future<Team?> getTeamById(int id) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        teamTableName,
        where: 's_no = ?',
        whereArgs: [id],
      );
      if (maps.isNotEmpty) {
        return Team.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      print('Error getting team by ID: $e');
      return null;
    }
  }

  static Future<int> updateTeam(Team team) async {
    try {
      final db = await database;
      return await db.update(
        teamTableName,
        team.toMap(),
        where: 's_no = ?',
        whereArgs: [team.sNo],
      );
    } catch (e) {
      print('Error updating team: $e');
      throw Exception('Failed to update team: $e');
    }
  }

  static Future<int> deleteTeam(int id) async {
    try {
      final db = await database;
      return await db.delete(teamTableName, where: 's_no = ?', whereArgs: [id]);
    } catch (e) {
      print('Error deleting team: $e');
      throw Exception('Failed to delete team: $e');
    }
  }

  static Future<int> getTeamsCount() async {
    try {
      final db = await database;
      final result = await db.rawQuery('SELECT COUNT(*) FROM $teamTableName');
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      print('Error getting teams count: $e');
      return 0;
    }
  }
}
