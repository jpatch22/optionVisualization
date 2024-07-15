class Tuple {
  final int i;
  final int j;

  Tuple(this.i, this.j);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tuple &&
          runtimeType == other.runtimeType &&
          i == other.i &&
          j == other.j;

  @override
  int get hashCode => i.hashCode ^ j.hashCode;
}
