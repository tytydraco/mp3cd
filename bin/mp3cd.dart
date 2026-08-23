import 'dart:io';

import 'package:args/args.dart';
import 'package:mp3cd/mp3cd.dart';
import 'package:mp3cd/src/model/mode.dart';
import 'package:mp3cd/src/model/profile.dart';

final ArgParser _argParser = _getArgParser();
late final Mp3cd _mp3cd;

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

Mp3cd _parseMp3cd(List<String> arguments) {
  final results = _argParser.parse(arguments);

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

  return Mp3cd(
    input: File(input),
    output: (output != null) ? File(output) : null,
    profiles: converters,
    mode: mode,
  );
}

Future<void> main(List<String> arguments) async {
  try {
    _mp3cd = _parseMp3cd(arguments);
  } on Object catch (e) {
    stderr
      ..writeln(e)
      ..writeln(_argParser.usage);
    exit(1);
  }

  try {
    await _mp3cd.convert();
  } on Object catch (e) {
    stderr.writeln(e);
    exit(1);
  }
}
