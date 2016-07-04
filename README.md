# WP Browser Travis Demo [![Build Status](https://travis-ci.org/JDGrimes/wp-browser-travis-demo.svg?branch=master)](https://travis-ci.org/JDGrimes/wp-browser-travis-demo)

An example of how to use [WP Browser](https://github.com/lucatume/wp-browser) to run [Codeception WebDriver acceptance tests](http://codeception.com/docs/03-AcceptanceTests) against WordPress on Travis CI.

## Notes

- You must use `http://127.0.0.1:8888` as the webdriver URL. Other ports will work, but if you try to use `localhost` or leave out the `http://` it will break.
- You have to install WordPress, see `travis.sh`.
- Currently failing on HHVM. PhantomJS says `XPath error : Invalid expression #user_login`.

See `.travis.yml` for more details.
