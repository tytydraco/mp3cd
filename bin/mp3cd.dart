import 'dart:io';

import 'package:args/args.dart';
import 'package:mp3cd/mp3cd.dart';

ArgParser _getArgParser() {
  final argParser = ArgParser();
  argParser
    ..addFlag(
      'help',
      abbr: 'h',
      help: 'Show usage.',
      callback: (value) {
        if (value) {
          stdout.writeln(argParser.usage);
          exit(0);
        }
      },
    )
    ..addOption(
      'yp3-bin',
      abbr: 'Y',
      help: 'Path to YP3-patched ffmpeg binary.',
      defaultsTo: 'ffmpeg-yp3',
    )
    ..addOption(
      'input',
      abbr: 'i',
      help: 'Input file or directory.',
      mandatory: true,
    )
    ..addOption(
      'output',
      abbr: 'o',
      help: 'Output file or directory.',
      mandatory: true,
    )
    ..addMultiOption(
      'converters',
      abbr: 'c',
      help: 'Converters to apply.',
    );

  return argParser;
}

Future<void> main(List<String> arguments) async {
  final argParser = _getArgParser();
  final results = argParser.parse(arguments);

  try {
    final yp3Bin = results['yp3-bin'] as String?;
    final input = results['input'] as String;
    final output = results['output'] as String;
    final converters = results['converters'] as List<String>;

    final mp3cd = Mp3cd(
      yp3Bin: yp3Bin,
      input: input,
      output: output,
      converters: converters,
    );

    await mp3cd.convert();
  } on Exception catch (e) {
    stderr
      ..writeln('Failed to parse arguments.')
      ..writeln(e)
      ..writeln(argParser.usage);
    exit(1);
  }
}
