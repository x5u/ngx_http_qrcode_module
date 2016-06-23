use warnings;
use strict;
use Test::Nginx::Socket 'no_plan';
require Image::Magick;
require Barcode::ZBar;

no_shuffle();
run_tests();

sub qrdecode($) {
    my $content = shift;
    my $scanner = Barcode::ZBar::ImageScanner->new();

    # configure the reader
    $scanner->parse_config("enable");

    my $magick = Image::Magick->new(magick => 'png');
    $magick->BlobToImage($content);

    my $raw = $magick->ImageToBlob(magick => 'GRAY', depth => 8);
    my $image = Barcode::ZBar::Image->new();
    $image->set_format('Y800');
    $image->set_size($magick->Get(qw(columns rows)));
    $image->set_data($raw);

    # scan the image for barcodes
    my $n = $scanner->scan_image($image);

    # extract results
    foreach my $symbol ($image->get_symbols()) {
        # clean up
        undef($image);
        return $symbol->get_data;
    }

    #nope
    return "badbeef";
}

__DATA__
=== TEST 1: qrcode should be right
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
"GET /qr_code?txt=123&size=400&fg_color=000000&bg_color=FFFFFF&case=1&margin=0&level=3&hint=2&ver=2",
"GET /qr_code?txt=456&size=400&fg_color=000000&bg_color=FFFFFF&case=1&margin=0&level=3&hint=2&ver=2",
"GET /qr_code?txt=789&size=400&fg_color=000000&bg_color=FFFFFF&case=1&margin=0&level=3&hint=2&ver=2",
"GET /qr_code?txt=123&size=400&fg_color=000000&bg_color=FFFFFF&case=1&margin=0&level=3&hint=2&ver=2",
]

--- response_body_filters eval
[\&main::qrdecode]

--- response_body_like eval
[
"123", "456", "789", 123
]

=== TEST 2: center picture on qrcode should be ok
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
"GET /qr_code?txt=123&size=400&fg_color=000000&bg_color=ffffff&case=1&margin=0&level=3&hint=2&ver=2&cp=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"

--- response_body_filters eval
[\&main::qrdecode]

--- response_body_like eval
[
"123"
]
