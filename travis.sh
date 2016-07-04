#!/usr/bin/env bash

# Install WordPress.
install-wordpress() {

	mkdir -p "$WP_DEVELOP_DIR"

	# Clone the WordPress develop repo.
	git clone --depth=1 --branch="$WP_VERSION" git://develop.git.wordpress.org/ "$WP_DEVELOP_DIR"

	# Set up tests config.
	cd "$WP_DEVELOP_DIR"
	cp wp-tests-config-sample.php wp-tests-config.php
	sed -i "s/youremptytestdbnamehere/wordpress_test/" wp-tests-config.php
	sed -i "s/yourusernamehere/root/" wp-tests-config.php
	sed -i "s/yourpasswordhere//" wp-tests-config.php
	cd -

	# Set up database.
	mysql -e 'CREATE DATABASE wordpress_test;' -uroot

	# Configure WordPress for access through a web server.
	cd "$WP_DEVELOP_DIR"
	sed -i "s/example.org/$WP_CEPT_SERVER/" wp-tests-config.php
	cp wp-tests-config.php wp-config.php
	echo "require_once(ABSPATH . 'wp-settings.php');" >> wp-config.php
	cd -
}

# EOF
