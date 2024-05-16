#!/bin/bash

#
# This code is mostly written by GitHub Copilot,
# so don't blame me if it doesn't work as expected.
#

# Configure shock (can only be the same as on the web interface)
MIN_INTENSITY=20
MAX_INTENSITY=30
DURATION=0.3

# Setup the environment:
# ```bash
# #!/bin/bash
# export PISHOCK_USER="Username"
# export PISHOCK_API_KEY="xxxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx"
# export PISHOCK_CODE="FFFFFFFFFFF"
# ```
. shockenv.sh

# Patch the game
MODIFIED_GAME="Buckshot Roulette.x86_64"
MODIFIED_HASH="bd76cf8a367d4fcedaa94c6528458a4d"
STEAM_GAME_DIR="$HOME/.steam/steam/steamapps/common/Buckshot Roulette/Buckshot Roulette_linux"
if [ -f "$MODIFIED_GAME" ] && [ "$(md5sum "$MODIFIED_GAME" | cut -d ' ' -f 1)" == "$MODIFIED_HASH" ]; then
    echo "Game already patched, skipping..."
else
    echo "Patching Buckshot Roulette..."
    sed -z 's/CheckAchievement_why()/print("player_shot"  )/1' "$STEAM_GAME_DIR/Buckshot Roulette.x86_64" > "$MODIFIED_GAME"
    sed -z -i 's/speaker_medicine\.play()/print("player_shot"   )/1' "$MODIFIED_GAME"
    sed -z -i 's/smoke\.SpawnSmoke("barrel")/print("player_shot"      )/2' "$MODIFIED_GAME"
    chmod +x "$MODIFIED_GAME"
    ln -s "$STEAM_GAME_DIR/libsteam_api.so" libsteam_api.so
    ln -s "$STEAM_GAME_DIR/Original Soundtrack" "Original Soundtrack"
fi


# Launch the game
echo "Launching Buckshot Roulette..."
stdbuf -oL "./$MODIFIED_GAME" | while IFS= read -r line
do
    # Check stdout for 'player shot'
    if [[ "$line" == *"player_shot"* ]]; then
        ./shockms.sh $(shuf -i $MIN_INTENSITY-$MAX_INTENSITY -n 1) $DURATION
    fi
done
