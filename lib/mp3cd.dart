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
import 'package:mp3cd/src/util/toolchain.dart';

export 'package:mp3cd/src/model/converter.dart';
export 'package:mp3cd/src/model/mode.dart';
export 'package:mp3cd/src/model/profile.dart';
export 'package:mp3cd/src/profiles/uid0001.dart';
export 'package:mp3cd/src/profiles/uid0002.dart';
export 'package:mp3cd/src/profiles/uid0003.dart';
export 'package:mp3cd/src/profiles/uid0004.dart';
export 'package:mp3cd/src/profiles/uid0005.dart';
export 'package:mp3cd/src/profiles/uid0007.dart';
export 'package:mp3cd/src/profiles/uid0008.dart';
export 'package:mp3cd/src/profiles/uid0009.dart';
export 'package:mp3cd/src/profiles/uid0010.dart';
export 'package:mp3cd/src/profiles/uid0011.dart';
export 'package:mp3cd/src/profiles/uid0013.dart';
export 'package:mp3cd/src/profiles/uid0014.dart';
export 'package:mp3cd/src/profiles/uid0016.dart';
export 'package:mp3cd/src/profiles/uid0017.dart';
export 'package:mp3cd/src/profiles/uid0018.dart';
export 'package:mp3cd/src/profiles/uid0019.dart';
export 'package:mp3cd/src/util/arg_builder.dart';
export 'package:mp3cd/src/util/toolchain.dart';
export 'package:mp3cd/src/util/video_extensions.dart';

/// MP3c.
class Mp3cd {
  /// Creates a new [Mp3cd].
  Mp3cd({
    required this.input,
    required this.output,
    required this.profiles,
    required this.mode,
    this.toolchain = const Toolchain(),
  });

  /// Input file.
  final File input;

  /// Output file.
  final File? output;

  /// List of converter profiles.
  final List<Profile> profiles;

  /// Mode of operation.
  final Mode mode;

  /// Toolchain for required binaries.
  final Toolchain toolchain;

  Converter _makeConverter(Profile profile) {
    return switch (profile) {
      Profile.uid0001 => Uid0001(
        inputFile: input,
        outputFile: output,
        toolchain: toolchain,
      ),
      Profile.uid0002 => Uid0002(
        inputFile: input,
        outputFile: output,
        toolchain: toolchain,
      ),
      Profile.uid0003 => Uid0003(
        inputFile: input,
        outputFile: output,
        toolchain: toolchain,
      ),
      Profile.uid0004 => Uid0004(
        inputFile: input,
        outputFile: output,
        toolchain: toolchain,
      ),
      Profile.uid0005 => Uid0005(
        inputFile: input,
        outputFile: output,
        toolchain: toolchain,
      ),
      Profile.uid0007 => Uid0007(
        inputFile: input,
        outputFile: output,
        toolchain: toolchain,
      ),
      Profile.uid0008 => Uid0008(
        inputFile: input,
        outputFile: output,
        toolchain: toolchain,
      ),
      Profile.uid0009 => Uid0009(
        inputFile: input,
        outputFile: output,
        toolchain: toolchain,
      ),
      Profile.uid0010 => Uid0010(
        inputFile: input,
        outputFile: output,
        toolchain: toolchain,
      ),
      Profile.uid0011 => Uid0011(
        inputFile: input,
        outputFile: output,
        toolchain: toolchain,
      ),
      Profile.uid0013 => Uid0013(
        inputFile: input,
        outputFile: output,
        toolchain: toolchain,
      ),
      Profile.uid0014 => Uid0014(
        inputFile: input,
        outputFile: output,
        toolchain: toolchain,
      ),
      Profile.uid0016 => Uid0016(
        inputFile: input,
        outputFile: output,
        toolchain: toolchain,
      ),
      Profile.uid0017 => Uid0017(
        inputFile: input,
        outputFile: output,
        toolchain: toolchain,
      ),
      Profile.uid0018 => Uid0018(
        inputFile: input,
        outputFile: output,
        toolchain: toolchain,
      ),
      Profile.uid0019 => Uid0019(
        inputFile: input,
        outputFile: output,
        toolchain: toolchain,
      ),
    };
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
