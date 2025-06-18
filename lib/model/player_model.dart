class Player {
  int? sNo;
  String pName;
  int jNumber;
  String pPosition;
  String? pImg;
  int? teamId; // Added team reference
  String? teamName;

  Player({
    this.sNo,
    required this.pName,
    required this.jNumber,
    required this.pPosition,
    this.pImg,
    this.teamId,
    this.teamName, // Add this
  });
  Map<String, dynamic> toMap() {
    return {
      's_no': sNo,
      'p_name': pName,
      'j_number': jNumber,
      'p_position': pPosition,
      'p_img': pImg,
      'team_id': teamId,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      sNo: map['s_no'],
      pName: map['p_name'],
      jNumber: map['j_number'],
      pPosition: map['p_position'],
      pImg: map['p_img'],
      teamId: map['team_id'],
      teamName: map['team_name'], // Add this
    );
  }
}
