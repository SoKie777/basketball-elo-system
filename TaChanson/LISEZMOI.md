# Ta Chanson · kit de lancement

Tout est prêt. Voici ce que contient le dossier et les quelques gestes qui restent de ton côté.

## 1. Mettre le site en ligne (une seule fois, environ 5 minutes)

1. Décompresse `TaChanson.zip` où tu veux (par exemple dans Téléchargements).
2. Double-clique sur **`installer.bat`**. Il fait tout seul :
   - il copie le dossier dans `C:\Users\<toi>\TaChanson\` ;
   - il installe le skill Claude Code dans `C:\Users\<toi>\.claude\skills\ta-chanson\` ;
   - il ouvre la page de connexion Cloudflare si besoin (c'est **toi** qui te connectes, puis tu cliques sur « Allow ») ;
   - il met le site en ligne sur **https://ta-chanson.pages.dev**.
3. Si Windows affiche « Windows a protégé votre ordinateur », clique sur **Informations complémentaires → Exécuter quand même**.

Le script a besoin de **Node.js** : s'il manque, il te le dit (installe la version LTS sur nodejs.org, puis relance).

Tu préfères taper les commandes toi-même ? Dans PowerShell, depuis `C:\Users\<toi>\TaChanson` :
```
npx wrangler login
npx wrangler pages deploy site --project-name ta-chanson --branch main
```
Si wrangler demande de créer le projet, accepte avec la branche de production `main`.

## 2. Ajouter les démos sur le site

1. Génère les 5 chansons dans Suno avec `demos/paroles_demos.md` (titre, paroles, style déjà prêts).
2. Télécharge-les en MP3, renomme-les `demo1.mp3` à `demo5.mp3` et dépose-les dans `C:\Users\<toi>\TaChanson\site\exemples\` (**moins de 25 Mo** chacune).
3. Relance **`installer.bat`** (depuis `C:\Users\<toi>\TaChanson\`) : le site se met à jour.

Tant qu'un fichier manque, sa carte affiche « Bientôt disponible ».

## 3. Produire une commande avec Claude Code

Ouvre Claude Code dans `C:\Users\<toi>\TaChanson\` et colle le message du client. Le skill **ta-chanson** :
- vérifie qu'il ne manque rien (sinon il rédige UN message pour tout demander) ;
- écrit le titre, les paroles et le style Suno dans 3 blocs à copier ;
- ajoute la commande dans `commandes.csv` et prépare le message « extrait + paiement ».

Ensuite, tape simplement : **« payé TC-001 »**, **« livré TC-001 »**, **« avis TC-001 : … »** ou **« le point »**.

Astuce Suno : mode **Custom**, colle les paroles dans *Lyrics* et la ligne de style dans *Style of Music*. Pour l'extrait de 20 s, coupe le début du refrain avec n'importe quel éditeur audio du téléphone.
Astuce clip (offre Avec clip) : fais un diaporama des photos du client sur la chanson avec un éditeur vidéo du téléphone, au format vertical.

## Contenu du dossier

| Élément | À quoi ça sert |
|---|---|
| `site/` | Le site (une page, formulaire qui ouvre WhatsApp avec le message déjà rédigé) |
| `site/exemples/` | Tes 5 démos MP3 |
| `skill/ta-chanson/SKILL.md` | Le skill Claude Code de production |
| `messages/01` à `07` | Les messages WhatsApp prêts à copier |
| `catalogue.md` + `catalogue/` | Les 4 articles du catalogue WhatsApp Business, avec leurs images |
| `affiches/affiche1.png` | Affiche principale 1080×1920 (statut, story) |
| `affiches/affiche2.png` | Affiche Fêtes 1080×1920 (à partir du 20 novembre) |
| `affiches/affiche3.png` | « Comment ça marche » 1080×1080 |
| `affiches/prompts.md` | 3 prompts pour un générateur d'images, si tu veux d'autres versions |
| `demos/paroles_demos.md` | Les paroles des 5 démos, prêtes pour Suno |
| `prospects.csv` | 20 commerces d'Abidjan à démarcher (coordonnées professionnelles publiques) |
| `calendrier_30_jours.md` | Une publication par jour, du 6 novembre au 5 décembre |
| `commandes.csv` | Le suivi des commandes (rempli par le skill) |

## Bon à savoir

- **Partenaires** : donne à chacun un lien du type `https://ta-chanson.pages.dev/?ref=FLEURS-PETALIA`. Leur code apparaît dans le message de commande, et le skill calcule leurs 500 F dans « le point ».
- **Prospects** : les numéros viennent de sites et d'annuaires publics. Vérifie-les avant d'écrire, et ne contacte que des entreprises.
- **Ouvrir les CSV** : dans Google Sheets (Fichier → Importer), ou dans Excel avec Données → À partir d'un fichier texte/CSV (choisis UTF-8 et la virgule comme séparateur).
- **Nom de domaine** : si tu en achètes un plus tard (ex. tachanson.ci), dis-le à Claude : il te guidera pour le brancher dans Cloudflare (Workers & Pages → ta-chanson → Domaines personnalisés).
- **Règles** : toujours « créée avec l'aide de l'IA, écrite sur mesure », aucun nom d'artiste ni imitation de voix, aucune parole existante, pas de chanson pour humilier, pas de politique, paiement avant la version complète, une retouche gratuite, rien publié sans accord écrit.
