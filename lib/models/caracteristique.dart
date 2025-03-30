class Caracteristique {
  final int _id;
  final String _carac;

  const Caracteristique(this._id, this._carac);

  String get carac => _carac;

  int get id => _id;

  String getGlobalLabet() => _carac;
  int getGlobalId() => _id;

}