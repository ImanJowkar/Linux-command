# main.py

from fastapi import FastAPI
import random
app = FastAPI()

@app.get("/")
async def get_price():
    rand = 10 * random.random() + 2
    return rand

