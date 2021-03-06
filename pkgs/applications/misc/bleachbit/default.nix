{ stdenv
, pythonPackages
, fetchurl
, gettext
, gobject-introspection
, wrapGAppsHook
, glib
, gtk3
, libnotify
}:

pythonPackages.buildPythonApplication rec {
  pname = "bleachbit";
  version = "3.2.0";

  format = "other";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "1sszpn7ifiry0wwmkzdppzh61zvgrfypm9g7wk6q1ya20qhb5b51";
  };

  nativeBuildInputs = [
    gettext
    gobject-introspection
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    libnotify
  ];

  propagatedBuildInputs = with pythonPackages; [
    chardet
    pygobject3
    requests
    scandir
  ];

  # Patch the many hardcoded uses of /usr/share/ and /usr/bin
  postPatch = ''
    find -type f -exec sed -i -e 's@/usr/share@${placeholder "out"}/share@g' {} \;
    find -type f -exec sed -i -e 's@/usr/bin@${placeholder "out"}/bin@g' {} \;
  '';

  dontBuild = true;

  installFlags = [
    "prefix=${placeholder "out"}"
  ];

  strictDeps = false;

  meta = with stdenv.lib; {
    homepage = http://bleachbit.sourceforge.net;
    description = "A program to clean your computer";
    longDescription = "BleachBit helps you easily clean your computer to free space and maintain privacy.";
    license = licenses.gpl3;
    maintainers = with maintainers; [ leonardoce ];
  };
}
