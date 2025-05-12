import '../../domain/entities/person.dart';

class PersonModel extends Person {
  PersonModel({
    required int id,
    required String surname,
    required String name,
    required String lastname,
    required String number,
  }) : super(
    id: id,
    surname: surname,
    name: name,
    lastname: lastname,
    number: number,
  );

  factory PersonModel.fromMap(Map<String, dynamic> map) {
    return PersonModel(
      id: map['id'],
      surname: map['surname'],
      name: map['name'],
      lastname: map['lastname'],
      number: map['number'],
    );
  }
}
