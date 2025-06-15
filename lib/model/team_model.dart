class Team {
  int? sNo;
  String tName;
  String? tLeagues;
  String tClub;
  String? tImg;

  Team({
    this.sNo,
    required this.tName,
    this.tLeagues,
    required this.tClub,
    this.tImg,
  });

  Map<String, dynamic> toMap() {
    return {
      's_no': sNo,
      't_name': tName,
      't_leagues': tLeagues,
      't_club': tClub,
      't_img': tImg,
    };
  }

  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      sNo: map['s_no'],
      tName: map['t_name'] ?? '',
      tLeagues: map['t_leagues'],
      tClub: map['t_club'] ?? '',
      tImg: map['t_img'],
    );
  }
}
