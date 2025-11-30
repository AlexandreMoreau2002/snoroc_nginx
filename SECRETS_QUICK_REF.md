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

## 🔐 GITHUB SECRETS (sensibles)

Voici ce que vous devez mettre dans **Settings → Secrets and variables → Actions → Secrets** :

---

### 🔑 SERVER_SSH_KEY
**Nom du secret** : `SERVER_SSH_KEY`  
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
- [ ] Ajouter `SERVER_HOST` dans GitHub Secrets
- [ ] Ajouter `SERVER_USER` dans GitHub Secrets
- [ ] Ajouter `SERVER_SSH_KEY` dans GitHub Secrets
- [ ] (Optionnel) Ajouter `SERVER_PORT` dans GitHub Secrets
- [ ] Tester le workflow en faisant un push sur `main`

---

## 🎯 Résumé en une image

```
┌─────────────────────────────────────────────────────────────┐
│  GitHub Repository Settings                                 │
│  → Secrets and variables → Actions → New repository secret │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
        ┌───────────────────────────────────────┐
        │  Secret 1: SERVER_HOST                │
        │  Value: 51.178.x.x                    │
        └───────────────────────────────────────┘
                            │
                            ▼
        ┌───────────────────────────────────────┐
        │  Secret 2: SERVER_USER                │
        │  Value: ubuntu                        │
        └───────────────────────────────────────┘
                            │
                            ▼
        ┌───────────────────────────────────────┐
        │  Secret 3: SERVER_SSH_KEY             │
        │  Value: -----BEGIN OPENSSH...         │
        │         ...                           │
        │         -----END OPENSSH...           │
        └───────────────────────────────────────┘
                            │
                            ▼
        ┌───────────────────────────────────────┐
        │  ✅ Secrets configurés !               │
        │  → Push sur main pour déployer        │
        └───────────────────────────────────────┘
```

---

**📖 Guide détaillé** : Voir [SECRETS.md](file:///Users/alex/Desktop/dev/snoroc/snoroc_nginx/SECRETS.md) pour les instructions complètes.
