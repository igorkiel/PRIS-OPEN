function onUpdateDatabase()
	print(">> [GUILDS] Moving old inbox into new, might take a while, one time operation")

	db.query("RENAME TABLE `guilds_inbox` TO `guilds_inbox_old`;")

	db.query(
		[[CREATE TABLE IF NOT EXISTS `guilds_inbox` (
		`id` INT NOT NULL AUTO_INCREMENT,
		`target_id` INT NOT NULL DEFAULT '0',
		`guild_id` INT NOT NULL DEFAULT '0',
		`date` BIGINT(20) UNSIGNED NOT NULL,
		`type` TINYINT NOT NULL,
		`text` VARCHAR(255) NOT NULL,
		`finished` TINYINT NOT NULL DEFAULT '0',
		PRIMARY KEY (`id`)
	);]]
	)

	db.query(
		[[CREATE TABLE IF NOT EXISTS `guilds_player_inbox` (
		`player_id` INT NOT NULL,
		`inbox_id` INT NOT NULL,
		FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE,
		FOREIGN KEY (`inbox_id`) REFERENCES `guilds_inbox` (`id`) ON DELETE CASCADE);]]
	)

	db.query(
		[[INSERT INTO guilds_inbox (target_id, guild_id, date, type, text, finished)
		SELECT target_id, guild_id, date, type, text, finished
		FROM guilds_inbox_old
		GROUP BY target_id, guild_id, date, type, text, finished;]]
	)

	db.query(
		[[INSERT INTO guilds_player_inbox (player_id, inbox_id)
		SELECT old.player_id, new.id
		FROM guilds_inbox_old AS old
		JOIN guilds_inbox AS new ON
				old.target_id = new.target_id
				AND old.guild_id = new.guild_id
				AND old.date = new.date
				AND old.type = new.type
				AND old.text = new.text
				AND old.finished = new.finished;]]
	)
	return true
end