import 'dart:io';

import 'package:mp3cd/src/util/toolchain.dart';

/// Converter profile base.
abstract class Converter {
  /// Creates a new [Converter].
  Converter({
    required this.inputFile,
    this.outputFile,
    this.toolchain = const Toolchain(),
  });

  /// The input file.
  final File inputFile;

  /// The output file.
  final File? outputFile;

  /// Toolchain for required binaries.
  final Toolchain toolchain;

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
