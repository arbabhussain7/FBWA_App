import 'package:football_app/data/localDB/db_helper.dart';
import 'package:football_app/model/player_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:football_app/model/team_model.dart';

class TeamController extends GetxController {
  var teamName = ''.obs;
  var userEnteredLeague = ''.obs;
  var teamImage = ''.obs;

  var allTeams = <Team>[].obs;
  var isLoading = false.obs;

  var totalTeamsCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllTeams();
  }

  Future<void> loadAllTeams() async {
    try {
      isLoading.value = true;
      List<Team> teams = await DatabaseHelper.getAllTeams();
      allTeams.value = teams;
      totalTeamsCount.value = teams.length;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load teams: $e');
      totalTeamsCount.value = 0;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateTeamsCount() async {
    try {
      var allTeamsData = await DatabaseHelper.getAllTeams();
      totalTeamsCount.value = allTeamsData.length;
    } catch (e) {
      print('Error getting teams count: $e');
      totalTeamsCount.value = 0;
    }
  }

  Future<void> deleteTeam(int teamId) async {
    try {
      await DatabaseHelper.deleteTeam(teamId);
      Get.snackbar('Success', 'Team deleted successfully!');
      await loadAllTeams();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete team: $e');
    }
  }

  // Add method to get players for a specific team
  Future<List<Player>> getTeamPlayers(int teamId) async {
    try {
      List<Player> allPlayers = await DatabaseHelper.getAllPlayers();
      return allPlayers.where((player) => player.teamId == teamId).toList();
    } catch (e) {
      print('Error getting team players: $e');
      return [];
    }
  }

  // Add method to get team by ID
  Future<Team?> getTeamById(int teamId) async {
    try {
      return await DatabaseHelper.getTeamById(teamId);
    } catch (e) {
      print('Error getting team by ID: $e');
      return null;
    }
  }

  void setTeamName(String name) {
    teamName.value = name;
  }

  void setUserEnteredLeague(String league) {
    userEnteredLeague.value = league;
  }

  void setTeamImage(String imagePath) {
    teamImage.value = imagePath;
  }

  bool isFormValid() {
    return teamName.value.isNotEmpty && userEnteredLeague.value.isNotEmpty;
  }

  Future<bool> saveTeam() async {
    if (!isFormValid()) {
      Get.snackbar(
        'Error',
        'Please fill all required fields',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(12),
        borderRadius: 8,
      );
      return false;
    }

    try {
      final team = Team(
        tName: teamName.value,
        tLeagues: userEnteredLeague.value,
        tImg: teamImage.value.isNotEmpty ? teamImage.value : null,
      );

      await DatabaseHelper.insertTeam(team);
      Get.snackbar(
        'Success',
        'Team created successfully!',
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(12),
        borderRadius: 8,
        duration: Duration(seconds: 2),
      );

      resetForm();
      await loadAllTeams();
      return true;
    } catch (e) {
      // Handle specific error cases
      if (e.toString().contains('Team name already exists')) {
        Get.snackbar(
          'Error',
          'Team name "${teamName.value}" already exists. Please choose a different name.',
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
          'Failed to create team. Please try again.',
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(12),
          borderRadius: 8,
        );
      }
      print('Error creating team: $e'); // For debugging
      return false;
    }
  }

  Future<void> refreshTeams() async {
    await loadAllTeams();
  }

  void resetForm() {
    teamName.value = '';
    userEnteredLeague.value = '';
    teamImage.value = '';
  }

  String get formattedTotalCount {
    return totalTeamsCount.value.toString().padLeft(2, '0');
  }
}
