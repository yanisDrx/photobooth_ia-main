# 🎨 Photo Booth IA – MDM 2025

Photobooth intelligent combinant vision par ordinateur, interaction gestuelle et génération d’images via Stable Diffusion XL.

Ce projet propose une expérience immersive où l’utilisateur interagit uniquement avec ses mains pour choisir un univers visuel, capturer une photo et générer une version stylisée par IA, prête à être imprimée.

---

# 📑 Sommaire

- [1. Présentation du projet](#1-présentation-du-projet)
- [2. Storyboard utilisateur (expérience complète)](#2-storyboard-utilisateur-expérience-complète)
- [3. Fonctionnement général du système](#3-fonctionnement-général-du-système)
- [4. Système d’interaction gestuelle](#4-système-dinteraction-gestuelle)
- [5. Profils de filtres & prompts](#5-profils-de-filtres--prompts)
- [6. Architecture technique](#6-architecture-technique)
- [7. Prérequis matériel](#7-prérequis-matériel)
- [8. Recherche & choix de conception](#9-recherche--choix-de-conception)
- [9. Pistes d’amélioration](#10-pistes-damélioration)

---

# 1. Présentation du projet

Ce projet implémente un photobooth interactif basé sur :

- 📸 Capture webcam en temps réel
- 🖐️ Détection et reconnaissance de gestes
- 🎨 Prévisualisation instantanée de styles (filtres temps réel)
- 🤖 Génération d’image via **Stable Diffusion XL + ControlNet OpenPose**
- 🖼️ Ajout automatique d’un logo
- 🖨️ Impression physique au format A6 glacé

L’utilisateur n’utilise **ni souris ni écran tactile** : tout se fait par gestes.

L’objectif est de créer une expérience fluide, intuitive et immersive.

---

# 2. Storyboard utilisateur (expérience complète)

### Étape 1 — Positionnement
L’utilisateur se place devant la webcam.

---

### Étape 2 — Prévisualisation (main gauche)

Il lève des doigts avec la **main gauche** pour tester différents styles.

 -> Cette action applique uniquement un filtre local (preview).
 -> Aucun prompt n’est encore envoyé à l’IA.

---

### Étape 3 — Sélection du style (main droite)

Il reproduit le même nombre de doigts avec la **main droite**.

 -> Cette action sélectionne officiellement le profil.
 -> Le prompt correspondant est chargé et sera transmis à l’IA lors de la génération.

---

### Étape 4 — Capture

Il déclenche la capture avec 👍 pouce gauche.

 -> L’image originale est enregistrée.
 -> Le prompt validé (main droite) est associé à cette image.

---

### Étape 5 — Génération IA

Le système envoie à Stable Diffusion :

- l’image originale
- le prompt sélectionné via la main droite

L’IA applique le style choisi.

---

### Étape 6 — Impression

Validation avec 👍 pouce droit.

L’image générée est imprimée.

---

# 3. Fonctionnement général du système

| Main | Rôle |
|------|------|
| ✋ Main gauche | Prévisualisation des filtres + Capture |
| 🤚 Main droite | Sélection du prompt + Impression |

### Principe clé

- La **prévisualisation** n’affecte jamais l’image envoyée à l’IA.
- La **main droite détermine le prompt réel** envoyé à Stable Diffusion.
- Les gestes système (capture / impression) sont isolés pour éviter tout conflit.

---

# 4. Système d’interaction gestuelle

## Règles fondamentales

- Le pouce n’est **jamais utilisé pour choisir un profil**
- Les profils commencent à partir de l’index levé
- Un poing fermé = état neutre
- Le nombre de doigts levés = numéro du profil

Cette logique évite les conflits entre sélection de style et actions système.

---

# 5. Profils de filtres & prompts

## Logique

- Main gauche → preview visuelle locale (OpenCV)
- Main droite → sélection du prompt Stable Diffusion

Le nombre de doigts correspond au même profil pour les deux mains.

---

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

# 6. Architecture technique

## Pipeline simplifié

1. Capture frame via OpenCV
2. Détection des mains via MediaPipe
3. Comptage/Reconnaissance des doigts
4. Détermination du profil
5. Capture image originale
6. Encodage base64
7. Envoi à Stable Diffusion WebUI
8. Réception image stylisée
9. Ajout logo
10. Impression

## Dépendances Logicielles
### Stable Diffusion WebUI

- PyTorch 2.5.1 + CUDA 12.1
- xFormers 0.0.23
- Diffusers 0.31.0
- ControlNet Aux 0.0.10
- MediaPipe 0.10.21
- ONNX Runtime GPU 1.17.1

### Photo Booth

- OpenCV 4.11.0
- MediaPipe 0.10.21
- NumPy 1.26.2
- Requests 2.32.5
- Python 3.10.x

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


---

# 9. Recherche & choix de conception

## Conflit du pouce

Le pouce était initialement un profil.

Problème : déjà utilisé pour l’impression.

Solution :

- Suppression du pouce comme profil
- Profils démarrent à l’index

---

## Conflit avec ✌

Servait à capturer.

Conflit avec Profil 2.

Solution :

- Capture = 👍 gauche
- Impression = 👍 droite

Interaction claire et intuitive.

---

# 10. Pistes d’amélioration

- Segmentation sujet/fond
- Filtres animés en temps réel
- Optimisation GPU
- Interface plein écran dédiée
- Mode multi-utilisateur
