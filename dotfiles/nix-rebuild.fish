pushd ~/.nixos/; or return
alejandra . &>/dev/null; or return
git diff -U0; or return
echo "NixOS Rebuilding..."; or return

sudo nixos-rebuild switch --flake ~/.nixos 2>&1 | tee nix-rebuild.log
if test $status -ne 0
  cat nixos-switch.log | grep --color error
  return
end

git commit -va; or return
git push; or return
popd; or return
dunstify "NixOS Rebuild OK!"; or return
