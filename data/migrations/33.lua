function onUpdateDatabase()
	print("> Updating database (New Guilds)")

	db.query("DROP TRIGGER IF EXISTS `oncreate_guilds`;")
	db.query("DROP TABLE IF EXISTS `guildwar_kills`;")
	db.query("DROP TABLE IF EXISTS `guild_wars`;")
	db.query("DROP TABLE IF EXISTS `guild_invites`;")
	db.query("DROP TABLE IF EXISTS `guild_membership`;")
	db.query("DROP TABLE IF EXISTS `guild_members`;")
	db.query("DROP TABLE IF EXISTS `guild_ranks`;")
	db.query("DROP TABLE IF EXISTS `guilds`;")
	db.query(
		[[CREATE TABLE IF NOT EXISTS `guilds` (
		`id` INT(11) NOT NULL AUTO_INCREMENT,
		`name` varchar(255) NOT NULL,
		`ownerid` INT(11) NOT NULL,
		`creationdata` BIGINT UNSIGNED NOT NULL DEFAULT 0,
		`level` INT UNSIGNED NOT NULL DEFAULT 1,
		`gold` BIGINT UNSIGNED NOT NULL DEFAULT 0,
		`buffs` BLOB DEFAULT NULL,
		`wars_won` INT UNSIGNED NOT NULL DEFAULT 0,
		`wars_lost` INT UNSIGNED NOT NULL DEFAULT 0,
		`motd` VARCHAR(255) NOT NULL DEFAULT '',
		`join_status` TINYINT NOT NULL DEFAULT 1,
		`language` TINYINT NOT NULL DEFAULT 1,
		`required_level` INT NOT NULL DEFAULT 1,
		`emblem` INT NOT NULL DEFAULT 1,
		`pacifism` BIGINT NOT NULL DEFAULT 0,
		`pacifism_status` TINYINT NOT NULL DEFAULT 0,
		PRIMARY KEY (`id`),
		UNIQUE KEY (`name`),
		UNIQUE KEY (`ownerid`),
		FOREIGN KEY (`ownerid`) REFERENCES `players`(`id`) ON DELETE CASCADE)]]
	)

	db.query(
		[[CREATE TABLE IF NOT EXISTS `guild_ranks` (
		`id` INT NOT NULL AUTO_INCREMENT,
		`guild_id` INT NOT NULL,
		`name` VARCHAR(255) NOT NULL,
		`permissions` INT NOT NULL DEFAULT 0,
		`default` TINYINT NOT NULL DEFAULT 0,
		`leader` TINYINT NOT NULL DEFAULT 0,
		PRIMARY KEY (`id`),
		FOREIGN KEY (`guild_id`) REFERENCES `guilds` (`id`) ON DELETE CASCADE);]]
	)

	db.query(
		[[CREATE TABLE IF NOT EXISTS `guild_members` (
		`player_id` INT NOT NULL,
		`guild_id` INT NOT NULL,
		`rank_id` INT NOT NULL,
		`nick` varchar(15) NOT NULL DEFAULT '',
		`leader` TINYINT NOT NULL DEFAULT 0,
		PRIMARY KEY (`player_id`),
		FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
		FOREIGN KEY (`guild_id`) REFERENCES `guilds` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    	FOREIGN KEY (`rank_id`) REFERENCES `guild_ranks` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION);]]
	)

	db.query(
		[[CREATE TABLE IF NOT EXISTS `guilds_inbox` (
		`player_id` INT NOT NULL,
		`target_id` INT NOT NULL DEFAULT '0',
		`guild_id` INT NOT NULL DEFAULT '0',
		`date` BIGINT(20) UNSIGNED NOT NULL,
		`type` TINYINT NOT NULL,
		`text` VARCHAR(255) NOT NULL,
		`finished` TINYINT NOT NULL DEFAULT '0',
		FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE);]]
	)

	db.query(
		[[CREATE TABLE IF NOT EXISTS `guild_wars` (
		`id` INT NOT NULL AUTO_INCREMENT,
		`guild1` INT NOT NULL DEFAULT 0,
		`guild2` INT NOT NULL DEFAULT 0,
		`status` TINYINT NOT NULL DEFAULT 0,
		`goldBet` INT NOT NULL DEFAULT 0,
		`duration` BIGINT(20) NOT NULL DEFAULT 0,
		`killsMax` INT NOT NULL DEFAULT 0,
		`forced` TINYINT NOT NULL DEFAULT 0,
		`started` BIGINT(20) NOT NULL DEFAULT 0,
		`ended` BIGINT(20) NOT NULL DEFAULT 0,
		`winner` INT NOT NULL DEFAULT 0,
		PRIMARY KEY (`id`),
		KEY `guild1` (`guild1`),
		KEY `guild2` (`guild2`),
		KEY `winner` (`winner`),
		FOREIGN KEY (`guild1`) REFERENCES `guilds` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
		FOREIGN KEY (`guild2`) REFERENCES `guilds` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
		FOREIGN KEY (`winner`) REFERENCES `guilds` (`id`) ON DELETE CASCADE ON UPDATE CASCADE);]]
	)

	db.query(
		[[CREATE TABLE IF NOT EXISTS `guildwar_kills` (
		`id` INT NOT NULL AUTO_INCREMENT,
		`warid` INT NOT NULL DEFAULT 0,
		`killer` varchar(50) NOT NULL,
		`target` varchar(50) NOT NULL,
		`killerguild` INT NOT NULL DEFAULT 0,
		`targetguild` INT NOT NULL DEFAULT 0,
		`time` BIGINT(20) NOT NULL,
		PRIMARY KEY (`id`),
		KEY `warid` (`warid`),
		CONSTRAINT `guildwar_kills_ibfk_1` FOREIGN KEY (`warid`) REFERENCES `guild_wars` (`id`) ON DELETE CASCADE);]]
	)

	db.query(
		[[CREATE TRIGGER `oncreate_guilds` AFTER INSERT ON `guilds`
		FOR EACH ROW BEGIN
			INSERT INTO `guild_ranks` (`name`, `permissions`, `guild_id`, `leader`) VALUES ('the Leader', -1, NEW.`id`, 1);
			INSERT INTO `guild_ranks` (`name`, `permissions`, `guild_id`, `default`) VALUES ('a Member', 0, NEW.`id`, 1);
		END]]
	)
	return true
end
