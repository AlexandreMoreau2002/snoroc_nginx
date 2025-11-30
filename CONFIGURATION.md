# 🎯 Guide de configuration GitHub - Variables

## 📋 Résumé : Que configurer ?

| Type | Où | Quoi | Visible dans les logs ? |
|------|-----|------|------------------------|
| **Variables** | Actions → Variables | Configuration non-sensible | ✅ Oui |

---

## 📊 ÉTAPE 1 : Configurer les Variables

**Chemin** : Settings → Secrets and variables → Actions → **Variables** tab → New repository variable

### Variables à créer

| Nom | Valeur | Description |
|-----|--------|-------------|
| `SERVER_HOST` | `51.178.x.x` | IP de votre serveur OVH |
| `SERVER_USER` | `ubuntu` | Utilisateur SSH |
| `SERVER_PORT` | `22` | Port SSH |
| `DEPLOY_TEMP_DIR` | `/tmp/nginx-deploy` | Répertoire temporaire |

### Exemple de configuration

```
┌─────────────────────────────────────────────────────────────┐
│  Repository variables                                       │
├─────────────────────────────────────────────────────────────┤
│  Name                    Value                              │
├─────────────────────────────────────────────────────────────┤
│  SERVER_HOST             51.178.40.123                      │
│  SERVER_USER             ubuntu                             │
│  SERVER_PORT             22                                 │
│  DEPLOY_TEMP_DIR         /tmp/nginx-deploy                  │
│  SERVER_SSH_KEY          <ssh_key>                          │
└─────────────────────────────────────────────────────────────┘
```

---

## ✅ Vérification de la configuration

### Checklist

- [ ] `SERVER_HOST` ajouté dans Variables
- [ ] `SERVER_USER` ajouté dans Variables
- [ ] `SERVER_PORT` ajouté dans Variables
- [ ] `DEPLOY_TEMP_DIR` ajouté dans Variables
- [ ] `SERVER_SSH_KEY` ajouté dans Variables
- [ ] `SITE_URL` ajouté dans Variables
- [ ] Clé SSH publique installée sur le serveur
- [ ] Test de connexion SSH réussi

### Test de connexion SSH

```bash
# Tester que la clé fonctionne
ssh -i ~/.ssh/snoroc_deploy ubuntu@VOTRE_IP

# Si ça fonctionne, vous êtes prêt ! 🎉
```

---

## 🚀 Utilisation dans le workflow

Le workflow utilise automatiquement ces variables :

```yaml
# Toutes les variables
host: ${{ vars.SERVER_HOST }}
username: ${{ vars.SERVER_USER }}
key: ${{ vars.SERVER_SSH_KEY }}
port: ${{ vars.SERVER_PORT }}
```

---

## 🔄 Modifier une variable

1. Settings → Secrets and variables → Actions → Variables
2. Cliquer sur la variable à modifier
3. Changer la valeur
4. Save

---

## 🆘 Troubleshooting

### Erreur "Variable not found"

→ Vérifiez que vous avez bien créé la variable dans l'onglet **Variables** de l'environnement `snoroc-nginx`

### Erreur "Permission denied (publickey)"

→ La clé SSH n'est pas correctement installée sur le serveur

```bash
# Sur le serveur
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

### Le workflow ne trouve pas les variables

→ Vérifiez que vous utilisez bien `${{ vars.VARIABLE }}` et non `${{ secrets.VARIABLE }}`

---

## 📚 Documentation

- [.env.example](file:///Users/alex/Desktop/dev/snoroc/snoroc_nginx/.env.example) - Template des variables
- [VARIABLES.md](file:///Users/alex/Desktop/dev/snoroc/snoroc_nginx/VARIABLES.md) - Vue d'ensemble
- [SECRETS.md](file:///Users/alex/Desktop/dev/snoroc/snoroc_nginx/SECRETS.md) - Guide SSH détaillé
