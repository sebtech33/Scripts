Used to take a backup of [Vaultwarden](https://github.com/dani-garcia/vaultwarden) on [unRAID](https://unraid.net/) (can be used on anything, but I made it for this).

I made the script by following [their recommended way](https://github.com/dani-garcia/vaultwarden/wiki/Backing-up-your-vault#sqlite-database-files) to backup the database.

All options are in the file, but you need to make a few folders inside the backup folder you intend to use.

The folderstructure needs to be like this:

```
./your-backup-folder
├── attachments
├── config
├── database
├── icon_cache
├── rsa
└── sends
```

If you fail to create these folders the script will fail.

I used a great plugin for unRAID called [User Scripts](https://forums.unraid.net/topic/48286-plugin-ca-user-scripts/) to make it easy to schedule and run the script.

Note: User scripts can be installed via [Community Applications](https://forums.unraid.net/topic/38582-plug-in-community-applications/) on unRAID.

I'm NOT by any means an expert on scripting, I just like to have some fun and try. So the script may not be up to everyone's standard, so if you have some suggestions/fixes you are more than welcome to create an Issue or create a PR.
