CREATE TABLE `admin` (
  `ckey` varchar(32) NOT NULL,
  `rank` varchar(32) NOT NULL,
  `feedback` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ckey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `datetime` datetime NOT NULL,
  `round_id` int(11) unsigned NULL,
  `adminckey` varchar(32) NOT NULL,
  `adminip` int(10) unsigned NOT NULL,
  `operation` enum('add admin','remove admin','change admin rank','add rank','remove rank','change rank flags') NOT NULL,
  `target` varchar(32) NOT NULL,
  `log` varchar(1000) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `admin_ranks` (
  `rank` varchar(32) NOT NULL,
  `flags` mediumint(5) unsigned NOT NULL,
  `exclude_flags` mediumint(5) unsigned NOT NULL,
  `can_edit_flags` mediumint(5) unsigned NOT NULL,
  PRIMARY KEY (`rank`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Table structure for table `erro_ban`
CREATE TABLE `erro_ban` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bantime` datetime NOT NULL,
  `serverip` varchar(32) NOT NULL,
  `bantype` varchar(32) NOT NULL,
  `reason` text NOT NULL,
  `job` varchar(32) DEFAULT NULL,
  `duration` int(11) NOT NULL,
  `rounds` int(11) DEFAULT NULL,
  `expiration_time` datetime NOT NULL,
  `ckey` varchar(32) NOT NULL,
  `computerid` varchar(32) NOT NULL,
  `ip` varchar(32) NOT NULL,
  `a_ckey` varchar(32) NOT NULL,
  `a_computerid` varchar(32) NOT NULL,
  `a_ip` varchar(32) NOT NULL,
  `who` text NOT NULL,
  `adminwho` text NOT NULL,
  `edits` text,
  `unbanned` tinyint(1) DEFAULT NULL,
  `unbanned_datetime` datetime DEFAULT NULL,
  `unbanned_ckey` varchar(32) DEFAULT NULL,
  `unbanned_computerid` varchar(32) DEFAULT NULL,
  `unbanned_ip` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 ;

-- Table structure for table `erro_connection_log`
CREATE TABLE `erro_connection_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `datetime` datetime NOT NULL,
  `serverip` varchar(32) NOT NULL,
  `ckey` varchar(32) NOT NULL,
  `ip` varchar(32) NOT NULL,
  `computerid` varchar(32) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 ;

-- Table structure for table `erro_feedback`
CREATE TABLE `erro_feedback` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time` datetime NOT NULL,
  `round_id` int(8) NOT NULL,
  `var_name` varchar(32) NOT NULL,
  `var_value` int(16) DEFAULT NULL,
  `details` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 ;

-- Table structure for table `erro_player`
CREATE TABLE `erro_player` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ckey` varchar(32) NOT NULL,
  `firstseen` datetime NOT NULL,
  `lastseen` datetime NOT NULL,
  `ip` varchar(18) NOT NULL,
  `computerid` varchar(32) NOT NULL,
  `lastadminrank` varchar(32) NOT NULL DEFAULT 'Player',
  `discord_id` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ckey` (`ckey`),
  KEY `discord_id` (`discord_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 ;

-- Table structure for table `erro_poll_option`
CREATE TABLE `erro_poll_option` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pollid` int(11) NOT NULL,
  `text` varchar(255) NOT NULL,
  `percentagecalc` tinyint(1) NOT NULL DEFAULT '1',
  `minval` int(3) DEFAULT NULL,
  `maxval` int(3) DEFAULT NULL,
  `descmin` varchar(32) DEFAULT NULL,
  `descmid` varchar(32) DEFAULT NULL,
  `descmax` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 ;

-- Table structure for table `erro_poll_question`
CREATE TABLE `erro_poll_question` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `polltype` varchar(16) NOT NULL DEFAULT 'OPTION',
  `starttime` datetime NOT NULL,
  `endtime` datetime NOT NULL,
  `question` varchar(255) NOT NULL,
  `adminonly` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 ;

-- Table structure for table `erro_poll_textreply`
CREATE TABLE `erro_poll_textreply` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `datetime` datetime NOT NULL,
  `pollid` int(11) NOT NULL,
  `ckey` varchar(32) NOT NULL,
  `ip` varchar(18) NOT NULL,
  `replytext` text NOT NULL,
  `adminrank` varchar(32) NOT NULL DEFAULT 'Player',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 ;

-- Table structure for table `erro_poll_vote`
CREATE TABLE `erro_poll_vote` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `datetime` datetime NOT NULL,
  `pollid` int(11) NOT NULL,
  `optionid` int(11) NOT NULL,
  `ckey` varchar(255) NOT NULL,
  `ip` varchar(16) NOT NULL,
  `adminrank` varchar(32) NOT NULL,
  `rating` int(2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 ;

-- Table structure for table `erro_privacy`
CREATE TABLE `erro_privacy` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `datetime` datetime NOT NULL,
  `ckey` varchar(32) NOT NULL,
  `option` varchar(128) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 ;

-- Table structure for table `death`
CREATE TABLE `death` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `pod` TEXT NOT NULL COMMENT 'Place of death' ,
  `coord` TEXT NOT NULL COMMENT 'X, Y, Z POD' ,
  `tod` DATETIME NOT NULL COMMENT 'Time of death' ,
  `job` TEXT NOT NULL ,
  `special` TEXT NOT NULL ,
  `name` TEXT NOT NULL ,
  `byondkey` TEXT NOT NULL ,
  `laname` TEXT NOT NULL COMMENT 'Last attacker name' ,
  `lakey` TEXT NOT NULL COMMENT 'Last attacker key' ,
  `gender` TEXT NOT NULL ,
  `bruteloss` INT(11) NOT NULL ,
  `brainloss` INT(11) NOT NULL ,
  `fireloss` INT(11) NOT NULL ,
  `oxyloss` INT(11) NOT NULL ,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 ;


-- Table structure for table `karma`
CREATE TABLE `karma` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `spendername` TEXT NOT NULL ,
  `spenderkey` TEXT NOT NULL ,
  `receivername` TEXT NOT NULL ,
  `receiverkey` TEXT NOT NULL ,
  `receiverrole` TEXT NOT NULL ,
  `receiverspecial` TEXT NOT NULL ,
  `isnegative` TINYINT(1) NOT NULL ,
  `spenderip` TEXT NOT NULL ,
  `time` DATETIME NOT NULL ,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 ;

-- Table structure for table `karmatotals`
CREATE TABLE `karmatotals` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `byondkey` TEXT NOT NULL ,
  `karma` INT(11) NOT NULL ,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 ;

-- Table structure for table `library`
CREATE TABLE `library` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `author` TEXT NOT NULL ,
  `title` TEXT NOT NULL ,
  `content` TEXT NOT NULL ,
  `category` TEXT NOT NULL ,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 ;

-- Table structure for table `population`
CREATE TABLE `population` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `playercount` INT(11) NULL DEFAULT NULL ,
  `admincount` INT(11) NULL DEFAULT NULL ,
  `time` DATETIME NOT NULL ,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 ;

-- Table structure for table `vr_player_hours`
CREATE TABLE `vr_player_hours` (
  `ckey` varchar(32) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `department` varchar(64) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `hours` double NOT NULL,
  `total_hours` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`ckey`,`department`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `round` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `initialize_datetime` DATETIME NOT NULL,
  `start_datetime` DATETIME NULL,
  `shutdown_datetime` DATETIME NULL,
  `end_datetime` DATETIME NULL,
  `server_ip` INT(10) UNSIGNED NOT NULL,
  `server_port` SMALLINT(5) UNSIGNED NOT NULL,
  `commit_hash` CHAR(40) NULL,
  `game_mode` VARCHAR(32) NULL,
  `game_mode_result` VARCHAR(64) NULL,
  `end_state` VARCHAR(64) NULL,
  `shuttle_name` VARCHAR(64) NULL,
  `map_name` VARCHAR(32) NULL,
  `station_name` VARCHAR(80) NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `chatlogs_ckeys` (
  `ckey` varchar(45) NOT NULL,
  `token` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ckey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Table structure for table `chatlogs_logs`
CREATE TABLE IF NOT EXISTS `chatlogs_logs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `round_id` int(11) NOT NULL DEFAULT -1,
  `target` varchar(45) NOT NULL,
  `text` mediumtext NOT NULL,
  `text_raw` mediumtext NOT NULL,
  `type` varchar(128) DEFAULT NULL,
  `created_at` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `chatlogs_ckeys_FK` (`target`),
  CONSTRAINT `chatlogs_ckeys_FK` FOREIGN KEY (`target`) REFERENCES `chatlogs_ckeys` (`ckey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- If you are doing this with the cli you will have to tell it first to use something else as a delimiter instead of ;
-- Otherwise the copy/paste will fail. Do not forget to revert the change in the end.
DELIMITER //
CREATE EVENT `chatlogs_logs_clear_old_logs`
	ON SCHEDULE
		EVERY 1 MONTH STARTS '2025-01-01 04:00:00'
	ON COMPLETION PRESERVE
	ENABLE
	COMMENT 'This event periodically clears the chatlog logs of very old logs'
	DO BEGIN

DELETE FROM chatlogs_logs WHERE created_at < UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL 3 MONTH)) * 1000;

END
DELIMITER ;
-- Also enable the event_scheduler after creating the event
SET GLOBAL event_scheduler = ON;

-- Table structure for table `chatlogs_rounds`
CREATE TABLE `chatlogs_rounds` (
	`round_id` BIGINT(20) NOT NULL DEFAULT -1,
	`ckey` VARCHAR(45) NOT NULL COLLATE 'utf8mb4_uca1400_ai_ci',
	PRIMARY KEY (`round_id`, `ckey`) USING BTREE
) ENGINE=InnoDB COLLATE='utf8mb4_uca1400_ai_ci';

-- If you are doing this with the cli you will have to tell it first to use something else as a delimiter instead of ;
-- Otherwise the copy/paste will fail. Do not forget to revert the change in the end.
DELIMITER //
CREATE PROCEDURE `chatlogs_rounds_insert`(
	IN `p_round_id` BIGINT,
	IN `p_ckey` VARCHAR(45)
)
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY INVOKER
COMMENT 'Inserts a new row into \'chatlogs_rounds\' and deletes the oldest entry, if the ckey already has 10 round id\'s stored.'
BEGIN

INSERT IGNORE INTO chatlogs_rounds(round_id, ckey) VALUES (p_round_id, p_ckey);

IF (SELECT COUNT(*) FROM chatlogs_rounds WHERE ckey = p_ckey) > 10 THEN
	DELETE FROM chatlogs_rounds WHERE ckey = p_ckey ORDER BY round_id ASC LIMIT 1;
END IF;

END
DELIMITER ;
