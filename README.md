# nordcreds
Simple Docker container that fetches public and private Keys from NordVPN w/ Wireguard.

## Problem

In trying to start my NordVPN network container with Wireguard, it required a private key that was only attainable in a Linux VM.
I wanted an easier way to retrieve these credentials without having to create a Linux VM and thought using a script in a Ubuntu container 
would do the trick. 

The ultimate goal is to help people who may not have the necessary background to go through creation of a VM and enable a faster turnaround 
in trying to get these keys. 

## Prerequisites

* Either pulling from Docker Hub or building this image locally. 
    * Local build sample command: `docker build -t nordcreds .`
* Docker installed. I'm on MacOS so I have docker-desktop.

## Instructions

Ensure that you have your NordVPN Access Token found in the [NordVPN UI](https://my.nordaccount.com/dashboard/nordvpn/access-tokens/authorize/) -> Get Access Token.

Once obtained, we will need to export the token so that `docker compose` can use the token.

```
export NORD_ACCESS_TOKEN=x9f234sb80lpo26d96bc4c490b99a1e039bb86m94k2a9z321e8a31797b51b # Token is a sample, please replace with your own
```

Now we should be all set to grab our details, run `docker compose up`:
```
✗ docker compose up
[+] Running 1/0
 ✔ Container nordcreds-nordvpn-1  Created                                                            0.0s
Attaching to nordvpn-1
nordvpn-1  | --------------------------------
nordvpn-1  | Logging into NordVPN
nordvpn-1  | Welcome to NordVPN! You can now connect to VPN by using 'nordvpn connect'.
nordvpn-1  |
nordvpn-1  | NOTE: By default, all users who are members of the 'nordvpn' group have permission to control the NordVPN application.
nordvpn-1  | To limit access exclusively to the root user, remove all users from the 'nordvpn' group.
nordvpn-1  | --------------------------------
nordvpn-1  | Connecting to NordVPN
nordvpn-1  | Connecting to United States #0001 (us0001.nordvpn.com)
nordvpn-1  | You are connected to United States #0001 (us0001.nordvpn.com)!
nordvpn-1  | --------------------------------
nordvpn-1  | Retrieving Public and Private Keys
nordvpn-1  | ---------------------------------
nordvpn-1  | >public_key: PUBLIC_KEY123xyzsample
nordvpn-1  | >private_key: PRIVATE_KEY123xyzsample
nordvpn-1  | Put these into a credentials file such as: nordcredentials.enc
nordvpn-1  | Encrypt them with ansible or similar: ansible-vault encrypt nordcredentials.enc
nordvpn-1  |
nordvpn-1  | Script completed successfully.
nordvpn-1 exited with code 0
```

The container will run and spit out the `public_key` and `private_key`. Utilize these as needed but I highly recommend to encrypt them. 