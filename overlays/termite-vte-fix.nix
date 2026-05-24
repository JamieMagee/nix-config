# Workaround for vte build failure caused by termite's vte-ng patches.
# See https://github.com/NixOS/nixpkgs/pull/522768
#
# The patch `vte-0005-expose-function-for-getting-the-selected-text.patch`
# references `vte::to_integral`, which no longer exists on current vte/gcc.
# Replace it with the standard `std::to_underlying` after the patch is applied.
#
# Can be removed once https://github.com/NixOS/nixpkgs/pull/522768 lands (or
# termite is removed, see https://github.com/NixOS/nixpkgs/pull/522784).
final: prev: {
  termite = prev.termite.overrideAttrs (old: {
    buildInputs = map (
      p:
      if p ? pname && p.pname == "vte" then
        p.overrideAttrs (vteOld: {
          postPatch =
            (vteOld.postPatch or "")
            + ''
              substituteInPlace src/vte.cc \
                --replace-quiet \
                  "vte::to_integral(vte::platform::ClipboardType::PRIMARY)" \
                  "std::to_underlying(vte::platform::ClipboardType::PRIMARY)"
            '';
        })
      else
        p
    ) old.buildInputs;
  });
}
