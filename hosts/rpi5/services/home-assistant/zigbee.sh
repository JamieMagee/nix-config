#!/usr/bin/env bash
# Script to create Zigbee2MQTT groups via MQTT messages
# Based on the configuration in mqtt.nix

MQTT_HOST="localhost"
MQTT_PORT="1883"

echo "Creating Zigbee2MQTT groups..."

# Group 1: kitchen-garage-stairs
echo "Creating group 1: kitchen-garage-stairs"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/add' -m '{"friendly_name": "kitchen-garage-stairs", "id": 1}'
sleep 0.5
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "kitchen-garage-stairs", "device": "0x001788010de59fb4", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "kitchen-garage-stairs", "device": "0x001788010de59f87", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "kitchen-garage-stairs", "device": "0xb43a31fffe38d5b8", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "kitchen-garage-stairs", "device": "0xb43a31fffe396ae0", "endpoint": 1}'

# Group 2: living-room-lights
echo "Creating group 2: living-room-lights"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/add' -m '{"friendly_name": "living-room-lights", "id": 2}'
sleep 0.5
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "living-room-lights", "device": "0xb43a31fffe307d4a", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "living-room-lights", "device": "0xb43a31fffe308aa9", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "living-room-lights", "device": "0x001788010de59294", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "living-room-lights", "device": "0x001788010de58f44", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "living-room-lights", "device": "0x001788010de58f50", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "living-room-lights", "device": "0x001788010de59d73", "endpoint": 11}'

# Group 3: kitchen-lights
echo "Creating group 3: kitchen-lights"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/add' -m '{"friendly_name": "kitchen-lights", "id": 3}'
sleep 0.5
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "kitchen-lights", "device": "0xb43a31fffe30b619", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "kitchen-lights", "device": "0xb43a31fffe270352", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "kitchen-lights", "device": "0x001788010de588ef", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "kitchen-lights", "device": "0x001788010de58f56", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "kitchen-lights", "device": "0x001788010de59fff", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "kitchen-lights", "device": "0x001788010de59fdc", "endpoint": 11}'

# Group 4: living-room-stairs
echo "Creating group 4: living-room-stairs"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/add' -m '{"friendly_name": "living-room-stairs", "id": 4}'
sleep 0.5
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "living-room-stairs", "device": "0xb43a31fffe34dcd3", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "living-room-stairs", "device": "0xb43a31fffe3babd1", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "living-room-stairs", "device": "0x001788010de59ed5", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "living-room-stairs", "device": "0x001788010de5c725", "endpoint": 11}'

# Group 5: front-porch-lights
echo "Creating group 5: front-porch-lights"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/add' -m '{"friendly_name": "front-porch-lights", "id": 5}'
sleep 0.5
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "front-porch-lights", "device": "0xb43a31fffe38377e", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "front-porch-lights", "device": "0x001788010dabd66b", "endpoint": 11}'

# Group 6: garage-indoors
echo "Creating group 6: garage-indoors"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/add' -m '{"friendly_name": "garage-indoors", "id": 6}'
sleep 0.5
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "garage-indoors", "device": "0xb43a31fffe30b639", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "garage-indoors", "device": "0x001788010db5e5e0", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "garage-indoors", "device": "0x001788010d6cef1e", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "garage-indoors", "device": "0x001788010db5e90e", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "garage-indoors", "device": "0x001788010d6cc048", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "garage-indoors", "device": "0x001788010cfc498d", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "garage-indoors", "device": "0x001788010bc2476c", "endpoint": 11}'

# Group 7: garage-outdoor-lights
echo "Creating group 7: garage-outdoor-lights"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/add' -m '{"friendly_name": "garage-outdoor-lights", "id": 7}'
sleep 0.5
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "garage-outdoor-lights", "device": "0xb43a31fffe34b129", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "garage-outdoor-lights", "device": "0x001788010daba6e8", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "garage-outdoor-lights", "device": "0x001788010db42d9c", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "garage-outdoor-lights", "device": "0x001788010db3bab6", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "garage-outdoor-lights", "device": "0x001788010dabc8e4", "endpoint": 11}'

# Group 8: balcony-lights
echo "Creating group 8: balcony-lights"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/add' -m '{"friendly_name": "balcony-lights", "id": 8}'
sleep 0.5
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "balcony-lights", "device": "0xe0798dfffeb367b4", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "balcony-lights", "device": "0x001788010daba3ee", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "balcony-lights", "device": "0x001788010ce618a9", "endpoint": 11}'

# Group 9: rooftop-lights
echo "Creating group 9: rooftop-lights"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/add' -m '{"friendly_name": "rooftop-lights", "id": 9}'
sleep 0.5
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "rooftop-lights", "device": "0xe0798dfffeaa77e9", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "rooftop-lights", "device": "0x001788010db42ff9", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "rooftop-lights", "device": "0x001788010ce32dd5", "endpoint": 11}'

# Group 10: office
echo "Creating group 10: office"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/add' -m '{"friendly_name": "office", "id": 10}'
sleep 0.5
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "office", "device": "0xe0798dfffeb3662c", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "office", "device": "0x001788010de5c649", "endpoint": 11}'

# Group 11: upstairs-hallway
echo "Creating group 11: upstairs-hallway"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/add' -m '{"friendly_name": "upstairs-hallway", "id": 11}'
sleep 0.5
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "upstairs-hallway", "device": "0xe0798dfffeaa77b1", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "upstairs-hallway", "device": "0xb43a31fffe34c1cf", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "upstairs-hallway", "device": "0x001788010de5c6e8", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "upstairs-hallway", "device": "0x001788010de5c44d", "endpoint": 11}'
# TODO: add 3rd light

# Group 12: bedroom
echo "Creating group 12: bedroom"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/add' -m '{"friendly_name": "bedroom", "id": 12}'
sleep 0.5
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "bedroom", "device": "0xe0798dfffeb36d7a", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "bedroom", "device": "0x001788010de5c72d", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "bedroom", "device": "0x001788010de5c4a6", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "bedroom", "device": "0x001788010de5c49a", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "bedroom", "device": "0x001788010de5cfd3", "endpoint": 11}'

# Group 13: bedroom-closet
echo "Creating group 13: bedroom-closet"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/add' -m '{"friendly_name": "bedroom-closet", "id": 13}'
sleep 0.5
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "bedroom-closet", "device": "0xe0798dfffeaa78c9", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "bedroom-closet", "device": "0x001788010de5c71f", "endpoint": 11}'

# Group 14: bathroom-overhead
echo "Creating group 14: bathroom-overhead"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/add' -m '{"friendly_name": "bathroom-overhead", "id": 14}'
sleep 0.5
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "bathroom-overhead", "device": "0x70ac08fffe6c8e2c", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "bathroom-overhead", "device": "0xe0798dfffeb368c0", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "bathroom-overhead", "device": "0x001788010de5c4a4", "endpoint": 11}'

# Group 15: bathroom-vanity
echo "Creating group 15: bathroom-vanity"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/add' -m '{"friendly_name": "bathroom-vanity", "id": 15}'
sleep 0.5
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "bathroom-vanity", "device": "0xe0798dfffeaa7745", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "bathroom-vanity", "device": "0x9035eafffec6e806", "endpoint": 1}'

# Group 16: indoor-lights
echo "Creating group 16: indoor-lights"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/add' -m '{"friendly_name": "indoor-lights", "id": 16}'
sleep 0.5
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-lights", "device": "0x001788010db5e5e0", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-lights", "device": "0x001788010d6cef1e", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-lights", "device": "0x001788010db5e90e", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-lights", "device": "0x001788010d6cc048", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-lights", "device": "0x001788010cfc498d", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-lights", "device": "0x001788010bc2476c", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-lights", "device": "0x001788010de59fb4", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-lights", "device": "0x001788010de59f87", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-lights", "device": "0x001788010de588ef", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-lights", "device": "0x001788010de58f56", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-lights", "device": "0x001788010de59fff", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-lights", "device": "0x001788010de59fdc", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-lights", "device": "0x001788010de59294", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-lights", "device": "0x001788010de58f44", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-lights", "device": "0x001788010de58f50", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-lights", "device": "0x001788010de59d73", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-lights", "device": "0x001788010de59ed5", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-lights", "device": "0x001788010de5c725", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-lights", "device": "0x001788010de5c649", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-lights", "device": "0x001788010de5c6e8", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-lights", "device": "0x001788010de5c44d", "endpoint": 11}'
# TODO: upstairs hallway light 3
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-lights", "device": "0x001788010de5c72d", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-lights", "device": "0x001788010de5c4a6", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-lights", "device": "0x001788010de5c49a", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-lights", "device": "0x001788010de5cfd3", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-lights", "device": "0x001788010de5c71f", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-lights", "device": "0x001788010de5c4a4", "endpoint": 11}'

# Group 17: upstairs-lights
echo "Creating group 17: upstairs-lights"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/add' -m '{"friendly_name": "upstairs-lights", "id": 17}'
sleep 0.5
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "upstairs-lights", "device": "0x001788010de59fb4", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "upstairs-lights", "device": "0x001788010de59f87", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "upstairs-lights", "device": "0x001788010de588ef", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "upstairs-lights", "device": "0x001788010de58f56", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "upstairs-lights", "device": "0x001788010de59fff", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "upstairs-lights", "device": "0x001788010de59fdc", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "upstairs-lights", "device": "0x001788010de59294", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "upstairs-lights", "device": "0x001788010de58f44", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "upstairs-lights", "device": "0x001788010de58f50", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "upstairs-lights", "device": "0x001788010de59d73", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "upstairs-lights", "device": "0x001788010de59ed5", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "upstairs-lights", "device": "0x001788010de5c725", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "upstairs-lights", "device": "0x001788010de5c649", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "upstairs-lights", "device": "0x001788010de5c6e8", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "upstairs-lights", "device": "0x001788010de5c44d", "endpoint": 11}'
# TODO: upstairs hallway light 3
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "upstairs-lights", "device": "0x001788010de5c72d", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "upstairs-lights", "device": "0x001788010de5c4a6", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "upstairs-lights", "device": "0x001788010de5c49a", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "upstairs-lights", "device": "0x001788010de5cfd3", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "upstairs-lights", "device": "0x001788010de5c71f", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "upstairs-lights", "device": "0x001788010de5c4a4", "endpoint": 11}'

# Group 18: garage-indoors-lights
echo "Creating group 18: garage-indoors-lights"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/add' -m '{"friendly_name": "garage-indoors-lights", "id": 18}'
sleep 0.5
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "garage-indoors-lights", "device": "0x001788010db5e5e0", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "garage-indoors-lights", "device": "0x001788010d6cef1e", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "garage-indoors-lights", "device": "0x001788010db5e90e", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "garage-indoors-lights", "device": "0x001788010d6cc048", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "garage-indoors-lights", "device": "0x001788010cfc498d", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "garage-indoors-lights", "device": "0x001788010bc2476c", "endpoint": 11}'

# Group 19: garage-stairs
echo "Creating group 19: garage-stairs"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/add' -m '{"friendly_name": "garage-stairs", "id": 19}'
sleep 0.5
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "garage-stairs", "device": "0x001788010de59fb4", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "garage-stairs", "device": "0x001788010de59f87", "endpoint": 11}'

# Group 20: kitchen
echo "Creating group 20: kitchen"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/add' -m '{"friendly_name": "kitchen", "id": 20}'
sleep 0.5
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "kitchen", "device": "0x001788010de588ef", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "kitchen", "device": "0x001788010de58f56", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "kitchen", "device": "0x001788010de59fff", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "kitchen", "device": "0x001788010de59fdc", "endpoint": 11}'

# Group 21: living-room
echo "Creating group 21: living-room"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/add' -m '{"friendly_name": "living-room", "id": 21}'
sleep 0.5
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "living-room", "device": "0x001788010de59294", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "living-room", "device": "0x001788010de58f44", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "living-room", "device": "0x001788010de58f50", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "living-room", "device": "0x001788010de59d73", "endpoint": 11}'

# Group 22: living-room-stairs-lights
echo "Creating group 22: living-room-stairs-lights"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/add' -m '{"friendly_name": "living-room-stairs-lights", "id": 22}'
sleep 0.5
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "living-room-stairs-lights", "device": "0x001788010de59ed5", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "living-room-stairs-lights", "device": "0x001788010de5c725", "endpoint": 11}'

# Group 23: front-porch
echo "Creating group 23: front-porch"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/add' -m '{"friendly_name": "front-porch", "id": 23}'
sleep 0.5
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "front-porch", "device": "0x001788010dabd66b", "endpoint": 11}'

# Group 24: balcony
echo "Creating group 24: balcony"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/add' -m '{"friendly_name": "balcony", "id": 24}'
sleep 0.5
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "balcony", "device": "0x001788010daba3ee", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "balcony", "device": "0x001788010ce618a9", "endpoint": 11}'

# Group 25: rooftop
echo "Creating group 25: rooftop"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/add' -m '{"friendly_name": "rooftop", "id": 25}'
sleep 0.5
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "rooftop", "device": "0x001788010db42ff9", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "rooftop", "device": "0x001788010ce32dd5", "endpoint": 11}'

# Group 26: office-lights
echo "Creating group 26: office-lights"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/add' -m '{"friendly_name": "office-lights", "id": 26}'
sleep 0.5
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "office-lights", "device": "0x001788010de5c649", "endpoint": 11}'

# Group 27: upstairs-hallway-lights
echo "Creating group 27: upstairs-hallway-lights"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/add' -m '{"friendly_name": "upstairs-hallway-lights", "id": 27}'
sleep 0.5
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "upstairs-hallway-lights", "device": "0x001788010de5c6e8", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "upstairs-hallway-lights", "device": "0x001788010de5c44d", "endpoint": 11}'
# TODO: add 3rd light

# Group 28: bedroom-lights
echo "Creating group 28: bedroom-lights"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/add' -m '{"friendly_name": "bedroom-lights", "id": 28}'
sleep 0.5
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "bedroom-lights", "device": "0x001788010de5c72d", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "bedroom-lights", "device": "0x001788010de5c4a6", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "bedroom-lights", "device": "0x001788010de5c49a", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "bedroom-lights", "device": "0x001788010de5cfd3", "endpoint": 11}'

# Group 29: bathroom-overhead-lights
echo "Creating group 29: bathroom-overhead-lights"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/add' -m '{"friendly_name": "bathroom-overhead-lights", "id": 29}'
sleep 0.5
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "bathroom-overhead-lights", "device": "0x001788010de5c4a4", "endpoint": 11}'

# Group 30: garage-outdoor
echo "Creating group 30: garage-outdoor"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/add' -m '{"friendly_name": "garage-outdoor", "id": 30}'
sleep 0.5
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "garage-outdoor", "device": "0x001788010daba6e8", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "garage-outdoor", "device": "0x001788010db42d9c", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "garage-outdoor", "device": "0x001788010db3bab6", "endpoint": 11}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "garage-outdoor", "device": "0x001788010dabc8e4", "endpoint": 11}'

# Group 31: indoor-light-switches
echo "Creating group 31: indoor-light-switches"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/add' -m '{"friendly_name": "indoor-light-switches", "id": 31}'
sleep 0.5
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-light-switches", "device": "0xb43a31fffe380054", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-light-switches", "device": "0xb43a31fffe38d5b8", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-light-switches", "device": "0xb43a31fffe396ae0", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-light-switches", "device": "0xb43a31fffe270352", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-light-switches", "device": "0xb43a31fffe308aa9", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-light-switches", "device": "0xb43a31fffe307d4a", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-light-switches", "device": "0xb43a31fffe30b619", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-light-switches", "device": "0xb43a31fffe34dcd3", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-light-switches", "device": "0xb43a31fffe30b639", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-light-switches", "device": "0xe0798dfffeaa77b1", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-light-switches", "device": "0xb43a31fffe3babd1", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-light-switches", "device": "0xe0798dfffeaa78c9", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-light-switches", "device": "0xe0798dfffeb36d7a", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-light-switches", "device": "0xe0798dfffeb3662c", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-light-switches", "device": "0xb43a31fffe34c1cf", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-light-switches", "device": "0x70ac08fffe6c8e2c", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-light-switches", "device": "0x9035eafffec6e806", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-light-switches", "device": "0xe0798dfffeb368c0", "endpoint": 1}'
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t 'zigbee2mqtt/bridge/request/group/members/add' -m '{"group": "indoor-light-switches", "device": "0xe0798dfffeaa7745", "endpoint": 1}'

echo ""
echo "Done! All groups have been created."
echo "You can verify the groups by checking: zigbee2mqtt/bridge/groups"
