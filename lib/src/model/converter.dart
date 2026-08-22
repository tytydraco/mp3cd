import 'dart:io';

/// Converter profile base.
abstract class Converter {
  /// Creates a new [Converter].
  Converter({
    required this.inputFile,
    this.outputFile,
  });

  /// The input file.
  final File inputFile;

  /// The output file.
  final File? outputFile;

  /// The converter ID.
  abstract final String id;

  /// Convert a video.
  Future<void> audio();

  /// Convert a video.
  Future<void> image();

  /// Convert a video.
  Future<void> text();

  /// Convert a video.
  Future<void> video();
}
