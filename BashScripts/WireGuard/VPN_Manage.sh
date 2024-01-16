#! /bin/bash

wg_configs_dir="/etc/wireguard"
wg_configs=()

if ! [ `id -u` = 0 ] ; then
        echo "Pls run as root, cant see into folders :C"
	exit 0;
fi

for file in "$wg_configs_dir"/*.conf; do
    filename=("$(basename "$file")")
    wg_configs+=("${filename%.*}")
done

clear

echo "Listing WireGuard configurations in $wg_configs_dir"
echo "----------------------------------------------"

# Display the selection menu for configurations
PS3="Select a WireGuard configuration (enter the number, or 0 to exit): "
select config_choice in "${wg_configs[@]}"; do
    case $REPLY in
        0)
            echo "Exiting."
            exit 0
            ;;
        *)
            if [ "$REPLY" -le "${#wg_configs[@]}" ]; then
                selected_config="$config_choice"
                echo "You selected: $selected_config"
                break
            else
                echo "Invalid selection. Please enter a valid number."
            fi
            ;;
    esac
done

# Display the menu for actions (connect or disconnect)
PS3="Select an action for $selected_config (1: Connect, 2: Disconnect, 0: Exit): "
select action_choice in "Connect" "Disconnect" "Exit"; do
    case $REPLY in
        1)
            echo "Connecting to $selected_config..."
            wg-quick up $selected_config
            ;;
        2)
            echo "Disconnecting from $selected_config..."
            wg-quick down $selected_config
            ;;
        0)
            echo "Exiting."
            exit 0
            ;;
        *)
            echo "Invalid selection. Please enter a valid number."
            ;;
    esac
done
