#!/bin/bash

# install homebrew #
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
# install homebrew apps #
brew install blueutil

##### Create Ryan Center Compliance script #####
cd ~/workspace
echo '#!/bin/bash


if [ "$(which blueutil)" != "/usr/local/bin/blueutil" ]
then
    echo "blueutil is required to execute this script, please install: brew install blueutil"
    exit
fi

if [ "$1" == "disable" ]
then
    blueutil --power 1
    networksetup -setairportpower en0 on

    /usr/bin/sudo /usr/bin/defaults write /Library/Preferences/com.apple.driver.AppleIRController DeviceEnabled -bool TRUE

    /usr/bin/profiles remove -identifier mil.disa.STIG.Application_Restrictions.alacarte
    /usr/bin/profiles remove -identifier mil.disa.STIG.Restrictions.alacarte
    /usr/bin/profiles remove -identifier DisableSiriInMenubar
    /usr/bin/profiles remove -identifier DisableSiri

    osascript -e "set volume input volume 50" 
elif [ "$1" == "enable" ]
then
    # closes V-75965 in a different way. #
    # Reference: Apple OS X 10.12 Security Technical Implementation Guide #
    blueutil --power 0 #

    # closes V-75967 in a different way. #
    # Reference: Apple OS X 10.12 Security Technical Implementation Guide #
    networksetup -setairportpower en0 off
    
    # close V-75969 #       
    # Reference: Apple OS X 10.12 Security Technical Implementation Guide #
    /usr/bin/sudo /usr/bin/defaults write /Library/Preferences/com.apple.driver.AppleIRController DeviceEnabled -bool FALSE 

    # closes V-76051 #
    # Reference: Apple OS X 10.12 Security Technical Implementation Guide #
    # Please note that both profiles listed below are required to lockdown the camera. 
    # Application Restriction prevents FaceTime to be accessed, Restrictions Policy disables the camera and other apps. However, both are required to lock down the camera functionality. #
    /usr/bin/profiles install -path ~/workspace/epoc-compliance/U_Apple_OS_X_10-12_V1R3_Mobile_Configuration_Files/U_Apple_OS_X_10-12_V1R3_STIG_Application_Restrictions_Policy.mobileconfig
    /usr/bin/profiles install -path ~/workspace/epoc-compliance/U_Apple_OS_X_10-12_V1R3_Mobile_Configuration_Files/U_Apple_OS_X_10-12_V1R3_STIG_Restrictions_Policy.mobileconfig    

    # closes: V-76059
    # Reference: Apple OS X 10.12 Security Technical Implementation Guide  #
    # Disables Siri entirely

    /usr/bin/profiles install -path ~/workspace/epoc-compliance/EPOC_Configuration_Files/DisableSiri.mobileconfig
    /usr/bin/profiles install -path ~/workspace/epoc-compliance/EPOC_Configuration_Files/DisableSiriInMenubar.mobileconfig     

    # closes V-51323 #
    # Reference: Apple OS X 10.8 (Mountain Lion) Workstation STIG #
    # Please note that this finding was derived from an OLDER STIG check #
    osascript -e "set volume input volume 0" 
else
    echo "Incorrect argument, please enter enable or disable"
fi' > rc-compliance.sh
chmod +x rc-compliance.sh
