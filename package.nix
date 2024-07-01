{ lib
, pkgs
, buildPythonPackage
, rustPlatform
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "surrealdb";
  version = "git";

  src = fetchFromGitHub {
    owner = "surrealdb";
    repo = "surrealdb.py";
    rev = "ffefd8a2354ff597f6f18115d18fa4eab45d6540";
    sha256 = "sha256-Y+cxFUZvagzw3e/W1L0Gat8Oud6sLnTULhUe/WJZkDM=";
  };

  patches = [
    ./0001-add-Cargo.lock-file.patch
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-jCnzd+ZbMss8nK/TBeV1N0dfZHt/gZpb4O+l3b1nTaQ=";
    patches = [ ./0001-add-Cargo.lock-file.patch ];
  };

  format = "pyproject";

  pythonImportsCheck = [
    "surrealdb"
    "surrealdb.execution_mixins"
    "surrealdb.async_execution_mixins"
  ];

  postInstall = ''
    cp -R surrealdb $out/${pkgs.python3.sitePackages}/
    mv $out/${pkgs.python3.sitePackages}/rust_surrealdb $out/${pkgs.python3.sitePackages}/surrealdb/
  '';

  nativeBuildInputs = with rustPlatform; [ cargoSetupHook maturinBuildHook ];
}
