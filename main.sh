#!/bin/bash

function connect {
	if [ "$1" != "" ]; then
		#nothing, as it is connected by cable
		echo
	else
		adb forward tcp:4444 localabstract:/adb-hub; adb connect localhost:4444
	  	echo -e "#!/bin/bash
adb forward tcp:4444 localabstract:/adb-hub; adb connect localhost:4444" > connect.sh
		chmod 777 connect.sh
		echo "Generated connect script"
	fi
}

function generateInstallScript {
	if [ "$1" != "" ]; then
	  echo -e "#!/bin/bash
adb -s" $1 " install $1" > install.sh
	else
	  echo -e "#!/bin/bash
adb -s localhost:4444 install $1" > install.sh
	fi
	chmod 777 install.sh
	echo "Generated install script"
}

function generateUninstallScript {
	if [ "$1" != "" ]; then
	  echo -e "#!/bin/bash
adb -s" $1 " uninstall $1" > uninstall.sh
	else
	  echo -e "#!/bin/bash
adb -s localhost:4444 uninstall $1" > uninstall.sh
	fi
	chmod 777 uninstall.sh
	echo "Generated uninstall script"
}

function generateListPackagesScript {
	if [ "$1" != "" ]; then
	  echo -e "#!/bin/bash
adb -s" $1 " shell 'pm list packages -f' | sed -e 's/.*=//' | sort" > listPackages.sh
	else
	  echo -e "#!/bin/bash
adb -s localhost:4444 shell 'pm list packages -f' | sed -e 's/.*=//' | sort" > listPackages.sh
	fi
	chmod 777 listPackages.sh
	echo "Generated list packages script"
}

function generateScreenshotScript {
	if [ "$1" != "" ]; then
  	  echo -e "#!/bin/bash
rand=\$RANDOM
adb -s " $1 " shell screencap -p /sdcard/screenshot\$rand.png
sleep 1
adb -s " $1 " pull /sdcard/screenshot\$rand.png
echo Screenshot: screenshot\$rand.png" > screenshot.sh
	else
	  echo -e "#!/bin/bash
rand=\$RANDOM
adb -s localhost:4444 shell screencap -p /sdcard/screenshot\$rand.png
sleep 1
adb -s localhost:4444 pull /sdcard/screenshot\$rand.png
echo Screenshot: screenshot\$rand.png" > screenshot.sh
	fi
	chmod 777 screenshot.sh
	echo "Generated screenshot script"
}

connect
generateInstallScript $1
generateUninstallScript $1
generateListPackagesScript $1
generateScreenshotScript $1