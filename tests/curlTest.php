<?php

class curlTest extends PHPUnit_Framework_TestCase {

    public function testVersion() {
		$cv=curl_version();
		$this->assertTrue($cv['ssl_version'] == "GnuTLS/3.1.28");
    }

}
