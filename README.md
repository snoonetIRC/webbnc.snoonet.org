# webbnc.snoonet.org

This is just a little web service that provides the correct data to Kiwi IRC for it to be able to connect users to our bouncer service. The app redirects all GET requests to the Kiwi IRC client for bouncer access. The main point of this is that the control over the Kiwi IRC connection is in our hands and to give us the opportunity of adding, removing or changing things about the bouncer connection without having to ask a third party.

Thanks to @prawnsalad for making the first version of this in PHP and for creating the BNC compatible Kiwi IRC client.

## Retrieving a bouncer response

POST requests to the ``/request`` route need two paramters, the user and the password. The data should be the login data to the Snoonet bouncer that was previously received via MemoServ. It then return a server, a port, whether SSL should be enabled and the password string it builds up with the provided password and user.

## Copyright and license

Copyright 2015 by Snoonet. Licensed under the [MIT license](https://github.com/snoonetIRC/webbnc.snoonet.org/blob/master/LICENSE).