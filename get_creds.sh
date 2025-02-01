# This script is a light wrapper around the commands required to retrieve the public and private keys for NordVPN w/ Wireguard.

SAVE=0
ACCESS_TOKEN=$ACCESS_TOKEN

while [ "$1" != "" ]; do
    param=${1%%=*}
    value=${1#*=}
    case $param in
        --access-token)
            ACCESS_TOKEN=$value
            ;;
        --save)
            SAVE=1
            ;;
        *)
            echo "unknown parameter \"$param\" value \"$value\""
            exit 1
            ;;
    esac
    shift
done

if [ -z $ACCESS_TOKEN ]; then
    echo "NORD_ACCESS_TOKEN is required, retrieve it from the NordVPN UI under NordVPN -> Get Access Token."
    echo "ensure NORD_ACCESS_TOKEN is exported as an environment variable for docker compose."
    exit 1
fi

function nord_login() {
    echo "--------------------------------"
    echo "Logging into NordVPN"
    /etc/init.d/nordvpn start
    sleep 5
    nordvpn login --token $ACCESS_TOKEN || exit 1
}

function nord_connect() {
    echo "--------------------------------"
    echo "Connecting to NordVPN"
    nordvpn connect || exit 1
}

function nord_details() {
    echo "--------------------------------"
    echo "Retrieving Public and Private Keys"
    DUMP=$(wg show nordlynx dump)
    PRIVATE_KEY=$(echo $DUMP | awk '{print $1}')
    PUBLIC_KEY=$(echo $DUMP | awk '{print $2}')
    
    if [ $PRIVATE_KEY != $(wg show nordlynx private-key) ]; then
        echo "Private key check failed; $PRIVATE_KEY"
        exit 1
    fi

    if [ $PUBLIC_KEY != $(wg show nordlynx public-key) ]; then
        echo "Public key check failed; $PUBLIC_KEY"
        exit 1
    fi

    echo "---------------------------------"
    echo ">public_key: $PUBLIC_KEY"
    echo ">private_key: $PRIVATE_KEY"

    echo "Put these into a credentials file such as: nordcredentials.enc"
    echo "Encrypt them with ansible or similar: ansible-vault encrypt nordcredentials.enc"
    echo -e "\nScript completed successfully."
}

nord_login
nord_connect
nord_details
