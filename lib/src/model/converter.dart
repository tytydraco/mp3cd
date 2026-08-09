import 'dart:io';

/// Converter profile base.
abstract class Converter {
  /// Creates a new [Converter].
  Converter({
    required this.inputFile,
    required this.outputFile,
  });

  /// The input file.
  final File inputFile;

  /// The output file.
  final File outputFile;

  /// Convert the file.
  Future<void> convert();
}
