#!/bin/bash
# restore-wallpaper.sh
# Roda no startup do Hyprland para restaurar wallpaper e cores do pywal

LAST_WALL_FILE="$HOME/.cache/wal/last-wallpaper"

# inicia o daemon do swww (necessário antes de qualquer swww img)
swww-daemon &
sleep 1

if [[ -f "$LAST_WALL_FILE" ]]; then
    wallpaper=$(cat "$LAST_WALL_FILE")

    if [[ -f "$wallpaper" ]]; then
        swww img "$wallpaper" --transition-type any --transition-fps 60 --transition-duration .5
    else
        # arquivo sumiu, tenta o backup
        swww img ~/wallpapers/pywallpaper.jpg --transition-type any --transition-fps 60 --transition-duration .5
    fi
else
    # nenhum wallpaper salvo ainda, usa o backup se existir
    [[ -f ~/wallpapers/pywallpaper.jpg ]] && \
        swww img ~/wallpapers/pywallpaper.jpg --transition-type any --transition-fps 60 --transition-duration .5
fi

# restaura as cores do pywal em todos os apps
wal -R
cat ~/.cache/wal/colors-kitty.conf > ~/.config/kitty/current-theme.conf
swaync-client --reload-css
pywalfox update 2>/dev/null || true
