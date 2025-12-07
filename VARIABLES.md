# 📊 Variables et chemins

## Variables GitHub (environnement `snoroc-nginx`)

| Variable | Description | Exemple |
|----------|-------------|---------|
| `SERVER_HOST` | IP ou hostname du serveur | `51.178.40.123` |
| `SERVER_USER` | Utilisateur SSH | `ubuntu` |
| `SERVER_PORT` | Port SSH | `22` |
| `SERVER_SSH_KEY` | Clé privée SSH complète | `-----BEGIN OPENSSH...` |
| `DEPLOY_TEMP_DIR` | Répertoire temporaire pour le déploiement | `/tmp/nginx-deploy` |
| `SITE_URL` | Domaine PROD pour le health check | `snoroc.fr` |
| `SITE_URL_DEV` | Domaine DEV pour le health check | `dev.snoroc.fr` |

## Chemins en dur dans les configs

Ces valeurs sont dans `nginx/sites/*.conf` et doivent correspondre à votre serveur (pas de variables ici).

| Environnement | Frontend | Uploads | Backend | Certificats |
|---------------|----------|---------|---------|-------------|
| PROD | `/srv/snoroc/snoroc_front/build` | `/srv/snoroc/snoroc_back/public/uploads/` | `http://127.0.0.1:13030` | `/etc/letsencrypt/live/snoroc.fr/` |
| DEV | `/srv/snoroc-dev/snoroc_front/build` | `/srv/snoroc-dev/snoroc_back/public/uploads/` | `http://127.0.0.1:3030` | `/etc/letsencrypt/live/dev.snoroc.fr/` |

## Checklist avant déploiement

- [ ] Variables GitHub ci-dessus renseignées
- [ ] Ports backend confirmés (PROD `13030`, DEV `3030` par défaut)
- [ ] Certificats Let's Encrypt présents pour chaque domaine
- [ ] Chemins `/srv/snoroc/...` et `/srv/snoroc-dev/...` existent sur le serveur

## Références

- `.env.example` : template rapide pour les variables GitHub
- `README.md` : fonctionnement CI/CD et séparation DEV/PROD
- `HEALTH_CHECK.md` : logique de vérification post-déploiement
