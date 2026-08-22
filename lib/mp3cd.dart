import 'dart:io';

import 'package:mp3cd/src/model/converter.dart';
import 'package:mp3cd/src/model/mode.dart';
import 'package:mp3cd/src/model/profile.dart';
import 'package:mp3cd/src/profiles/uid0001.dart';
import 'package:mp3cd/src/profiles/uid0002.dart';
import 'package:mp3cd/src/profiles/uid0003.dart';
import 'package:mp3cd/src/profiles/uid0004.dart';
import 'package:mp3cd/src/profiles/uid0005.dart';
import 'package:mp3cd/src/profiles/uid0007.dart';
import 'package:mp3cd/src/profiles/uid0008.dart';
import 'package:mp3cd/src/profiles/uid0009.dart';
import 'package:mp3cd/src/profiles/uid0010.dart';
import 'package:mp3cd/src/profiles/uid0011.dart';
import 'package:mp3cd/src/profiles/uid0013.dart';
import 'package:mp3cd/src/profiles/uid0014.dart';
import 'package:mp3cd/src/profiles/uid0016.dart';
import 'package:mp3cd/src/profiles/uid0017.dart';
import 'package:mp3cd/src/profiles/uid0018.dart';
import 'package:mp3cd/src/profiles/uid0019.dart';

/// MP3c.
class Mp3cd {
  /// Creates a new [Mp3cd].
  Mp3cd({
    required this.input,
    required this.output,
    required this.profiles,
    required this.mode,
  });

  /// Input file.
  final File input;

  /// Output file.
  final File? output;

  /// List of converter profiles.
  final List<Profile> profiles;

  /// Mode of operation.
  final Mode mode;

  Converter _makeConverter(Profile profile) {
    switch (profile) {
      case Profile.uid0001:
        return Uid0001(inputFile: input, outputFile: output);
      case Profile.uid0002:
        return Uid0002(inputFile: input, outputFile: output);
      case Profile.uid0003:
        return Uid0003(inputFile: input, outputFile: output);
      case Profile.uid0004:
        return Uid0004(inputFile: input, outputFile: output);
      case Profile.uid0005:
        return Uid0005(inputFile: input, outputFile: output);
      case Profile.uid0007:
        return Uid0007(inputFile: input, outputFile: output);
      case Profile.uid0008:
        return Uid0008(inputFile: input, outputFile: output);
      case Profile.uid0009:
        return Uid0009(inputFile: input, outputFile: output);
      case Profile.uid0010:
        return Uid0010(inputFile: input, outputFile: output);
      case Profile.uid0011:
        return Uid0011(inputFile: input, outputFile: output);
      case Profile.uid0013:
        return Uid0013(inputFile: input, outputFile: output);
      case Profile.uid0014:
        return Uid0014(inputFile: input, outputFile: output);
      case Profile.uid0016:
        return Uid0016(inputFile: input, outputFile: output);
      case Profile.uid0017:
        return Uid0017(inputFile: input, outputFile: output);
      case Profile.uid0018:
        return Uid0018(inputFile: input, outputFile: output);
      case Profile.uid0019:
        return Uid0019(inputFile: input, outputFile: output);
    }
  }

  /// Begin conversions.
  Future<void> convert() async {
    for (final profile in profiles) {
      final converter = _makeConverter(profile);
      switch (mode) {
        case Mode.audio:
          await converter.audio();
        case Mode.image:
          await converter.image();
        case Mode.text:
          await converter.text();
        case Mode.video:
          await converter.video();
      }
    }
  }
}
