# FBWA ⚽

**Football Bhutan Western Australia**

FBWA is a mobile application designed to manage local football teams and players for Bhutanese communities in Western Australia. It allows users to create and manage their own teams and players, making it easier to organize local leagues, matches, and events.

This app is built using **Flutter** and **Dart**, with **GetX** for state management and the **MVVM architecture** pattern. It uses **SQFLite**, a local SQL database, to store and manage data offline.

---

## 🛠️ Features

### ✅ Team Management

* Create and name your football team.
* Upload a **team logo**.
* View and manage a list of teams.

### ✅ Player Management

* Add players to any team.
* Store player details like:

  * Player Name
  * Jersey Number
  * Player Image
* Edit or delete player profiles.

### ✅ League Support

* Add and display custom league names.
* Assign teams to different leagues for match tracking.

### ✅ Offline Storage

* All data is stored locally using **SQFLite** (No internet required).
* Fast read/write performance for real-time updates.

---

## 📲 Technologies Used

| Technology | Purpose                        |
| ---------- | ------------------------------ |
| Flutter    | Cross-platform app development |
| Dart       | Programming language           |
| GetX       | State management & navigation  |
| MVVM       | Clean app structure            |
| SQFLite    | Local SQL database (offline)   |

---

## 📸 Screenshots (Add your screenshots here)

```
📷 ![Team List](link-to-your-screenshot)
📷 ![Add Player](link-to-your-screenshot)
📷 ![Upload Logo](link-to-your-screenshot)
```

---

## 📁 Project Structure

```
lib/
│
├── models/         # Data models for teams and players
├── views/          # UI screens (Team list, Player form, etc.)
├── viewModel/      # GetX controllers for logic and data flow
├── data/Db_helper  # Local DB helper using SQFLite
├── constants/      # App constants and utilities
├── main.dart       # Entry point
```

---

## 🚀 Getting Started

### 🔧 Prerequisites

* Flutter SDK
* Android Studio / VS Code

### 🧰 Installation

1. **Clone the Repository**

```bash
git clone https://github.com/your-username/FBWA.git
cd FBWA
```

2. **Install Dependencies**

```bash
flutter pub get
```

3. **Run the App**

```bash
flutter run
```

---

## ✅ Future Improvements

* Multi-language support (Dzongkha & English)
* Export/import data (cloud backup)
* Match scheduling & score tracking
* Dark mode UI

---

## 📄 License

This project is licensed under the **MIT License** – see the [LICENSE](LICENSE) file for details.

---

## 👤 Author

**Arbab Hussain**
Flutter Developer | [LinkedIn](https://www.linkedin.com/in/arbabhussain)
Email Arbab Hussain | [arbabhussain414@gmail.com](arbabhussain414@gmail.com)
