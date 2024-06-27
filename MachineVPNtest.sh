#!/bin/bash

TOKEN='TOKEN'

VPN_SERVER_IDS=(14 29 289 113 201 7 44 314)

# Arrays to hold machine IDs and names
MACHINE_IDS=(611 608 605 604 603 602 601 600 599 598 597 596 595 594 593 592 591 590 589 588 587 586 585)
MACHINE_NAMES=("axlle" "editorial" "blurry" "freelancer" "boardlight" "magicgardens" "solarlab" "mailing" "intuition" "runner" "usage" "iclean" "mist" "headless" "wifinetictwo" "formulax" "builder" "perfection" "jab" "office" "crafty" "skyfall" "pov")

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
    *)
      echo "Error: Unknown VPN server name"
      exit 1
      ;;
  esac
}

# Stop any active machines
stop_active_machines() {
    response=$(curl -s --location --request POST "https://labs.hackthebox.com/api/v4/machine/stop" -H "Authorization: Bearer $TOKEN")
    green_tick "Stopped active machines"
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
    green_tick "Changed VPN server to $server_name"
    log_verbose "Now connected to $server_name"
}

# Download VPN file
download_vpn_file() {
    local vpn_server_id=$1
    rm *.ovpn
    response=$(curl -s "https://labs.hackthebox.com/api/v4/access/ovpnfile/$vpn_server_id/0" \
        -H "accept: application/json, text/plain, */*" \
        -H "authorization: Bearer $TOKEN" \
        --output vpn"$vpn_server_id".ovpn)
    green_tick "Downloaded VPN file for $server_name"
    log_verbose "VPN file downloaded as vpn$vpn_server_id.ovpn"
}

# Connect to VPN
connect_to_vpn() {
    local vpn_server_id=$1
    sudo killall openvpn
    sleep 10
    sudo openvpn vpn"$vpn_server_id".ovpn > /tmp/openvpn.log 2>&1 &  # Redirect output to a temporary log file
    sleep 30
    # Wait for "Initialization Sequence Completed" message in openvpn output
    for i in {1..30}; do
        if grep -q "Initialization Sequence Completed" /tmp/openvpn.log; then
            green_tick "VPN connected for server $server_name"
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
    green_tick "Spawned machine $MACHINE_NAME on $server_name"
    log_verbose "Response: $response"
    
    # Wait 30 seconds to allow machine to initialize before getting IP
    echo "Getting the IP of $MACHINE_NAME on $server_name"
    sleep 30
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

# Ping machine IP and handle errors
ping_machine() {
    ip=$1
    if [ -z "$ip" ]; then
        echo "Error: Failed to get machine IP for server $server_name"
    else
        if ping -c 3 "$ip" > /dev/null; then
            green_tick "Machine Live and Running on $server_name"
            ping_output=$(ping -c 3 "$ip")
            log_verbose "$ping_output"
        else
            echo "Error: Machine is not reachable on $server_name"
        fi
    fi
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
    
    green_tick "Testing $MACHINE_NAME on VPN $server_name"
    
    ip=$(get_machine_ip)
    echo "Machine's IP is $ip"
    ping_machine "$ip"
    
    echo "Waiting for 20 seconds before switching to the next VPN server..."
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
    spawn_machine

    green_tick "Testing $MACHINE_NAME on VPN $server_name"
    
    ip=$(get_machine_ip)
    echo "Machine's IP is $ip"
    ping_machine "$ip"
    
    echo "Waiting for 20 seconds before testing the next machine..."
    sleep 10
  done
}

# Main logic
if [ "$mode" == "machine" ]; then
  read -p "Enter machine name: " MACHINE_NAME
  MACHINE_NAME=$(echo "$MACHINE_NAME" | tr '[:upper:]' '[:lower:]')
  test_machine_on_all_vpns "$MACHINE_NAME"
elif [ "$mode" == "vpn" ]; then
  read -p "Enter VPN server name: " VPN_SERVER_NAME
  test_all_machines_on_vpn "$VPN_SERVER_NAME"
else
  echo "Error: Invalid mode. Use -m machine to test one machine on all VPN servers or -m vpn to test all machines on one VPN server."
  exit 1
fi
