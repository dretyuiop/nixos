{ lib,
  stdenvNoCC,
  fetchFromGitHub,
  gitUpdater
}:

stdenvNoCC.mkDerivation rec {
  pname = "lavanda-kvantum";
  version = "unstable-2023-03-29";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "Lavanda-kde";
    rev = "c820cb5aebc4061d3d373ac891b21995e0c3e1d8";
    sha256 = "sha256-i00qcaev+NI3NacY+r0D3p0k/rfrAbyxmPj04nzqga8=";
  };

  preInstall = ''
    mkdir -p $out/share/Kvantum
  '';

  installPhase = ''
    runHook preInstall

    cp -a Kvantum/* $out/share/Kvantum/
    sed -i "/translucent_windows/s/true/false/" $out/share/Kvantum/LavandaSea/LavandaSeaDark.kvconfig
    sed -i "/blurring/s/true/false/" $out/share/Kvantum/LavandaSea/LavandaSeaDark.kvconfig
    sed -i "/[Focus]/{n;n;s/frame=false/frame=true/}" $out/share/Kvantum/LavandaSea/LavandaSeaDark.kvconfig

    runHook postInstall
  '';

  meta = with lib; {
    description = "Lavanda kvantum theme";
    homepage = "https://github.com/vinceliuice/Lavanda-kde";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.dretyuiop ];
  };
}
