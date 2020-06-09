
# ezrecon

 > This tool performs basic recon used for HTB/vulnhub. This tool is easy to use and just requires an input of an IP.
 The results are stored in easy to read formats in a single location.


**ezrecon**

<a href="https://imgur.com/9cO4xn9.png">
  <img src="https://imgur.com/9cO4xn9.png" />
</a>

---

## Table of Contents 

- [Installation](#installation)
- [Requirements](#requirements)
- [Features](#features)
- [Documentation](#documentation)
- [Future Updates](#future-updates)
---


## Installation

- git clone `https://github.com/dalemazza/ezrecon.git` 
- run `python3 ezrecon`

---

## Features

- Performs a basic nmap scan against a target IP
- Performs an OS & version detection,Script Scanning and Traceroute scan for the open ports
- If port 80 is found open
  - Runs a Nikto scan
  - Runs a ffuf scan
- Finally it runs a full port scan to check or missed ports
- All scan results are placed into a single folder in the recon dir `/home/kali/reports/`


## Future-Updates

- Fix the input to only accept IP's
- Fix the directory to cater for non "kali" usernames
- Compare the new ports found in the full scan against the basic ports
