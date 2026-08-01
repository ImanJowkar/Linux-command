## call a webhook

```sh

# n8n webhook
curl -X POST https://nnnn.biatobagh.ir/webhook-ca/user-info \
-H "Content-Type: application/json" \
-d '{
    "name":"Iman",
    "age":28
}'



# get update
curl "https://tapi.bale.ai/botYOUR_BOT_TOKEN/getUpdates"

# send msg with curl
curl -X POST \
  "https://tapi.bale.ai/botYOUR_BOT_TOKEN/sendMessage" \
  -H "Content-Type: application/json" \
  -d '{
    "chat_id": "YOUR_CHAT_ID",
    "text": "Test message from Zabbix"
  }'




```

```sh

# set webhook in bale bot for recv data
curl https://tapi.bale.ai/botYOUR_BOT_TOKEN/getWebhookInfo


#set webhook for test
curl https://tapi.bale.ai/botYOUR_BOT_TOKEN/setWebhook?url=https://n8n.biatobagh.ir/webhook-test/reci-data

# set webhook for production
curl https://tapi.bale.ai/botYOUR_BOT_TOKEN/setWebhook?url=https://n8n.biatobagh.ir/webhook/reci-data




https://n8n.biatobagh.ir/webhook-test/reci-data

```


```sh



# python call webhook
python3 -m venv venv
pip install faker requests

vim app.py
-----
import random
import time
import requests
from faker import Faker

# ------------------------------------
# Configuration
# ------------------------------------
WEBHOOK_URL = "https://nnnn.biatobagh.ir/webhook/send"


INTERVAL = 5          # seconds
USERS_PER_REQUEST = 10

fake = Faker()

universities = [
    "Massachusetts Institute of Technology",
    "Stanford University",
    "Harvard University",
    "University of Oxford",
    "University of Cambridge",
    "ETH Zurich",
    "University of Toronto",
    "University of Tokyo",
    "National University of Singapore",
    "Technical University of Munich",
    "University of California, Berkeley",
    "Carnegie Mellon University",
    "Princeton University",
    "Yale University",
    "Imperial College London"
]

degrees = [
    "Associate",
    "Bachelor",
    "Master",
    "PhD"
]


def generate_user():
    return {
        "name": fake.name(),
        "age": random.randint(18, 65),
        "city": fake.city(),
        "job": fake.job(),
        "university": random.choice(universities),
        "degree": random.choice(degrees),
        "country": fake.country()
    }


def main():
    print(f"Sending {USERS_PER_REQUEST} users every {INTERVAL} seconds...")
    print(f"Webhook: {WEBHOOK_URL}\n")

    while True:
        users = [generate_user() for _ in range(USERS_PER_REQUEST)]

        try:
            response = requests.post(
                WEBHOOK_URL,
                json=users,
                headers={"Content-Type": "application/json"},
                timeout=10,
            )

            print("=" * 70)
            print(f"Sent {len(users)} users")
            print(f"Status Code : {response.status_code}")

            if response.text:
                print("Response    :", response.text)

            print("First user:")
            print(users[0])

        except requests.exceptions.RequestException as e:
            print(f"Request failed: {e}")

        time.sleep(INTERVAL)


if __name__ == "__main__":
    main()

-----


```