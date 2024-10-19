#!/home/kuber/bash/8-service/send-crypto-price/venv/bin/python3 

import cryptocompare
import json


btc_price = cryptocompare.get_price(['BTC', 'ETH', 'USDT', 'ADA'], currency='USD', full=False)
print(json.dumps(btc_price))
