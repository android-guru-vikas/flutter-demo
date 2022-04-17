class Employee {
  final int? id;
  final String name;
  final String role;
  final String doj;

  const Employee({
    this.id,
    required this.name,
    required this.role,
    required this.doj,
  });

  Map<String, dynamic> toMap() {
    return {
     // 'id': id,
      'name': name,
      'role': role,
      'doj':doj
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Dog{id: $id, name: $name, role: $role, doj:$doj}';
  }
}