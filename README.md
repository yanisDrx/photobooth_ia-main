# 🎨 Photo Booth IA – MDM 2025

Photobooth intelligent combinant vision par ordinateur, interaction gestuelle et génération d’images via Stable Diffusion XL.

---

# 📑 Sommaire

- [1. Présentation du projet](#1-présentation-du-projet)
- [2. Fonctionnement général](#2-fonctionnement-général)
- [3. Système d’interaction gestuelle](#3-système-dinteraction-gestuelle)
- [4. Profils de filtres & prompts](#4-profils-de-filtres--prompts)
- [5. Storyboard utilisateur](#5-workflow-utilisateur)
- [6. Architecture technique](#6-architecture-technique)
- [7. Prérequis matériel](#7-prérequis-matériel)
- [8. Dépendances logicielles](#8-dépendances-logicielles)
- [9. Recherche & choix de conception](#9-recherche--choix-de-conception)
- [10. Pistes d’amélioration](#10-pistes-damélioration)

---

# 1. Présentation du projet

Ce projet implémente un photobooth interactif capable de :

- 📸 Capturer une image via webcam
- 🖐️ Détecter des gestes en temps réel
- 🎨 Prévisualiser des styles via filtres live
- 🤖 Générer une image stylisée avec **Stable Diffusion XL + ControlNet OpenPose**
- 🖼️ Ajouter automatiquement un logo
- 🖨️ Imprimer le résultat au format A6 glacé

L’objectif est de proposer une expérience intuitive, immersive et sans interface tactile.

---

# 2. Fonctionnement général

| Main | Rôle |
|------|------|
| ✋ Main gauche | Prévisualisation des filtres + Capture |
| 🤚 Main droite | Sélection du prompt + Impression |

Principe clé :

- La **prévisualisation** n’affecte jamais l’image envoyée à l’IA.
- Le **profil sélectionné à droite** détermine réellement le prompt envoyé à Stable Diffusion.
- Les gestes système (capture / impression) sont isolés pour éviter tout conflit.

---

# 3. Système d’interaction gestuelle

## Règles fondamentales

- Le pouce n’est **jamais utilisé pour choisir un profil**
- Les profils commencent à partir de l’index levé
- Un poing fermé = état par défaut
- Le nombre de doigts levés correspond exactement au numéro du profil

---

# 4. Profils de filtres & prompts

## Logique

La main gauche permet de **visualiser** un style.

La main droite permet de **confirmer l’application réelle du prompt IA correspondant**.

Le nombre de doigts levés est identique pour la preview et la sélection.

## Prompts de Profils

**Profil 1 : Médiéval**
```python
PROMPT_MEDIEVAL = (
    "medieval fantasy illustration, cinematic lighting, ultra detailed, realistic textures, "
    "knight armor with engraved steel, leather straps, medieval tunic, "
    "(stone castle background:1.3), (torch light atmosphere:1.2), warm fire glow, "
    "(dramatic volumetric lighting:1.2), epic fantasy mood, "
    "high detail fabric texture, 14th century aesthetic, "
    "sharp focus, 4k, professional fantasy artwork"
)

NEGATIVE_PROMPT_MEDIEVAL = (
    "modern clothes, futuristic objects, neon lights, cyberpunk, low quality, blurry, "
    "extra fingers, extra limbs, deformed hands, bad anatomy"
)

```

**Profil 2 : Jungle**
```python
PROMPT_JUNGLE = (
    "tropical jungle portrait, cinematic natural lighting, ultra realistic, "
    "(lush green foliage:1.3), (hanging vines:1.2), dense rainforest background, "
    "sunlight rays through trees, humid atmosphere, "
    "(leaf crown and natural elements integrated into clothing:1.2), "
    "earth tones color palette, shallow depth of field, "
    "high detail skin texture, photorealistic, 4k photography"
)

NEGATIVE_PROMPT_JUNGLE = (
    "urban background, buildings, modern objects, cold lighting, cyberpunk, "
    "low resolution, blurry, extra fingers, extra limbs, bad anatomy"
)
```

**Profil 3 : Futuriste**
```python
PROMPT_FUTURISTIC = (
    "futuristic sci-fi portrait, cinematic lighting, ultra detailed, "
    "(holographic interface around subject:1.3), (floating transparent screens:1.2), "
    "cyberpunk city background, neon cyan and magenta glow, "
    "(advanced wearable technology:1.2), glowing circuits on clothes, "
    "high contrast lighting, reflective glass surfaces, "
    "professional sci-fi photography, 4k, sharp focus"
)

NEGATIVE_PROMPT_FUTURISTIC = (
    "medieval objects, nature forest, warm lighting, low detail, blurry, "
    "extra fingers, extra limbs, deformed anatomy"
)
```

**Profil 4 : Peinture**
```python
PROMPT_ARTISTIC = (
    "oil painting portrait, renaissance inspired, dramatic chiaroscuro lighting, "
    "(visible brush strokes:1.3), textured canvas effect, "
    "warm golden highlights, deep shadows, "
    "classical fine art composition, museum quality painting, "
    "high detail face, realistic proportions, "
    "8k resolution, masterpiece"
)

NEGATIVE_PROMPT_ARTISTIC = (
    "photography, modern background, flat lighting, low quality, "
    "extra fingers, extra limbs, bad anatomy"
)
```
---

## Tableau récapitulatif

| Geste | Main gauche (Preview filtre) | Main droite (Prompt appliqué) | Exemple visuel |
|-------|-----------------------------|-------------------------------|----------------|
| ✊ Poing fermé | Aucun filtre | Image classique (pas de prompt) | *(Image par défaut ici)* |
| ☝ 1 doigt | Filtre futuriste | Prompt futuriste cartoon | *(Image exemple profil 1 ici)* |
| ✌ 2 doigts | Filtre médiéval | Prompt médiéval | *(Image exemple profil 2 ici)* |
| 🤟 3 doigts | Filtre naturel | Prompt nature réaliste | *(Image exemple profil 3 ici)* |
| 🖖 4 doigts | Filtre artistique | Prompt artistique avancé | *(Image exemple profil 4 ici)* |


---

# 5. Workflow utilisateur

## Exemple d’utilisation

1. L’utilisateur lance le programme.
2. Il se place devant la webcam.
3. Il teste différents styles avec la main gauche.
4. Lorsqu’un filtre lui plaît, il reproduit le même nombre de doigts avec la main droite.
5. Un message confirme : *“Profil X appliqué”*.
6. Il déclenche la capture avec 👍 pouce gauche.
7. L’image est générée par Stable Diffusion.
8. Il valide l’impression avec 👍 pouce droit.

---

# 6. Architecture technique

## Vue simplifiée du pipeline

1. OpenCV capture une frame
2. MediaPipe détecte les mains
3. Le système compte les doigts
4. Sélection du profil
5. Capture image originale
6. Encodage base64
7. Envoi à Stable Diffusion
8. Réception image stylisée
9. Ajout du logo
10. Impression

---

## Modules utilisés

### 🎥 OpenCV

Rôle :

- Capture webcam
- Affichage temps réel
- Dessin UI
- Application des filtres preview

Les filtres type “Snap” sont réalisés via :

- Modification des canaux RGB
- Flou gaussien
- Vignette
- Overlay PNG (textures, feuillages, lumières)

Aucune librairie externe supplémentaire n’est nécessaire pour ces effets.

---

### 🖐 MediaPipe

Rôle :

- Détection de 2 mains max
- Extraction de 21 points clés par main
- Détermination des doigts levés

Permet :

- Identifier main gauche / droite
- Compter les doigts
- Déclencher actions système

---

### 🌐 Requests

Permet :

- Envoyer l’image en base64 à Stable Diffusion WebUI
- Récupérer l’image générée

---

### 🤖 Stable Diffusion XL + ControlNet

Utilisé en mode `img2img` avec :

- SDXL
- ControlNet OpenPose

ControlNet permet de conserver la posture tout en modifiant le style.

Paramètres clés :

- CFG Scale
- Denoising Strength
- Steps
- Sampler

---

## Séparation critique

- `frame_original` → envoyé à l’IA
- `frame_preview` → utilisé uniquement pour les filtres

Cela garantit :

- Aucune altération involontaire
- Architecture propre
- Debug simplifié

---

# 7. Prérequis matériel

| Composant | Spécification |
|-----------|--------------|
| GPU | NVIDIA RTX 2060+ recommandé |
| RAM | 16GB minimum (32GB recommandé) |
| Webcam | 720p minimum |
| Écran | 3840x1080 recommandé |
| Imprimante | HP Color LaserJet 5700 |

---

# 8. Dépendances logicielles

## Stable Diffusion WebUI

- PyTorch 2.5.1 + CUDA 12.1
- xFormers 0.0.23
- Diffusers 0.31.0
- ControlNet Aux 0.0.10
- MediaPipe 0.10.21
- ONNX Runtime GPU 1.17.1

## Photo Booth

- OpenCV 4.11.0
- MediaPipe 0.10.21
- NumPy 1.26.2
- Requests 2.32.5
- Python 3.10.x

---

# 9. Recherche & choix de conception

## Problème 1 : Conflit avec le pouce

Initialement utilisé pour un profil.

Problème : déjà assigné à l’impression.

Solution :

- Suppression du pouce comme sélection de profil
- Profils démarrent à l’index

---

## Problème 2 : Conflit avec ✌

Index + majeur servaient à la capture.

Conflit avec Profil 2.

Solution :

- Suppression du geste ✌ pour capturer
- 👍 Gauche → Capture
- 👍 Droite → Impression

Résultat :

- Interaction claire
- Aucun conflit logique
- Système intuitif

---

# 10. Pistes d’amélioration

- Segmentation sujet/fond
- Filtres dynamiques animés
- Optimisation GPU
- Interface plein écran dédiée
- Mode multi-utilisateur avancé

---
