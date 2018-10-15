# epoc-compliance

# Install procedures
```
Important! Ensure that you have accessed the Apple App Store before executing this script.
1. Open terminal
2. If not already there, cd ~
3. git clone https://github.com/jmcclenny-epoc/epoc-compliance.git
4. cd epoc-compliance
5. ./configure-rc-compliance.sh

See below for individual script usage.
```
This project is to provision the compliance script for disabling specific functions of the MacBook to bring into secure facilities.

## Programs installed to make my life easier
    - Homebrew (version: latest)

## Packages installed with homebrew:   

    - blueutil (version: latest) 

```
#### Compliance Usage:
```
To make the MacBook compliant to our security standards, please run:
./rc-compliance.sh enable 
To remove the security compliance, please run:
./rc-compliance.sh disable
```