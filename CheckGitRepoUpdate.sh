#!/bin/bash
# 2018/01/17 Mike Chen
# Check remote GIT repo is up to date.
# If not, show what's update recently.

#Define Dirs
E911_DIR=/media/Data/Projects/E911/MDM9607_APPS_000803
SDX20_DIR=/media/Data/Projects/SDX20/sdx20_app_20171206
PRJ_LIST="$E911_DIR $SDX20_DIR"
PRJ_NAME=("E911" "SDX20")
i=0
for PROJECT in $PRJ_LIST
do
	echo "============================"
	echo "     Check ${PRJ_NAME[i]} remote"
	echo "============================"
	if [  -e ${PROJECT} ] ; then
		cd ${PROJECT}
		# Show original update items	
		#git remote show origin
		# if local out of date, show diff without fetch
		if git remote show origin | grep "local out of date" &> /dev/null; then
			echo -e "\e[0;31m Found new updates in remote/master!\e[0m"
			echo "┏━━━━━━━━━━━━━━━ New Commits ━━━━━━━━━━━━━━━━━┓"
			echo "▼                                             ▼"
			git fetch -v --dry-run 2>&1 | sed '1d' | awk '{print $1}'
			git log `git fetch -v --dry-run 2>&1 | sed '1d' | awk '{print $1}'`
			echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"
		else
			echo -e "\e[0;32m Local branch is up to date.\e[0m"
			echo
		fi
	else
		echo "${PRJ_NAME[i]} directory not exist!"
	fi
	((i++))
done

