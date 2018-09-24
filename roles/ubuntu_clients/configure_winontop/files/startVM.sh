#!/bin/bash

# Startscript for Virtual Machines
# Idee from VlizedLab http://www.vlizedlab.at/
# Changes by Reinhard Fink
# call Script with Parameters
#
# 1:	Path/Filename of Virtual Machine Harddisk File with Ending .vdi
#
# 2:	VBoxManage Option1 Option1-Parameter
#	VBoxManage Option1 Option1-Parameter Option2 Option2-Parameter
#
# Examples: 
#	startVM.sh /opt/vms/win7.vdi			  
#   	starts Virtualmachine win.vdi in directory /opt/vms
#
#	startVM	/opt/vms/win7.vdi --acpi off 
#   	starts Virtualmachine win7.vdi in directory /opt/vms and 
#   	turns acpi off. 
#	Script will call VBoxManage modifyvm $MACHINE --acpi off 
#	
# Create Variables and Directories ######################################################


## Helper function for inotify - pdf - printer - spooler
#~ function killInotifyWait()
#~ {
	#~ # check, if an inotifywait process is running and kill it
	#~ LOST_INOTIFY=$(ps ef | grep "inotifywait -e close_write $DIRECTORY_TO_MONITOR" | grep -v grep |  awk '{ print $1 }')
	#~ if [ ! "$LOST_INOTIFY" = "" ];
	#~ then
		#~ kill $LOST_INOTIFY
	#~ fi
#~ }

## Set variables
echo "Set variables"

MACHINE_PATH_AND_FILE=$1

MACHINE_PATH=$(dirname $MACHINE_PATH_AND_FILE)

MACHINE_FILE=$(basename $MACHINE_PATH_AND_FILE)

MACHINE_NAME=${MACHINE_FILE%.vdi}

MACHINE_WORK_DIR=/tmp/${USER}_vms

echo "Looking for $MACHINE_FILE in $MACHINE_PATH to create machine $MACHINE_NAME"
echo "Working directory for current running VM:  $MACHINE_WORK_DIR"

if [ ! -f $MACHINE_PATH_AND_FILE ];
then
	echo "File "$MACHINE_PATH_AND_FILE" does not exist"
	echo "--- AUTOMATIK UPDATE TRY LATER! ---"
	echo "--- OR WRONG FILENAME! ---"
	exit
fi

echo "Clean & create machine work directory"
if [ -d $MACHINE_WORK_DIR ];
then
	rm -R $MACHINE_WORK_DIR
fi
mkdir -p $MACHINE_WORK_DIR

# Directories for shares
INF_LEHRER_DIR="/netzordner/inf-lehrer"
echo "Directory for: " $INF_LEHRER_DIR

INF_SCHUELER_DIR="/netzordner/inf-schueler"
echo "Directory for: " $INF_SCHUELER_DIR

INF_MATERIAL_DIR="/netzordner/inf-material"
echo "Directory for: " $INF_MATERIAL_DIR

INF_CNAP_DIR="/netzordner/inf-cnap"
echo "Directory for: " $INF_CNAP_DIR

#PROGRAMMES_DIR="/home/shares/programmes"
#echo "Directory for: " $PROGRAMMES_DIR

CONFIG_WINONTOP_DIR=$MACHINE_STORAGE_DIR"/configwinontop"
echo "Config Directory for WinOnTop: " $CONFIG_WINONTOP_DIR

# Directories for PDF - Spooler
DIRECTORY_TO_MONITOR="$HOME/pdf-spooler"
echo "Spooler directory for PDF-printer >>Printer_sw<< printing from  WinOnTop: " $DIRECTORY_TO_MONITOR

DIRECTORY_TO_MONITOR_FOR_COLOR="$DIRECTORY_TO_MONITOR/color"
echo "Spooler directory for PDF-printer >>Printer_color<< printing from  WinOnTop: " $DIRECTORY_TO_MONITOR_FOR_COLOR

# check, if Color-Printer available
# COLOR_PRINTER_NAME=Printer-Color
COLOR_PRINTER_NAME=$(lpstat -p | grep color | awk '{ print $2 }')
echo "Color printer: " $COLOR_PRINTER_NAME

# Manage Virtualbox Configuration Directorys
echo "Manage Virtualbox configuration directorys"
echo "Save original .VirtualBox directory, if exists and .VirtualBox.$USER does not exist"
if [ -d $HOME/.config/VirtualBox ] && [ ! -d $HOME/.VirtualBox.$USER ];
then
	mv $HOME/.config/VirtualBox $HOME/.VirtualBox.$USER/
fi

# Set ramsize for host
HOST_RAM=$((1536 + 0))
#HOST_RAM=$((2048 + 0))
# Get available ramsize from host
VM_RAM=$(cat /proc/meminfo | grep MemTotal: | awk -F' ' '{ print $2 }' )
# Ramsize im MB
VM_RAM=$(($VM_RAM / 1024))
# Calculate VM_RAM
VM_RAM=$(($VM_RAM - $HOST_RAM))
#VM_RAM=1024
echo "Ram Size for VM: " $VM_RAM

# Create virtual machine ################################################################
#
echo "Create virtual machine"
VBoxManage --nologo createvm --name $MACHINE_NAME --register --basefolder $MACHINE_WORK_DIR
# OS
VBoxManage --nologo modifyvm $MACHINE_NAME --ostype Windows10_64
# CPU + GPU
VBoxManage --nologo modifyvm $MACHINE_NAME --cpus 4
VBoxManage --nologo modifyvm $MACHINE_NAME --memory $VM_RAM
VBoxManage --nologo modifyvm $MACHINE_NAME --vram 128
VBoxManage --nologo modifyvm $MACHINE_NAME --accelerate3d on
VBoxManage --nologo modifyvm $MACHINE_NAME --accelerate2dvideo on
VBoxManage --nologo modifyvm $MACHINE_NAME --acpi on
# ioacoi off IMPORTANT: otherwise Windows 7 wants to reinstall CPU - Driver
# VBoxManage --nologo modifyvm $MACHINE_NAME --ioapic off  ## am APP off
VBoxManage --nologo modifyvm $MACHINE_NAME --ioapic on
VBoxManage --nologo modifyvm $MACHINE_NAME --hwvirtex on
VBoxManage --nologo modifyvm $MACHINE_NAME --pae off
# BIOS
VBoxManage --nologo modifyvm $MACHINE_NAME --bioslogofadein off
VBoxManage --nologo modifyvm $MACHINE_NAME --bioslogofadeout off
VBoxManage --nologo modifyvm $MACHINE_NAME --bioslogodisplaytime 1
# NetworkAdapter
VBoxManage --nologo modifyvm $MACHINE_NAME --nictype1 82540EM
VBoxManage --nologo modifyvm $MACHINE_NAME --nic1 nat
# plug in virtuall cable into networkAdapter (needed since somwhere 5.0.40 and 5.1.30)
VBoxManage --nologo modifyvm $MACHINE_NAME --cableconnected1 on
#VBoxManage --nologo modifyvm $MACHINE_NAME --macaddress1 0800276D37F9
# Set address space for internal networkAdapter 
VBoxManage --nologo modifyvm $MACHINE_NAME --natnet1 192.168.254.0/24
# AudioAdapter
# "alsa" was working perfect in Ubuntu 16.04, but has bad sound in 18.04
# so switch to "pulse", which works on 16.04 and 18.04
# VBoxManage --nologo modifyvm $MACHINE_NAME --audio alsa --audiocontroller hda
VBoxManage --nologo modifyvm $MACHINE_NAME --audio pulse --audiocontroller hda
VBoxManage --nologo modifyvm $MACHINE_NAME --audiocontroller hda
# switch audio in/out on (needed since somwhere 5.2.??)
VBoxManage --nologo modifyvm $MACHINE_NAME --audioin on
VBoxManage --nologo modifyvm $MACHINE_NAME --audioout on
# --boot<1-4> none|floppy|dvd|disk|net
VBoxManage --nologo modifyvm $MACHINE_NAME --boot1 disk
# Create storage adapters
echo "Create harddisk controller for virtual machine"
# IDE
VBoxManage --nologo storagectl $MACHINE_NAME --name IDE-Controller-$MACHINE_NAME --add ide --controller PIIX4 --hostiocache on
# SATA
VBoxManage --nologo storagectl $MACHINE_NAME --name SATA-Controller-$MACHINE_NAME --add sata --controller IntelAHCI --portcount 1 --hostiocache off

#echo "Link Machine VDI from Storage Directory to Work Directory"
#ln -s $MACHINE_STORAGE_DIR/$MACHINE.vdi $MACHINE_WORK_DIR/$MACHINE/$MACHINE.vdi

echo "Attach Harddisk to Virtual Machine"
#VBoxManage --nologo storageattach $MACHINE_NAME --storagectl SATA-Controller-$MACHINE_NAME --port 0 --device 0 --type hdd --medium $MACHINE_WORK_DIR/$MACHINE_NAME/$MACHINE_FILE --mtype immutable
VBoxManage --nologo storageattach $MACHINE_NAME --storagectl SATA-Controller-$MACHINE_NAME --port 0 --device 0 --type hdd --medium $MACHINE_PATH_AND_FILE --mtype immutable
echo "Set Display Settings/Supress Notifications"
VBoxManage setextradata global GUI/SuppressMessages confirmGoingFullscreen,confirmInputCapture,remindAboutAutoCapture,remindAboutWrongColorDepth,remindAboutMouseIntegration

VBoxManage setextradata $MACHINE_NAME GUI/Fullscreen on
VBoxManage setextradata $MACHINE_NAME GUI/ShowMiniToolBar no

# Apply command line options from script to VBoxManage  
if [ ! -z $2 ];
then 
	echo "Apply command line options NR 1 from script to VBoxManage "
	VBoxManage --nologo modifyvm $MACHINE_NAME $2 $3
fi
if [ ! -z $4 ];
then 
	echo "Apply command line options NR 2 from script to VBoxManage "
	VBoxManage --nologo modifyvm $MACHINE_NAME $4 $5
fi


# Create Shared Folder
# Folders, witch are mounted inside Virtual Windows every time, via script mountshares.cmd in .../Autostart
echo "Createing shared Folders"
#~ if [ -d $SCHUELER_DIR ];
#~ then
	#~ echo "Create shared Folder for Directory: "$SCHUELER_DIR
	#~ VBoxManage sharedfolder add $MACHINE_NAME --name schueler --hostpath $SCHUELER_DIR
#~ fi
#~ if [ -d $LEHRMATERIAL_DIR ];
#~ then
	#~ echo "Create shared Folder for Directory: "$LEHRMATERIAL_DIR
	#~ VBoxManage sharedfolder add $MACHINE_NAME --name lehrmaterial --hostpath $LEHRMATERIAL_DIR
#~ fi
#~ if [ -d $OPT_PROG_DIR ];
#~ then
	#~ echo "Create shared Folder for Directory: "$OPTPROGS_DIR
	#~ VBoxManage sharedfolder add $MACHINE_NAME --name optProgs --hostpath $OPTPROGS_DIR
#~ fi



echo "Create shared folder for USB"
VBoxManage sharedfolder add $MACHINE_NAME --name USB-Storage --hostpath /media 

echo "Create shared folder for home directory: "$HOME
VBoxManage --nologo sharedfolder add $MACHINE_NAME --name persönlicher_Ordner --hostpath $HOME

echo "Create shared folder for inf_lehrer: "$INF_LEHRER_DIR
VBoxManage --nologo sharedfolder add $MACHINE_NAME --name inf-lehrer --hostpath $INF_LEHRER_DIR

echo "Create shared folder for home directory: "$INF_SCHUELER_DIR
VBoxManage --nologo sharedfolder add $MACHINE_NAME --name inf-schueler --hostpath $INF_SCHUELER_DIR

echo "Create shared folder for inf_lehrer: "$INF_MATERIAL_DIR
VBoxManage --nologo sharedfolder add $MACHINE_NAME --name inf-material --hostpath $INF_MATERIAL_DIR

echo "Create shared folder for home directory: "$INF_CNAP_DIR
VBoxManage --nologo sharedfolder add $MACHINE_NAME --name inf-cnap --hostpath $INF_CNAP_DIR


# Starts VM ################################################################
#
echo "Start virtual machine"
# Starts VM and return to this script, when VM shuts down

VirtualBox --startvm $MACHINE_NAME --fullscreen

# Restore drectories/##############################################
#
echo "Restore all Virtualbox config - directories"
echo "Wait for 5 seconds to shutdown virtual machine"
sleep 5
rm -R $HOME/.config/VirtualBox
rm -R $MACHINE_WORK_DIR
echo "Restore original .config/VirtualBox Directory if exists."
if [ -d $HOME/.VirtualBox.$USER ];
then
	mv $HOME/.VirtualBox.$USER $HOME/.config/VirtualBox/
fi

