<?php

function sanitize($content){
    $no_newlines = str_replace(array("\n", "\r"), '', $content);
    return preg_replace('/[^\dA-Za-z_]/i', '', $no_newlines);
}

$rootpath = '/var/www/data/';

$post_data = json_decode(file_get_contents('php://input'), true);
$sanitized_filename = sanitize($post_data['filename']);

$sanitized_username = sanitize($post_data['username']);

$user_dir = $rootpath;

$filetype = $post_data['filetype'];
$sanitized_filetype = '';
if ($filetype === 'json' || $filetype === 'json.enc' || $filetype === 'csv' || $filetype === 'csv.enc' || $filetype === 'webm.enc') {
    $data = $post_data['filedata'];
    $sanitized_filetype = $filetype;
} else {
    http_response_code(400);
    die();
}


$name = $user_dir . $sanitized_filename . '-'. $sanitized_username .'.' .  $sanitized_filetype;

while (file_exists($name)) {
    $name = $name . '-' . time() . '-' . uniqid();
}

if (!file_put_contents($name, $data)) {
    http_response_code(500);
}
?>