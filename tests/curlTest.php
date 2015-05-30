<?php

class curlTest extends PHPUnit_Framework_TestCase {

    public function testVersion() {
		$this->assertTrue(curl_version()['ssl_version'] == "GnuTLS/3.1.28");
    }

}
