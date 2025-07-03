from fastapi import FastAPI, UploadFile, File
from fastapi.responses import JSONResponse
from ultralytics import YOLO
import numpy as np
from PIL import Image
import io

app = FastAPI()
model = YOLO("best.pt")  # ton modèle

@app.post("/analyze")
async def analyze(file: UploadFile = File(...)):
    # Lire l'image reçue
    contents = await file.read()
    img = Image.open(io.BytesIO(contents)).convert("RGB")
    img_array = np.array(img)

    # Prédiction avec seuil de confiance à 0.2
    results = model.predict(source=img_array, conf=0.2, save=False)

    detections = []
    # Parcourir toutes les détections
    for result in results:
        boxes = result.boxes
        for box in boxes:
            detection = {
                "label": model.names[int(box.cls[0])],
                "confidence": float(box.conf[0]),
                "coordinates": box.xyxy[0].tolist()  # [x1, y1, x2, y2]
            }
            detections.append(detection)

    return JSONResponse(content={"detections": detections})
