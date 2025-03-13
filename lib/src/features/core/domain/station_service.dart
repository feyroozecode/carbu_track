

class StationService {
  String name;
  String company;
  String? adresse;
  String lat;
  String lng;

  StationService({
    required this.name,
    required this.company,
    this.adresse,
    required this.lat,
    required this.lng
  });
}