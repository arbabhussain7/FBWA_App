import 'dart:io';
import 'package:flutter/material.dart';
import 'package:football_app/data/localDB/db_helper.dart';
import 'package:football_app/model/player_model.dart';
import 'package:football_app/model/team_model.dart';
import 'package:football_app/views/home_screen.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class PlayerController extends GetxController {
  late TextEditingController playerNameController;
  late TextEditingController jerseyNumberController;
  late TextEditingController positionController;
  var isLoading = false.obs;
  var players = <Player>[].obs;
  var totalPlayersCount = 0.obs;
  var selectedImagePath = ''.obs;
  final ImagePicker _picker = ImagePicker();

  // Team selection variables
  var allTeams = <Team>[].obs;
  var selectedTeam = Rxn<Team>();
  var isLoadingTeams = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    loadPlayers();
    loadAllTeams();
  }

  @override
  void onReady() {
    super.onReady();
    loadAllTeams();
  }

  void _initializeControllers() {
    playerNameController = TextEditingController();
    jerseyNumberController = TextEditingController();
    positionController = TextEditingController();
  }

  Future<void> loadAllTeams() async {
    try {
      isLoadingTeams.value = true;
      List<Team> teams = await DatabaseHelper.getAllTeams();
      allTeams.value = teams;
      print('Loaded ${teams.length} teams'); // Debug log
    } catch (e) {
      Get.snackbar('Error', 'Failed to load teams: $e');
    } finally {
      isLoadingTeams.value = false;
    }
  }
  Future<void> refreshTeams() async {
    print('Refreshing teams...'); // Debug log
    await loadAllTeams();
  }

  void setSelectedTeam(Team? team) {
    selectedTeam.value = team;
  }

  Future<void> loadPlayers() async {
    try {
      isLoading.value = true;
      List<Map<String, dynamic>> playersData =
          await DatabaseHelper.getPlayersWithTeamInfo();
      players.value = playersData.map((data) => Player.fromMap(data)).toList();
      totalPlayersCount.value = players.length;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load players: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePlayersCount() async {
    try {
      var allPlayers = await DatabaseHelper.getAllPlayers();
      totalPlayersCount.value = allPlayers.length;
    } catch (e) {
      print('Error getting players count: $e');
      totalPlayersCount.value = 0;
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (image != null) {
        String savedImagePath = await _saveImageToLocal(image.path);
        selectedImagePath.value = savedImagePath;
        Get.snackbar('Success', 'Image selected successfully!');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  Future<String> _saveImageToLocal(String imagePath) async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      Directory playersImagesDir = Directory('$appDocPath/players_images');
      if (!await playersImagesDir.exists()) {
        await playersImagesDir.create(recursive: true);
      }
      String fileName = '${DateTime.now().millisecondsSinceEpoch}_player.jpg';
      String newPath = '${playersImagesDir.path}/$fileName';
      File imageFile = File(imagePath);
      await imageFile.copy(newPath);
      return newPath;
    } catch (e) {
      throw Exception('Failed to save image: $e');
    }
  }

  Future<void> deletePlayer(int playerId) async {
    try {
      isLoading.value = true;
      Player? playerToDelete;
      for (var player in players) {
        if (player.sNo == playerId) {
          playerToDelete = player;
          break;
        }
      }

      int result = await DatabaseHelper.deletePlayer(playerId);
      if (result > 0) {
        if (playerToDelete?.pImg != null && playerToDelete!.pImg!.isNotEmpty) {
          try {
            File imageFile = File(playerToDelete.pImg!);
            if (await imageFile.exists()) {
              await imageFile.delete();
            }
          } catch (e) {
            print('Error deleting image file: $e');
          }
        }

        await loadPlayers();
        Get.snackbar(
          'Success',
          'Player deleted successfully!',
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(12),
          borderRadius: 8,
          duration: Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete player',
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(12),
          borderRadius: 8,
        );
      }
    } catch (e) {
      print('Delete player error: $e');
      Get.snackbar(
        'Error',
        'Failed to delete player: ${e.toString()}',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(12),
        borderRadius: 8,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshPlayers() async {
    await loadPlayers();
  }

  void removeSelectedImage() {
    selectedImagePath.value = '';
  }

  Future<void> createPlayer() async {
    if (!await _validateInputs()) return;
    try {
      isLoading.value = true;

      int jerseyNumber = int.parse(jerseyNumberController.text.trim());

      Player newPlayer = Player(
        pName: playerNameController.text.trim(),
        jNumber: jerseyNumber,
        pPosition: positionController.text.trim(),
        pImg: selectedImagePath.value.isNotEmpty
            ? selectedImagePath.value
            : null,
        teamId: selectedTeam.value?.sNo,
      );

      await DatabaseHelper.insertPlayer(newPlayer);

      _clearForm();
      await loadPlayers();
      Get.snackbar(
        'Success',
        'Player created successfully!',
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(12),
        borderRadius: 8,
        duration: Duration(seconds: 2),
      );
      Get.off(() => HomeScreen());
    } catch (e) {
      // Check if it's a UNIQUE constraint error for jersey number
      if (e.toString().contains('UNIQUE constraint failed') &&
          e.toString().contains('j_number')) {
        Get.snackbar(
          'Error',
          'Jersey Number ${jerseyNumberController.text.trim()} player is exist',
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(12),
          borderRadius: 8,
          duration: Duration(seconds: 3),
        );
      } else if (e.toString().contains('UNIQUE constraint failed') &&
          e.toString().contains('p_name')) {
        Get.snackbar(
          'Error',
          'Player name already exists in this team',
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(12),
          borderRadius: 8,
          duration: Duration(seconds: 3),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to create player. Please try again.',
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(12),
          borderRadius: 8,
        );
      }
      print('Create player error: $e'); // Keep this for debugging
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> _validateInputs() async {
    // Basic field validations
    if (playerNameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter player name',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(12),
        borderRadius: 8,
      );
      return false;
    }

    if (jerseyNumberController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter jersey number',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(12),
        borderRadius: 8,
      );
      return false;
    }

    if (int.tryParse(jerseyNumberController.text.trim()) == null) {
      Get.snackbar(
        'Error',
        'Please enter valid jersey number',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(12),
        borderRadius: 8,
      );
      return false;
    }

    if (positionController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter player position',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(12),
        borderRadius: 8,
      );
      return false;
    }

    if (selectedTeam.value == null) {
      Get.snackbar(
        'Error',
        'Please select a team',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(12),
        borderRadius: 8,
      );
      return false;
    }

    // Advanced validations
    int jerseyNumber = int.parse(jerseyNumberController.text.trim());
    String playerName = playerNameController.text.trim();
    int? teamId = selectedTeam.value?.sNo;
    String teamName = selectedTeam.value?.tName ?? 'Unknown Team';

    // Check if player already exists in the selected team
    bool playerExistsInTeam = await DatabaseHelper.isPlayerExistsInTeam(
      playerName,
      teamId,
    );
    if (playerExistsInTeam) {
      Get.snackbar(
        'Error',
        'Player "$playerName" already exists in team "$teamName"',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(12),
        borderRadius: 8,
        duration: Duration(seconds: 3),
      );
      return false;
    }

    // Check if jersey number already exists in the selected team
    bool jerseyExistsInTeam = await DatabaseHelper.isJerseyNumberExistsInTeam(
      jerseyNumber,
      teamId,
    );
    if (jerseyExistsInTeam) {
      Get.snackbar(
        'Error',
        'Jersey number $jerseyNumber is already taken in team "$teamName".\nPlease choose a different number.',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(12),
        borderRadius: 8,
        duration: Duration(seconds: 4),
      );
      return false;
    }

    return true;
  }

  void _clearForm() {
    playerNameController.clear();
    jerseyNumberController.clear();
    positionController.clear();
    selectedImagePath.value = '';
    selectedTeam.value = null;
  }

  void resetForCreateScreen() {
    _clearForm();
    // Refresh teams when resetting for create screen
    loadAllTeams();
    // ignore: invalid_use_of_protected_member
    if (!playerNameController.hasListeners) {
      _initializeControllers();
    }
  }

  String get teamDisplayText {
    return selectedTeam.value == null
        ? '- Select Team -'
        : selectedTeam.value!.tName;
  }

  @override
  void onClose() {
    try {
      playerNameController.dispose();
      jerseyNumberController.dispose();
      positionController.dispose();
    } catch (e) {
      print('Error disposing controllers: $e');
    }
    super.onClose();
  }
}
