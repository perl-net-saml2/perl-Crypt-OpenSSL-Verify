use Test::More;
use Crypt::OpenSSL::Verify;
use Crypt::OpenSSL::X509;
use File::Slurper qw(read_text);

my $v = Crypt::OpenSSL::Verify->new('t/cacert.pem');
isa_ok($v, 'Crypt::OpenSSL::Verify');

my $text = read_text('t/cert.pem');
like($text, qr/wIHHf7S8RDyoGpgP4QBXqE/, "seems to be a pem");

my $cert = Crypt::OpenSSL::X509->new_from_string($text);
isa_ok($cert, 'Crypt::OpenSSL::X509');

my $ret = $v->verify($cert);
ok($ret, "t/cert.pem verified");

$v = Crypt::OpenSSL::Verify->new(
    't/cacert.pem',
    {
        CApath   => '/etc/ssl/certs',
        noCAfile => 0,
    }
);
isa_ok($v, 'Crypt::OpenSSL::Verify');

$ret = $v->verify($cert);
ok($ret, "t/cert.pem verified");

done_testing;
