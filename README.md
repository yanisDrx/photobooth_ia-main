# Photo Booth IA – MDM 2025

Photobooth intelligent combinant vision par ordinateur, interaction gestuelle et génération d’images via Stable Diffusion XL.

Ce projet propose une expérience immersive où l’utilisateur interagit uniquement avec ses mains pour choisir un univers visuel, capturer une photo et générer une version stylisée par IA, prête à être imprimée.

---

# Sommaire

- [1. Présentation du projet](#1-présentation-du-projet)
- [2. Storyboard utilisateur (expérience complète)](#2-storyboard-utilisateur-expérience-complète)
- [3. Fonctionnement général du système](#3-fonctionnement-général-du-système)
- [4. Profils de filtres & prompts](#5-profils-de-filtres--prompts)
- [5. Architecture technique et dépendances logicielles](#6-architecture-technique-et-dépendances-logicielles)
- [6. Prérequis matériel](#7-prérequis-matériel)
- [7. Recherche & choix de conception](#9-recherche--choix-de-conception)
- [8. Pistes d’amélioration](#10-pistes-damélioration)

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

### Étape 2 — Prévisualisation (main gauche)

Il lève des doigts avec la **main gauche** pour tester différents styles.

 -> Cette action applique uniquement un filtre local (preview).
 -> Aucun prompt n’est encore envoyé à l’IA.

### Étape 3 — Sélection du style (main droite)

Il reproduit le même nombre de doigts avec la **main droite**.

 -> Cette action sélectionne officiellement le profil.
 -> Le prompt correspondant est chargé et sera transmis à l’IA lors de la génération.
 -> Un message de confirmation du choix du profil est affiché sur l'écran

### Étape 4 — Génération IA

Le système envoie à Stable Diffusion :

- l’image originale
- le prompt sélectionné via la main droite

L’IA applique le style choisi.

### Étape 5 — Capture  

Il déclenche la capture avec 👍 pouce gauche.

 -> L'utilisateur doit garder son pouce levé 2 secondes pour confirmer la capture.
 -> Un chargement indiquant la progression sur l'écoulement du cooldown s'affiche.
 -> Une fois le cooldown terminé, un message de confirmation s'affiche.
 -> L’image générée par IA est enregistrée.
 
### Étape 6 — Impression

Validation avec 👍 pouce droit.

 -> L'utilisateur doit garder son pouce levé 2 secondes pour confirmer l'impression.
 -> Un chargement indiquant la progression sur l'écoulement du cooldown s'affiche.
 -> Une fois le cooldown terminé, un message de confirmation s'affiche.
 -> L’image générée est imprimée.

---

# 3. Fonctionnement général du système

| Main | Rôle |
|------|------|
| ✋ Main gauche | Prévisualisation des filtres + Capture |
| 🤚 Main droite | Sélection du prompt + Impression |

## Principes clés

- La **prévisualisation** n’affecte jamais l’image (le prompt) envoyée à l’IA.
- La **main droite détermine le prompt réel** envoyé à Stable Diffusion.
- Les gestes système (capture / impression) sont isolés pour éviter tout conflit.

## Règles de gestuelle

- Le pouce n’est **jamais utilisé pour choisir un profil**
- Les profils commencent à partir de l’index levé
- Un poing fermé = état neutre
- Le nombre de doigts levés = numéro du profil

---

# 4. Profils de filtres & prompts

## Tableau récapitulatif

| Geste | Profil | Image |
|-------|--------|-------|
| ✊ Poing fermé | Default | <img src="images_profils/profil0.jpg" width="200"> |
| ☝ 1 doigt | Futuriste cartoon | <img src="images_profils/profil1.jpg" width="200"> |
| ✌ 2 doigts | Médiéval | <img src="images_profils/profil2.png" width="200"> |
| 🤟 3 doigts | Naturel / Jungle | <img src="images_profils/profil3.png" width="200"> |
| 🖖 4 doigts | Artistique / Peinture | <img src="images_profils/profil4.jpg" width="200"> |

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

# 5. Architecture technique et dépendances logicielles

## Pipeline simplifié

1. Capture image via OpenCV
2. Détection des mains via MediaPipe
3. Comptage/Reconnaissance des doigts
4. Détermination du profil
5. Capture image originale
6. Encodage base64
7. Envoi à Stable Diffusion WebUI
8. Réception image stylisée
9. Capture et/ou impression de l'image générée

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

# 6. Prérequis matériel

| Composant | Spécification |
|-----------|--------------|
| GPU | NVIDIA RTX 2060+ recommandé |
| RAM | 16GB minimum (32GB recommandé) |
| Webcam | 720p minimum |
| Écran | 3840x1080 recommandé |
| Imprimante | HP Color LaserJet 5700 |

---

# 7. Recherche & choix de conception

## Conflit avec Symbole V

Servait à capturer.
Conflit avec Profil 2.
Solution :

- Capture = 👍 gauche
- Impression = 👍 droite

Interaction claire et intuitive.

---

# 10. Pistes d’amélioration

- ...
