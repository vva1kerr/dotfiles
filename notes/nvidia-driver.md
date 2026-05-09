https://github.com/Infinirc/nvfd
https://github.com/UnknownSuperficialNight/nvidia-fan-control





  - NVFD — NVIDIA GPU fan control daemon (GitHub) https://github.com/Infinirc/nvfd 
  - nvidia-fan-control Wayland compatible (GitHub) https://github.com/UnknownSuperficialNight/nvidia-fan-control 
  - Nvidia fan Control wayland — NVIDIA Developer Forums https://forums.developer.nvidia.com/t/nvidia-fan-control-wayland/304824
  - Automatic adjustment of Nvidia fans on Wayland — Arch Linux Forums https://bbs.archlinux.org/viewtopic.php?id=293846
  - Wayland fan and other GPU controls — NVIDIA Developer Forums https://forums.developer.nvidia.com/t/wayland-fan-and-other-gpu-controls/271320
  - Permission for NVML on Wayland without root — NVIDIA Developer Forums https://forums.developer.nvidia.com/t/permission-for-nvml-or-nvidia-settings-on-wayland-without-root/322665






heck driver version:
  nvidia-smi
  Shows driver version top-right. Also: cat /proc/driver/nvidia/version

  ---
  Permission error cause:
  
  nvidia-settings fan control requires Coolbits enabled in xorg.conf. Without
  it, kernel blocks fan speed writes even for your own user.

  Fix — add Coolbits to xorg.conf:

  sudo nvidia-xconfig --cool-bits=4

  Then restart display manager:
  sudo systemctl restart gdm   # or sddm/lightdm
  
  Coolbits 4 = fan control. 5 = fan + overclocking.

  ---
  If no X server / headless:

  Fan control via nvidia-settings needs X. Headless box → use nvidia-smi instead
   (limited fan control on some cards) or nvtop/fancontrol workarounds. RTX 3090
   fan control via nvidia-smi not supported directly — needs X + Coolbits.

  Quick test after fix:
  nvidia-settings -a "[gpu:0]/GPUFanControlState=1" -a
  "[fan:0]/GPUTargetFanSpeed=40"
