class VetList {
  final List<Vet> vets;

  VetList({
    required this.vets,
  });

  factory VetList.fromJson(Map<String, dynamic> parsedJson) {

    Iterable list = parsedJson['vetList'];

    List<Vet> vets = list.map((i) =>
        Vet.fromJson(i)).toList();

    return new VetList(
        vets: vets
    );
  }
}


class Vet {
  final int id;
  final String firstName;
  final String lastName;

  Vet({
    required this.id,
    required this.firstName,
    required this.lastName});

  factory Vet.fromJson(Map<String, dynamic> json) => Vet(
    id: json['id'],
    firstName: json['firstName'],
    lastName: json['lastName'],
  );

}