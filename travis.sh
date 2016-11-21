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

	# Install.
	php tests/phpunit/includes/install.php wp-config.php

	# Update the config to actually load WordPress, and add multisite support.
	echo "

		// Support enabling multisite by the presence of this file.
		// We don't define this during install because of how the installer works.
		if ( ! defined( 'WP_INSTALLING' ) && file_exists( dirname( __FILE__ ) . '/is-multisite' ) ) {
			define( 'MULTISITE', true );
			define( 'SUBDOMAIN_INSTALL', false );
			\$GLOBALS['base'] = '/';
		}

		require_once(ABSPATH . 'wp-settings.php');

	" >> wp-config.php

	cd -
}

# Enable multisite on this WordPress install.
enable-multisite() {

	cd "$WP_DEVELOP_DIR"

	# Our wp-config.php automatically enables multisite if this file exists.
	# Doing this via a file allows us to enable and disable multisite easily, and
	# is superior to passing a query var, since that would only affect the first
	# page, not any links clicked on during the tests.
	touch "$WP_DEVELOP_DIR/is-multisite"

	# The installer listens for this env var.
	export WP_MULTISITE=1

	php tests/phpunit/includes/install.php wp-config.php

	cd -
}

# EOF
