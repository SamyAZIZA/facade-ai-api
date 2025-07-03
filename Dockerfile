# Utiliser une image officielle Python légère
FROM python:3.11-slim

# Installer les dépendances système nécessaires
RUN apt-get update && apt-get install -y \
    gcc \
    libgl1-mesa-glx \
    && rm -rf /var/lib/apt/lists/*

# Copier les fichiers de l’API dans le container
WORKDIR /app
COPY ./app.py /app/
COPY ./best.pt /app/

# Installer pip + ultralytics + fastapi + uvicorn + pillow + numpy
RUN pip install --no-cache-dir --upgrade pip \
 && pip install --no-cache-dir ultralytics fastapi uvicorn pillow numpy

# Exposer le port 8000 pour l’API
EXPOSE 8000

# Commande pour lancer le serveur uvicorn
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]

