# main.py

from fastapi import FastAPI
import random
import json
from fastapi.responses import JSONResponse
from faker import Faker

app = FastAPI()

fake = Faker()


@app.get("/")
async def get_random():
    rand = 10 * random.random() + 2
    dict1 = {'rand': rand}
    dict1['name'] = str(fake.name())
    return JSONResponse(dict1)



