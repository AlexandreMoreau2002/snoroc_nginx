# 🔐 Configuration des Secrets GitHub

## Variables à configurer dans GitHub

Allez dans **Settings → Secrets and variables → Actions** de votre repository GitHub.

### Secrets obligatoires

| Nom du secret | Description | Comment l'obtenir |
|---------------|-------------|-------------------|
| `SERVER_HOST` | IP ou hostname de votre serveur OVH | Exemple : `51.178.x.x` ou `snoroc.fr` |
| `SERVER_USER` | Utilisateur SSH | `ubuntu` (sur Ubuntu) ou votre user |
| `SERVER_SSH_KEY` | Clé privée SSH complète | Voir instructions ci-dessous |

### Secrets optionnels

| Nom du secret | Description | Valeur par défaut |
|---------------|-------------|-------------------|
| `SERVER_PORT` | Port SSH | `22` |

---

## 📝 Instructions détaillées

### 1. Générer une clé SSH dédiée

```bash
# Sur votre machine locale
ssh-keygen -t ed25519 -C "github-actions-snoroc" -f ~/.ssh/snoroc_deploy

# Afficher la clé PUBLIQUE
cat ~/.ssh/snoroc_deploy.pub
```

### 2. Installer la clé publique sur le serveur

**Option A : Avec ssh-copy-id (recommandé)**
```bash
ssh-copy-id -i ~/.ssh/snoroc_deploy.pub ubuntu@<IP_SERVEUR>
```

**Option B : Manuellement**
```bash
# Se connecter au serveur
ssh ubuntu@<IP_SERVEUR>

# Ajouter la clé publique
mkdir -p ~/.ssh
nano ~/.ssh/authorized_keys
# Coller la clé publique (celle avec .pub)
# Sauvegarder et quitter

# Sécuriser les permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
exit
```

### 3. Récupérer la clé PRIVÉE pour GitHub

```bash
# Afficher la clé PRIVÉE (SANS .pub)
cat ~/.ssh/snoroc_deploy
```

**Copiez TOUT le contenu**, y compris :
```
-----BEGIN OPENSSH PRIVATE KEY-----
...
-----END OPENSSH PRIVATE KEY-----
```

### 4. Ajouter les secrets dans GitHub

1. Allez sur votre repo GitHub
2. **Settings** → **Secrets and variables** → **Actions**
3. Cliquez sur **New repository secret**
4. Ajoutez chaque secret :

#### SERVER_HOST
```
Nom : SERVER_HOST
Valeur : 51.178.x.x
```

#### SERVER_USER
```
Nom : SERVER_USER
Valeur : ubuntu
```

#### SERVER_SSH_KEY
```
Nom : SERVER_SSH_KEY
Valeur : [Coller TOUTE la clé privée]
```

#### SERVER_PORT (optionnel)
```
Nom : SERVER_PORT
Valeur : 22
```

---

## ✅ Vérifier la configuration

### Test de connexion SSH

```bash
# Tester que la clé fonctionne
ssh -i ~/.ssh/snoroc_deploy ubuntu@<IP_SERVEUR>
```

Si ça fonctionne, vous êtes prêt ! 🎉

### Test du workflow GitHub Actions

1. Faites un petit changement dans le repo
2. Commitez et pushez sur `main`
3. Allez dans l'onglet **Actions** de votre repo
4. Vérifiez que le workflow s'exécute sans erreur

---

## 🔒 Sécurité

- ✅ **Ne jamais committer** la clé privée dans Git
- ✅ Utiliser une clé SSH **dédiée** au déploiement
- ✅ Limiter les permissions de la clé sur le serveur (uniquement ce qui est nécessaire)
- ✅ Régénérer la clé si elle est compromise

---

## 🆘 Troubleshooting

### Erreur "Permission denied (publickey)"

→ La clé publique n'est pas installée sur le serveur ou les permissions sont incorrectes

```bash
# Sur le serveur
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

### Erreur "Host key verification failed"

→ Ajoutez le serveur aux known_hosts

```bash
ssh-keyscan -H <IP_SERVEUR> >> ~/.ssh/known_hosts
```

### Le workflow échoue avec "Connection refused"

→ Vérifiez que :
- Le port SSH est correct (22 par défaut)
- Le firewall autorise les connexions SSH
- L'IP du serveur est correcte
