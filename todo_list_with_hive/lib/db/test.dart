import 'dart:developer';

void main(List<String> args) {
  final planets = <num, String>{
    1: 'Mercury',
    2: 'Venus',
    3: 'Earth',
    4: 'Mars'
  };
  final mapFrom = Map<int, String>.from(planets);
  log(mapFrom.toString());
}
