BEGIN {
    $ENV{TEST_NGINX_USE_HUP} = 1;
    $ENV{TEST_NGINX_CHECK_LEAK} = 1;
}

use Test::Nginx::Socket 'no_plan';

repeat_each(100);
# plan tests => repeat_each() * (3 * blocks());
no_shuffle();
run_tests();

__DATA__
=== TEST 1: memory leak check
--- config
location = /qr_code {
    qrcode_fg_color $arg_fg_color;
    qrcode_bg_color $arg_bg_color;
    qrcode_level $arg_level;
    qrcode_hint $arg_hint;
    qrcode_size $arg_size;
    qrcode_margin $arg_margin;
    qrcode_version $arg_ver;
    qrcode_casesensitive $arg_case;
    qrcode_txt $arg_txt;
    qrcode_urlencode_txt $arg_txt;
    qrcode_cp $arg_cp;

    qrcode_gen;
}

--- request eval
[
"GET /qr_code?txt=123&size=400&fg_color=ffffff&bg_color=000000&case=1&margin=0&level=3&hint=2&ver=2",
"GET /qr_code?txt=456&size=400&fg_color=ffffff&bg_color=000000&case=1&margin=0&level=3&hint=2&ver=2",
"GET /qr_code?txt=789&size=400&fg_color=ffffff&bg_color=000000&case=1&margin=0&level=3&hint=2&ver=2",
"GET /qr_code?txt=abcd&size=400&fg_color=ffffff&bg_color=000000&case=1&margin=0&level=3&hint=2&ver=2",
]

--- error_code eval
[200, 200, 200, 200]