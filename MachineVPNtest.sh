#!/bin/bash

echo "___  ___           _     _                              _   _   _______ _   _   _____         _   _              "
echo "|  \/  |          | |   (_)                            | | | | | | ___ \ \ | | |_   _|       | | (_)             "
echo "| .  . | __ _  ___| |__  _ _ __   ___    __ _ _ __   __| | | | | | |_/ /  \| |   | | ___  ___| |_ _ _ __   __ _   "
echo "| |\/| |/ _\` |/ __| '_ \| | '_ \ / _ \  / _\` | '_ \ / _\` | | | | |  __/| . \` |   | |/ _ \/ __| __| | '_ \ / _\` | "
echo "| |  | | (_| | (__| | | | | | | |  __/ | (_| | | | | (_| | \ \_/ / |   | |\  |   | |  __/\__ \ |_| | | | | (_| | "
echo "\_|  |_/\__,_|\___|_| |_|_|_| |_|\___|  \__,_|_| |_|\__,_|  \___/\_|   \_| \_/   \_/\___||___/\__|_|_| |_|\__, | "
echo "                                                                                                           __/ | "
echo "                                                                                                          |___/  "
echo "-----------------------------------------------------------------------------------------------------------------"




echo "                                                                                             __       __     __  "
echo "                                                                                            |  \| /\ |__)|  /  \ "
echo "                                                                                            |__/|/--\|__)|__\__/ "
echo "                                                                                                                 "


TOKEN=''

VPN_SERVER_IDS=(14 29 289 113 201 7 44 314 1 2 5 6 8 9 11 17 18 20 21 23 27 28 30 31 33 35 36 41 42 45 46 47 48 49 50 51 52 54 56 57 58 61 65 66 67 68 69 70 71 73 74 77 122 177 182 219 220 222 223 251 252 280 86 89 253 254 38 202 426 288)

# Arrays for StartingPoint server IDs and names
STARTINGPOINT_SERVER_IDS=(412 413 414 415 440 441)



# Arrays to hold machine IDs and names
MACHINE_IDS=(611 608 605 604 603 602 601 600 599 598 597 596 595 594 593 592 591 590 589 588 587 586 585)
MACHINE_NAMES=("axlle" "editorial" "blurry" "freelancer" "boardlight" "magicgardens" "solarlab" "mailing" "intuition" "runner" "usage" "iclean" "mist" "headless" "wifinetictwo" "formulax" "builder" "perfection" "jab" "office" "crafty" "skyfall" "pov")



# Arrays for StartingPoint machine IDs and names
STARTINGPOINT_MACHINE_IDS=(520 515 501 489 479 472 461 449 441 407 406 405 404 403 402 397 396 395 394 393 295 294 293 292 291 290 289 288 287)
STARTINGPOINT_MACHINE_NAMES=("funnel" "synced" "mongod" "three" "base" "redeemer" "responder" "bike" "unified" "tactics" "pennyworth" "ignition" "crocodile" "sequel" "appointment" "preignition" "explosion" "dancing" "meow" "fawn" "base (legacy)" "guard" "markup" "included" "pathfinder" "shield" "vaccine" "oopsie" "archetype")


verbose=false
mode=""

# Check for verbose flag and mode option
while getopts ":vm:" option; do
  case $option in
    v)
      verbose=true
      ;;
    m)
      mode=$OPTARG
      ;;
    *)
      ;;
  esac
done

shift $((OPTIND - 1))

# Function to echo green tick and log message
green_tick() {
    echo -e "\033[0;32m\xE2\x9C\x85 $1\033[0m"
}

red_cross() {
    echo -e "\033[0;31m\xE2\x9D\x8C $1\033[0m"
}


# Function to log verbose messages
log_verbose() {
    if $verbose; then
        echo "$1"
    fi
}

# Function to map machine name to ID
map_machine_name_to_id() {
  local name="$1"
  local i
  for i in "${!MACHINE_NAMES[@]}"; do
    if [[ "${MACHINE_NAMES[$i]}" == "$name" ]]; then
      MACHINE_ID=${MACHINE_IDS[$i]}
      MACHINE_NAME="${MACHINE_NAMES[$i]}"
      return 0
    fi
  done
  return 1
}


map_startingpoint_machine_name_to_id() {
  local name="$1"
  local i
  for i in "${!STARTINGPOINT_MACHINE_NAMES[@]}"; do
    if [[ "${STARTINGPOINT_MACHINE_NAMES[$i]}" == "$name" ]]; then
      MACHINE_ID=${STARTINGPOINT_MACHINE_IDS[$i]}
      MACHINE_NAME="${STARTINGPOINT_MACHINE_NAMES[$i]}"
      return 0
    fi
  done
  return 1
}

# Function to map VPN server ID to name
map_vpn_server_name_to_id() {
  local name="$1"
  case "$name" in
    "US VIP 2") VPN_SERVER_ID=14 ;;
    "US VIP 7") VPN_SERVER_ID=29 ;;
    "US VIP +1") VPN_SERVER_ID=289 ;;
    "US FREE 1") VPN_SERVER_ID=113 ;;
    "EU FREE 2") VPN_SERVER_ID=201 ;;
    "EU VIP 4") VPN_SERVER_ID=7 ;;
    "EU VIP 14") VPN_SERVER_ID=44 ;;
    "EU VIP +2") VPN_SERVER_ID=314 ;;
    "EU FREE 1") VPN_SERVER_ID=1 ;;
    "EU VIP 1") VPN_SERVER_ID=2 ;;
    "EU VIP 2") VPN_SERVER_ID=5 ;;
    "EU VIP 3") VPN_SERVER_ID=6 ;;
    "EU VIP 5") VPN_SERVER_ID=8 ;;
    "EU VIP 6") VPN_SERVER_ID=9 ;;
    "US VIP 1") VPN_SERVER_ID=11 ;;
    "US VIP 3") VPN_SERVER_ID=17 ;;
    "EU VIP 7") VPN_SERVER_ID=18 ;;
    "US VIP 4") VPN_SERVER_ID=20 ;;
    "EU VIP 8") VPN_SERVER_ID=21 ;;
    "US VIP 5") VPN_SERVER_ID=23 ;;
    "US VIP 6") VPN_SERVER_ID=27 ;;
    "EU VIP 9") VPN_SERVER_ID=28 ;;
    "EU VIP 10") VPN_SERVER_ID=30 ;;
    "US VIP 8") VPN_SERVER_ID=31 ;;
    "EU VIP 11") VPN_SERVER_ID=33 ;;
    "US VIP 9") VPN_SERVER_ID=35 ;;
    "EU VIP 12") VPN_SERVER_ID=36 ;;
    "US VIP 11") VPN_SERVER_ID=41 ;;
    "EU VIP 13") VPN_SERVER_ID=42 ;;
    "US VIP 12") VPN_SERVER_ID=45 ;;
    "US VIP 13") VPN_SERVER_ID=46 ;;
    "EU VIP 15") VPN_SERVER_ID=47 ;;
    "US VIP 14") VPN_SERVER_ID=48 ;;
    "EU VIP 16") VPN_SERVER_ID=49 ;;
    "US VIP 15") VPN_SERVER_ID=50 ;;
    "EU VIP 17") VPN_SERVER_ID=51 ;;
    "US VIP 16") VPN_SERVER_ID=52 ;;
    "EU VIP 18") VPN_SERVER_ID=54 ;;
    "US VIP 17") VPN_SERVER_ID=56 ;;
    "EU VIP 19") VPN_SERVER_ID=57 ;;
    "US VIP 18") VPN_SERVER_ID=58 ;;
    "EU VIP 20") VPN_SERVER_ID=61 ;;
    "US VIP 19") VPN_SERVER_ID=65 ;;
    "EU VIP 21") VPN_SERVER_ID=66 ;;
    "US VIP 20") VPN_SERVER_ID=67 ;;
    "EU VIP 22") VPN_SERVER_ID=68 ;;
    "US VIP 21") VPN_SERVER_ID=69 ;;
    "EU VIP 23") VPN_SERVER_ID=70 ;;
    "US VIP 22") VPN_SERVER_ID=71 ;;
    "EU VIP 24") VPN_SERVER_ID=73 ;;
    "US VIP 23") VPN_SERVER_ID=74 ;;
    "EU VIP 25") VPN_SERVER_ID=77 ;;
    "EU VIP 28") VPN_SERVER_ID=122 ;;
    "AU FREE 1") VPN_SERVER_ID=177 ;;
    "AU VIP 1") VPN_SERVER_ID=182 ;;
    "EU FREE 3") VPN_SERVER_ID=253 ;;
    "US FREE 3") VPN_SERVER_ID=254 ;;
    "EU VIP 26") VPN_SERVER_ID=219 ;;
    "US VIP 26") VPN_SERVER_ID=220 ;;
    "EU VIP 27") VPN_SERVER_ID=222 ;;
    "US VIP 27") VPN_SERVER_ID=223 ;;
    "SG FREE 1") VPN_SERVER_ID=251 ;;
    "SG VIP 1") VPN_SERVER_ID=252 ;;
    "SG VIP 2") VPN_SERVER_ID=280 ;;
    "US VIP 25") VPN_SERVER_ID=89 ;;
    "US VIP 24") VPN_SERVER_ID=86 ;;
    "EU VIP 29") VPN_SERVER_ID=329 ;;
    "US VIP 10") VPN_SERVER_ID=38 ;;
    "US FREE 2") VPN_SERVER_ID=202 ;;
    "SG VIP +1") VPN_SERVER_ID=426;;
    "EU VIP +1") VPN_SERVER_ID=288 ;;
    *)
      echo "Error: Unknown VPN server name"
      exit 1
      ;;
  esac
}

map_startingpoint_server_name_to_id() {
  local name="$1"
  case "$name" in
    "EU SP 1") VPN_SERVER_ID=412 ;;
    "EU SP VIP 1") VPN_SERVER_ID=413 ;;
    "US SP 1") VPN_SERVER_ID=414 ;;
    "US SP VIP 1") VPN_SERVER_ID=415 ;;
    "EU SP 2") VPN_SERVER_ID=440 ;;
    "US SP 2") VPN_SERVER_ID=441 ;;
    *)
      echo "Error: Unknown StartingPoint server name"
      exit 1
      ;;
  esac
}


# Stop any active machines
stop_active_machines() {
    response=$(curl -s --location --request POST "https://labs.hackthebox.com/api/v4/machine/stop" -H "Authorization: Bearer $TOKEN")
    echo "[+]Stopped active machines"
    log_verbose "Response: $response"
}

# Switch VPN server
switch_vpn_server() {
    local vpn_server_id=$1
    response=$(curl -s "https://labs.hackthebox.com/api/v4/connections/servers/switch/$vpn_server_id" \
        -H "accept: application/json, text/plain, */*" \
        -H "authorization: Bearer $TOKEN" \
        -H "content-type: application/json" \
        --data-raw '{"arena":false}')
    
    sleep 10
    server_name=$(echo "$response" | jq -r '.data.friendly_name')
     echo "[+]Changed VPN server to $server_name"
}

# Download VPN file
download_vpn_file() {
    local vpn_server_id=$1
    rm *.ovpn
    response=$(curl -s "https://labs.hackthebox.com/api/v4/access/ovpnfile/$vpn_server_id/0" \
        -H "accept: application/json, text/plain, */*" \
        -H "authorization: Bearer $TOKEN" \
        --output vpn"$vpn_server_id".ovpn)
     echo "[+]Downloaded VPN file for $server_name"
    log_verbose "VPN file downloaded as vpn$vpn_server_id.ovpn"
}

# Connect to VPN
connect_to_vpn() {
    local vpn_server_id=$1
    sudo killall openvpn > /dev/null 2>&1
    sleep 10
    sudo openvpn vpn"$vpn_server_id".ovpn > /tmp/openvpn.log 2>&1 &  # Redirect output to a temporary log file
    sleep 30
    # Wait for "Initialization Sequence Completed" message in openvpn output
    for i in {1..30}; do
        if grep -q "Initialization Sequence Completed" /tmp/openvpn.log; then
            echo "[+]VPN connected for server $server_name"
            rm /tmp/openvpn.log  # Clean up temporary log file
            return 0
        fi
        sleep 1
    done
    echo "Error: VPN connection failed"
    rm /tmp/openvpn.log  # Clean up temporary log file on error
    exit 1
}

# Spawn a machine
spawn_machine() {
    response=$(curl -s --location --request POST "https://labs.hackthebox.com/api/v4/machine/play/$MACHINE_ID" -H "Authorization: Bearer $TOKEN")
     echo "[+]Spawning machine $MACHINE_NAME on $server_name"
    log_verbose "Response: $response"
    
    # Wait 30 seconds to allow machine to initialize before getting IP
    SECONDS=0
    while [ $SECONDS -lt 20 ]; do
      for s in / - \\ \|; do
        printf "\r$s"
        sleep .1
      done
    done
}


wait_for_spawn() {
    local name="$1"
    if [[ "$name" == *"VIP"* ]]; then
        echo "[+]VIP server detected, waiting for few more seconds for the machine to fully spawn"
        sleep 40
    else
        echo "Non-VIP server detected, no wait required."
    fi
}



nmap_scan() {
    ip=$1
    if [ -z "$ip" ]; then
        echo "Error: No IP provided for nmap scan."
        return 1
    fi

    echo "[+] Performing nmap scan on $ip..."
    nmap_output=$(nmap -T4 --min-rate=1000 -F "$ip")
    SECONDS=0
    while [ $SECONDS -lt 5 ]; do
      for s in / - \\ \|; do
        printf "\r$s"
        sleep .1
      done
    done
     echo "[+] Nmap scan completed on $ip"
    echo "$nmap_output"
  
}


# Get machine IP
get_machine_ip() {
    local machine_ip
    while true; do
        response=$(curl -s "https://labs.hackthebox.com/api/v4/machine/profile/$MACHINE_ID" \
            -H "accept: application/json, text/plain, */*" \
            -H "authorization: Bearer $TOKEN")
        machine_ip=$(echo $response | jq -r '.info.ip')
        if [ -n "$machine_ip" ] && [[ "$machine_ip" =~ ^10\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
            echo $machine_ip
            return 0
        fi
        sleep 5
    done
}


# Get machine IP
get_sp_ip() {
    local machine_ip
    while true; do
        response=$(curl -s "https://labs.hackthebox.com/api/v4/sp/profile/$MACHINE_ID" \
            -H "accept: application/json, text/plain, */*" \
            -H "authorization: Bearer $TOKEN")
        machine_ip=$(echo $response | jq -r '.info.ip')
        if [ -n "$machine_ip" ] && [[ "$machine_ip" =~ ^10\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
            echo $machine_ip
            return 0
        fi
        sleep 5
    done
}

# Ping machine IP and handle errors
ping_machine() {
    ip=$1
    if [ -z "$ip" ]; then
        echo "Error: Failed to get machine IP for server $server_name"
    else
        if ping -c 4 "$ip" > /dev/null; then
            green_tick "Machine $MACHINE_NAME Live and Running on $server_name"
            ping_output=$(ping -c 4 "$ip")
            log_verbose "$ping_output"
            nmap_scan "$ip"

        else
            
            red_cross "Error: Machine is not reachable on $server_name"
            ping_output=$(ping -c 4 "$ip")
            log_verbose "$ping_output"
        fi
    fi
}



test_machine_on_startingpoint_vpn() {
  local machine_name="$1"
  local vpn_server_name="$2"

  if ! map_startingpoint_machine_name_to_id "$machine_name"; then
    echo "Error: Machine name not found"
    exit 1
  fi

  map_startingpoint_server_name_to_id "$vpn_server_name"

  stop_active_machines
  switch_vpn_server "$VPN_SERVER_ID"
  download_vpn_file "$VPN_SERVER_ID"
  connect_to_vpn "$VPN_SERVER_ID"
  spawn_machine

  ip=$(get_sp_ip)
  echo "Machine's IP is $ip"
  sleep 20
  echo "[+]Testing $MACHINE_NAME on VPN $server_name"
  ping_machine "$ip"
}



# Main loop for testing one machine on all VPN servers
test_machine_on_all_vpns() {
  local machine_name="$1"
  if ! map_machine_name_to_id "$machine_name"; then
    echo "Error: Machine name not found"
    exit 1
  fi

  for vpn_server_id in "${VPN_SERVER_IDS[@]}"; do
    stop_active_machines
    switch_vpn_server "$vpn_server_id"
    download_vpn_file "$vpn_server_id"
    connect_to_vpn "$vpn_server_id"
    spawn_machine
    
    
    ip=$(get_machine_ip)
    echo "Machine's IP is $ip"
    wait_for_spawn "$server_name"
    echo "[+]Testing $MACHINE_NAME on VPN $server_name"

    ping_machine "$ip"
    
    echo "------- Moving to the next VPN server ---------"
    sleep 10
  done
}

# Main loop for testing all machines on one VPN server
test_all_machines_on_vpn() {
  local vpn_server_name="$1"
  map_vpn_server_name_to_id "$vpn_server_name"

  stop_active_machines
  switch_vpn_server "$VPN_SERVER_ID"
  download_vpn_file "$VPN_SERVER_ID"
  connect_to_vpn "$VPN_SERVER_ID"

  for i in "${!MACHINE_IDS[@]}"; do
    MACHINE_ID=${MACHINE_IDS[$i]}
    MACHINE_NAME=${MACHINE_NAMES[$i]}
    stop_active_machines
    spawn_machine

    
    ip=$(get_machine_ip)
    echo "Machine's IP is $ip"
    wait_for_spawn "$server_name"
    echo "[+]Testing $MACHINE_NAME on VPN $server_name"

    ping_machine "$ip"
    
    echo "--------- Moving to the next machine ---------"
    sleep 10
  done
}


# Main loop for testing one machine on one VPN server
test_machine_on_vpn() {
  local machine_name="$1"
  local vpn_server_name="$2"

  if ! map_machine_name_to_id "$machine_name"; then
    echo "Error: Machine name not found"
    exit 1
  fi

  map_vpn_server_name_to_id "$vpn_server_name"

  stop_active_machines
  switch_vpn_server "$VPN_SERVER_ID"
  download_vpn_file "$VPN_SERVER_ID"
  connect_to_vpn "$VPN_SERVER_ID"
  spawn_machine
  
  
  ip=$(get_machine_ip)
  echo "Machine's IP is $ip"
  wait_for_spawn "$server_name"
  echo "[+]Testing $MACHINE_NAME on VPN $server_name"
  ping_machine "$ip"
}



# Main logic
if [ "$mode" == "machine" ]; then
  read -p "Enter machine name: " MACHINE_NAME
  MACHINE_NAME=$(echo "$MACHINE_NAME" | tr '[:upper:]' '[:lower:]')
  test_machine_on_all_vpns "$MACHINE_NAME"
elif [ "$mode" == "vpn" ]; then
  read -p "Enter VPN server name: " VPN_SERVER_NAME
  test_all_machines_on_vpn "$VPN_SERVER_NAME"
elif [ "$mode" == "single" ]; then
  read -p "Enter machine name: " MACHINE_NAME
  MACHINE_NAME=$(echo "$MACHINE_NAME" | tr '[:upper:]' '[:lower:]')
  read -p "Enter VPN server name: " VPN_SERVER_NAME
  test_machine_on_vpn "$MACHINE_NAME" "$VPN_SERVER_NAME"
elif [ "$mode" == "startingpoint" ]; then
  read -p "Enter StartingPoint Machine name: " MACHINE_NAME
  MACHINE_NAME=$(echo "$MACHINE_NAME" | tr '[:upper:]' '[:lower:]')
  read -p "Enter StartingPoint Server name: " VPN_SERVER_NAME
  test_machine_on_startingpoint_vpn "$MACHINE_NAME" "$VPN_SERVER_NAME"
else
  echo "Error: Invalid mode. Use -m machine to test one machine on all VPN servers or -m vpn to test all machines on one VPN server."
  exit 1
fi
