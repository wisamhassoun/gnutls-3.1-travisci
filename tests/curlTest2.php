<?php

class curlTest extends PHPUnit_Framework_TestCase {

    public function testVersion() {

		$url = "https://api.mdi-staging.ericsson.net";

        // default version SSLVERSION je php specific, tko da je dobro, da jo sam
        // nastavis. SSLv2/SSLv3 nimamo podprt, tko da varianti 2 in 3 ne delata
        // http://php.net/manual/en/function.curl-setopt.php
        // CURL_SSLVERSION_DEFAULT (0),
        // CURL_SSLVERSION_TLSv1 (1),
        // CURL_SSLVERSION_SSLv2 (2),
        // CURL_SSLVERSION_SSLv3 (3),
        // CURL_SSLVERSION_TLSv1_0 (4),
        // CURL_SSLVERSION_TLSv1_1 (5)
        // CURL_SSLVERSION_TLSv1_2 (6).

        for ($i = 0; $i <= 6; $i++) {
            // create a new cURL resource
            $ch = curl_init();
            // set URL and other appropriate options
            curl_setopt($ch, CURLOPT_URL, $url);
            curl_setopt($ch, CURLOPT_HEADER, 0);
            curl_setopt($ch, CURLOPT_VERBOSE, true);
            curl_setopt($ch, CURLOPT_SSLVERSION, $i);
            // grab URL and pass it to the browser
            $response = curl_exec($ch);
            if(curl_exec($ch) === false)
            {
              echo 'Curl error: ' . curl_error($ch) . ' SSL VERSION: ' .$i;
            }
            else
            {
        //      $tokens = explode("\n", trim($response));
        //      print_r($tokens);
            }
            curl_close($ch);
        }
    }
}

