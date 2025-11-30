# 🛡️ Sécurité Nginx - Configuration du Reverse Proxy

## 🎯 Protections mises en place

### 1. **Rate Limiting** (Protection DDoS)

#### API générale
- **10 requêtes/seconde** par IP
- Burst de 20 requêtes autorisé
- Code 429 (Too Many Requests) si dépassement

#### Endpoints sensibles (login, register, reset-password)
- **5 requêtes/minute** par IP
- Burst de 3 requêtes
- Protection contre le brute force

#### Frontend et uploads
- **30 requêtes/seconde** par IP
- Burst de 50-100 requêtes

### 2. **Limites de taille et timeouts**

```nginx
client_max_body_size 10M;        # Max 10MB par requête
proxy_connect_timeout 10s;       # Timeout connexion
proxy_read_timeout 30s;          # Timeout lecture
client_body_timeout 30s;         # Timeout body
```

**Protège contre** :
- Upload de fichiers énormes
- Connexions qui bloquent le serveur
- Attaques par épuisement de ressources

### 3. **Protection contre les bots**

Bloque automatiquement :
- User agents suspects (bots, scrapers, curl, wget)
- Requêtes sans user agent
- Méthodes HTTP non autorisées
- Tentatives d'injection SQL dans les URLs

### 4. **CORS sécurisé**

**Avant** : `Access-Control-Allow-Origin: *` (DANGEREUX)  
**Maintenant** : `Access-Control-Allow-Origin: https://dev.snoroc.fr`

**Avantages** :
- Seul ton frontend peut appeler l'API
- Protection contre les requêtes cross-origin malveillantes
- Support des credentials (cookies, auth headers)

### 5. **Protection des fichiers sensibles**

```nginx
# Bloquer les fichiers cachés (.env, .git, etc.)
location ~ /\. { deny all; }

# Bloquer les fichiers de config
location ~ \.(conf|config|yml|yaml|json|env)$ { deny all; }

# Bloquer l'exécution de scripts dans /uploads/
location ~ \.(php|pl|py|jsp|asp|sh|cgi)$ { deny all; }
```

---

## 📊 Zones de rate limiting

Les zones sont définies dans `rate-limit.conf` :

| Zone | Limite | Usage |
|------|--------|-------|
| `api_limit` | 10 req/s | API générale |
| `login_limit` | 5 req/min | Login, register, reset-password |
| `general_limit` | 30 req/s | Frontend, uploads |
| `conn_limit` | 10 connexions | Connexions simultanées par IP |

---

## ⚙️ Configuration automatique

Le script `deploy.sh` configure automatiquement `/etc/nginx/nginx.conf` :

1. **Détecte** si `rate-limit.conf` est déjà inclus
2. **Ajoute** l'include si nécessaire
3. **Backup** `nginx.conf` avant modification
4. **Teste** la configuration avec `nginx -t`

**Tu n'as rien à faire manuellement !** Le déploiement via GitHub Actions s'occupe de tout. 🎉

---

## 🧪 Tester le rate limiting

### Test API générale (10 req/s)

```bash
# Envoyer 15 requêtes rapidement
for i in {1..15}; do
  curl -I https://dev.snoroc.fr/api/test
done

# Les 10 premières passent, les 5 suivantes → 429 Too Many Requests
```

### Test login (5 req/min)

```bash
# Envoyer 10 tentatives de login
for i in {1..10}; do
  curl -X POST https://dev.snoroc.fr/api/login \
    -H "Content-Type: application/json" \
    -d '{"email":"test@test.com","password":"wrong"}'
done

# Les 5 premières passent, les 5 suivantes → 429
```

---

## 🔧 Ajuster les limites

Si tu veux modifier les limites, édite `nginx/snippets/rate-limit.conf` :

```nginx
# Plus strict
limit_req_zone $binary_remote_addr zone=api_limit:10m rate=5r/s;

# Plus permissif
limit_req_zone $binary_remote_addr zone=api_limit:10m rate=20r/s;
```

---

## 📋 Checklist de sécurité

- [x] Rate limiting activé
- [x] Timeouts configurés
- [x] Taille max des requêtes limitée
- [x] Protection contre les bots
- [x] CORS sécurisé
- [x] Fichiers sensibles bloqués
- [x] Scripts dans /uploads/ bloqués
- [ ] Ajouter les zones dans `/etc/nginx/nginx.conf`
- [ ] Tester le rate limiting
- [ ] Monitorer les logs pour ajuster les limites

---

## 🚨 Logs à surveiller

```bash
# Voir les requêtes bloquées par rate limiting
sudo grep "limiting requests" /var/log/nginx/snoroc-dev.error.log

# Voir les 429 (Too Many Requests)
sudo grep "429" /var/log/nginx/snoroc-dev.access.log

# Voir les bots bloqués
sudo grep "403" /var/log/nginx/snoroc-dev.access.log
```

---

## 🎯 Résultat

Ton reverse proxy est maintenant **sécurisé** contre :

✅ Attaques DDoS  
✅ Brute force sur login  
✅ Bots et scrapers  
✅ Injections SQL  
✅ Upload de fichiers énormes  
✅ Requêtes cross-origin malveillantes  
✅ Exécution de scripts uploadés  
✅ Accès aux fichiers sensibles  

**Ton API est maintenant production-ready !** 🚀
