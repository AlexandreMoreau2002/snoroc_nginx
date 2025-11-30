# 📋 Récapitulatif : Variables et Secrets GitHub à configurer

## 📊 GITHUB VARIABLES (non-sensibles)

Voici ce que vous devez mettre dans **Settings → Secrets and variables → Actions → Variables** de votre repo GitHub :

---

### 1️⃣ SERVER_HOST
**Nom de la variable** : `SERVER_HOST`  
**Valeur** : L'IP de votre serveur OVH

**Exemple** :
```
51.178.40.123
```

---

### 2️⃣ SERVER_USER
**Nom de la variable** : `SERVER_USER`  
**Valeur** : Votre utilisateur SSH (généralement `ubuntu`)

**Exemple** :
```
ubuntu
```

---

### 3️⃣ SERVER_PORT
**Nom de la variable** : `SERVER_PORT`  
**Valeur** : Port SSH

**Exemple** :
```
22
```

---

### 4️⃣ DEPLOY_TEMP_DIR
**Nom de la variable** : `DEPLOY_TEMP_DIR`  
**Valeur** : Répertoire temporaire pour le déploiement

**Exemple** :
```
/tmp/nginx-deploy
```

---

### 5️⃣ SITE_URL
**Nom de la variable** : `SITE_URL`  
**Valeur** : URL du site pour le health check

**Exemple** :
```
dev.snoroc.fr
```

---

### 6️⃣ SERVER_SSH_KEY
**Nom de la variable** : `SERVER_SSH_KEY`  
**Valeur** : La clé privée SSH COMPLÈTE (générée avec `ssh-keygen`)

**Comment l'obtenir** :
```bash
# 1. Générer la clé
ssh-keygen -t ed25519 -C "github-deploy" -f ~/.ssh/snoroc_deploy

# 2. Installer la clé PUBLIQUE sur le serveur
ssh-copy-id -i ~/.ssh/snoroc_deploy.pub ubuntu@VOTRE_IP

# 3. Afficher la clé PRIVÉE (à copier dans GitHub)
cat ~/.ssh/snoroc_deploy
```

**Format attendu** :
```
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACBK...
...
...plusieurs lignes...
...
-----END OPENSSH PRIVATE KEY-----
```

> ⚠️ **IMPORTANT** : Copiez la clé **PRIVÉE** (sans `.pub`), PAS la clé publique !

---

## 🔧 Secret OPTIONNEL

### 4️⃣ SERVER_PORT (optionnel)
**Nom du secret** : `SERVER_PORT`  
**Valeur** : Port SSH (par défaut `22`)

**Exemple** :
```
22
```

> 💡 Si vous n'ajoutez pas ce secret, le port 22 sera utilisé par défaut.

---

## 📸 Capture d'écran de la configuration GitHub

Voici à quoi ça doit ressembler dans GitHub :

```
Repository secrets
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Name                    Updated
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SERVER_HOST             2 minutes ago    [Update] [Remove]
SERVER_USER             2 minutes ago    [Update] [Remove]
SERVER_SSH_KEY          2 minutes ago    [Update] [Remove]
SERVER_PORT             2 minutes ago    [Update] [Remove]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## ✅ Checklist de configuration

- [ ] Générer la paire de clés SSH (`ssh-keygen`)
- [ ] Installer la clé publique sur le serveur (`ssh-copy-id`)
- [ ] Tester la connexion SSH avec la nouvelle clé
- [ ] Ajouter `SERVER_HOST` dans GitHub Variables
- [ ] Ajouter `SERVER_USER` dans GitHub Variables
- [ ] Ajouter `SERVER_PORT` dans GitHub Variables
- [ ] Ajouter `DEPLOY_TEMP_DIR` dans GitHub Variables
- [ ] Ajouter `SERVER_SSH_KEY` dans GitHub Variables
- [ ] Ajouter `SITE_URL` dans GitHub Variables
- [ ] Clé SSH publique installée sur le serveur
- [ ] Test de connexion SSH réussih sur `main`

---

## 🎯 Résumé en une image

```
┌─────────────────────────────────────────────────────────────┐
│  GitHub Repository Settings                                 │
│  → Secrets and variables → Actions → Variables             │
│  → Environnement: snoroc-nginx                              │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
        ┌───────────────────────────────────────┐
        │  Variable 1: SERVER_HOST              │
        │  Value: 51.210.77.73                  │
        └───────────────────────────────────────┘
                            │
                            ▼
        ┌───────────────────────────────────────┐
        │  Variable 2: SERVER_USER              │
        │  Value: ubuntu                        │
        └───────────────────────────────────────┘
                            │
                            ▼
        ┌───────────────────────────────────────┐
        │  Variable 3: SERVER_PORT              │
        │  Value: 22                            │
        └───────────────────────────────────────┘
                            │
                            ▼
        ┌───────────────────────────────────────┐
        │  Variable 4: DEPLOY_TEMP_DIR          │
        │  Value: /tmp/nginx-deploy             │
        └───────────────────────────────────────┘
                            │
                            ▼
        ┌───────────────────────────────────────┐
        │  Variable 5: SITE_URL                 │
        │  Value: dev.snoroc.fr                 │
        └───────────────────────────────────────┘
                            │
                            ▼
        ┌───────────────────────────────────────┐
        │  Variable 6: SERVER_SSH_KEY           │
        │  Value: -----BEGIN OPENSSH...         │
        │         ...                           │
        │         -----END OPENSSH...           │
        └───────────────────────────────────────┘
                            │
                            ▼
        ┌───────────────────────────────────────┐
        │  ✅ Variables configurées !            │
        │  → Push sur main pour déployer        │
        └───────────────────────────────────────┘
```

---

**📖 Guide détaillé** : Voir [SECRETS.md](file:///Users/alex/Desktop/dev/snoroc/snoroc_nginx/SECRETS.md) pour les instructions complètes.
