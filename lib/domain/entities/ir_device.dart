class IrDevice {
  final int id;
  final String category; // e.g., 'TV', 'AC'
  final String brand;
  final String series;
  final String model;
  final int carrierFrequency;
  final Map<String, List<int>> buttons;

  IrDevice({
    required this.id,
    required this.category,
    required this.brand,
    required this.series,
    required this.model,
    required this.carrierFrequency,
    required this.buttons,
  });
}
