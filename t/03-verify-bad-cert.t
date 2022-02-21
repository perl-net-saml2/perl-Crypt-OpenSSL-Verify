use strict;
use warnings;
use Test::More;
use Crypt::OpenSSL::Verify;
use Crypt::OpenSSL::X509;

my $v = Crypt::OpenSSL::Verify->new('t/cacert.pem');
isa_ok($v, 'Crypt::OpenSSL::Verify');

my $text =<<CERT;
-----BEGIN CERTIFICATE-----
MIIEwjCCAqoCCQDUW/qSgnKE7jANBgkqhkiG9w0BAQsFADAjMQswCQYDVQQGEwJV
SzEUMBIGA1UEAwwLVEVTVF9DTElFTlQwHhcNMjIwMjIxMjEzMTQ4WhcNMzIwMjE5
MjEzMTQ4WjAjMQswCQYDVQQGEwJVSzEUMBIGA1UEAwwLVEVTVF9DTElFTlQwggIi
MA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDaVuz19yglZ/REN0q8qy623WaH
lrRTgSnrUtvr5nz7liBXvTmo1KAfXPwltOThgd5BoQXyRzIqe3nKTWfwLjEEXhWg
80txYtjk0fBn4WoihxDcjNAgtirBha+eqVx+RG9vBNcUhobEtVe0/+3XkSeUeGRW
OIbL5WMlNp4zwKtd8375EyjakYDfcc4e/ho5zJv0UqgxI/Zyh1PT6Ed3apIh6I1Y
ecnCCEQjlc0UJ5EVTZlgOFGDs5w0SrbBQQWIEdcQAsvd0qjhj5Z6CBXONN+KVpy9
jhwA4s/RTT2MvN/eMU4GrOJfqqkjZ7NCeY64MLwGT5ynVNC7FpZyJaXw1leak/rw
/qiCkJSG53B6dXLDfUgtLuk7qGM2NLB3EYgVe9/iXklxrpEKbZ/0l8QamIq2cJqV
66dlvMhORjccSrxO03wYYsU7w4gHHyGcpSkHiyQIXuXopABJJ+9hFgvXJ1UJXMdK
GeRGamx/SPega22wj8B2sXPug5EgfnFWrOChfcL0PfSwZWN5XfQr9qUZhml8L0nm
lDOJAt9vlnXOw3B2rXEO4oaTGtTqDjHSWh9A3x3v12d8hEyxmAXG6IL2UDB8qxuw
W8Rw8ctrYJ6bJsuvYVWlTHZDNL85FDNoA8Z+ThX/gKgXf5WN7+h2BStdcEHjz0Bm
AaeMm9Pyxe2B9ejKgwIDAQABMA0GCSqGSIb3DQEBCwUAA4ICAQAFbW5iiZrfJFau
g7cVmrzEMWHFRaZrnIgPAcVWOt76tEJu2uDWe8tjIMDekD/1vcxJ5SdWH9zJQxsT
jDWvFVle+henWLVR9/2EsmA4B2l/lJ2x3eBs9PwhQQt2W4V3PVlOplYL18cBUjNP
74PdEUc7PBi+ddbYgYZmIHZL4A0zhbb99xnDANIdbFRwR9d1OMgD4MXt+35w3I92
VaMXvZWRxFI85100k/mJO3W8yQ9DRMUHuRjeZPuIFOHbHtpl3xQ8nGiR7XD7iIMS
EuH+Ropm0zz7fgZHk4DaCWElYbbak1yGHnsH9eig1zsa2yAOOvWSd2IyYvFqsioN
Mt4amwY+a+WyVEIA3e4Z22YSJ1/R2COcXETV6PBCkpduFt9B2njIeLEvW607CQgY
hGj37bOFszNrhZtP2c3aBQ6RTOJnwyYB3xnhvCpSL/sndC2itg9uHLonQNfsaQSp
9I1sMqfj1j1bS1Ai2VHtge85bwQQvOY3tw+ctCJC3pi6WcwCiHXTxVQHbU34v9JT
QqALBJHwSPH++2iRuFVaNsALkUQCKLtbIFsKCRjJIt8QRJ2DgdUPvhpKDBUHRhfr
Mav2gnzx60cUL/CnoQeosYsx2bLWN0WwCYsdYr/484DbMC4UEvCc+oGXDJfWAgS+
Gx8CghoNtEXNLm2fPBd9Gc6DzkwlLg==
-----END CERTIFICATE-----
CERT

my $cert = Crypt::OpenSSL::X509->new_from_string($text);
isa_ok($cert, 'Crypt::OpenSSL::X509');

my $ret;
eval {
        $ret = $v->verify($cert);
};

$v = Crypt::OpenSSL::Verify->new(
    't/cacert.pem',
    {
        CApath => '/etc/ssl/certs',
        noCAfile => 0,
    }
);
isa_ok($v, 'Crypt::OpenSSL::Verify');

$ret = undef;
eval {
        $ret = $v->verify($cert);
};

ok($@ =~ /verify: /);
ok(!$ret);

done_testing;
