Used to take a backup of Vaultwarden on unRAID (can be used on anything, but I made it for it).
Vaultwarden: https://github.com/dani-garcia/vaultwarden

All options are in the file, but you need to make a few folders inside the backup folder you intend to use.

The folderstructure needs to be like this:
./your-backup-folder

├── attachments

├── config

├── database

├── icon_cache

├── rsa

└── sends

If you fail to create these folders the script will fail.

I used a great plugin for unRAID called User Scripts to make it easy to schedule and run the script.
User Scripts: https://forums.unraid.net/topic/48286-plugin-ca-user-scripts/
Note this can be installed via Community Applications on unRAID.
Community Applications: https://forums.unraid.net/topic/38582-plug-in-community-applications/
