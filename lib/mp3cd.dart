import 'dart:io';

import 'package:mp3cd/src/profiles/uid0001.dart';

/// MP3c.
class Mp3cd {
  /// Creates a new [Mp3cd].
  Mp3cd({
    required this.yp3Bin,
    required this.input,
    required this.output,
    required this.converters,
  });

  /// Path to YP3-patch ffmpeg binary.
  final String? yp3Bin;

  /// Input file or directory.
  final String input;

  /// Output file or directory.
  final String output;

  /// List of converter profiles.
  final List<String> converters;

  Future<void> _convertFile(File inputFile, File outputFile) async {
    await Uid0001(inputFile: inputFile, outputFile: outputFile).video();
  }

  /// Begin conversions.
  Future<void> convert() async {
    if (File(input).existsSync()) {
      final inputFile = File(input);
      final outputFile = File(output);

      await _convertFile(inputFile, outputFile);
    } else if (Directory(input).existsSync()) {
      final inputDirectory = Directory(input);
      final outputDirectory = Directory(output);
    } else {
      stderr.writeln('No input file or directory found.');
      exit(1);
    }
  }
}
