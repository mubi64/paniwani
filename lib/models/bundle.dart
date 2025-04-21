class Bundle {
  final String id;
  final String name;
  final String description;
  final double price;
  final bool isActive;

  Bundle({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.isActive = false,
  });
}