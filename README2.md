# 🎨 Photo Booth IA - MDM 2025

Photo booth intelligent avec génération d'images par IA utilisant Stable Diffusion XL et détection de gestes en temps réel.

## 📋 Description

Ce projet crée un photobooth interactif qui :
- 📸 Capture des photos via webcam avec détection de gestes (signe V ✌️, pouce levé 👍)
- Génère des images stylisées via **Stable Diffusion XL + ControlNet OpenPose**
- Possibilité de choisir le prompt envoyé à Stable Diffusion XL à l'aide de gestes
- Prévisualisation des profils de prompt à l'aide de filtres appliqués en temps réel
- Applique automatiquement un logo transparent (template CPE)
- Imprime les résultats sur imprimante HP Color LaserJet au format A6 glacé 🖨️

### Profils de prompt (selection avec la main droite levée)
- 0) *Pas de doigts levés* : Image classique, pas de prompt envoyé, impression de l'image telle quelle.
- 1) *1 doigt levé* : Style futuristique, cartoon
...

---

## 🖐️ Interaction gestuelle avancée

Le photobooth intègre désormais un **système de sélection de profils de prompt et de filtres via les mains**.

### Main gauche : prévisualisation du filtre

- **Objectif** : voir à l’écran quel type de rendu ou prompt correspond à chaque profil avant de générer l’image IA.
- **Principe** :
  - Poing fermé → profil 0 (pas de filtre, photo originale)
  - 1 doigt levé → Profil 1
  - 2 doigts levés → Profil 2
  - 3 doigts levés → Profil 3
  - 4 doigts levés → Profil 4
  - 5 doigts levés → Profil 5
- Le filtre est appliqué **en temps réel sur le flux vidéo**, sans modifier l’image finale capturée.
- Permet de **tester visuellement le rendu** des différents prompts associés.

### Main droite : application réelle du prompt

- **Objectif** : choisir le profil de prompt à envoyer à **Stable Diffusion XL** pour générer l’image finale.
- **Principe** :
  - Poing fermé → profil 0 (prompt par défaut, photo classique)
  - 1 doigt levé → Profil 1 appliqué
  - 2 doigts levés → Profil 2 appliqué
  - Etc.
- Le nombre de doigts levés à droite doit **correspondre au même profil que celui visualisé à gauche**.
- Une fois le profil sélectionné, le workflow de capture et d’impression reste identique :
  1. Maintien du **signe V ✌️** → déclenche le compte à rebours et capture
  2. Maintien du **pouce levé 👍** → imprime la photo finale (original + IA)

### Exemple d’interaction

| Main gauche (prévisualisation) | Main droite (application prompt) | Résultat |
|--------------------------------|--------------------------------|----------|
| Poing fermé                     | Poing fermé                     | Photo classique (prompt par défaut), pas de filtre |
| 1 doigt levé                     | Poing fermé                     | Filtre Profile 1 appliqué sur la vidéo (prévisualisation), pas d’IA |
| 2 doigts levés                   | Poing fermé                     | Filtre Profile 2 appliqué sur la vidéo (prévisualisation), pas d’IA |
| 2 doigts levés                   | 2 doigts levés                   | Prompt Profile 2 envoyé à SDXL → génération IA correspondante |
| 3 doigts levés                   | 3 doigts levés                   | Prompt Profile 3 envoyé à SDXL → génération IA correspondante |

**Remarques importantes** :

- La main gauche **ne modifie jamais le prompt final**, elle sert uniquement à visualiser les filtres en temps réel.
- La main droite **déclenche l’application réelle du profil Stable Diffusion**, utilisé pour générer l’image IA.
- Les profils de prompt sont identiques pour la gauche et la droite : le nombre de doigts levés est la clé unique.
- Poings fermés = profil 0, donc pas de filtre et prompt par défaut.

---

## 🔧 Prérequis matériel

| Composant | Spécification |
|-----------|--------------|
| **GPU** | NVIDIA avec CUDA (RTX 2060+ recommandé) |
| **Webcam** | Résolution 720p minimum |
| **Écran** | 3840×1080 (dual monitor) recommandé |
| **Imprimante** | HP Color LaserJet 5700 + papier A6 glacé 200g |
| **RAM** | 16 GB minimum (32 GB recommandé pour SDXL) |

---

## 🔧 Dépendances logicielles

### Stable Diffusion WebUI

- PyTorch 2.5.1 + CUDA 12.1
- xFormers 0.0.23 pour optimisations
- Diffusers 0.31.0 (SDXL)
- ControlNet Aux 0.0.10 (OpenPose)
- MediaPipe 0.10.21 (détection gestes)
- ONNX Runtime GPU 1.17.1 (inference)

### Photo Booth

- OpenCV 4.11.0
- MediaPipe 0.10.21
- NumPy 1.26.2
- Requests 2.32.5
- Python 3.10.x (obligatoire)

---

