# 🛡️ OWASP Top 10 – #5: Security Misconfiguration

Les erreurs de configuration exposent les applications à de nombreuses attaques. Cela inclut les configurations par défaut, des fichiers sensibles accessibles, ou encore des services inutiles laissés actifs.

---

## 🔍 Exemples classiques

- Pages de debug accessibles (ex : `info.php`)
- Permissions de fichiers incorrectes
- Services non utilisés exposés
- Mots de passe par défaut laissés intacts

---

## 🧠 Cas réel – Capital One (2019)

- **Problème :** Mauvaise configuration du pare-feu sur un serveur AWS
- **Conséquences :** Données personnelles de **100 millions** de clients exposées
- **Attaquante :** Paige Thompson (ancienne employée AWS)
- **Coût estimé :** +150 millions de dollars

---

## ❓ Pourquoi cette faille est-elle fréquente ?

- Déploiements rapides sans **hardening**
- Confusion entre environnements (prod, dev, test)
- Manque de documentation, d’audits ou de surveillance

---

## ⚠️ Risques associés

- Fuite de données sensibles
- Prise de contrôle du serveur
- Escalade de privilèges

---

# 💻 2. Démonstration sur DVWA

### 🎯 Objectif : Exploiter des fichiers mal protégés via LFI

---

### 🔹 Étapes

1. **Page info.php accessible**
   - URL : `http://localhost/dvwa/info.php`
   - Contenu : chemins système, version PHP, modules activés

2. **Inclusion de fichiers via LFI**
   - URL : `http://localhost/dvwa/vulnerabilities/fi/?page=../../../../../../Windows/win.ini`
   - But : tester la lecture de fichiers système

3. **Lecture du fichier hosts**
   - URL : `http://localhost/dvwa/vulnerabilities/fi/?page=../../../../../../Windows/System32/drivers/etc/hosts`
   - Contenu utile pour :
     - Comprendre la configuration réseau locale
     - Mettre en place des attaques de type phishing en local

4. **Lecture de fichiers confidentiels encodés (via php://filter)**
   - URL : `http://localhost/dvwa/vulnerabilities/fi/?page=php://filter/convert.base64-encode/resource=../../config/config.inc.php`
   - Résultat : contenu encodé en base64 (fichier de config contenant mots de passe DB)

---

### 🧨 Conséquences démontrées

- Accès aux identifiants de base de données
- Compréhension de l’architecture serveur
- Rejouabilité des credentials dans d’autres services

---

# 🔒 Recommandations de sécurité – OWASP #5

## ✅ Bonnes pratiques pour les développeurs

- **Désactiver les fichiers sensibles en production**
  - Supprimer `info.php`, `.env`, `phpinfo()`, etc.

- **Limiter l'accès aux répertoires**
  - Utiliser `.htaccess`, `AllowOverride None`, `Options -Indexes`
  - Configuration NGINX équivalente

- **Fichier robots.txt**
  - Empêcher l'indexation par les moteurs de recherche des dossiers sensibles

- **Contrôle d’accès aux outils d’administration et debug**
  - Restreindre `/admin`, `/debug`, `/tools` à certaines IP

- **Supprimer les fonctionnalités inutiles**
  - Ex : désactiver `allow_url_include`, `display_errors`, `expose_php`

- **Mettre à jour régulièrement le serveur et ses dépendances**

- **Automatiser l’audit de configuration**
  - Outils recommandés :
    - [Lynis](https://cisofy.com/lynis/)
    - [Nessus](https://www.tenable.com/products/nessus)
    - [OpenVAS](https://www.openvas.org/)

---

## 🧪 Résultat attendu après sécurisation

- Blocage de `php://filter`, `data://`, `input://`
- Blocage des inclusions de fichiers via `../`
- Autorisation uniquement des inclusions internes dans `includes/pages/`
- Test possible avec un fichier `hello.php` pour vérifier le bon comportement

---

## 🛠️ Astuce : Automatiser la sécurité

Utilisez un **script shell** ou un **patch** pour désactiver les options dangereuses et renforcer les permissions par défaut.

---

