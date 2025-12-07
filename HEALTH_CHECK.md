# 🏥 Health Check - Validation du déploiement

## 🎯 Pourquoi

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

- **DEV (`dev.snoroc.fr`)** : HTTP 200 + contenu sans page d'erreur. **Non bloquant** (le job continue mais un warning est affiché).
- **PROD (`snoroc.fr`)** : HTTP 200 + contenu sans page d'erreur. **Bloquant** (échec du job si KO).

Patterns détectés dans la page :
- `nginx error`
- `Bad Gateway` (502)
- `Welcome to nginx`
- `403 Forbidden`
- `404 Not Found`

---

## 🔧 Configuration

Variables à ajouter dans GitHub (`snoroc-nginx` environment) :

- `SITE_URL` : domaine PROD (ex : `snoroc.fr`)
- `SITE_URL_DEV` : domaine DEV (ex : `dev.snoroc.fr`)

---

## 📊 Pipeline complet

```
1. Checkout code
2. Validation syntaxe réelle (nginx -t dans un bac à sable avec certifs auto-signés)
3. Déploiement via SCP
4. Reload Nginx (graceful)
5. Vérification Nginx status + nginx -t sur le serveur
6. Health Check
   ├─ Attente 5s (stabilisation)
   ├─ Test DEV (non bloquant)
   └─ Test PROD (bloquant)
```

---

## 📋 Checklist

- [ ] Ajouter `SITE_URL` dans les variables GitHub
- [ ] Ajouter `SITE_URL_DEV` dans les variables GitHub
- [ ] Tester le déploiement avec le health check
- [ ] Vérifier les logs dans GitHub Actions

---

## 🎯 Résultat

✅ Validation syntaxe  
✅ Déploiement sécurisé  
✅ Vérification fonctionnelle  
✅ Détection automatique des erreurs  
✅ Zéro downtime non détecté  
