{ lib, pkgs, fetchurl, mkYarnPackage, makeWrapper, nodejs, git }:

mkYarnPackage rec {
  name = "incus-ui";
  pname = "incus-ui";
  version = "0.6";
  buildInputs = [ git ];
  src = fetchurl {
    url = "https://github.com/canonical/lxd-ui/archive/refs/tags/0.6.tar.gz";
    sha256 = "sha256-QnNJshX+HPMU1beV5szBOeGRMn7EH0c7UX7yx4APEoI=";
  };
  patches = [ 
    (pkgs.fetchpatch { url = "https://raw.githubusercontent.com/zabbly/incus/8bbe23f42beedd845bd95069c06f4d0c85e450b6/patches/ui-canonical-0001-Branding.patch"; hash = "sha256-H6ssutdSgxYX1h5/dQ89TSFhioAombvLzXwm5qXw7W0="; }) 
    (pkgs.fetchpatch { url = "https://raw.githubusercontent.com/zabbly/incus/8bbe23f42beedd845bd95069c06f4d0c85e450b6/patches/ui-canonical-0002-Update-navigation.patch"; hash = "sha256-wLylkjmA+gGM39o3ko2hRfcwHh0uYnDQ/NlQU6s2JO8"; }) 
    (pkgs.fetchpatch { url = "https://raw.githubusercontent.com/zabbly/incus/8bbe23f42beedd845bd95069c06f4d0c85e450b6/patches/ui-canonical-0003-Update-certificate-generation.patch"; hash = "sha256-jG0G/DL6NasjGliQj6RLSjMI3Mww7pGZf49p4C88EyQ="; }) 
    (pkgs.fetchpatch { url = "https://raw.githubusercontent.com/zabbly/incus/8bbe23f42beedd845bd95069c06f4d0c85e450b6/patches/ui-canonical-0004-Remove-external-links.patch"; hash = "sha256-O/9HiR8ICfcjho0Z4s89VaWXZODBtV/9PpVfv+IQxUk="; }) 
    (pkgs.fetchpatch { url = "https://raw.githubusercontent.com/zabbly/incus/8bbe23f42beedd845bd95069c06f4d0c85e450b6/patches/ui-canonical-0005-Remove-Canonical-image-servers.patch"; hash = "sha256-wihZDQ3BNjsGQyuYTeza8qV6lkgQaR7c4emVfYjdLh0="; }) 
    (pkgs.fetchpatch { url = "https://raw.githubusercontent.com/zabbly/incus/8bbe23f42beedd845bd95069c06f4d0c85e450b6/patches/ui-canonical-0006-Remove-version-check.patch"; hash = "sha256-wcMELrX1EjnGuDYFvhgiMKEQA9WhvB4DlGJtGDL6j38="; }) 
  ];

  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;
  yarnNix = ./yarn.nix;

  nativeBuildInputs = [ makeWrapper git ];
  patchPhase = ''
    for p in $patches;
    do
      bash -c  "git apply --reject --whitespace=fix $p; exit 0"
    done
    sed -i "s/LXD/Incus/g" src/*/*.ts* src/*/*/*.ts* src/*/*/*/*.ts*
    sed -i "s/devlxd/guestapi/g" src/*/*.ts* src/*/*/*.ts* src/*/*/*/*.ts*
    sed -i "s/dev\/lxd/dev\/incus/g" src/*/*.ts* src/*/*/*.ts* src/*/*/*/*.ts*
    sed -i "s/lxd_/incus_/g" src/*/*.ts* src/*/*/*.ts* src/*/*/*/*.ts*
    sed -i "s/\"lxd\"/\"incus\"/g" src/*/*.ts* src/*/*/*.ts* src/*/*/*/*.ts*
  '';

  buildPhase = ''
    yarn --offline build
  '';

  postInstall = ''
  '';
  fixupPhase = ''
    mkdir -p $out/opt/incus/ui/
    mv $out/libexec/lxd-ui/deps/lxd-ui/build/ui/* $out/opt/incus/ui/
    rm -rf $out/libexec
    rm -rf $out/bin
  '';

  doDist = false;

  meta = with lib; {
    description = "Web UI for Incus/LXD by Canonical";
    homepage = "https://github.com/canonical/lxd-ui";
    platforms = platforms.all;
  };
}
