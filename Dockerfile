# Image Python légère
FROM python:3.11-slim

# Installer dépendances système nécessaires
RUN apt-get update && apt-get install -y \
    gcc \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Définir le dossier de travail dans le container
WORKDIR /app

# Copier les fichiers essentiels
COPY ./app.py /app/
COPY ./best.pt /app/

# Installer les dépendances Python
RUN pip install --no-cache-dir --upgrade pip \
 && pip install --no-cache-dir ultralytics fastapi uvicorn pillow numpy opencv-python-headless

# Exposer le port utilisé par FastAPI
EXPOSE 8000

# Commande de démarrage du serveur FastAPI
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
