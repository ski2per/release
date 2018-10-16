#!/bin/bash

echo -e "\e[33m   ____   __  __ _ _               _____      _               \e[0m";
echo -e "\e[33m  / __ \ / _|/ _| (_)             / ____|    | |              \e[0m";
echo -e "\e[33m | |  | | |_| |_| |_ _ __   ___  | (___   ___| |_ _   _ _ __  \e[0m";
echo -e "\e[33m | |  | |  _|  _| | | '_ \ / _ \  \___ \ / _ \ __| | | | '_ \ \e[0m";
echo -e "\e[33m | |__| | | | | | | | | | |  __/  ____) |  __/ |_| |_| | |_) |\e[0m";
echo -e "\e[33m  \____/|_| |_| |_|_|_| |_|\___| |_____/ \___|\__|\__,_| .__/ \e[0m";
echo -e "\e[33m                                                       | |    \e[0m";
echo -e "\e[33m                                                       |_|    \e[0m";

sleep 2
#set -ex

WORKING_DIR=$PWD
NODE_CONF="node-conf.sh"

# Import node configuration
# ====================================

. $NODE_CONF

FABRIC_DEPLOYER="fabric_deployer"
MAPPING_DIR="$FABRIC_DEPLOYER/mappings"
MAPPING_TPL="$MAPPING_DIR/mapping.tpl"
NODE_MAPPING="$MAPPING_DIR/node_mapping.json"
FABIRC_PLATFORM=`grep '"FABIRC_PLATFORM_BASE"' $MAPPING_TPL | awk -F'"' '{print $4}'`

EXPLORER="explorer"
EXPLORER_CONF_TPL="$EXPLORER/config/config.json.tpl"
EXPLORER_CONF="$EXPLORER/config/config.json"
EXPLORER_SQL="explorer/app/persistence/postgreSQL/db/*.sql"

# Replace IP and Authentication in node mapping file
# ====================================
cp -f $MAPPING_TPL $NODE_MAPPING
sed -i "s/CA_NODE/${CA_NODE}/g" $NODE_MAPPING
sed -i "s/ORG1_NODE/${ORG1_NODE}/g" $NODE_MAPPING
sed -i "s/ORG2_NODE/${ORG2_NODE}/g" $NODE_MAPPING
sed -i "s/ORG3_NODE/${ORG3_NODE}/g" $NODE_MAPPING
sed -i "s/ORG4_NODE/${ORG4_NODE}/g" $NODE_MAPPING
sed -i "s/SSH_USERNAME/${SSH_USERNAME}/g" $NODE_MAPPING
sed -i "s/SSH_PASSWORD/${SSH_PASSWORD}/g" $NODE_MAPPING

echo ""
echo ""
echo -e "\e[32m========================================================================\e[0m"
echo -e "\e[32mDeploy Fabric Network\e[0m"
echo -e "\e[32m========================================================================\e[0m"
cd $FABRIC_DEPLOYER
python deploy_fabric.py -c configs/4org_kafka -m mappings/node_mapping.json

# Copy all cryptos to /fabric_platform
# ====================================
cp -a configs/4org_kafka/crypto-config "$FABIRC_PLATFORM/configs"

echo -e "\e[33mWait 15 seconds for Fabric Network to start \e[0m";
sleep 10

# Join channel on peer node
# ====================================
cd $WORKING_DIR
HOSTS=`grep ORG $NODE_CONF | awk -F'=' '{print $2}'`
for host in $HOSTS;do
    python utils/sshcopy.py $host $SSH_USERNAME $SSH_PASSWORD "utils/join.sh"
done

sleep 3

for host in $HOSTS;do
    python utils/sshexec.py $host $SSH_USERNAME $SSH_PASSWORD 'bash /tmp/join.sh'
done

echo ""
echo ""
echo -e "\e[32m========================================================================\e[0m"
echo -e "\e[32mDeploy Explorer\e[0m"
echo -e "\e[32m========================================================================\e[0m"
cd $WORKING_DIR
cp -f $EXPLORER_CONF_TPL $EXPLORER_CONF
sed -i "s/ORG1_NODE/${ORG1_NODE}/g" $EXPLORER_CONF
sed -i "s/ORG2_NODE/${ORG2_NODE}/g" $EXPLORER_CONF
sed -i "s/ORG3_NODE/${ORG3_NODE}/g" $EXPLORER_CONF
sed -i "s/ORG4_NODE/${ORG4_NODE}/g" $EXPLORER_CONF

cp $EXPLORER_SQL /tmp
chmod o+rwx /tmp/*.sql
sudo -u postgres psql -c '\i /tmp/explorerpg.sql'
sudo -u postgres psql -c '\i /tmp/updatepg.sql'

cd $EXPLORER
bash "start.sh"

echo ""
echo ""
echo -e "\e[32m========================================================================\e[0m"
echo -e "\e[32mSetup Composer Playground\e[0m"
echo -e "\e[32m========================================================================\e[0m"
cd $WORKING_DIR
CARD_ORG="org1.example.com"
CARD_NAME="PeerAdmin@hlfv1"
PRIVATE_KEY_FILE=`ls -1 $FABIRC_PLATFORM/configs/crypto-config/peerOrganizations/$CARD_ORG/users/Admin@$CARD_ORG/msp/keystore`
PRIVATE_KEY="$FABIRC_PLATFORM/configs/crypto-config/peerOrganizations/$CARD_ORG/users/Admin@$CARD_ORG/msp/keystore/$PRIVATE_KEY_FILE"
CERT="$FABIRC_PLATFORM/configs/crypto-config/peerOrganizations/$CARD_ORG/users/Admin@$CARD_ORG/msp/signcerts/Admin@$CARD_ORG-cert.pem"

rm -rf "/tmp/$CARD_NAME.card"

# Generate connection.json
# ====================================
cat << EOF > /tmp/connection.json
{
    "name": "hlfv1",
    "x-type": "hlfv1",
    "x-commitTimeout": 300,
    "version": "1.0.0",
    "client": {
        "organization": "Org1",
        "connection": {
            "timeout": {
                "peer": {
                    "endorser": "300",
                    "eventHub": "300",
                    "eventReg": "300"
                },
                "orderer": "300"
            }
        }
    },
    "channels": {
        "composerchannel": {
            "orderers": [
                "orderer1.example.com"
            ],
            "peers": {
                "peer0.org1.example.com": {}
            }
        }
    },
    "organizations": {
        "Org1": {
            "mspid": "Org1MSP",
            "peers": [
                "peer0.org1.example.com"
            ],
            "certificateAuthorities": [
                "ca.org1.example.com"
            ]
        }
    },
    "orderers": {
        "orderer1.example.com": {
            "url": "grpc://${ORG1_NODE}:7050"
        }
    },
    "peers": {
        "peer0.org1.example.com": {
            "url": "grpc://${ORG1_NODE}:7051",
            "eventUrl": "grpc://${ORG1_NODE}:7053"
        }
    },
    "certificateAuthorities": {
        "ca.org1.example.com": {
            "url": "http://${CA_NODE}:7059",
            "caName": "ca.org1.example.com"
        }
    }
}
EOF
composer card create -p /tmp/connection.json -u PeerAdmin -c "${CERT}" -k "${PRIVATE_KEY}" -r PeerAdmin -r ChannelAdmin --file "/tmp/$CARD_NAME.card"

python utils/sshcopy.py $COMPOSER_NODE $SSH_USERNAME $SSH_PASSWORD "/tmp/$CARD_NAME.card"
python utils/sshexec.py $COMPOSER_NODE $SSH_USERNAME $SSH_PASSWORD "composer card list"
python utils/sshexec.py $COMPOSER_NODE $SSH_USERNAME $SSH_PASSWORD "composer card import --file /tmp/$CARD_NAME.card"
python utils/sshexec.py $COMPOSER_NODE $SSH_USERNAME $SSH_PASSWORD "composer card list"

# Start Composer Playground
python utils/sshexec.py $COMPOSER_NODE $SSH_USERNAME $SSH_PASSWORD "nohup composer-playground &> /dev/null &" bg





echo -e "\e[33m  _____   ____  _   _ ______ \e[0m";
echo -e "\e[33m |  __ \ / __ \| \ | |  ____|\e[0m";
echo -e "\e[33m | |  | | |  | |  \| | |__   \e[0m";
echo -e "\e[33m | |  | | |  | | . \` |  __|  \e[0m";
echo -e "\e[33m | |__| | |__| | |\  | |____ \e[0m";
echo -e "\e[33m |_____/ \____/|_| \_|______|\e[0m";
echo -e "\e[33m                             \e[0m";

echo -e "\e[32mHyperledger Fabric Explorer can be accessed through: \e[33mhttp://$CA_NODE:8081\e[0m\e[0m"
echo -e "\e[32mHyperledger Composer Playground: \e[33mhttp://$COMPOSER_NODE:8080\e[0m\e[0m"
