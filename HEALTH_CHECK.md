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

## 📋 Checklist

- [ ] Ajouter `SITE_URL` dans les variables GitHub
- [ ] Tester le déploiement avec le health check
- [ ] Vérifier les logs dans GitHub Actions

---

## 🎯 Résultat

✅ Validation syntaxe  
✅ Déploiement sécurisé  
✅ Vérification fonctionnelle  
✅ Détection automatique des erreurs  
✅ Zéro downtime non détecté  
