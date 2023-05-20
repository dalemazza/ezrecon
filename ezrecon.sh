#!/bin/bash

# Function to conduct an nmap scan
conduct_nmap_scan() {
    local ip=$1
    local output_dir=$2
    
    # Perform nmap scan and save results to a file
    nmap -oN "${output_dir}/${ip}_nmap_scan.txt" $ip
}

# Function to conduct a version and OS scan against open ports
conduct_version_os_scan() {
    local ip=$1
    local output_dir=$2
    
    # Read open ports from nmap scan results
    open_ports=$(grep -E '^[0-9]+/open' "${output_dir}/${ip}_nmap_scan.txt" | cut -d '/' -f 1)
    
    # Perform version and OS scan against open ports
    nmap -oN "${output_dir}/${ip}_version_os_scan.txt" -p $open_ports -sV -O $ip
}

# Function to conduct a nikto scan on ports 80 and 443
conduct_nikto_scan() {
    local ip=$1
    local output_dir=$2
    
    # Check if ports 80 or 443 are open
    if grep -qE '^(80|443)/open' "${output_dir}/${ip}_nmap_scan.txt"; then
        # Perform nikto scan on open ports
        nikto -h $ip -p 80,443 -o "${output_dir}/${ip}_nikto_scan.txt"
    fi
}

# Help function
display_help() {
    echo "Usage: $0 [OPTIONS] <IP address | file>"
    echo "OPTIONS:"
    echo "  -h, --help           Display this help message and exit"
    echo "  -d, --directory DIR  Specify the directory name to store the results"
    echo
    echo "EXAMPLES:"
    echo "  $0 192.168.1.100           # Scan a single IP address"
    echo "  $0 ips.txt                # Scan a list of IP addresses from a file"
    echo "  $0 -d scan_results 192.168.1.100   # Specify a custom directory name"
    exit 0
}

# Main script

# Check if no arguments are provided or if the first argument is "--help" or "-h"
if [[ $# -eq 0 || "$1" == "--help" || "$1" == "-h" ]]; then
    display_help
fi

# Set default directory name
directory_name="scan_results"

# Process the arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -d|--directory)
            directory_name="$2"
            shift 2
            ;;
        *)
            break
            ;;
    esac
done

# Create the directory to store the results
mkdir -p "$directory_name"

# Process the remaining argument(s)
if [[ -f "$1" ]]; then
    # Argument is a file containing a list of IPs
    ip_file=$1

    # Loop through each IP in the file
    while IFS= read -r ip || [[ -n "$ip" ]]; do
        echo "Scanning IP: $ip"
        
        # Create a subdirectory for the IP within the main directory
        output_dir="$directory_name/$ip"
        mkdir -p "$output_dir"
        
        # Conduct the nmap scan
        conduct_nmap_scan "$ip" "$output_dir"
        
        # Conduct the version and OS scan
        conduct_version_os_scan "$ip"
