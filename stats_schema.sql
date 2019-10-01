SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for `stats`
-- ----------------------------
DROP TABLE IF EXISTS `stats`;
CREATE TABLE `stats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Timestamp` int(11) NOT NULL COMMENT 'Timestamp of entry',
  `VBat` float DEFAULT NULL COMMENT 'battery voltage',
  `IBat` float DEFAULT NULL COMMENT 'battery current',
  `WBat` float DEFAULT NULL COMMENT 'Battery Power',
  `VPho` float DEFAULT NULL COMMENT 'photovoltaic voltage',
  `IPho` float DEFAULT NULL COMMENT 'current of photovoltaic array',
  `WPho` float DEFAULT NULL COMMENT 'wattage of photovoltaic array',
  `IL` float DEFAULT NULL COMMENT 'current of load',
  `WL` float DEFAULT NULL COMMENT 'wattage of load (calculated from battery voltage)',
  `CS` int(11) DEFAULT NULL COMMENT 'Charger State',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of stats
-- ----------------------------
