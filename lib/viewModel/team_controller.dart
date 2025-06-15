import 'package:football_app/data/localDB/db_helper.dart';
import 'package:get/get.dart';
import 'package:football_app/model/team_model.dart';

class TeamController extends GetxController {
  var teamName = ''.obs;
  var userEnteredLeague = ''.obs;
  var selectedClub = ''.obs;
  var teamImage = ''.obs;

  var selectedClubIndex = (-1).obs;

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

  void setTeamName(String name) {
    teamName.value = name;
  }

  void setUserEnteredLeague(String league) {
    userEnteredLeague.value = league;
  }

  void setClub(String club, int index) {
    selectedClub.value = club;
    selectedClubIndex.value = index;
  }

  void setTeamImage(String imagePath) {
    teamImage.value = imagePath;
  }

  bool isFormValid() {
    return teamName.value.isNotEmpty &&
        userEnteredLeague.value.isNotEmpty &&
        selectedClub.value.isNotEmpty;
  }

  Future<bool> saveTeam() async {
    if (!isFormValid()) {
      Get.snackbar('Error', 'Please fill all required fields');
      return false;
    }

    try {
      final team = Team(
        tName: teamName.value,
        tLeagues: userEnteredLeague.value,
        tClub: selectedClub.value,
        tImg: teamImage.value.isNotEmpty ? teamImage.value : null,
      );

      await DatabaseHelper.insertTeam(team);
      Get.snackbar('Success', 'Team created successfully!');

      resetForm();
      await loadAllTeams();
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to create team: $e');
      return false;
    }
  }

  Future<void> refreshTeams() async {
    await loadAllTeams();
  }

  void resetForm() {
    teamName.value = '';
    userEnteredLeague.value = '';
    selectedClub.value = '';
    teamImage.value = '';
    selectedClubIndex.value = -1;
  }

  String get clubDisplayText {
    return selectedClub.value.isEmpty ? '- Select Club -' : selectedClub.value;
  }

  String get formattedTotalCount {
    return totalTeamsCount.value.toString().padLeft(2, '0');
  }
}
