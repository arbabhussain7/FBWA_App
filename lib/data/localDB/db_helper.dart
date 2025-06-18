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
      version: 7, // Incremented version to fix migration issues
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
    );
  }

  static Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $playerTableName (
        s_no INTEGER PRIMARY KEY AUTOINCREMENT,
        p_name TEXT NOT NULL,
        j_number INTEGER NOT NULL,
        p_position TEXT NOT NULL,
        p_img TEXT,
        team_id INTEGER,
        FOREIGN KEY (team_id) REFERENCES $teamTableName (s_no),
        UNIQUE(j_number, team_id)
      )
    ''');
    await db.execute('''
      CREATE TABLE $teamTableName (
        s_no INTEGER PRIMARY KEY AUTOINCREMENT,
        t_name TEXT NOT NULL UNIQUE,
        t_leagues TEXT,
        t_img TEXT
      )
    ''');
  }

  // Check if column exists before adding it
  static Future<bool> _columnExists(
    Database db,
    String tableName,
    String columnName,
  ) async {
    try {
      final result = await db.rawQuery("PRAGMA table_info($tableName)");
      for (var row in result) {
        if (row['name'] == columnName) {
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error checking column existence: $e');
      return false;
    }
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
      bool columnExists = await _columnExists(db, teamTableName, 't_leagues');
      if (!columnExists) {
        await db.execute('''
          ALTER TABLE $teamTableName ADD COLUMN t_leagues TEXT
        ''');
      }
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
    if (oldVersion < 5) {
      await db.execute('''
        CREATE TABLE ${teamTableName}_new (
          s_no INTEGER PRIMARY KEY AUTOINCREMENT,
          t_name TEXT NOT NULL,
          t_leagues TEXT,
          t_img TEXT
        )
      ''');

      await db.execute('''
        INSERT INTO ${teamTableName}_new (s_no, t_name, t_leagues, t_img)
        SELECT s_no, t_name, t_leagues, t_img FROM $teamTableName
      ''');

      await db.execute('DROP TABLE $teamTableName');
      await db.execute(
        'ALTER TABLE ${teamTableName}_new RENAME TO $teamTableName',
      );
    }
    if (oldVersion < 6) {
      // Check if team_id column already exists before adding it
      bool columnExists = await _columnExists(db, playerTableName, 'team_id');
      if (!columnExists) {
        await db.execute('''
          ALTER TABLE $playerTableName ADD COLUMN team_id INTEGER
        ''');
      }
    }
    if (oldVersion < 7) {
      // Add UNIQUE constraint to team name if not exists
      try {
        await db.execute('''
          CREATE TABLE ${teamTableName}_new (
            s_no INTEGER PRIMARY KEY AUTOINCREMENT,
            t_name TEXT NOT NULL UNIQUE,
            t_leagues TEXT,
            t_img TEXT
          )
        ''');

        await db.execute('''
          INSERT INTO ${teamTableName}_new (s_no, t_name, t_leagues, t_img)
          SELECT s_no, t_name, t_leagues, t_img FROM $teamTableName
        ''');

        await db.execute('DROP TABLE $teamTableName');
        await db.execute(
          'ALTER TABLE ${teamTableName}_new RENAME TO $teamTableName',
        );
      } catch (e) {
        print('Error adding UNIQUE constraint to team name: $e');
      }
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

  static Future<List<Map<String, dynamic>>> getPlayersWithTeamInfo() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        p.s_no,
        p.p_name,
        p.j_number,
        p.p_position,
        p.p_img,
        p.team_id,
        t.t_name as team_name
      FROM $playerTableName p
      LEFT JOIN $teamTableName t ON p.team_id = t.s_no
      ORDER BY p.s_no DESC
    ''');
      return maps;
    } catch (e) {
      print('Error getting players with team info: $e');
      return [];
    }
  }

  static Future<int> insertTeam(Team team) async {
    try {
      final db = await database;
      return await db.insert(teamTableName, team.toMap());
    } catch (e) {
      print('Error inserting team: $e');
      // Check if it's a UNIQUE constraint error for team name
      if (e.toString().contains('UNIQUE constraint failed') &&
          e.toString().contains('t_name')) {
        throw Exception('Team name already exists');
      }
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

  static Future<bool> isTeamNameExists(String teamName) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> result = await db.query(
        teamTableName,
        where: 'LOWER(t_name) = ?',
        whereArgs: [teamName.toLowerCase()],
      );
      return result.isNotEmpty;
    } catch (e) {
      print('Error checking team name existence: $e');
      return false;
    }
  }

  static Future<bool> isJerseyNumberExistsInTeam(
    int jerseyNumber,
    int? teamId,
  ) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> result = await db.query(
        playerTableName,
        where: 'j_number = ? AND team_id = ?',
        whereArgs: [jerseyNumber, teamId],
      );
      return result.isNotEmpty;
    } catch (e) {
      print('Error checking jersey number existence in team: $e');
      return false;
    }
  }

  static Future<bool> isJerseyNumberExists(int jerseyNumber) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> result = await db.query(
        playerTableName,
        where: 'j_number = ?',
        whereArgs: [jerseyNumber],
      );
      return result.isNotEmpty;
    } catch (e) {
      print('Error checking jersey number existence: $e');
      return false;
    }
  }

  static Future<String?> getTeamNameById(int teamId) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        teamTableName,
        columns: ['t_name'],
        where: 's_no = ?',
        whereArgs: [teamId],
      );
      if (maps.isNotEmpty) {
        return maps.first['t_name'] as String?;
      }
      return null;
    } catch (e) {
      print('Error getting team name by ID: $e');
      return null;
    }
  }

  static Future<bool> isPlayerExistsInTeam(
    String playerName,
    int? teamId,
  ) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> result = await db.query(
        playerTableName,
        where: 'LOWER(p_name) = ? AND team_id = ?',
        whereArgs: [playerName.toLowerCase(), teamId],
      );
      return result.isNotEmpty;
    } catch (e) {
      print('Error checking player existence in team: $e');
      return false;
    }
  }
}
