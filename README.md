# webbnc.snoonet.org

This is just a little web service that provides the correct data to Kiwi IRC for it to be able to connect users to our bouncer service. The app redirects all GET requests to the Kiwi IRC client for bouncer access.

Thanks to [prawnsalad](https://github.com/prawnsalad) for making the first version of this in PHP and for creating the BNC compatible Kiwi IRC client.

## Goal of this app

The point of this app is that the Kiwi client that connects users to the bouncer can be controlled by us without having to go through third party every time. The Kiwi IRC client uses this endpoint to gather data like the server to connect and whether it should use SSL and makes a connection with the exact data it receives. This lets us change servers, ports or even allows for something like multiple bouncer servers for different users and the likes.

## Retrieving a bouncer response

POST requests to the ``/request`` route need two paramters, the user and the password. The data should be the login data to the Snoonet bouncer that was previously received via MemoServ. It then return a server, a port, whether SSL should be enabled and the password string it builds up with the provided password and user.

### Example request / response

A curl request might look like this:

```curl
curl -i -X POST \
   -d "user=username" \
   -d "password=password" \
 'http://webbnc.snoonet.org/request'
```

The corresponding response would be something like this:

```json
{  
    "server":"bnc.snoonet.org",
    "port":5457,
    "ssl":true,
    "username":"username",
    "password":"username/Snoonet:password"
}
```

## Copyright and license

Copyright 2015 by Snoonet. Licensed under the [MIT license](https://github.com/snoonetIRC/webbnc.snoonet.org/blob/master/LICENSE).