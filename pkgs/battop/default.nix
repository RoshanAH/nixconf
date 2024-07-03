{ rustPlatform
, fetchFromGitHub
} : rustPlatform.buildPackage rec {
    pname = "battop";
    version = "0.2.4";
    src = fetchFromGitHub {
        owner = "svartalf";
        repo = pname;
        rev = version;
        hash = "";
    };
    cargoHash = "";
}
