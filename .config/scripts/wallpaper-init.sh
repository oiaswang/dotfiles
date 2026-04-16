#!/bin/bash

# Inicia o daemon e aguarda o socket estar pronto
swww-daemon &

# swww query fica em loop até o daemon responder
# é o método oficial da documentação do swww
swww query
while [ $? -ne 0 ]; do
    sleep 0.1
    swww query
done

# Daemon pronto — restaura o último wallpaper
swww restore

# Executa seu script de wallpaper adicional se existir
if [ -f ~/.config/hypr/scripts/wallpaper.sh ]; then
    ~/.config/hypr/scripts/wallpaper.sh
fi
