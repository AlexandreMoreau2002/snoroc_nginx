# 📊 Variables du projet

## 📊 GITHUB VARIABLES

**Où** : Settings → Secrets and variables → Actions → **Variables** tab

| Variable | Description | Exemple |
|----------|-------------|---------|
| `SERVER_HOST` | IP ou hostname du serveur | `51.178.40.123` |
| `SERVER_USER` | Utilisateur SSH | `ubuntu` |
| `SERVER_PORT` | Port SSH | `22` |
| `DEPLOY_TEMP_DIR` | Répertoire temporaire pour le déploiement | `/tmp/nginx-deploy` |
| `SERVER_SSH_KEY` | Clé privée SSH complète | `-----BEGIN OPENSSH...` |
| `SITE_URL` | URL du site pour health check | `dev.snoroc.fr` |

---

## 📁 CHEMINS HARDCODÉS (dans la config Nginx)

**Où** : `nginx/sites/snoroc-dev.conf`

Ces chemins sont spécifiques à votre serveur et ne doivent **PAS** être mis en variables.

| Chemin | Description |
|--------|-------------|
| `/etc/letsencrypt/live/dev.snoroc.fr/` | Certificats SSL Let's Encrypt |
| `/srv/snoroc-dev/snoroc_back/public/uploads/` | Uploads backend |
| `/srv/snoroc-dev/snoroc_front/build` | Build frontend React |
| `http://127.0.0.1:3030/` | Backend API Express |

> ⚠️ **Important** : Ces chemins restent en dur car ils sont spécifiques à l'infrastructure serveur.

---

## 🎯 Résumé : Que mettre où ?

```
┌─────────────────────────────────────────────────────────────┐
│  SECRETS GITHUB (sensibles)                                 │
│  → À configurer dans l'interface GitHub                    │
│  → Ne JAMAIS committer dans Git                            │
├─────────────────────────────────────────────────────────────┤
│  • SERVER_HOST                                              │
│  • SERVER_USER                                              │
│  • SERVER_SSH_KEY                                           │
│  • SERVER_PORT (optionnel)                                  │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  VARIABLES D'ENVIRONNEMENT (workflow)                       │
│  → Définies dans .github/workflows/deploy.yml               │
│  → Versionnées dans Git                                     │
├─────────────────────────────────────────────────────────────┤
│  • DEPLOY_TEMP_DIR                                          │
│  • NGINX_CONFIG_DIR                                         │
│  • NGINX_SITES_DIR                                          │
│  • NGINX_SNIPPETS_DIR                                       │
│  • NGINX_ENABLED_DIR                                        │
│  • BACKUP_DIR                                               │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  CHEMINS SERVEUR (hardcodés)                                │
│  → Dans nginx/sites/snoroc-dev.conf                         │
│  → Spécifiques à votre infrastructure                       │
├─────────────────────────────────────────────────────────────┤
│  • Certificats SSL                                          │
│  • Chemins applicatifs (/srv/snoroc-dev/...)               │
│  • Ports backend (3030)                                     │
└─────────────────────────────────────────────────────────────┘
```

---

## ✅ Checklist de configuration

### Avant le premier déploiement

- [ ] Configurer `SERVER_HOST` dans GitHub Variables
- [ ] Configurer `SERVER_USER` dans GitHub Variables
- [ ] Configurer `SERVER_PORT` dans GitHub Variables
- [ ] Configurer `DEPLOY_TEMP_DIR` dans GitHub Variables
- [ ] Générer et configurer `SERVER_SSH_KEY` dans GitHub Variables
- [ ] Configurer `SITE_URL` dans GitHub Variables
- [ ] Vérifier que les chemins dans `nginx/sites/snoroc-dev.conf` correspondent à votre serveur
- [ ] Vérifier que les variables d'environnement dans `deploy.yml` correspondent à votre structure

### Pour modifier la configuration

**Variables** → GitHub Settings → Secrets and variables → Actions → Variables (environnement `snoroc-nginx`)

---

## 📚 Documentation

- [SECRETS_QUICK_REF.md](file:///Users/alex/Desktop/dev/snoroc/snoroc_nginx/SECRETS_QUICK_REF.md) - Guide rapide des secrets
- [SECRETS.md](file:///Users/alex/Desktop/dev/snoroc/snoroc_nginx/SECRETS.md) - Guide détaillé SSH
- [.env.example](file:///Users/alex/Desktop/dev/snoroc/snoroc_nginx/.env.example) - Template des variables
- [README.md](file:///Users/alex/Desktop/dev/snoroc/snoroc_nginx/README.md) - Documentation générale
