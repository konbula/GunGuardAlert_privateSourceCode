class shooting {
  String incidentID;
  String incidentDate;
  String state;
  String cityOrCounty;
  String address;
  String killed;
  String injured;
  shooting({
    required this.incidentID,
    required this.incidentDate,
    required this.state,
    required this.cityOrCounty,
    required this.address,
    required this.killed,
    required this.injured,
  });
}

List<shooting> addShootings(List shootingsList) {
  List<shooting> shootings = [];
  if (shootingsList.length < 6) {
    return shootings;
  } else {
    for (var i = 0; i < ((shootingsList.length + 1) / 7); i++) {
      shootings.insert(
          0,
          shooting(
            incidentID: shootingsList[0],
            incidentDate: shootingsList[1],
            state: shootingsList[2],
            cityOrCounty: shootingsList[3],
            address: shootingsList[4],
            killed: shootingsList[5],
            injured: shootingsList[6],
          ));
      shootingsList.removeRange(0, 7);
    }
    return shootings;
  }
}
