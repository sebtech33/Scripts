#!/bin/bash
set -Eeuo pipefail

#########################################################################
# Author:  Sebastian Eliassen
# Project: https://github.com/sebtech33/Scripts/tree/main/unRAID/Vaultwarden%20Backup
# Issues:  https://github.com/sebtech33/Scripts/issues
#########################################################################
#                                                                       #
# MIT License                                                           #
#                                                                       #
# Copyright (c) 2023 Sebastian Eliassen                                 #
#                                                                       #
# Permission is hereby granted, free of charge, to any person obtaining #
# a copy of this software and associated documentation files            #
# (the "Software"), to deal in the Software without restriction,        #
# including without limitation the rights to use, copy, modify, merge,  #
# publish, distribute, sublicense, and/or sell copies of the Software,  #
# and to permit persons to whom the Software is furnished to do so,     #
# subject to the following conditions:                                  #
#                                                                       #
# The above copyright notice and this permission notice shall be        #
# included in all copies or substantial portions of the Software.       #
#                                                                       #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,       #
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF    #
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.#
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY  #
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,  #
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE     #
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                #
#                                                                       #
#########################################################################


#########################################################################
# BITWARDEN AND BACKUP PATH                                             #
#########################################################################
# NOTE: Both path's must be without trailing '/'                        #
#########################################################################

# Bitwarden/Vaultwarden volume path:
BITWARDEN_LOCATION=/mnt/user/appdata/bitwarden

# Backup path:
BACKUP_LOCATION=/mnt/user/backups/Bitwarden


#########################################################################
# BACKUP OPTIONS                                                        #
#########################################################################
# NOTE: This uses cp for backups so a modification is needed if you     #
# want to use scp (for remote backups)                                  #
#########################################################################

# Backup Config.json? - Backup recommended
CONFIG=true # true | false (Default: true)

# Backup Database? - Backup required
DATABASE=true # true | false (Default: true)

# Backup RSA? - Backup recommended
RSA=true # true | false (Default: true)

# Backup Attachments? - Backup required
ATTACHMENTS=true # true | false (Default: true)

# Backup Sends? - Backup optional
SENDS=true # true | false (Default: true)

# Backup Icon Cache? - Backup optional
ICON_CACHE=true # true | false (Default: true)


#########################################################################
# BACKUP RETENTION/CLEAR OLD BACKUPS                                    #
#########################################################################
# NOTE: This will delete all the files older than the BACKUP_RETENTION  #
# in all folders, but if there are no files older than the              #
# BACKUP_RETENTION no files will be touched.                            #
#########################################################################

# Clear old backups?
CLEAR_OLD_BACKUPS=true # true | false (Default: true)

# Select how many backups that will be saved
# before the older ones are deleted.
BACKUP_RETENTION=33 # Files not days


#########################################################################
# SCRIPT START (DO NOT EDIT UNLESS YOU KNOW WHAT YOUR DOING)            #
#########################################################################

echo ""

# Sets the backup locations in a variable list
BACKUP_LOCATIONS=("$BACKUP_LOCATION/config"
                  "$BACKUP_LOCATION/database"
                  "$BACKUP_LOCATION/rsa"
                  "$BACKUP_LOCATION/attachments"
                  "$BACKUP_LOCATION/sends"
                  "$BACKUP_LOCATION/icon_cache")


#########################################################################
# BACKUP FILES                                                          #
#########################################################################

if [ $CONFIG = true ]; then # Backup config.json
    echo "Starting backup of config"
    echo "..."
    cp "$BITWARDEN_LOCATION/config.json" "${BACKUP_LOCATIONS[0]}/config-$(date '+%Y%m%d-%H%M').json"
    echo "Done"
    echo ""
elif [ $CONFIG = false ]; then
    echo "Skipping backup of config"
    echo ""
fi
if [ $DATABASE = true ]; then # Backup database
    echo "Starting backup of database"
    echo "..."
    sqlite3 $BITWARDEN_LOCATION/db.sqlite3 ".backup '${BACKUP_LOCATIONS[1]}/db-$(date '+%Y%m%d-%H%M').sqlite3'"
    echo "Done"
    echo ""
elif [ $DATABASE = false ]; then
    echo "Skipping backup of database"
    echo ""
fi
if [ $RSA = true ]; then # Backup rsa files to folder
    echo "Starting backup of rsa files"
    echo "..."
    RSA_OUT="${BACKUP_LOCATIONS[2]}/rsa-$(date '+%Y%m%d-%H%M')/"
    mkdir -p $RSA_OUT
    cp "$BITWARDEN_LOCATION/rsa_key.der" \
       "$BITWARDEN_LOCATION/rsa_key.pem" \
       "$BITWARDEN_LOCATION/rsa_key.pub.der" \
       "$BITWARDEN_LOCATION/rsa_key.pub.pem" \
       "$RSA_OUT"
    echo "Done"
    echo ""
elif [ $RSA = false ]; then
    echo "Skipping backup of rsa"
    echo ""
fi
if [ $ATTACHMENTS = true ]; then # Backup attachments folder
    echo "Starting backup of attachments"
    echo "..."
    cp -r "$BITWARDEN_LOCATION/attachments" "${BACKUP_LOCATIONS[3]}/attach-$(date '+%Y%m%d-%H%M')/"
    echo "Done"
    echo ""
elif [ $ATTACHMENTS = false ]; then
    echo "Skipping backup of attachments"
    echo ""
fi
if [ $SENDS = true ]; then # Backup sends folder
    echo "Starting backup of sends"
    echo "..."
    cp -r "$BITWARDEN_LOCATION/sends" "${BACKUP_LOCATIONS[4]}/sends-$(date '+%Y%m%d-%H%M')/"
    echo "Done"
    echo ""
elif [ $SENDS = false ]; then
    echo "Skipping backup of sends"
    echo ""
fi
if [ $ICON_CACHE = true ]; then # Backup icon cache folder
    echo "Starting backup of icon cache"
    echo "..."
    cp -r "$BITWARDEN_LOCATION/icon_cache" "${BACKUP_LOCATIONS[5]}/icon_cache-$(date '+%Y%m%d-%H%M')/"
    echo "Done"
    echo ""
elif [ $ICON_CACHE = false ]; then
    echo "Skipping backup of icon cache"
    echo ""
fi


#########################################################################
# CLEAR OLD BACKUPS                                                     #
#########################################################################

if [ $CLEAR_OLD_BACKUPS = true ]; then
    echo "Cleaning up old backups:"
    for BACKUPS in "${BACKUP_LOCATIONS[@]}"; do
        echo ""
        echo "Location: $BACKUPS/"
        REMOVE_OVER_RETENTION=$(ls -t -1 $BACKUPS/ | tail -n +$((BACKUP_RETENTION+1)))
        echo "File(s) to remove:"
        echo "$REMOVE_OVER_RETENTION"
        echo ""
        echo "Removing:"
        for LINE in $REMOVE_OVER_RETENTION; do
            if [ -f "$BACKUPS/$LINE" ]; then
                echo "$LINE"
                rm "$BACKUPS/$LINE"
            elif [ -d "$BACKUPS/$LINE/" ]; then
                echo "$LINE/"
                rm -r "$BACKUPS/$LINE/"
            else
                echo ""
                echo "Error: Couldn't remove the following file(s):"
                echo "$BACKUPS/$LINE"
            fi
        done
        echo ""
    done
elif [ $CLEAR_OLD_BACKUPS = false ]; then
    echo "Skipping deletion old backup file(s):"
    echo ""
    for BACKUPS in "${BACKUP_LOCATIONS[@]}"; do
        OVER_RETENTION=$(ls -t -1 $BACKUPS/ | tail -n +$((BACKUP_RETENTION+1)))
        echo "$OVER_RETENTION"
    done
else
    echo "Error: Something else went wrong when trying to remove old backups"
fi

echo ""
echo "All done, you can close this window now."
echo ""
