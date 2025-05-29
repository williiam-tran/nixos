{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kmod,
}:
stdenv.mkDerivation rec {
  pname = "bluetooth-6.8-driver";
  version = "4.1";

  src = fetchFromGitHub {
    owner = "jeremyb31";
    repo = "bluetooth-6.8";
    rev = "706f83bd34f9bfc170e290343c732aeb7f52a6d7";
    hash = "sha256-Oe0wAbl7uJ3Q6OdZafGS4Yb80MA/P34MW3LuAJ7lRpg=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

  preBuild = ''
        substituteInPlace Makefile --replace /lib/modules/ "${kernel.dev}/lib/modules/"
        substituteInPlace Makefile --replace '$(shell uname -r)' "${kernel.modDirVersion}"
        substituteInPlace Makefile --replace /usr/src/linux-headers-$(shell uname -r) "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"

        # Fix for kernel 6.12+ where asm/unaligned.h was moved to linux/unaligned.h
        # Apply the fix to all C source files that include asm/unaligned.h
        for file in *.c; do
          if grep -q '#include <asm/unaligned.h>' "$file"; then
            substituteInPlace "$file" \
              --replace '#include <asm/unaligned.h>' \
              $'#include <linux/kernel.h>\n#include <linux/types.h>\n#include <linux/version.h>\n\n#if LINUX_VERSION_CODE < KERNEL_VERSION(6, 12, 0)\n#include <asm/unaligned.h>\n#else\n#include <linux/unaligned.h>\n#endif'
          fi
        done
        
        # Add UGREEN BT5.4 adapter quirks for better compatibility
        if [ -f btusb.c ]; then
          # Add UGREEN device ID with quirks before the module table
          sed -i '/static const struct usb_device_id blacklist_table\[\] = {/i\
    /* UGREEN BT5.4 Adapter quirks */\
    { USB_DEVICE(0x33fa, 0x0010), .driver_info = BTUSB_REALTEK |\
                                                   BTUSB_WIDEBAND_SPEECH },\
    ' btusb.c
        fi
  '';

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/bluetooth
    cp btusb.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/bluetooth/
  '';

  meta = {
    description = "Custom Bluetooth driver for problematic adapters";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
