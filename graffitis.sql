
CREATE TABLE IF NOT EXISTS `graffitis` (
  `key` int NOT NULL AUTO_INCREMENT,
  `owner` text CHARACTER SET latin1 COLLATE latin1_swedish_ci,
  `model` text CHARACTER SET latin1 COLLATE latin1_swedish_ci,
  `coords` varchar(150) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `rotation` varchar(150) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  PRIMARY KEY (`key`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;