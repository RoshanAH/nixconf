{
  writeShellApplication,
  pciutils,
  coreutils,
  gawk,
  gnugrep,
}: writeShellApplication {
  name = "gpu-select";
  runtimeInputs = [ pciutils coreutils gawk gnugrep ];
  text = ''
    CONFIG_FILE="$HOME/.config/uwsm/env-hyprland"

    get_pci_address() {
        local vendor="$1"
        lspci -d ::03xx | grep -i "$vendor" | awk '{print $1}'
    }

    get_card_number() {
        local pci_address="$1"
        local full_pci="pci-0000:$pci_address"

        for card in /dev/dri/card*; do
            [[ -e "$card" ]] || continue
            if udevadm info -q property -n "$card" | grep -q "ID_PATH=$full_pci"; then
                basename "$card" | sed 's/card//'
                return
            fi
        done

        echo "Error: no /dev/dri/card for PCI $pci_address" >&2
        return 1
    }

    nvidia_pci=$(get_pci_address "NVIDIA")
    amd_pci=$(get_pci_address "AMD")

    if [[ -z "$nvidia_pci" ]]; then
        echo "Error: NVIDIA card not found"
        exit 1
    fi

    if [[ -z "$amd_pci" ]]; then
        echo "Error: AMD card not found"
        exit 1
    fi

    nvidia_card=$(get_card_number "$nvidia_pci")
    amd_card=$(get_card_number "$amd_pci")

    echo "Detected cards:"
    echo "  NVIDIA ($nvidia_pci) -> /dev/dri/card$nvidia_card"
    echo "  AMD ($amd_pci) -> /dev/dri/card$amd_card"

    mkdir -p "$(dirname "$CONFIG_FILE")"

    gpu_choice="amd"

    echo "Checking NVIDIA connectors on card$nvidia_card:"
    for connector in /sys/class/drm/card"$nvidia_card"-*; do
        if [[ -d "$connector" && -f "$connector/status" ]]; then
            status=$(cat "$connector/status")
            if [[ "$status" == "connected" ]]; then
                gpu_choice="nvidia"
                echo "Display connected on $(basename "$connector") → selecting NVIDIA"
                break
            fi
        fi
    done

    if [[ "$gpu_choice" == "nvidia" ]]; then
        drm_devices="/dev/dri/card$nvidia_card"
        echo "Using NVIDIA as primary GPU"
    else
        drm_devices="/dev/dri/card$amd_card"
        echo "Using AMD as primary GPU"
    fi

    echo "export AQ_DRM_DEVICES=\"$drm_devices\"" > "$CONFIG_FILE"
    echo "export WLR_DRM_DEVICES=\"$drm_devices\"" >> "$CONFIG_FILE"

    echo "Configuration written to: $CONFIG_FILE"
    echo "AQ_DRM_DEVICES=$drm_devices"
  '';
}
