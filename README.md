# Snoroc Nginx Configuration

Infrastructure-as-Code pour les reverse proxies Snoroc. Deux environnements isolés :

- **PROD** `snoroc.fr` / `www.snoroc.fr`
- **DEV** `dev.snoroc.fr`

## Environnements et chemins

| Environnement | Fichier Nginx (repo → serveur) | Frontend (root) | Uploads (alias) | Backend (upstream) | Certificats |
|---------------|---------------------------------|-----------------|-----------------|--------------------|-------------|
| PROD | `nginx/sites/snoroc.conf` → `/etc/nginx/sites-available/snoroc.conf` | `/srv/snoroc/snoroc_front/build` | `/srv/snoroc/snoroc_back/public/uploads/` | `127.0.0.1:13030` | `/etc/letsencrypt/live/snoroc.fr/` |
| DEV | `nginx/sites/snoroc-dev.conf` → `/etc/nginx/sites-available/snoroc-dev.conf` | `/srv/snoroc-dev/snoroc_front/build` | `/srv/snoroc-dev/snoroc_back/public/uploads/` | `127.0.0.1:3030` | `/etc/letsencrypt/live/dev.snoroc.fr/` |

Chaque fichier ne référence que ses propres domaines, ports et chemins pour éviter tout mélange entre DEV et PROD.

## Ce que font les deux fichiers Nginx

- **snoroc.conf (PROD)** : redirection HTTP→HTTPS + www→non-www, certificats Let's Encrypt `snoroc.fr`, proxy `/api/` vers le backend PROD (127.0.0.1:13030), alias `/uploads/` vers `/srv/snoroc/snoroc_back/public/uploads/`, frontend React servi depuis `/srv/snoroc/snoroc_front/build`, rate limiting + headers de sécurité depuis `nginx/snippets`.
- **snoroc-dev.conf (DEV)** : HTTPS sur `dev.snoroc.fr`, proxy `/api/` vers le backend DEV, alias `/uploads/` vers `/srv/snoroc-dev/snoroc_back/public/uploads/`, frontend React servi depuis `/srv/snoroc-dev/snoroc_front/build`, mêmes protections/snippets mais chemins distincts.

## CI/CD GitHub Actions (`.github/workflows/deploy.yml`)

1. **Validate**  
   - `scripts/test.sh` (sanity check).  
   - Installe Nginx, injecte les configs/snippets dans un bac à sable, génère des certificats auto-signés et lance `nginx -t` avec un `nginx.conf` minimal (incluant `rate-limit.conf`). Cela valide vraiment la syntaxe des deux sites.
2. **Deploy**  
   - SCP du dossier `nginx/` et `scripts/` vers `$DEPLOY_TEMP_DIR`.  
   - `scripts/deploy.sh` côté serveur : sauvegarde `/etc/nginx/sites-available` et `/etc/nginx/snippets`, refuse tout mélange de chemins PROD/DEV, copie séparément `snoroc.conf` et `snoroc-dev.conf`, crée les symlinks dans `sites-enabled`, vérifie que `rate-limit.conf` est inclus dans `nginx.conf`, puis `nginx -t` + reload.
3. **Health check**  
   - DEV est vérifié mais **non bloquant** (échec signalé en warning).  
   - PROD est **bloquant** : HTTP 200 et contenu sans page d'erreur sinon le job échoue.

## Variables GitHub à définir (env `snoroc-nginx`)

| Variable | Rôle |
|----------|------|
| `SERVER_HOST` | IP / hostname du serveur |
| `SERVER_USER` | Utilisateur SSH |
| `SERVER_PORT` | Port SSH |
| `SERVER_SSH_KEY` | Clé privée SSH |
| `DEPLOY_TEMP_DIR` | Répertoire temporaire sur le serveur |
| `SITE_URL` | Domaine PROD (ex : `snoroc.fr`) |
| `SITE_URL_DEV` | Domaine DEV (ex : `dev.snoroc.fr`) |

## Déploiement manuel (si besoin)

```bash
git checkout main
chmod +x scripts/deploy.sh
sudo ./scripts/deploy.sh
```

## Redémarrer / recharger Nginx proprement

```bash
sudo nginx -t
sudo systemctl reload nginx   # reload sans coupure
# ou sudo systemctl restart nginx si nécessaire
```

## Vérifications post-déploiement

- Accès : `curl -I https://snoroc.fr`, `curl -I https://dev.snoroc.fr`
- Logs : `/var/log/nginx/snoroc.access.log`, `/var/log/nginx/snoroc.error.log`, `/var/log/nginx/snoroc-dev.*`
- Certificats : `sudo ls /etc/letsencrypt/live/snoroc.fr` et `/etc/letsencrypt/live/dev.snoroc.fr`

## Points d'attention

- Port backend PROD configuré à `127.0.0.1:13030` (à garder cohérent avec le service backend).
- Ne jamais mélanger les chemins `/srv/snoroc/...` et `/srv/snoroc-dev/...` : les garde-fous du script bloquent le déploiement si c'est le cas.
- Les certificats Let's Encrypt doivent correspondre exactement aux domaines utilisés dans chaque fichier.
