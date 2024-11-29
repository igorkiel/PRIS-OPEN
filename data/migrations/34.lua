function onUpdateDatabase()
	db.query([[ALTER TABLE `guild_members` ADD `contribution` BIGINT UNSIGNED NOT NULL DEFAULT 0;]])
	return true
end