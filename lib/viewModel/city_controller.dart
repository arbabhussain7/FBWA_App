import 'package:get/get.dart';

class CityController extends GetxController {
  var selectedIndex = (-1).obs;
  var selectedCityName = ''.obs;

  void selectCity(int index) {
    selectedIndex.value = index;
  }

  void setSelectedCity(String cityName) {
    selectedCityName.value = cityName;
  }

  void resetSelection() {
    selectedIndex.value = -1;
    selectedCityName.value = '';
  }

  bool get hasSelection => selectedIndex.value != -1;

  String get getSelectedCityName => selectedCityName.value;
}
