{
  fetchFromGitHub,
  gitUpdater,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation rec {
  pname = "twilight-kde-theme";
  version = "unstable-2023-03-10";

  src = fetchFromGitHub {
    owner = "yeyushengfan258";
    repo = "Twilight-kde";
    rev = "a5fc50a040693a53472d83d2d47e964d2cf2bcd3";
    hash = "sha256-b9//jWOD9TPOBPIDl/66j6wsWvo82h6wsee0JoQcBD0=";
  };

  postPatch = ''
    patchShebangs install.sh

    substituteInPlace install.sh \
      --replace '$HOME/.local' $out \
      --replace '$HOME/.config' $out/share
  '';

  installPhase = ''
    runHook preInstall

    bash ./install.sh

    mkdir -p $out/share/sddm/themes
    cp -a sddm-dark/Twilight-dark $out/share/sddm/themes/

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Twilight kde is a light clean theme for KDE Plasma desktop.";
    homepage = "https://github.com/yeyushengfan258/Twilight-kde";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ dretyuiop ];
  };
}
