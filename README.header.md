# bitcore-wallet-client-vidulum

[![NPM Package](https://img.shields.io/npm/v/bitcore-wallet-client-vidulum.svg?style=flat-square)](https://www.npmjs.org/package/bitcore-wallet-client-vidulum)
[![Build Status](https://img.shields.io/travis/bitpay/bitcore-wallet-client-vidulum.svg?branch=master&style=flat-square)](https://travis-ci.org/bitpay/bitcore-wallet-client-vidulum)
[![Coverage Status](https://coveralls.io/repos/bitpay/bitcore-wallet-client-vidulum/badge.svg)](https://coveralls.io/r/bitpay/bitcore-wallet-client-vidulum)

The *official* client library for [bitcore-wallet-service] (https://github.com/pittxid/bitcore-wallet-service).

## Description

This package communicates with BWS [Bitcore wallet service VDL](https://github.com/pittxid/bitcore-wallet-service) using the REST API. All REST endpoints are wrapped as simple async methods. All relevant responses from BWS are checked independently by the peers, thus the importance of using this library when talking to a third party BWS instance.

See [Bitcore-wallet] (https://github.com/bitpay/bitcore-wallet) for a simple CLI wallet implementation that relays on BWS and uses bitcore-wallet-client-vidulum.

## Get Started

You can start using bitcore-wallet-client-vidulum with the command below:

* via [NPM]: by running `npm install https://github.com/pittxid/bitcore-wallet-service.git`
from your console.

## Example

Start your own local [Bitcore wallet service VDL](https://github.com/pittxid/bitcore-wallet-service) instance. In this example we assume you have `bitcore-wallet-service` running on your `localhost:3232`.

Then create two files `irene.js` and `tomas.js` with the content below:

**irene.js**

``` javascript
var Client = require('bitcore-wallet-client-vidulum');


var fs = require('fs');
var BWS_INSTANCE_URL = 'https://bws.bitcoinz.ph/bws/api'

var client = new Client({
  baseUrl: BWS_INSTANCE_URL,
  verbose: false,
});

client.createWallet("My Wallet", "Irene", 2, 2, {network: 'testnet'}, function(err, secret) {
  if (err) {
    console.log('error: ',err);
    return
  };
  // Handle err
  console.log('Wallet Created. Share this secret with your copayers: ' + secret);
  fs.writeFileSync('irene.dat', client.export());
});
```

**tomas.js**

``` javascript

var Client = require('bitcore-wallet-client-vidulum');


var fs = require('fs');
var BWS_INSTANCE_URL = 'https://bws.bitcoinz.ph/bws/api'

var secret = process.argv[2];
if (!secret) {
  console.log('./tomas.js <Secret>')

  process.exit(0);
}

var client = new Client({
  baseUrl: BWS_INSTANCE_URL,
  verbose: false,
});

client.joinWallet(secret, "Tomas", {}, function(err, wallet) {
  if (err) {
    console.log('error: ', err);
    return
  };

  console.log('Joined ' + wallet.name + '!');
  fs.writeFileSync('tomas.dat', client.export());


  client.openWallet(function(err, ret) {
    if (err) {
      console.log('error: ', err);
      return
    };
    console.log('\n\n** Wallet Info', ret); //TODO

    console.log('\n\nCreating first address:', ret); //TODO
    if (ret.wallet.status == 'complete') {
      client.createAddress({}, function(err,addr){
        if (err) {
          console.log('error: ', err);
          return;
        };

        console.log('\nReturn:', addr)
      });
    }
  });
});
```

Install `bitcore-wallet-client-vidulum` before start:

```
npm install https://github.com/pittxid/bitcore-wallet-service.git
```

Create a new wallet with the first script:

```
$ node irene.js
info Generating new keys
 Wallet Created. Share this secret with your copayers: JbTDjtUkvWS4c3mgAtJf4zKyRGzdQzZacfx2S7gRqPLcbeAWaSDEnazFJF6mKbzBvY1ZRwZCbvT
```

Join to this wallet with generated secret:

```
$ node tomas.js JbTDjtUkvWS4c3mgAtJf4zKyRGzdQzZacfx2S7gRqPLcbeAWaSDEnazFJF6mKbzBvY1ZRwZCbvT
Joined My Wallet!

Wallet Info: [...]

Creating first address:

Return: [...]

```

Note that the scripts created two files named `irene.dat` and `tomas.dat`. With
these files you can get status, generate addresses, create proposals, sign
transactions, etc.
