#!/usr/bin/env bash

# Install WordPress.
install-wordpress() {

	mkdir -p "$WP_DEVELOP_DIR"

	# Clone the WordPress develop repo.
	git clone --depth=1 --branch="$WP_VERSION" git://develop.git.wordpress.org/ "$WP_DEVELOP_DIR"

	cd "$WP_DEVELOP_DIR"

	# Set up tests config.
	cp wp-tests-config-sample.php wp-config.php
	sed -i "s/youremptytestdbnamehere/wordpress_test/" wp-config.php
	sed -i "s/yourusernamehere/root/" wp-config.php
	sed -i "s/yourpasswordhere//" wp-config.php

	# Set up database.
	mysql -e 'CREATE DATABASE wordpress_test;' -uroot

	# Configure WordPress for access through a web server.
	sed -i "s/example.org/$WP_CEPT_SERVER/" wp-config.php
	echo "require_once(ABSPATH . 'wp-settings.php');" >> wp-config.php

	# Install.
	php tests/phpunit/includes/install.php wp-config.php

	cd -
}

# EOF
