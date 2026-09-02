{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  makeDesktopItem,
  unzip,
  jdk21,
}:

let
  version = "6.3.5";

  desktopItem = makeDesktopItem {
    name = "tracker";
    exec = "tracker %f";
    icon = "tracker";
    desktopName = "Tracker";
    genericName = "Video Analysis and Modeling Tool";
    comment = "Open Source Physics video analysis and modeling tool";
    categories = [ "Education" "Science" ];
  };

  # tracker_icon_16 lives under a different resource package than the
  # 32/256 variants inside the jar.
  icons = {
    "16" = "org/opensourcephysics/resources/tools/images/tracker_icon_16.png";
    "32" = "org/opensourcephysics/cabrillo/tracker/resources/images/tracker_icon_32.png";
    "256" = "org/opensourcephysics/cabrillo/tracker/resources/images/tracker_icon_256.png";
  };
in
stdenvNoCC.mkDerivation {
  pname = "tracker";
  inherit version;

  src = fetchurl {
    url = "https://opensourcephysics.github.io/tracker-website/archives/tracker-${version}.jar";
    hash = "sha256-O2VfQ3BhOvpcQiTI4uQ10hofH9zCgnSTeJD+uQ4UYNA=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
    unzip
  ];

  installPhase =
    ''
      runHook preInstall

      install -Dm444 "$src" "$out/share/java/tracker.jar"

      # Tracker's own Main-Class (org.opensourcephysics.cabrillo.tracker.Tracker)
      # always relaunches itself as a child `java -jar` process via the bundled
      # TrackerStarter. When TrackerStarter can't find any Xuggle install at all
      # (as here - upstream's video engine isn't packaged), it hits a real
      # upstream bug: TrackerStarter.copyXuggleJarsTo() calls listFiles() on a
      # nonexistent directory, which returns null and NPEs before the relaunch
      # happens, so the GUI never opens. An empty "Xuggle" directory next to the
      # jar makes TrackerStarter.findXuggleHome() resolve to a real (if empty)
      # directory and avoids the crash - verified against the 6.3.5 jar running
      # under Xvfb, including with a read-only install directory. Net effect:
      # everything works except opening video files directly (mp4/avi/mov);
      # image sequences and animated GIFs are unaffected.
      mkdir -p "$out/share/java/Xuggle"
    ''
    + lib.concatStrings (
      lib.mapAttrsToList (size: path: ''
        install -Dm444 <(unzip -p "$src" "${path}") \
          "$out/share/icons/hicolor/${size}x${size}/apps/tracker.png"
      '') icons
    )
    + ''
      install -Dm444 ${desktopItem}/share/applications/tracker.desktop \
        "$out/share/applications/tracker.desktop"

      makeWrapper ${jdk21}/bin/java $out/bin/tracker \
        --add-flags "-jar $out/share/java/tracker.jar"

      runHook postInstall
    '';

  meta = {
    description = "Video analysis and modeling tool for physics education";
    longDescription = ''
      Tracker is a free video analysis and modeling tool built on the Open
      Source Physics (OSP) Java framework, used in physics education to track
      and model the motion of objects in video clips.

      This build packages the upstream prebuilt jar directly rather than
      building from source with ant, and does not bundle the (abandoned,
      awkward to build) Xuggle video engine - so out of the box this package
      supports image-sequence and animated-GIF analysis but not native
      mp4/avi/mov playback. Transcode video to an image sequence first, or see
      https://github.com/NixOS/nixpkgs/issues/140103 for background.
    '';
    homepage = "https://physlets.org/tracker/";
    changelog = "https://opensourcephysics.github.io/tracker-website/help/change_log.txt";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "tracker";
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
  };
}
