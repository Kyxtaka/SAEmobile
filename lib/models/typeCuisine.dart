class TypeCuisine {
  final int _idTypeCuisine;
  final String _cuisine;
  final String _img;

  const TypeCuisine(
      this._idTypeCuisine,
      this._cuisine,
      this._img
  );

  int get id => _idTypeCuisine;

  String get cuisine => _cuisine;

  String get img => _img;

  void debugPrint() {
    String typeCuisine = "idTypeCuisine: $_idTypeCuisine, cuisine: $_cuisine";
    print(typeCuisine);
  }

  Map<String, Object?> toMapLocal() {
    return {
      'idCuisine': _idTypeCuisine,
      'nomCuisine': _cuisine,
      'imgCuisine': _img
    };
  }
}