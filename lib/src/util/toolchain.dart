import 'dart:convert';
import 'dart:io';

/// Toolchain for required binaries.
class Toolchain {
  /// Creates a new [Toolchain].
  const Toolchain({
    this.binPathFfmpeg = 'ffmpeg',
    this.binPathFfprobe = 'ffprobe',
    this.binPathFfmpegYp3Patch = 'ffmpeg-yp3-patch',
    this.binPathImageMagick = 'convert',
    this.binPathEbookConvert = 'ebook-convert',
    this.binPathMp4box = 'MP4Box',
  });

  /// Binary path for FFmpeg.
  final String binPathFfmpeg;

  /// Binary path for FFprobe.
  final String binPathFfprobe;

  /// Binary path for FFmpeg with YP3 x264 patch.
  final String binPathFfmpegYp3Patch;

  /// Binary path for Image Magick convert.
  final String binPathImageMagick;

  /// Binary path for ebook-convert.
  final String binPathEbookConvert;

  /// Binary path for MP4Box.
  final String binPathMp4box;

  /// Run a process and return the exit code. Write to [stdout] and [stderr].
  Future<ProcessResult> run(
    String executable,
    List<String> args,
  ) async {
    final process = await Process.start(executable, args);

    final stdoutBuffer = StringBuffer();
    final stderrBuffer = StringBuffer();

    final stdoutFuture = process.stdout.transform(utf8.decoder).listen((data) {
      stdout.write(data);
      stdoutBuffer.write(data);
    }).asFuture<dynamic>();

    final stderrFuture = process.stderr.transform(utf8.decoder).listen((data) {
      stderr.write(data);
      stderrBuffer.write(data);
    }).asFuture<dynamic>();

    final exitCode = await process.exitCode;

    await Future.wait([stdoutFuture, stderrFuture]);

    return ProcessResult(
      process.pid,
      exitCode,
      stdoutBuffer.toString(),
      stderrBuffer.toString(),
    );
  }

  /// FFmpeg.
  Future<ProcessResult> ffmpeg(List<String> args) => run(binPathFfmpeg, args);

  /// FFprobe.
  Future<ProcessResult> ffprobe(List<String> args) => run(binPathFfprobe, args);

  /// FFmpeg with YP3 x264 patch.
  Future<ProcessResult> ffmpegYp3Patch(List<String> args) =>
      run(binPathFfmpegYp3Patch, args);

  /// Image Magick convert.
  Future<ProcessResult> imageMagick(List<String> args) =>
      run(binPathImageMagick, args);

  /// Calibre ebook-convert.
  Future<ProcessResult> ebookConvert(List<String> args) =>
      run(binPathEbookConvert, args);

  /// MP4Box.
  Future<ProcessResult> mp4Box(List<String> args) => run(binPathMp4box, args);
}
