class TypeCuisine {
  final int _idTypeCuisine;
  final String _cuisine;

  const TypeCuisine(
      this._idTypeCuisine,
      this._cuisine);

  int get id => _idTypeCuisine;

  String get cuisine => _cuisine;

  void debugPrint() {
    String typeCuisine = "idTypeCuisine: $_idTypeCuisine, cuisine: $_cuisine";
    print(typeCuisine);
  }

  Map<String, Object?> toMapLocal() {
    return {
      'idTypeCuisine': _idTypeCuisine,
      'cuisine': _cuisine,
    };
  }
}