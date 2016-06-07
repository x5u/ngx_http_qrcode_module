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

    my $raw = $magick->ImageToBlob();
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
        return $symbol->get_type() . ":" . $symbol->get_data();
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
]

--- response_body_filters eval
\&main::qrdecode

--- response_body_like eval
[
"abcd"
]
