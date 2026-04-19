{
	lib,
	stdenvNoCC,
	fetchurl,
	autoPatchelfHook,
	makeWrapper,
	copyDesktopItems,
	makeDesktopItem,
	glib,
	gtk3,
	nss,
	nspr,
	atk,
	at-spi2-atk,
	cairo,
	pango,
	gdk-pixbuf,
	dbus,
	cups,
	libX11,
	libXcomposite,
	libXdamage,
	libXext,
	libXfixes,
	libXrandr,
	libxcb,
	libxkbcommon,
	mesa,
	libgbm,
	libdrm,
	vulkan-loader,
	alsa-lib,
	expat,
	udev,
	libGL,
}: let
	runtimeLibs = [
		glib
		gtk3
		nss
		nspr
		atk
		at-spi2-atk
		cairo
		pango
		gdk-pixbuf
		dbus
		cups
		libX11
		libXcomposite
		libXdamage
		libXext
		libXfixes
		libXrandr
		libxcb
		libxkbcommon
		mesa
		libgbm
		libdrm
		vulkan-loader
		alsa-lib
		expat
		udev
		libGL
	];
in
stdenvNoCC.mkDerivation {
	pname = "apifox";
	version = "latest-manual";

	src = fetchurl {
		url = "https://file-assets.apifox.com/download/Apifox-linux-manual-latest.tar.gz";
		hash = "sha256-HKq075iNMYfUOCIZb2H13YfBpKuwG+Yk1IifaFGgkIQ=";
	};

	nativeBuildInputs = [
		autoPatchelfHook
		makeWrapper
		copyDesktopItems
	];

	buildInputs = runtimeLibs;

	desktopItems = [
		(makeDesktopItem {
			name = "apifox";
			desktopName = "Apifox";
			comment = "API Design, Debugging and Testing";
			exec = "apifox %U";
			icon = "apifox";
			categories = [
				"Development"
				"Network"
			];
			startupWMClass = "Apifox";
			terminal = false;
		})
	];

	installPhase = ''
		runHook preInstall

		mkdir -p $out/opt/apifox $out/bin
		cp -r ./* $out/opt/apifox/

		chmod +x $out/opt/apifox/apifox

		makeWrapper $out/opt/apifox/apifox $out/bin/apifox \
			--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeLibs} \
			--unset ELECTRON_OZONE_PLATFORM_HINT \
			--add-flags "--no-sandbox"

		if [ -f "$out/opt/apifox/resources/app.asar.unpacked/dist/assets/logo.png" ]; then
			mkdir -p $out/share/icons/hicolor/512x512/apps
			cp $out/opt/apifox/resources/app.asar.unpacked/dist/assets/logo.png \
				$out/share/icons/hicolor/512x512/apps/apifox.png
		fi

		runHook postInstall
	'';

	autoPatchelfIgnoreMissingDeps = [ "*" ];

	meta = with lib; {
		description = "Apifox desktop client";
		homepage = "https://apifox.com";
		sourceProvenance = [ sourceTypes.binaryNativeCode ];
		license = licenses.unfree;
		platforms = [ "x86_64-linux" ];
		mainProgram = "apifox";
		maintainers = [ ];
	};
}