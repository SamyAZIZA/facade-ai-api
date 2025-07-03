FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    gcc \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY ./app.py /app/
COPY ./best.pt /app/

RUN pip install --no-cache-dir --upgrade pip \
 && pip install --no-cache-dir ultralytics fastapi uvicorn pillow numpy opencv-python-headless python-multipart

EXPOSE 8000

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
