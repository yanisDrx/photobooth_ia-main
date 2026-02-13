# 🎨 Photo Booth IA - MDM 2025

Photo booth intelligent avec génération d'images par IA utilisant Stable Diffusion XL et détection de gestes en temps réel.

## 📋 Description

Ce projet crée un photobooth interactif qui :
- 📸 Capture des photos via webcam avec détection de gestes (signe V ✌️, pouce levé 👍)
- Génère des images stylisées **"Comic Book Ligne Claire"** via Stable Diffusion XL + ControlNet OpenPose
- Applique automatiquement un logo transparent (template CPE)
-  Imprime les résultats sur imprimante HP Color LaserJet au format A6 glacé 🖨️

### Style graphique
- **Bande dessinée européenne** (ligne claire)
- Traits nets et épurés, aplats de couleurs avec dégradés
- Scènes futuristes avec interfaces holographiques cyan/orange
- Arrière-plans technologiques complexes

---

## 🔧 Prérequis matériel

| Composant | Spécification |
|-----------|--------------|
| **GPU** | NVIDIA avec CUDA (RTX 2060+ recommandé) |
| **Webcam** | Résolution 720p minimum |
| **Écran** | 3840×1080 (dual monitor) recommandé |
| **Imprimante** | HP Color LaserJet 5700 + papier A6 glacé 200g |
| **RAM** | 16 GB minimum (32 GB recommandé pour SDXL) |


## 🔧 Dépendances de Stable Diffusion WebUI :

PyTorch 2.5.1 + CUDA 12.1 ✅

xFormers 0.0.23 pour optimisations ✅

Diffusers 0.31.0 (SDXL) ✅

ControlNet Aux 0.0.10 (OpenPose) ✅

MediaPipe 0.10.21 (détection gestes) ✅

ONNX Runtime GPU 1.17.1 (inference) ✅

## 🔧 Dépendances du Photo Booth  :

OpenCV 4.11.0 ✅

MediaPipe 0.10.21 ✅

NumPy 1.26.2 ✅

Requests 2.32.5 ✅

---

## PHOTO BOOTH IA - ARCHITECTURE SYSTEME

```text


COUCHE MATERIELLE
-----------------
        Webcam USB          GPU NVIDIA          Imprimante HP
        1280x720            CUDA/cuDNN          A6 Glossy
            |                   |                   |
            +-------------------+-------------------+
                                |
SYSTEME D'EXPLOITATION (Linux/Windows)
Drivers: V4L2 (webcam), CUPS (imprimante), NVIDIA (GPU)
                                |
ENVIRONNEMENT PYTHON 3.10 (venv)
PyTorch 2.x + CUDA + xFormers
```


## APPLICATION PHOTOBOOTH (photobooth.py)


```text
MODULE 1: CAPTURE & DETECTION
------------------------------
OpenCV           MediaPipe         Detection Gestes
VideoCapture --> Hands Module -->  - Victory (V)
1280x720         21 pts/main       - Thumbs Up
30 FPS                             - Maintien 2 secondes
                                          |
                                          v
MODULE 2: MACHINE A ETATS
-------------------------
[waiting_victory] --(V 2s)--> [countdown] --(capture)--> [processing]
       ^                                                       |
       |                                                       v
       +----------(V 2s)--------+                    [IA terminee]
                                |                             |
                         [ready_print] <---------------------+
                                |
                                +--(pouce 2s)--> [printing]

MODULE 3: PREPARATION IMAGE
---------------------------
Frame capturee (numpy array BGR 1280x720)
    |
    v
Redimensionnement --> Encodage Base64 --> Sauvegarde _input.png + Logo CPE
                                                |
                                                v
                                    HTTP POST Request (JSON)


```
## STABLE DIFFUSION WEBUI (Automatic1111)
```text
================================================================================
                STABLE DIFFUSION WEBUI (Automatic1111)
                    Port: 127.0.0.1:7860 - API REST
================================================================================

Endpoint: POST /sdapi/v1/img2img

Payload JSON:
{
  "init_images": ["base64_image"],
  "prompt": "comic book illustration...",
  "negative_prompt": "photorealistic, blurry...",
  "denoising_strength": 0.62,
  "steps": 28,
  "cfg_scale": 7.5,
  "sampler_name": "DPM++ 2M Karras",
  "width": 1280, "height": 720,
  "batch_size": 1,
  "n_iter": N_IMAGES,
  "controlnet_units": [{
    "model": "kohya_controllllite_xl_openpose_anime",
    "module": "openpose_full",
    "weight": 0.95,
    "guidance_start": 0.0,
    "guidance_end": 1.0
  }]
}

PIPELINE DE GENERATION
----------------------
ControlNet OpenPose --> SDXL UNet --> VAE Decoder --> Image 1280x720
(detection squelette)   (28 steps)    (latent->img)

MODELES CHARGES EN VRAM GPU:
- sd_xl_base_1.0.safetensors (6.9 GB)
- kohya_controllllite_xl_openpose_anime (1.5 GB)
- VAE SDXL (335 MB)
TOTAL: ~9-12 GB VRAM

Response JSON:
{
  "images": [
    "iVBORw0KGgoAAAANS...",  // Image IA #1
    "9j/4AAQSkZJRgABA...",   // Image IA #2
    ...
  ]
}



================================================================================
                   APPLICATION PHOTOBOOTH (Suite)
================================================================================

MODULE 4: POST-TRAITEMENT
-------------------------
Decodage Base64 --> Application Logo CPE --> Sauvegarde
    (PNG)           (Overlay RGBA)           result_API_1111/
                                             timestamp_IA1.png
                                             timestamp_IA2.png

MODULE 5: AFFICHAGE (OpenCV)
----------------------------
Ecran 3840x1080 (Dual Monitor)

Fenetre 1: "Webcam" (1440x810)
- Flux live 30 FPS
- Overlay gestes (cercles + barres progression)
- Messages etat systeme

Fenetre 2: "Image StableDiffusion" (1440x1620)
- Affiche derniere image IA
- Mise a jour apres generation

MODULE 6: IMPRESSION
--------------------
Files d'impression:
1. timestamp_input.png  <---- Photo originale + logo
2. timestamp_IA1.png    <---- Variation IA #1 + logo
3. timestamp_IA2.png    <---- Variation IA #2 + logo

Commande CUPS:
lp -d HP_Color_LaserJet_5700_USB
   -o media=A6
   -o InputSlot=Tray2
   -o mediaType=HP-Brochure-Glossy-200g
   -o orientation-requested=4
   -o print-quality=5
   image.png

CUPS Daemon --> USB --> HP LaserJet --> Photos imprimees


================================================================================
                            FLUX DE DONNEES
================================================================================

Webcam --> photobooth.py --> Automatic1111 --> photobooth.py
   |            |                  |                  |
   |            |                  |                  |
Frame BGR   JSON+Base64      Generation IA      Decode+Logo
1280x720    POST /img2img    ~20-30 sec         Sauvegarde
                             9-12 GB VRAM
                                                Display + Print


================================================================================
                   COMMUNICATION INTER-PROCESSUS
================================================================================

TERMINAL 1                          TERMINAL 2
bash launch_webui.sh                python photobooth.py

+------------------------+          +------------------------+
| Stable Diffusion WebUI |   HTTP   | Photo Booth Client     |
| Flask Server           | <------> | requests.post()        |
| Port 7860              |   REST   | Timeout: 180s          |
+------------------------+          +------------------------+
         |                                   |
         v                                   v
  PyTorch + CUDA                      OpenCV + MediaPipe
  GPU 0                               CPU threads

Process independant                 Process principal
Python 3.10 (venv WebUI)            Python 3.10 (venv photobooth)
Memoire: ~15 GB (modeles)           Memoire: ~500 MB
VRAM: 9-12 GB                       VRAM: 0 GB

```

## TIMELINE D'UNE SESSION

```text

t=0s      Utilisateur fait signe V

t=0-2s    Maintien geste --> Barre progression jaune

t=2s      Validation --> Countdown "3-2-1"

t=3s      Capture frame --> Flash bleu --> "PHOTO!"

t=3s      Sauvegarde input.png + logo
          Envoi requete HTTP POST --> Automatic1111

t=3-33s   Generation IA (SDXL + ControlNet)
          - OpenPose detection: ~1s
          - Diffusion 28 steps: ~25s
          - VAE decode: ~2s

t=33s     Reception images Base64
          Decodage + Application logo
          Sauvegarde IA1.png, IA2.png...

t=33s     Affichage fenetre StableDiffusion
          Etat: "ready_print"

t=33s+    Utilisateur decide:
          - Pouce 2s --> Impression
          - Signe V 2s --> Nouvelle photo

[SI IMPRESSION]

t=35-37s  Maintien pouce --> Validation

t=37s     Envoi CUPS: input.png + IA1.png + IA2.png

t=37-60s  Impression physique (~8s par page A6)

t=60s     Etat: "waiting_victory" (pret nouvelle session)

```
## DEPENDANCES CLES
```text

photobooth.py                    Automatic1111 WebUI
+-- opencv-python 4.11.0.86      +-- torch 2.5.1+cu121
+-- mediapipe 0.10.21            +-- diffusers 0.31.0
+-- numpy 1.26.2                 +-- transformers 4.30.2
+-- requests 2.32.5              +-- xformers 0.0.23.post1
+-- Python 3.10.x                +-- accelerate 0.21.0
                                 +-- safetensors 0.4.2
                                 +-- controlnet_aux 0.0.10
                                 +-- onnxruntime-gpu 1.17.1

Partagés (système):
+-- CUDA Toolkit 12.1
+-- cuDNN 9.1
+-- NVIDIA Driver 525+




## RESUME ARCHITECTURE SIMPLIFIEE


[Webcam] --frame--> [photobooth.py]
                         |
                         | HTTP POST (Base64)
                         v
                    [Automatic1111]
                         | Port 7860
                         | SDXL + ControlNet
                         | GPU: 9-12 GB VRAM
                         v
                    [photobooth.py]
                         |
                    +----+----+
                    |         |
                    v         v
                [Ecran]  [Imprimante]




```

### ⚠️ IMPORTANT : Python 3.10 OBLIGATOIRE pour WebUi

Stable Diffusion WebUI nécessite **Python 3.10.x** (pas 3.11, 3.12 ou supérieur) [web:1][web:8].

### Étape 1 : Installer Python 3.10

#### Sur Ubuntu/Debian
```bash
sudo apt update
sudo apt install python3.10 python3.10-venv python3.10-dev
