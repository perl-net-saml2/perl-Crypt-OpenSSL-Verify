# NAME

Crypt::OpenSSL::Verify - OpenSSL Verify certificate verification in XS.

# SYNOPSIS

```perl
use Crypt::OpenSSL::Verify;
use Crypt::OpenSSL::X509;

my $ca = Crypt::OpenSSL::Verify->new(
    't/cacert.pem', # or undef
    {
        CApath   => '/etc/ssl/certs',    # Optional
        noCAfile => 1,                   # Optional
        noCApath => 0                    # Optional
    }
);

# Backward compatible with Crypt::OpenSSL:VerifyX509
my $ca = Crypt::OpenSSL::Verify->new('t/cacert.pem');

# Using the defaults of your OS:
my $ca = Crypt::OpenSSL::Verify->new();

# and later on..

my $cert = Crypt::OpenSSL::X509->new(...);
$ca->verify($cert);
```

The object created is similar to running the following command with the
`openssl verify` command line tool: `openssl verify [ -CApath /path/to/certs ]
[ -noCApath ] [ -noCAfile ] [ -CAfile /path/to/file ] cert.pem`

# DESCRIPTION

Given a CA certificate and another untrusted certificate, will show
whether the CA signs the certificate. This is a useful thing to have
if you're signing with X509 certificates, but outside of SSL.

A specific example is where you're working with XML signatures, and
need to verify that the signing certificate is valid.

# METHODS

## new()

Constructor. Returns an OpenSSL Verify instance, set up with the given CA.

```perl
my $ca = Crypt::OpenSSL::Verify->new(
    't/cacert.pem',   # or undef
    {
        # Path to a directory containg hashed CA Certificates
        CApath => $ca_path,

        # Default CAfile should not be loaded if TRUE, defaults to FALSE
        noCAfile => 0,

        # Default CApath should not be loaded if TRUE, defaults to FALSE
        noCApath => 0,

        # Do not override any OpenSSL verify errors if FALSE, defaults to TRUE
        strict_certs => 1,
    }
);

# Backward compatible with Crypt::OpenSSL:VerifyX509
my $ca = Crypt::OpenSSL::Verify->new('t/cacert.pem', {strict_certs => 0 });

# Using the defaults of your OS:
my $ca = Crypt::OpenSSL::Verify->new();
```

## verify($cert)

Verify the certificate is signed by the CA. Returns true if so, and
croaks with the verification error if not.

Arguments:

```
* $cert - a Crypt::OpenSSL::X509 object for the certificate to verify.
```

## ctx\_error\_code($ctx)

Calls the C code to obtain the OpenSSL error code of the verify and
returns an integer value

Arguments:

```
* $ctx - a long unsigned integer containing the  pointer to the
      X509_STORE_CTX that was passed to the callback function
      during the certificate verification
```

## register\_verify\_cb(\\&verify\_callback);

Registers a Perl Sub as the callback function for OpenSSL to call
during the registration process

Arguments:

```perl
* \&verify_callback - a reference to the verify_callback sub
```

## verify\_callback($ok, $ctx)

Called directly by OpenSSL and in the case of an acceptable error will
change the response to 1 to signify no error

Arguments:

```perl
$ok - Error (0) or Success (1) from the OpenSSL certificate verification
      results

$ctx - value of the pointer to the Certificate Store CTX used to access the
      error codes that OpenSSL returned
```

# AUTHOR

- Timothy Legge <timlegge@gmail.com>
- Wesley Schwengle <waterkip@cpan.org>

# COPYRIGHT

The following copyright notice applies to all the files provided in
this distribution, including binary files, unless explicitly noted
otherwise.

- Copyright 2020-2023 Timothy Legge
- Copyright 2020-2023 Wesley Schwengle

Based on the Original Crypt::OpenSSL::VerifyX509 by

- Copyright 2010 Chris Andrews <chrisandrews@venda.com>

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as OpenSSL and is covered by the dual
OpenSSL and SSLeay license.
