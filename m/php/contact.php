<?
sleep(1);
$request_body = @file_get_contents('php://input'); // http_get_request_body(); doesn't work w/o HTTP extensions :-(

header('Cache-Control: no-cache, must-revalidate');
header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');
header('Content-type: application/json');

if ($_SERVER['REQUEST_METHOD'] == "POST") {

    $body = json_decode($request_body);
    // json_last_error needs PHP 5.3+
    if (function_exists("json_last_error") && json_last_error() != JSON_ERROR_NONE) {
        ?>{ "success": false, "message": "Unable to decode JSON data.", "code": "json_parse_error" }<?
        return;
    }

    $msg = substr(trim("" . $body->{'name'}), 0, 100) . "\n"
        . substr(trim("" . $body->{'email'}), 0, 70) . "\n"
        . substr(trim("" . $body->{'message'}), 0, 300);

    if (strlen($msg) < 20 || $body->{'sum'} != "21") {
        ?>{ "success": false, "message": "Please fill in the form correctly!", "code": "form_invalid" }<?
    }
    else {
        $rc = mail("sysprog@goebl.com", "BLITZ", $msg, "From: sysprog@goebl.com");
        if (!$rc) {
            ?>{ "success": false, "message": "Error sending the mail.", "code": "sendmail_error" }<?
        }
        else {
            ?>{ "success": true, "message": "Thank you! Mail and SMS is on its way." }<?
        }
    }
}
else {
    ?>{ "success": false, "message": "Unsupported HTTP method. Use POST!", "code": "unsupported_method" }<?
}
?>
