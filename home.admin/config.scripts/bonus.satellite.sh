#!/bin/bash

#               ______
#            ,'"       "-._
#          ,'              "-._ _._
#          ;              __,-'/ ₿ |
#         ;|           ,-' _,'"'._,.
#         |:            _,'      |\ `.
#         : \       _,-'         | \  `.
#          \ \   ,-'             |  \   \
#           \ '.         .-.     |       \
#            \  \         "      |        :
#             `. `.              |        |
#               `. "-._          |        ;
#               / |`._ `-._      L       /
#              /  | \ `._   "-.___    _,'
#             /   |  \_.-"-.___   """"
#             \   :            /"""
#              `._\_       __.'_
#         __,--''_ ' "--'''' \_  `-._
#   __,--'     .' /_  |   __. `-._   `-._
#  <            `.  `-.-''  __,-'     _,-'
#   `.            `.   _,-'"      _,-'
#     `.            ''"       _,-'
#       `.                _,-'
#         `.          _,-'
#           `.   __,'"
#             `'"

# command info
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "-help" ]; then
 echo "config script to setup Blockstream Satellite Kit"
 echo "bonus.satellite.sh [on|off|menu]"
 exit 1
fi

source /mnt/hdd/raspiblitz.conf

# add default value to raspi config if needed
if ! grep -Eq "^satellite=" /mnt/hdd/raspiblitz.conf; then
  echo "satellite=off" >> /mnt/hdd/raspiblitz.conf
fi

# show info menu
if [ "$1" = "menu" ]; then
  dialog --title " Info Blockstream Satellite " --msgbox "\n\
TODO: submenu
" 10 56
  exit 0
fi

# switch on
if [ "$1" = "1" ] || [ "$1" = "on" ]; then
  echo "*** INSTALL BLOCKSTREAM SATELLITE ***"

  # TODO: add introduction text + infos
  # - WARNING ONLY compatible with Blockstream Satellite Basic Kit 
  # - if the USB should be plugged in or not during setup
  # - how to alignment

  sudo apt update

  # install blocksat-cli
  sudo pip3 install blocksat-cli==0.2.9

  # config
  sudo runuser bitcoin -c 'blocksat-cli cfg'

  # [3] Telstar 11N Europe (T11N EU)
  # [1] TBS 5927 (Linux USB receiver)
  # [1] Satellite Dish (60cm / 24in)
  # [0] GEOSATpro UL1PLL (Universal Ku band LNBF)
  # reusing setup? no

  # mkdir /home/admin/.blocksat
  # cp /home/bitcoin/.blocksat/config* /home/admin/.blocksat/

  # instructions
  # sudo runuser -l bitcoin -c 'blocksat-cli instructions'

  # install drivers
  # manually as 'linux-headers-4.19.118-v7+' can't be found
  # sudo blocksat-cli deps --dry-run tbs-drivers
  sudo apt install -y make gcc git patch patchutils libproc-processtable-perl #linux-headers-4.19.118-v7+

  # TODO: fails with command "make allyesconfig;"
  # sudo runuser bitcoin -c '\
  #   mkdir /home/bitcoin/.blocksat/src; \
  #   mkdir /home/bitcoin/.blocksat/src/tbsdriver; \
  #   cd /home/bitcoin/.blocksat/src/tbsdriver; \
  #   git clone https://github.com/tbsdtv/media_build.git; \
  #   git clone --depth=1 https://github.com/tbsdtv/linux_media.git -b latest ./media; \
  #   cd /home/bitcoin/.blocksat/src/tbsdriver/media_build; \
  #   make cleanall; \
  #   make dir DIR=../media; \
  #   make allyesconfig; \
  #   make -j4; \
  #   make install; \
  # '

  # Download: https://www.tbsdtv.com/download/document/linux/tbs-tuner-firmwares_v1.0.tar.bz2
  # Save at: /home/bitcoin/.blocksat/src/tbsdriver
  cd /home/bitcoin/.blocksat/src/tbsdriver
  tar jxvf tbs-tuner-firmwares_v1.0.tar.bz2 -C /lib/firmware/

  # deps
  # TODO: "sudo add-apt-repository ppa:blockstream/satellite -y" fails "no distribution template for Raspbian/buster"
  # blocksat-cli --cfg-dir /home/bitcoin/.blocksat deps -y install

  # INFO: first get carrier, then get lock

  # blocksat-cli deps install --btc
  # y
  # y

  # blocksat-cli btc
  # y

  # reboot

  # sudo blocksat-cli usb config
  # creates network devices

  # check: sysctl net.core.rmem_max
  # set (if less): sudo sysctl -w net.core.rmem_max=24660008
fi

# switch off
if [ "$1" = "0" ] || [ "$1" = "off" ]; then
  # setting value in raspi blitz config
  sudo sed -i "s/^satellite=.*/satellite=off/g" /mnt/hdd/raspiblitz.conf

  # TODO

  exit 0
fi

echo "FAIL - Unknown Parameter $1"
exit 1
  
