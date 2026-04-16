#!/bin/bash

WALLDIR="$HOME/wallpapers/walls"
CACHE="$HOME/.cache/wal/last-wallpaper"

# lista imagens com prefixo img: (pro wofi renderizar preview)
menu() {
    find "$WALLDIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) \
    | sort \
    | awk '{print "img:"$0}'
}

main() {
    choice=$(menu | wofi \
        --dmenu \
        --prompt "wall" \
        --location bottom \
        --width 1200 \
        --height 260 \
        --hide-scroll \
        --no-actions \
        -c ~/.config/wofi/wallpaper \
        -s ~/.config/wofi/style-wallpaper.css)

    selected=$(echo "$choice" | sed 's/^img://')

    [[ -z "$selected" ]] && exit 0

    # 🔥 animação FLUIDA (240Hz tuned)
    swww img "$selected" \
        --transition-type grow \
        --transition-fps 240 \
        --transition-duration 0.8 \
        --transition-bezier 0.25,1,0.5,1

    wal -i "$selected" -n --cols16
    echo "$selected" > "$CACHE"

    # reload visual
    pkill swayosd-server 2>/dev/null
    swayosd-server &

    swaync-client --reload-css 2>/dev/null
    pywalfox update 2>/dev/null

    # kitty
    cat ~/.cache/wal/colors-kitty.conf > ~/.config/kitty/current-theme.conf

    # cava
    color1=$(grep color2 ~/.cache/wal/colors.sh | cut -d"'" -f2)
    color2=$(grep color3 ~/.cache/wal/colors.sh | cut -d"'" -f2)

    sed -i "s/^gradient_color_1.*/gradient_color_1 = '$color1'/" ~/.config/cava/config
    sed -i "s/^gradient_color_2.*/gradient_color_2 = '$color2'/" ~/.config/cava/config

    pkill -USR2 cava 2>/dev/null

    # fix variável bugada
    cp "$selected" ~/wallpapers/pywallpaper.jpg
}

main
