# 🏥 Health Check - Validation du déploiement

## 🎯 Pourquoi c'est essentiel

Une configuration Nginx **syntaxiquement valide** ne garantit **PAS** un site fonctionnel !

### Problèmes possibles même avec `nginx -t` OK :

- ❌ Backend Express down → **502 Bad Gateway**
- ❌ Permissions incorrectes → **403 Forbidden**
- ❌ Fichiers frontend manquants → **404 Not Found**
- ❌ Mauvais proxy_pass → Page Nginx par défaut
- ❌ Certificat SSL expiré → Erreur HTTPS

**Le Health Check détecte ces problèmes AVANT que les utilisateurs ne les voient !**

---

## ✅ Ce que le Health Check vérifie

### 1. Code HTTP = 200
```bash
curl -o /dev/null -s -w "%{http_code}" https://dev.snoroc.fr
```

Si ≠ 200 → **Échec du déploiement**

### 2. Contenu de la page

Détecte les patterns d'erreur :
- `nginx error`
- `Bad Gateway` (502)
- `Welcome to nginx` (page par défaut)
- `403 Forbidden`
- `404 Not Found`

Si détecté → **Échec du déploiement**

---

## 🔧 Configuration

### Variable à ajouter dans GitHub

**Nom** : `SITE_URL`  
**Valeur** : `dev.snoroc.fr`

**Où** : Settings → Secrets and variables → Actions → Variables (environnement `snoroc-nginx`)

---

## 📊 Pipeline complet

```
1. Checkout code
2. Validation syntaxe (nginx -t)
3. Déploiement via SCP
4. Reload Nginx
5. Vérification Nginx status
6. Health Check ← NOUVEAU !
   ├─ Attente 5s (stabilisation)
   ├─ Test HTTP 200
   └─ Vérification contenu
```

---

## 🚀 Aller plus loin (optionnel)

### Option 1 : Endpoint backend dédié

Créer un endpoint `/health` dans Express :

```javascript
// Dans ton backend Express
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'OK', timestamp: Date.now() });
});
```

Puis dans le workflow :

```yaml
- name: Health Check Backend
  run: |
    curl -f https://dev.snoroc.fr/api/health
```

### Option 2 : Rollback automatique

Si le health check échoue, restaurer automatiquement le backup :

```yaml
- name: Rollback on failure
  if: failure()
  uses: appleboy/ssh-action@v1.0.3
  with:
    host: ${{ vars.SERVER_HOST }}
    username: ${{ vars.SERVER_USER }}
    key: ${{ vars.SERVER_SSH_KEY }}
    port: ${{ vars.SERVER_PORT }}
    script: |
      LATEST_BACKUP=$(ls -t /etc/nginx/backup/ | head -1)
      sudo cp -r /etc/nginx/backup/$LATEST_BACKUP/* /etc/nginx/sites-available/
      sudo nginx -t && sudo systemctl reload nginx
```

### Option 3 : Notifications Slack/Discord

Envoyer une notification en cas d'échec :

```yaml
- name: Notify on failure
  if: failure()
  run: |
    curl -X POST ${{ secrets.SLACK_WEBHOOK }} \
      -H 'Content-Type: application/json' \
      -d '{"text":"❌ Déploiement Nginx échoué sur dev.snoroc.fr"}'
```

---

## 📋 Checklist

- [ ] Ajouter `SITE_URL` dans les variables GitHub
- [ ] Tester le déploiement avec le health check
- [ ] Vérifier les logs dans GitHub Actions
- [ ] (Optionnel) Créer un endpoint `/health` dans le backend
- [ ] (Optionnel) Ajouter le rollback automatique

---

## 🎯 Résultat

Avec le Health Check, ton pipeline est **production-ready** et conforme aux standards de l'industrie :

✅ Validation syntaxe  
✅ Déploiement sécurisé  
✅ Vérification fonctionnelle  
✅ Détection automatique des erreurs  
✅ Zéro downtime non détecté  

**Tu ne déploieras plus jamais une page d'erreur sans le savoir !** 🚀
