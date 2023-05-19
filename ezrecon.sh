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

# Main script

# Check the number of arguments
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <IP address | file>"
    exit 1
fi

# Process the argument
if [[ -f "$1" ]]; then
    # Argument is a file containing a list of IPs
    ip_file=$1

    # Loop through each IP in the file
    while IFS= read -r ip || [[ -n "$ip" ]]; do
        echo "Scanning IP: $ip"
        
        # Create a subdirectory for the IP within the main directory
        output_dir="$ip"
        mkdir -p "$output_dir"
        
        # Conduct the nmap scan
        conduct_nmap_scan "$ip" "$output_dir"
        
        # Conduct the version and OS scan
        conduct_version_os_scan "$ip" "$output_dir"
        
        # Conduct the nikto scan on ports 80 and 443
        conduct_nikto_scan "$ip" "$output_dir"
        
        echo "Scan completed for IP: $ip"
        echo
    done < "$ip_file"
else
    # Argument is a single IP address
    ip=$1
    echo "Scanning IP: $ip"
    
    # Create a subdirectory for the IP within the main directory
    output_dir="$ip"
    mkdir -p "$output_dir"
    
    # Conduct the nmap scan
    conduct_nmap_scan "$ip" "$output_dir"
    
    # Conduct the version and OS scan
    conduct_version_os_scan "$ip" "$output_dir"
    
    # Conduct the nikto scan on ports 80 and 443
    conduct_nikto_scan "$ip" "$output_dir"
    
    echo "Scan completed for IP: $ip"
fi
