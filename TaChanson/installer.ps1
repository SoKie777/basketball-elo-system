# =====================================================================
#  Ta Chanson : installation et mise en ligne (Windows / PowerShell)
#  - copie le dossier dans C:\Users\<toi>\TaChanson (sans écraser tes commandes)
#  - installe le skill Claude Code (~\.claude\skills\ta-chanson)
#  - vérifie la connexion Cloudflare (ouvre la page de connexion si besoin)
#  - met le site en ligne sur Cloudflare Pages (projet "ta-chanson", branche main)
#  Relance-le après avoir déposé les MP3 dans site\exemples : il remet le site à jour.
# =====================================================================
# "Continue" : les avertissements de wrangler (écrits sur stderr) ne doivent pas arrêter le script.
$ErrorActionPreference = "Continue"
$Source = $PSScriptRoot
$Dest   = Join-Path $HOME "TaChanson"

function Etape($t) { Write-Host ""; Write-Host "==> $t" -ForegroundColor Yellow }
function Ok($t)    { Write-Host "    OK : $t" -ForegroundColor Green }
function Stop-Avec($t) {
    Write-Host ""
    Write-Host "!! $t" -ForegroundColor Red
    Read-Host "Appuie sur Entrée pour fermer"
    exit 1
}

try {
    # 1. Dossier de travail --------------------------------------------
    Etape "Dossier de travail : $Dest"
    $sourceNette = (Resolve-Path $Source).Path.TrimEnd('\')
    if ($sourceNette -ne $Dest.TrimEnd('\')) {
        New-Item -ItemType Directory -Force -Path $Dest -ErrorAction Stop | Out-Null
        $proteges = @("commandes.csv", "prospects.csv")
        foreach ($item in Get-ChildItem -Path $Source -Force) {
            if ($item.Name -eq ".git") { continue }
            $cible = Join-Path $Dest $item.Name
            if (($proteges -contains $item.Name) -and (Test-Path $cible)) {
                Write-Host "    $($item.Name) existe déjà : je le garde tel quel."
                continue
            }
            Copy-Item -Path $item.FullName -Destination $Dest -Recurse -Force -ErrorAction Stop
        }
        Ok "fichiers copiés dans $Dest"
    } else {
        Ok "tu es déjà dans $Dest"
    }
    New-Item -ItemType Directory -Force -Path (Join-Path $Dest "site\exemples") -ErrorAction Stop | Out-Null

    # 2. Skill Claude Code ---------------------------------------------
    Etape "Installation du skill Claude Code"
    $SkillDest = Join-Path $HOME ".claude\skills\ta-chanson"
    New-Item -ItemType Directory -Force -Path $SkillDest -ErrorAction Stop | Out-Null
    Copy-Item -Path (Join-Path $Dest "skill\ta-chanson\*") -Destination $SkillDest -Recurse -Force -ErrorAction Stop
    Ok "skill installé dans $SkillDest"
}
catch {
    Stop-Avec "Problème de copie : $($_.Exception.Message)"
}

# 3. Node.js / npx -----------------------------------------------------
Etape "Vérification de Node.js"
if (-not (Get-Command npx -ErrorAction SilentlyContinue)) {
    Stop-Avec "Node.js n'est pas installé. Installe la version LTS sur https://nodejs.org (ou dans PowerShell : winget install OpenJS.NodeJS.LTS), puis relance installer.bat."
}
Ok "Node.js présent"

# 4. Vérification des MP3 (limite Cloudflare Pages : 25 Mo par fichier) ---
Etape "Vérification des démos MP3"
$mp3 = @(Get-ChildItem -Path (Join-Path $Dest "site\exemples") -Filter *.mp3 -ErrorAction SilentlyContinue)
if ($mp3.Count -eq 0) {
    Write-Host "    Aucune démo pour l'instant : le site affichera « Bientôt disponible »."
}
foreach ($f in $mp3) {
    $mo = [math]::Round($f.Length / 1MB, 1)
    if ($f.Length -ge 25MB) {
        Stop-Avec "$($f.Name) fait $mo Mo, au-dessus de la limite de 25 Mo. Réexporte-le plus léger (128 kbps suffit)."
    }
    Ok "$($f.Name) ($mo Mo)"
}

# 5. Connexion Cloudflare ----------------------------------------------
Etape "Connexion à Cloudflare"
Set-Location $Dest
$who = (& npx --yes wrangler whoami 2>&1 | Out-String)
if ($who -match "not authenticated|Not logged in") {
    Write-Host "    Tu n'es pas connecté. La page de connexion Cloudflare va s'ouvrir dans ton navigateur :"
    Write-Host "    connecte-toi (ou crée ton compte gratuit), puis clique sur « Allow »."
    & npx --yes wrangler login
    $who = (& npx --yes wrangler whoami 2>&1 | Out-String)
    if ($who -match "not authenticated|Not logged in") {
        Stop-Avec "La connexion à Cloudflare n'est pas terminée. Relance installer.bat."
    }
}
Ok "connecté à Cloudflare"

# 6. Mise en ligne -----------------------------------------------------
Etape "Mise en ligne sur Cloudflare Pages"
$projets = (& npx --yes wrangler pages project list 2>&1 | Out-String)
if ($projets -notmatch "ta-chanson") {
    Write-Host "    Création du projet « ta-chanson » (branche de production : main)..."
    & npx --yes wrangler pages project create ta-chanson --production-branch main
}
& npx --yes wrangler pages deploy site --project-name ta-chanson --branch main --commit-dirty=true
if ($LASTEXITCODE -ne 0) {
    Stop-Avec "Le déploiement a échoué. Copie le message ci-dessus et colle-le à Claude."
}

Write-Host ""
Write-Host "C'est en ligne : https://ta-chanson.pages.dev" -ForegroundColor Green
Write-Host "(si Cloudflare affiche juste au-dessus une autre adresse en .pages.dev, c'est celle-là qu'il faut utiliser)"
Write-Host ""
Read-Host "Appuie sur Entrée pour fermer"
