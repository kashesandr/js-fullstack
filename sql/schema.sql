CREATE SCHEMA `test-app` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `password` varchar(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `firstname` varchar(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `lastname` varchar(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `street` varchar(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `zip` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `location` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
