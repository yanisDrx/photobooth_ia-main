# 🎨 Photo Booth IA - MDM 2025

Photo booth intelligent avec génération d'images par IA utilisant Stable Diffusion XL et détection de gestes en temps réel.

---

## 📋 Description

Ce projet crée un photobooth interactif qui :

- 📸 Capture des photos via webcam avec détection de gestes
- 🤖 Génère des images stylisées via **Stable Diffusion XL + ControlNet OpenPose**
- 🖐️ Permet de choisir le prompt envoyé à Stable Diffusion XL à l'aide de gestes
- 👁️ Permet la prévisualisation des profils de prompt à l'aide de filtres appliqués en temps réel
- 🖼️ Applique automatiquement un logo transparent (template CPE)
- 🖨️ Imprime les résultats sur imprimante HP Color LaserJet au format A6 glacé

---

# 🖐️ Système d'interaction gestuelle

Le photobooth fonctionne avec une logique claire séparant :

- **Main gauche → prévisualisation + capture**
- **Main droite → sélection du prompt + impression**

Chaque main a un rôle précis afin d'éviter les conflits de gestes.

---

## 🎨 Profils de prompt (sélection avec la main droite)

⚠️ Seuls les doigts à partir de l’index sont utilisés pour éviter tout conflit avec les gestes système.

| Profil | Geste (main droite) | Effet |
|--------|--------------------|-------|
| 0 | Poing fermé | Image classique (aucun prompt IA) |
| 1 | Index levé | Style futuristique cartoon |
| 2 | Index + majeur levés | Style médiéval |
| 3 | Index + majeur + annulaire levés | Style naturel |
| 4 | Index + majeur + annulaire + auriculaire levés | Style artistique avancé |

- Le profil sélectionné est confirmé à l’écran (ex: **"Profil 2 appliqué"**).
- Ce profil détermine le prompt envoyé à Stable Diffusion lors de la génération.

---

## 👁️ Prévisualisation des profils (main gauche)

La main gauche permet uniquement de visualiser le rendu associé aux profils.

| Geste (main gauche) | Effet |
|---------------------|-------|
| Poing fermé | Aucun filtre |
| 1 doigt levé | Filtre correspondant au Profil 1 |
| 2 doigts levés | Filtre correspondant au Profil 2 |
| 3 doigts levés | Filtre correspondant au Profil 3 |
| 4 doigts levés | Filtre correspondant au Profil 4 |

Important :

- La main gauche **n'applique jamais le prompt IA final**.
- Elle applique seulement un filtre visuel temporaire sur le flux vidéo.
- Le nombre de doigts correspond exactement aux profils disponibles.
- Cela permet à l’utilisateur de tester visuellement avant d’appliquer le prompt réel.

---

## 📸 Capture et impression

Les gestes système sont séparés pour éviter toute ambiguïté :

| Geste | Action |
|-------|--------|
| 👍 Pouce gauche levé (2s)| Capture la photo (déclenchement du compte à rebours) |
| 👍 Pouce droit levé (2s)| Impression de la photo |

---

## 🔄 Storyboard utilisateur complet

0. Un utilisateur lance le programme Photobooth, puis se place en face de la webcam (seul ou à plusieurs)
1. L'utilisateur peut tester (ou non) différents styles avec la main gauche. Ex : lève l'index gauche pour visualiser le filtre profil 1
2. Il peut séléctionner un profil de prompt avec la main droite. Ex : lève l'index droit pour confirmer le prompt correspondant au filtre visualisé en temps reel.
3. Il déclenche la capture en levant le pouce gauche.
4. Il valide l’impression en levant le pouce droit.

---

# 🔧 Prérequis matériel

| Composant | Spécification |
|-----------|--------------|
| **GPU** | NVIDIA avec CUDA (RTX 2060+ recommandé) |
| **Webcam** | Résolution 720p minimum |
| **Écran** | 3840×1080 (dual monitor recommandé) |
| **Imprimante** | HP Color LaserJet 5700 + papier A6 glacé 200g |
| **RAM** | 16 GB minimum (32 GB recommandé pour SDXL) |

---

# 🔧 Dépendances logicielles

## Stable Diffusion WebUI

- PyTorch 2.5.1 + CUDA 12.1
- xFormers 0.0.23
- Diffusers 0.31.0 (SDXL)
- ControlNet Aux 0.0.10 (OpenPose)
- MediaPipe 0.10.21
- ONNX Runtime GPU 1.17.1

## Photo Booth

- OpenCV 4.11.0
- MediaPipe 0.10.21
- NumPy 1.26.2
- Requests 2.32.5
- Python 3.10.x

---

**TODO** : Expliquer comment avec uniquement openCV il est possible de faire des filtres type snap (ajouter/modifier des couleurs, ajouter des vignettes, des overlay PNG etc.)
...

---

# 🔬 Recherche et développement du concept

## Problème 1 : Conflit avec le pouce levé

Initialement, 5 profils étaient prévus :

- Profil 1 devait correspondre au **pouce levé seul**.

Problème :
Le pouce était déjà utilisé pour déclencher l'impression.

Solution adoptée :
- Suppression du pouce comme geste de sélection de profil.
- Les profils commencent désormais à partir de l’index levé.
- Nombre total réduit à **4 profils personnalisés + 1 profil par défaut**.

---

## Problème 2 : Conflit avec le symbole ✌️ (index + majeur)

Le Profil 2 correspondait naturellement à :

Index + majeur levés.

Mais ce geste était initialement utilisé pour déclencher la capture photo.

Cela créait un conflit logique :
Le système ne pouvait pas distinguer si l’utilisateur voulait :
- Sélectionner un profil
- Prendre la photo

Solution adoptée :

- Suppression complète du geste ✌️ comme déclencheur de capture.
- Nouvelle logique :
  - 👍 Pouce gauche → Capture
  - 👍 Pouce droit → Impression

Cela permet :

- Une séparation claire des responsabilités entre les mains
- Aucun conflit entre sélection de profil et actions système
- Une interaction plus intuitive

---

## Idées pour les curieux :
- 

