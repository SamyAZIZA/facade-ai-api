from fastapi import FastAPI, File, UploadFile
from fastapi.responses import JSONResponse
from ultralytics import YOLO
import io
from PIL import Image
import numpy as np

app = FastAPI()

# Charger le modèle une fois au lancement du serveur
model = YOLO("best.pt")

@app.post("/analyze")
async def analyze_image(file: UploadFile = File(...)):
    contents = await file.read()
    image = Image.open(io.BytesIO(contents)).convert("RGB")
    img_array = np.array(image)

    results = model.predict(source=img_array, conf=0.5, save=False)

    detections = []
    for r in results:
        boxes = r.boxes.xyxy.cpu().numpy()
        scores = r.boxes.conf.cpu().numpy()
        classes = r.boxes.cls.cpu().numpy()
        for box, score, cls in zip(boxes, scores, classes):
            detections.append({
                "bbox": box.tolist(),
                "confidence": float(score),
                "class_id": int(cls)
            })

    return JSONResponse(content={"detections": detections})

