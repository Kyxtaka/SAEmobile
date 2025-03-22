class TypeCuisine {
  final int _idType;
  final String _cuisine;

  const TypeCuisine(
      this._idType,
      this._cuisine);

  int get idType => _idType;

  String get cuisine => _cuisine;

  void debugPrint() {
    String typeCuisine = "idType: $_idType, cuisine: $_cuisine";
    print(typeCuisine);
  }

  Map<String, Object?> toMapLocal() {
    return {
      'idType': _idType,
      'cuisine': _cuisine,
    };
  }
}