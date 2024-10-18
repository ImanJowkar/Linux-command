from fastapi import FastAPI
import random
import json
from fastapi.responses import JSONResponse
from faker import Faker
import uvicorn

fake = Faker()
app = FastAPI()

@app.get("/")
async def get_random():
    rand = 10 * random.random() + 2
    dict1 = {'rand': rand}
    dict1['name'] = str(fake.name())
    return JSONResponse(dict1)


if __name__ == "__main__":
    uvicorn.run("main:app", port=8000, host='0.0.0.0', log_level="info")
