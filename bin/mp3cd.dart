import 'dart:io';

import 'package:args/args.dart';
import 'package:mp3cd/mp3cd.dart';
import 'package:mp3cd/src/model/mode.dart';
import 'package:mp3cd/src/model/profile.dart';

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
      'input',
      abbr: 'i',
      help: 'Input file.',
      mandatory: true,
    )
    ..addOption(
      'output',
      abbr: 'o',
      help: 'Output file. Automatic if null.',
    )
    ..addMultiOption(
      'converters',
      abbr: 'c',
      help: 'Converters to apply.',
      allowed: Profile.values.map((p) => p.name),
    )
    ..addOption(
      'mode',
      abbr: 'm',
      help: 'Mode of operation.',
      mandatory: true,
      allowed: Mode.values.map((m) => m.name),
    );

  return argParser;
}

Future<void> main(List<String> arguments) async {
  final argParser = _getArgParser();
  final results = argParser.parse(arguments);

  try {
    final input = results['input'] as String;
    final output = results['output'] as String?;
    final converterNames = results['converters'] as List<String>;
    final modeName = results['mode'] as String;

    final converters = converterNames
        .map(
          (name) => Profile.values.singleWhere((p) => p.name == name),
        )
        .toList();
    final mode = Mode.values.singleWhere((m) => m.name == modeName);

    final mp3cd = Mp3cd(
      input: File(input),
      output: (output != null) ? File(output) : null,
      profiles: converters,
      mode: mode,
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
