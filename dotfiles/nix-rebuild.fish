pushd ~/.nixos/; or return
alejandra . &>/dev/null; or return
git diff -U0; or return
echo "NixOS Rebuilding..."; or return

sudo nixos-rebuild switch --flake ~/.nixos &>nixos-switch.log
if test $status -ne 0
  cat nixos-switch.log | grep --color error
  return
end

git commit -am "$(date --iso-8601=seconds)"; or return
popd; or return
dunstify "NixOS Rebuild OK!"; or return
