/// Argument list builder.
class ArgBuilder {
  /// Argument list.
  final List<String> args = [];

  /// Add a single argument.
  void single(Object arg) => args.add(arg.toString());

  /// Add an argument pair.
  void pair(Object arg1, Object arg2) => args.addAll([
    arg1.toString(),
    arg2.toString(),
  ]);

  @override
  String toString() => args.join(' ');
}
