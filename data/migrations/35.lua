function onUpdateDatabase()
	db.query([[ALTER TABLE `guilds` ADD `buffs_save` BIGINT UNSIGNED NOT NULL DEFAULT 0;]])
	return true
end