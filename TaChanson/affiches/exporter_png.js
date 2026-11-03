// Exporte les affiches HTML en PNG (nécessite Node.js et Playwright).
// Utilisation, depuis le dossier TaChanson :  node affiches/exporter_png.js
const path = require("path");
const { chromium } = require("playwright");

const dir = __dirname;
const racine = path.join(dir, "..");
const url = (f, hash = "") => "file://" + path.join(dir, f) + hash;

const travaux = [
  { src: url("affiche1.html"), out: path.join(dir, "affiche1.png"), w: 1080, h: 1920 },
  { src: url("affiche2.html"), out: path.join(dir, "affiche2.png"), w: 1080, h: 1920 },
  { src: url("affiche3.html"), out: path.join(dir, "affiche3.png"), w: 1080, h: 1080 },
  { src: url("apercu_lien.html"), out: path.join(racine, "site", "og.png"), w: 1200, h: 630 },
  ...["statut", "complete", "clip", "evenement"].map((o) => ({
    src: url("catalogue_offre.html", "#" + o),
    out: path.join(racine, "catalogue", "offre-" + o + ".png"),
    w: 1080,
    h: 1080,
  })),
];

(async () => {
  const browser = await chromium.launch();
  for (const t of travaux) {
    const page = await browser.newPage({ viewport: { width: t.w, height: t.h }, deviceScaleFactor: 1 });
    await page.goto(t.src, { waitUntil: "networkidle" });
    await page.evaluate(() => document.fonts.ready);
    await page.waitForTimeout(300);
    await page.screenshot({ path: t.out });
    await page.close();
    console.log("OK", path.relative(racine, t.out));
  }
  await browser.close();
})();
