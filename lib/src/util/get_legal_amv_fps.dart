/// Returns the ceiling value for a legal AMV FPS.
int getLegalAmvFps(int fps) {
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
    (value) => value >= fps,
    orElse: () => legalAmvFps.last,
  );
}
