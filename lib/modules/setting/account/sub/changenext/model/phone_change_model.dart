enum PhoneChangeStep { first, second }

class PhoneChangeModel {
  PhoneChangeModel({required this.step, required this.code});

  final PhoneChangeStep step;
  final String code;
}
