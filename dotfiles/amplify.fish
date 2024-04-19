function amplify
  NIXPKGS_ALLOW_UNFREE=1 nix run --impure nixpkgs#steam-run ~/.amplify/bin/amplify $argv
end
