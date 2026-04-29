# Override the `uboot-rpi-arm64` package provided by raspberry-pi-nix
# to bump the source to u-boot 2026.04 and apply Torsten Duwe's
# "ARM: RPi5: Enable PCIe" v2 series (9 patches).
#
# Series cover letter:
#   https://lists.denx.de/pipermail/u-boot/2026-April/616492.html
#
# Patches are pulled from lore.kernel.org. lore rejects the default
# curl User-Agent, so we set one explicitly via curlOptsList.
#
# NOTE: This override is dormant unless `raspberry-pi-nix.uboot.enable`
# is set to true on the host (currently false on rpi5).
final: prev: {
  uboot-rpi-arm64 =
    let
      fetchLorePatch =
        {
          name,
          msgId,
          hash,
        }:
        final.fetchurl {
          inherit name hash;
          url = "https://lore.kernel.org/u-boot/${msgId}@verein.lst.de/raw";
          curlOptsList = [
            "-A"
            "git/2.40"
          ];
        };
      rpi5-pcie-patches = [
        (fetchLorePatch {
          name = "0001-ARM-bcm283x-Add-bcm2712-PCIe-memory-window.patch";
          msgId = "20260428163918.C5D4268C4E";
          hash = "sha256-potxnOnNWlVsO83voPnzHi0Sa67zps/upH2Uc913SKU=";
        })
        (fetchLorePatch {
          name = "0002-pci-brcmstb-Fix-PCIe-bus-numbers.patch";
          msgId = "20260428163922.977E668CFE";
          hash = "sha256-n9eqocLOFYI/4lvIIQDBAQ//0ZZ+KsRWGoYQ98XNbCI=";
        })
        (fetchLorePatch {
          name = "0003-pci-brcmstb-Support-different-variants-using-a-cfg-s.patch";
          msgId = "20260428163925.6DF1968D07";
          hash = "sha256-TjETz2zAgUU2U79QdIvU6vt7AgWJu/RuFL/jFLpZ/OA=";
        })
        (fetchLorePatch {
          name = "0004-pci-brcmstb-Add-RPi5-reset-facilities.patch";
          msgId = "20260428163929.3501268D0D";
          hash = "sha256-BzOYgxol9To4n8VKC8UZGvUyUm91Rd1zx1G8U3Z2mb4=";
        })
        (fetchLorePatch {
          name = "0005-pci-brcmstb-Add-RPi5-rescal-reset-facilities.patch";
          msgId = "20260428163932.5540868D0F";
          hash = "sha256-LMwKYlDrkCSq/6syUtZYtqtaWaGoUKW+RpMneKLLjzU=";
        })
        (fetchLorePatch {
          name = "0006-pci-brcmstb-Get-and-use-bridge-and-rescal-reset-prop.patch";
          msgId = "20260428163936.7987968D09";
          hash = "sha256-nL5ep0vd30xcuQh/0kvbT74o9ZiYHDQiQMGtMY07uug=";
        })
        (fetchLorePatch {
          name = "0007-pci-brcmstb-Fix-iBAR-size-calculation.patch";
          msgId = "20260428163940.CE7CB68D0A";
          hash = "sha256-siyibeDNemM5gerocBqMLhV10aT28nyufK9CKFsyn14=";
        })
        (fetchLorePatch {
          name = "0008-pci-brcmstb-rework-iBAR-handling.patch";
          msgId = "20260428163946.42D4368D12";
          hash = "sha256-3vmjFbzP3YZnCizyJMAv50tInb18UAHgyeTkLZaOmxg=";
        })
        (fetchLorePatch {
          name = "0009-pci-brcmstb-Adapt-to-AXI-bridge.patch";
          msgId = "20260428163950.9BB2668D09";
          hash = "sha256-2azdJZrXXS0OKdA8MxQN1ViLsgpcIDsebFZpigwhq2w=";
        })
      ];
    in
    (prev.uboot-rpi-arm64.override {
      version = "2026.04";
      src = final.fetchurl {
        url = "https://ftp.denx.de/pub/u-boot/u-boot-2026.04.tar.bz2";
        hash = "sha256-rHwEuLcASSOwCk5dZpnF300hIzusn9ppDYz7wgn/8v0=";
      };
    }).overrideAttrs
      (old: {
        patches = (old.patches or [ ]) ++ rpi5-pcie-patches;
      });
}
