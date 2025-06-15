import 'dart:io';
import 'package:flutter/material.dart';
import 'package:football_app/data/localDB/db_helper.dart';
import 'package:football_app/model/player_model.dart';
import 'package:football_app/views/player_manage_screen.dart';
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

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    loadPlayers();
  }

  void _initializeControllers() {
    playerNameController = TextEditingController();
    jerseyNumberController = TextEditingController();
    positionController = TextEditingController();
  }

  Future<void> loadPlayers() async {
    try {
      isLoading.value = true;
      players.value = await DatabaseHelper.getAllPlayers();
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
    if (!_validateInputs()) return;
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
      );

      await DatabaseHelper.insertPlayer(newPlayer);

      _clearForm();
      await loadPlayers();
      Get.snackbar('Success', 'Player created successfully!');
      Get.off(() => PlayerManageScreen());
    } catch (e) {
      Get.snackbar('Error', 'Failed to create player: $e');
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateInputs() {
    if (playerNameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter player name');
      return false;
    }

    if (jerseyNumberController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter jersey number');
      return false;
    }

    if (int.tryParse(jerseyNumberController.text.trim()) == null) {
      Get.snackbar('Error', 'Please enter valid jersey number');
      return false;
    }

    if (positionController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter player position');
      return false;
    }

    return true;
  }

  void _clearForm() {
    playerNameController.clear();
    jerseyNumberController.clear();
    positionController.clear();
    selectedImagePath.value = '';
  }

  void resetForCreateScreen() {
    _clearForm();
    // ignore: invalid_use_of_protected_member
    if (!playerNameController.hasListeners) {
      _initializeControllers();
    }
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
