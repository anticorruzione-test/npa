# 🔄 Git Hooks - Sostituzione Automatica Segmento Branch

Questa cartella contiene script Git che **automaticamente sostituiscono il segmento branch** nei path GitHub col nome del branch corrente.

## 📂 File in questa cartella

| File | Scopo | Quando scatta |
|------|-------|---------------|
| `update-branch-path.ps1` | **Script logica unica** con regex per sostituire il segmento path dinamicamente | Richiamato dagli altri hook |
| `post-checkout` | Hook Git che esegue lo script | Quando esegui `git checkout`, `git switch`, o crei un branch |
| `post-merge` | Hook Git che esegue lo script | Dopo un merge locale completato (compreso conflitti risolti) |

## 🚀 Setup Una Tantum

Esegui questo comando **una sola volta** nella root del repo (Windows PowerShell):

```powershell
cd "C:\Dev Projects\ANAC\GitHub\anticorruzione-test\npa"
git config core.hooksPath .githooks
```

Questo configura Git per usare gli hook dalla cartella `.githooks` invece di `.git/hooks`.

## ✅ Installazione completata quando:

```
git config --local core.hooksPath
```

stampa:

```
.githooks
```

## 📝 Cosa succede automaticamente

1. **Crei/cambi branch:**
   ```
   git checkout -b feature/mio-feature
   ↓ (Hook post-checkout)
   /anticorruzione-test/npa/main/ → /anticorruzione-test/npa/feature%2Fmio-feature/
   ```

2. **Fai un merge locale:**
   ```
   git merge develop
   ↓ (Hook post-merge)
   Segmento path aggiornato se necessario
   ```

## 🧪 Test

```powershell
# 1. Crea un branch di test
git checkout -b test-hook

# 2. Verifica la sostituzione (grep con PowerShell)
Select-String -Path "*.json", "*.yml" -Pattern "/anticorruzione-test/npa/" -Recurse

# 3. Dovrai vedere percorsi come: /anticorruzione-test/npa/test-hook/
```

## 🔍 Logica di Sostituzione

Lo script in `update-branch-path.ps1`:

- **Legge** il nome del branch corrente (`git rev-parse --abbrev-ref HEAD`)
- **Se il branch contiene `/`** (es. `feature/mio-branch`): lo codifica in `feature%2Fmio-branch` per mantenere un singolo segmento URL
- **Scansiona** file con estensioni: `.yml`, `.yaml`, `.json`, `.xml`, `.md`, `.txt`, `.properties`, `.conf`
- **Sostituisce** i seguenti formati:
  - `/anticorruzione-test/npa/<BRANCH>/`
  - `/anticorruzione-test/npa/blob/<BRANCH>/`
  - `/anticorruzione-test/npa/tree/<BRANCH>/`
- **Esclude** directory: `.git`, `node_modules`, `target`, `.idea`, `bin`, `obj`, `.githooks`

## ⚙️ Customizzazione

Vuoi aggiungere altre estensioni di file? Modifica `update-branch-path.ps1`:

```powershell
$extensions = @(".yml", ".yaml", ".json", ".xml", ".md", ".txt", ".properties", ".conf", ".gradle", ".xml")
```

Vuoi escludere altre directory?

```powershell
$excludeDirNames = @(".git", "node_modules", "target", ".idea", "bin", "obj", ".githooks", "docs")
```

## 🚫 Disabilitare Temporaneamente

Se un hook vi crea problemi:

```powershell
git config core.hooksPath ""
# [... fai quello che devi ...]
git config core.hooksPath .githooks
```

## 📌 Note Importanti

- **Hook locali**: gli hook **non** si eseguono su merge remoti (PR merge su GitHub)
- **TeamShare**: è buona pratica condividere `.githooks` con il team aggiungendolo al repo
- **Performance**: il primo run su un repo grande potrebbe impiegare 1-2 secondi
- **Encoding**: lo script preserva encoding UTF-8 dei file

---

Made for Windows (PowerShell + Git for Windows)

