# Snoroc Nginx Configuration

Infrastructure-as-Code pour la configuration Nginx de Snoroc.

## 🎯 Objectif

Gérer la configuration Nginx de manière versionnée, testable et déployable automatiquement via Git.

## 📁 Structure

```
snoroc_nginx/
├── nginx/
│   ├── sites/              # Configurations des sites
│   │   └── snoroc-dev.conf
│   └── snippets/           # Configurations réutilisables
│       ├── security.conf   # Headers de sécurité
│       ├── gzip.conf       # Compression
│       ├── proxy.conf      # Configuration proxy
│       └── cors.conf       # CORS pour API
├── scripts/
│   ├── deploy.sh           # Script de déploiement
│   └── test.sh             # Validation syntaxe
└── .github/
    └── workflows/
        └── deploy.yml      # CI/CD automatique
```

## 🚀 Déploiement automatique

### Workflow

1. **Push sur `main`** → déclenche le workflow GitHub Actions
2. **Validation** → teste la syntaxe Nginx
3. **Déploiement** → copie les dossiers `nginx/` et `scripts/` sur le serveur via SSH et recharge Nginx (tous les sites sont donc mis à jour en même temps)
4. **Health check** → vérifie que le site est accessible

### Configuration GitHub

**Résumé rapide** : Configurez ces variables dans **Settings → Secrets and variables → Actions → Variables** (environnement `snoroc-nginx`) :

| Variable | Valeur |
|----------|--------|
| `SERVER_HOST` | IP de votre serveur (ex: `51.210.77.73`) |
| `SERVER_USER` | Utilisateur SSH (ex: `ubuntu`) |
| `SERVER_PORT` | Port SSH (ex: `22`) |
| `DEPLOY_TEMP_DIR` | Répertoire temporaire (ex: `/tmp/nginx-deploy`) |
| `SERVER_SSH_KEY` | Clé privée SSH complète |
| `SITE_URL` | URL du site (ex: `dev.snoroc.fr`) |

> 💡 Le fichier [CONFIGURATION.md](file:///Users/alex/Desktop/dev/snoroc/snoroc_nginx/CONFIGURATION.md) contient les instructions détaillées. serveur
git clone <repo-url> /tmp/snoroc_nginx
cd /tmp/snoroc_nginx

# 2. Exécuter le script de déploiement
chmod +x scripts/deploy.sh
sudo ./scripts/deploy.sh
```

## 🧪 Tester localement

```bash
# Validation basique
chmod +x scripts/test.sh
./scripts/test.sh
```

## 🔄 Rollback

En cas de problème après déploiement :

### Option 1 : Git revert (recommandé)

```bash
# Identifier le commit problématique
git log --oneline

# Revert le commit
git revert <commit-hash>
git push origin main
# → Le CI/CD redéploiera automatiquement la version précédente
```

### Option 2 : Restauration manuelle sur le serveur

```bash
# Les backups sont dans /etc/nginx/backup/
ls -la /etc/nginx/backup/

# Restaurer un backup
sudo cp -r /etc/nginx/backup/YYYYMMDD_HHMMSS/* /etc/nginx/sites-available/
sudo nginx -t
sudo systemctl reload nginx
```

## 📝 Ajouter un nouveau site

1. Créer un fichier dans `nginx/sites/` :
   ```bash
   cp nginx/sites/snoroc-dev.conf nginx/sites/snoroc-prod.conf
   ```

2. Modifier la configuration selon vos besoins

3. Commit et push :
   ```bash
   git add nginx/sites/snoroc-prod.conf
   git commit -m "Add production site configuration"
   git push origin main
   ```

4. Le déploiement se fait automatiquement ! 🎉

## 🔒 Sécurité

- ✅ Aucune clé SSH n'est committée dans le repo
- ✅ Les certificats SSL restent sur le serveur
- ✅ Validation syntaxe avant déploiement
- ✅ Backup automatique avant chaque déploiement
- ✅ Reload graceful (pas de downtime)

## 📊 Monitoring

Vérifier les logs après déploiement :

```bash
# Logs d'accès
sudo tail -f /var/log/nginx/snoroc-dev.access.log

# Logs d'erreur
sudo tail -f /var/log/nginx/snoroc-dev.error.log

# Status Nginx
sudo systemctl status nginx
```

## 🎯 Bonnes pratiques

1. **Ne jamais éditer directement sur le serveur** → toujours passer par Git
2. **Tester en local** avant de push
3. **Commits atomiques** : une modification = un commit
4. **Messages de commit clairs** : `feat: add rate limiting` plutôt que `update config`
5. **Utiliser les snippets** pour éviter la duplication

## 🆘 Troubleshooting

### Le déploiement échoue avec "Permission denied"

→ Vérifiez que la clé SSH est correctement configurée et que l'utilisateur a les droits sudo

### Nginx ne reload pas

```bash
# Sur le serveur, vérifier la syntaxe
sudo nginx -t

# Voir les erreurs détaillées
sudo journalctl -u nginx -n 50
```

### Le workflow GitHub Actions ne se déclenche pas

→ Vérifiez que vous avez bien push sur la branche `main` (pas `master`)

---

**Maintenu par** : Alex  
**Dernière mise à jour** : 2025-11-30
