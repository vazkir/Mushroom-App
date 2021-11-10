import os
from fastapi import FastAPI
from starlette.middleware.cors import CORSMiddleware
from fastapi import File
from tempfile import TemporaryDirectory
from api import model
import asyncio
from api.tracker import TrackerService
import pandas as pd
from api.local import RUN_LOCAL



# Initialize Tracker Service
tracker_service = TrackerService()

# Setup FastAPI app
app = FastAPI(
    title="API Server",
    description="API Server",
    version="v1"
)

# Enable CORSMiddleware
app.add_middleware(
    CORSMiddleware,
    allow_credentials=False,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# Call the tracker service when the API service starts running.
@app.on_event("startup")
async def startup():
    # Startup tasks
    # Start the tracker service
    asyncio.create_task(tracker_service.track())

@app.get("/best_model")
async def get_best_model():
    model.check_model_change()
    if model.best_model is None:
        return {"message": 'No model available to serve'}
    else:
        return {
            "message": 'Current model being served:'+model.best_model["model_name"],
            "model_details": model.best_model
        }


@app.post("/predict")
async def predict(
        file: bytes = File(...)
):
    print("predict file:", len(file), type(file))

    # Save the image
    with TemporaryDirectory() as image_dir:
        image_path = os.path.join(image_dir, "test.png")
        with open(image_path, "wb") as output:
            output.write(file)

        # Make prediction
        prediction_results = model.make_prediction(image_path)

    return prediction_results


@app.get("/leaderboard")
def leaderboard_fetch():
    leaderboard_path ="/persistent/experiments/leaderboard.csv"

    if RUN_LOCAL:
        # Pyenv root is inside this folder
        path_lead =  "../../persistent-folder/experiments/leaderboard.csv"
        leaderboard_path = os.path.join(os.path.dirname(__file__),path_lead)

      
    # Fetch leaderboard
    df = pd.read_csv(leaderboard_path)

    df["id"] = df.index
    df = df.fillna('')

    return df.to_dict('records')



# Routes
@app.get("/")
async def get_index():
    return {
        "message": "Welcome to the API Service"
    }


# Routes
@app.get("/mushr")
async def get_index():
    return {
        "message": "Mushrooms test"
    }