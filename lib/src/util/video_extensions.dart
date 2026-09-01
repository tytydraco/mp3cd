import 'dart:io';

import 'package:mp3cd/src/util/arg_builder.dart';
import 'package:mp3cd/src/util/toolchain.dart';
import 'package:path/path.dart';

/// Video extension functions on [File].
extension VideoExtensionsFile on File {
  /// Perform in-place MP4Box interlacing.
  Future<void> mp4Box(Toolchain toolchain) async {
    final argBuilder = ArgBuilder()
      ..pair('-inter', 1)
      ..pair('-tmp', parent.path)
      ..single(path);
    await toolchain.mp4Box(argBuilder.args);
  }

  /// Returns true if there is an audio track.
  Future<bool> hasAudio(Toolchain toolchain) async {
    final argBuilder = ArgBuilder()
      ..pair('-v', 'error')
      ..pair('-select_streams', 'a:0')
      ..pair('-show_entries', 'stream=index')
      ..pair('-of', 'csv=p=0')
      ..single(path);

    final result = await toolchain.ffprobe(argBuilder.args);

    if (result.exitCode != 0) return false;
    return result.stdout.toString().trim().isNotEmpty;
  }

  /// Return the average FPS as a double.
  Future<double?> getAverageFps(Toolchain toolchain) async {
    final argBuilder = ArgBuilder()
      ..pair('-v', 'error')
      ..pair('-select_streams', 'v:0')
      ..pair('-show_entries', 'stream=avg_frame_rate')
      ..pair('-of', 'csv=p=0')
      ..single(path);
    final result = await toolchain.ffprobe(argBuilder.args);

    if (result.exitCode != 0) return null;

    final output = result.stdout.toString();

    final parts = output.split('/');
    if (parts.length == 1) return double.parse(output);

    final numerator = double.parse(parts[0]);
    final denominator = double.parse(parts[1]);

    return numerator / denominator;
  }
}

/// Video extension functions on [num].
extension VideoExtensionsNum on num {
  /// Returns the nearest ceil value for a legal AMV FPS.
  int nearestLegalAMVFps() {
    const legalAmvFps = [
      9,
      10,
      14,
      15,
      18,
      21,
      25,
      30,
      35,
      42,
      45,
      49,
      50,
      63,
      70,
      75,
      90,
      98,
      105,
      126,
      147,
      150,
      175,
      210,
      225,
    ];

    return legalAmvFps.firstWhere(
      (value) => value >= this,
      orElse: () => legalAmvFps.last,
    );
  }

  /// Returns the GOP length based on duration.
  int temporalGop(num seconds) {
    final duration = (this * seconds).round();
    return duration >= 1 ? duration : 1;
  }
}

/// FFmpeg 2-pass helper extension functions on [ArgBuilder].
extension Ffmpeg2PassArgBuilder on ArgBuilder {
  /// Return an [ArgBuilder] set up for pass 1.
  ArgBuilder pass1(Directory passLogDirectory) {
    return clone()
      ..pair('-pass', 1)
      ..pair('-passlogfile', join(passLogDirectory.path, 'log'))
      ..single('-an')
      ..pair('-f', 'null')
      ..single(Platform.isWindows ? 'NUL' : '/dev/null');
  }

  /// Return an [ArgBuilder] set up for pass 2.
  ArgBuilder pass2(Directory passLogDirectory, File outputFile) {
    return clone()
      ..pair('-pass', 2)
      ..pair('-passlogfile', join(passLogDirectory.path, 'log'))
      ..single(outputFile.path);
  }
}
