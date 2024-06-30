# Machine and VPN Testing Script

This shell script tests machines and VPN servers using calls to HTB API across different VPN servers.

## Requirements

- [jq](https://stedolan.github.io/jq/) for parsing JSON responses
- [nmap](https://nmap.org/) for network scanning
- [curl](https://curl.se/) for API requests
- [openvpn](https://openvpn.net/) for VPN connection

## Usage

```bash
sudo ./MachineVPNtest.sh -m [mode] [-v]
```

## Options
- `-m [mode]`: Specify the mode of operation. Available modes:
    - `machine`: Test a single machine on all VPN servers.
    - `vpn`: Test all machines on a single VPN server.
    - `single`: Test a single machine on a single VPN server.
    - `startingpoint`: Test a single StartingPoint machine on a StartingPoint VPN server.
- `-v`: Enable verbose logging.


## Configuration
`TOKEN`: Your HTB APP token, You can get this from your [Profile Settings](https://app.hackthebox.com/profile/settings)
## Functions

- `stop_active_machines`: Stops any active machines.
- `switch_vpn_server`: Switches to a specified VPN server.
- `download_vpn_file`: Downloads the VPN file for the specified VPN server.
- `connect_to_vpn`: Connects to the VPN server.
- `spawn_machine`: Spawns a machine.
- `get_machine_ip`: Retrieves the IP address of the machine.
- `ping_machine`: Pings the machine and performs an nmap scan if reachable.
- `nmap_scan`: Performs an nmap scan on the specified IP.
---
## Steps on How the Script Works
- Kills all VPN connections using `sudo killall openvpn` 
- Removes old VPN files using `rm *.ovpn` 
- Switch to the needed VPN server 
- Download VPN file and starts connection 
- Spawns Machine and wait for the IP, if it's a VIP server it will wait longer since the machine takes a while to spawn 
- Pings the target 
- Runs an `nmap` scan using `nmap -T4 --min-rate=1000 -F IP`
- Moves to the next Server or Machine depending on the mode

---
### Example Usage
Test a Single Machine on All VPN Servers
```bash
sudo ./MachineVPNtest.sh -m machine 
```
Test ALL Active Machines on a Single VPN Server
```bash
sudo ./MachineVPNtest.sh -m vpn 
```
Test a Single Machine on a Single VPN Server
```bash
sudo ./MachineVPNtest.sh -m single 
```
Test a Single StartingPoint Machine on a StartingPoint VPN Server
```bash
sudo ./MachineVPNtest.sh -m startingpoint -v
```
When prompted, enter the machine name and VPN server name as needed.

Machines that can be used to test : All Active Machines, All Starting Point machines. 
VPN Servers that can be used to test: All VPN Free, VIP and VIP+ servers.

----
### Disclamer
This script is intended for use with Hack The Box and requires appropriate permissions and credentials. Ensure you have the necessary App token and access rights before running the script.
