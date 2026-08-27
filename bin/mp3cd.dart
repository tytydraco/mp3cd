import 'dart:io';

import 'package:args/args.dart';
import 'package:mp3cd/mp3cd.dart';

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
    )
    ..addSeparator('Toolchain')
    ..addOption(
      'bin-ffmpeg',
      help: 'Binary path for FFmpeg.',
      defaultsTo: Toolchain.defaultBinPathFfmpeg,
    )
    ..addOption(
      'bin-ffprobe',
      help: 'Binary path for FFprobe.',
      defaultsTo: Toolchain.defaultBinPathFfprobe,
    )
    ..addOption(
      'bin-ffmpeg-yp3-patch',
      help: 'Binary path for FFmpeg with YP3 x264 patch.',
      defaultsTo: Toolchain.defaultBinPathFfmpegYp3Patch,
    )
    ..addOption(
      'bin-image-magick',
      help: 'Binary path for Image Magick convert.',
      defaultsTo: Toolchain.defaultBinPathImageMagick,
    )
    ..addOption(
      'bin-ebook-convert',
      help: 'Binary path for ebook-convert.',
      defaultsTo: Toolchain.defaultBinPathEbookConvert,
    )
    ..addOption(
      'bin-mp4box',
      help: 'Binary path for MP4Box.',
      defaultsTo: Toolchain.defaultBinPathMp4box,
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

  final binFfmpeg = results['bin-ffmpeg'] as String?;
  final binFfprobe = results['bin-ffprobe'] as String?;
  final binFfmpegYp3Patch = results['bin-ffmpeg-yp3-patch'] as String?;
  final binImageMagick = results['bin-image-magick'] as String?;
  final binEbookConvert = results['bin-ebook-convert'] as String?;
  final binMp4box = results['bin-mp4box'] as String?;

  final inputFile = File(input);
  if (!inputFile.existsSync()) {
    stderr.writeln('Input file not found.');
    exit(1);
  }

  final toolchain = Toolchain(
    binPathFfmpeg: binFfmpeg ?? Toolchain.defaultBinPathFfmpeg,
    binPathFfprobe: binFfprobe ?? Toolchain.defaultBinPathFfprobe,
    binPathFfmpegYp3Patch:
        binFfmpegYp3Patch ?? Toolchain.defaultBinPathFfmpegYp3Patch,
    binPathImageMagick: binImageMagick ?? Toolchain.defaultBinPathImageMagick,
    binPathEbookConvert:
        binEbookConvert ?? Toolchain.defaultBinPathEbookConvert,
    binPathMp4box: binMp4box ?? Toolchain.defaultBinPathMp4box,
  );

  return Mp3cd(
    input: inputFile,
    output: (output != null) ? File(output) : null,
    profiles: converters,
    mode: mode,
    toolchain: toolchain,
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
