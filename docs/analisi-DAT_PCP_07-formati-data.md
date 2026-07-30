# PdL DAT_PCP_07 — Censimento campi `date` / `time` / `date-time` e centralizzazione del formato

**Repository:** `anticorruzione-test/npa` · **Data analisi:** 29/07/2026 · **Autore:** analisi automatizzata sul working tree locale

## 1. Scopo e perimetro

Il PdL DAT_PCP_07 richiede di rendere **esplicito e centralizzato** il formato dei campi temporali. Questo documento censisce, riga per riga, tutte le occorrenze rilevate nei tre perimetri richiesti:

| # | Perimetro | Percorso | Oggetti analizzati |
|---|---|---|---|
| A | Specifiche di interfaccia | `docs/specifiche-interfacce/specifiche-servizi-appalto.yaml` | 46 path, 46 operazioni |
| B | Modello dati — schede | `docs/modello-dati/schede/` | 148 file YAML (147 schede + `modello-dati-schede-dati-comuni.yaml`) |
| C | Regole di validazione | `docs/modello-dati/regole/` | 151 file DMN |

### Sintesi dei risultati

| Perimetro | Occorrenze trovate | Formato già dichiarato? | Formato centralizzato? |
|---|---|---|---|
| A — parametri di input dei servizi | **16 query parameter** + **4 campi in request body** | Sì, `format: date-time` su tutti (20/20) | **No** — 20 dichiarazioni duplicate inline |
| B — schede modello dati | **92 schede su 147** contengono almeno un campo temporale; **159 occorrenze** risolte transitivamente | Sì, `format: date-time` | **Parzialmente** — 16 definizioni in `dati-comuni.yaml`, **47 dichiarazioni locali duplicate** |
| C — regole DMN | **26 regole distinte** su campi data, presenti in **58 file DMN** (173 istanze) | n/a | **Nessuna regola valida il formato** |

> **Nota di lettura:** i capitoli 2, 3 e 4 fotografano lo stato **precedente** all'intervento e restano il censimento di riferimento del PdL. Il capitolo 5 riporta il formato canonico deciso, il capitolo 6 le modifiche effettivamente applicate (perimetro A, completato).

> **Esito chiave:** il `format: date-time` è già dichiarato in modo pressoché uniforme, ma **nessun punto della catena vincola la sintassi effettiva del valore** (offset, precisione, presenza di `Z`). Le regole DMN `REG105`/`REG106` *assumono* implicitamente il suffisso `Z` senza verificarlo, e 5 regole confrontano date come stringhe. È questa l'assenza di controllo che il PdL deve colmare.

---

## 2. Perimetro A — `specifiche-servizi-appalto.yaml`

### 2.1 Parametri in input di tipo temporale (`in: query`)

Nessun parametro temporale è presente in `path`, `header` o `cookie`; `components.parameters` è **vuoto** (nessun parametro riusabile è definito), quindi tutte le occorrenze sono dichiarate **inline** e duplicate.

| # | Path | operationId | Parametro | `in` | type | format | Obbligatorio | `example` | Riga |
|---|---|---|---|---|---|---|---|---|---|
| 1 | `/ricerca-piano` | `idPianoRicerca` | `dataCreazioneDa` | query | string | `date-time` | no | `2015-05-28T14:07:17Z` | 265 |
| 2 | `/ricerca-piano` | `idPianoRicerca` | `dataCreazioneA` | query | string | `date-time` | no | `2015-05-28T14:07:17Z` | 272 |
| 3 | `/ricerca-appalto` | `idAppaltoRicerca` | `dataCreazioneDa` | query | string | `date-time` | no | `2015-05-28T14:07:17Z` | 508 |
| 4 | `/ricerca-appalto` | `idAppaltoRicerca` | `dataCreazioneA` | query | string | `date-time` | no | `2015-05-28T14:07:17Z` | 515 |
| 5 | `/ricerca-avviso` | `idAvvisoRicerca` | `dataCreazioneDa` | query | string | `date-time` | no | `2022-01-23T12:02:05Z` | 885 |
| 6 | `/ricerca-avviso` | `idAvvisoRicerca` | `dataCreazioneA` | query | string | `date-time` | no | `2022-01-23T12:02:05Z` | 892 |
| 7 | `/ricerca-avviso` | `idAvvisoRicerca` | `dataCreazioneAvvisoDa` | query | string | `date-time` | no | `2022-01-23T12:02:05Z` | 924 |
| 8 | `/ricerca-avviso` | `idAvvisoRicerca` | `dataCreazioneAvvisoA` | query | string | `date-time` | no | `2022-01-23T12:02:05Z` | 931 |
| 9 | `/ricerca-scheda` | `idSchedaRicerca` | `dataCreazioneDa` | query | string | `date-time` | no | `2022-01-23T12:02:05Z` | 1229 |
| 10 | `/ricerca-scheda` | `idSchedaRicerca` | `dataCreazioneA` | query | string | `date-time` | no | `2022-01-23T12:02:05Z` | 1236 |
| 11 | `/recupera-tipologica` | `idRecuperaTipologica` | `dataInizio` | query | string | `date-time` | no | `2022-01-23T12:02:05Z` | 1556 |
| 12 | `/recupera-tipologica` | `idRecuperaTipologica` | `dataFine` | query | string | `date-time` | no | `2022-01-23T12:02:05Z` | 1563 |
| 13 | `/ricerca-soggetti` | `idIncaricatoRicerca` | `dataInizioDa` | query | string | `date-time` | no | `2015-05-28T14:07:17Z` | 1724 |
| 14 | `/ricerca-soggetti` | `idIncaricatoRicerca` | `dataInizioA` | query | string | `date-time` | no | `2015-05-28T14:07:17Z` | 1731 |
| 15 | `/ricerca-soggetti` | `idIncaricatoRicerca` | `dataFineDa` | query | string | `date-time` | no | `2015-05-28T14:07:17Z` | 1738 |
| 16 | `/ricerca-soggetti` | `idIncaricatoRicerca` | `dataFineA` | query | string | `date-time` | no | `2015-05-28T14:07:17Z` | 1745 |

**Anomalie rilevate**

- Il parametro `dataCreazioneA` di `/ricerca-avviso` (riga 893) riporta nella `description` `«A date-time specified by RF333»` invece di `«…by ISO 8601 as profiled by RFC 3339»`: refuso da correggere.
- L'`example` è collocato in modo incoerente: talvolta come sibling di `schema` (righe 270, 513, 890…), talvolta *dentro* `schema` (righe 1556, 1563). Solo la seconda forma è quella corretta per OpenAPI 3.0.3 quando si vuole esemplificare il valore dello schema.
- Due valori di esempio diversi (`2015-05-28T14:07:17Z` e `2022-01-23T12:02:05Z`) per lo stesso concetto.
- Nessun `pattern`, nessun `minLength`/`maxLength`: un client può inviare `2026-07-29`, `2026-07-29T10:00:00+02:00`, `2026-07-29T10:00:00.123Z` e tutte queste forme sono formalmente valide per `format: date-time` (RFC 3339) ma **non equivalenti** per le regole DMN a valle (§4).

### 2.2 Campi temporali nel request body

| # | Path | operationId | Schema | Campo | type | format | `example` |
|---|---|---|---|---|---|---|---|
| 17 | `/aggiungi-soggetto` | `idSoggettoAggiungi` | `SoggettoRequest` | `dataInizio` | string | `date-time` | `2022-01-23T12:02:05Z` |
| 18 | `/aggiungi-soggetto` | `idSoggettoAggiungi` | `SoggettoRequest` | `dataFine` | string | `date-time` | `2022-01-23T12:02:05Z` |
| 19 | `/elimina-soggetto` | `idSoggettoElimina` | `EliminaSoggettoRequest` | `dataInizio` | string | `date-time` | `2022-01-23T12:02:05Z` |
| 20 | `/elimina-soggetto` | `idSoggettoElimina` | `EliminaSoggettoRequest` | `dataFine` | string | `date-time` | `2022-01-23T12:02:05Z` |

`SoggettoRequest` e `EliminaSoggettoRequest` duplicano la stessa coppia di campi: candidate all'unificazione.

### 2.3 Header temporali

Non esistono header di **input** temporali. Fra gli header di **risposta** definiti in `components.headers`:

| Header | type | format | Nota |
|---|---|---|---|
| `Sunset` | string | `HTTP-date` | Formato RFC 7231 (`Sun, 06 Nov 1994 08:49:37 GMT`), **diverso** da ISO 8601 — corretto per la semantica HTTP, da non uniformare |
| `Retry-After`, `X-RateLimit-Reset` | integer | `int32` | Durate in secondi, non date |

### 2.4 Request body che ereditano campi temporali dal modello dati

Otto operazioni ricevono l'intera scheda per riferimento esterno: i loro campi temporali sono quelli censiti nel §3 e **non sono ridefiniti** nel file dei servizi.

| Path | operationId | Campo body | `$ref` |
|---|---|---|---|
| `/crea-piano`, `/modifica-piano` | `idPianoCrea`, `idPianoModifica` | `scheda` | `modello-dati-npa.yaml#/…/SchedaPianificazioneType` |
| `/crea-appalto`, `/modifica-appalto` | `idAppaltoCrea`, `idAppaltoModifica` | `scheda` | `modello-dati-npa.yaml#/…/SchedaComunicaAppaltoType` |
| `/modifica-avviso`, `/rettifica-avviso` | `idAvvisoModifica`, `idAvvisoRettifica` | `scheda` | `modello-dati-npa.yaml#/…/SchedaGroupType` |
| `/crea-scheda`, `/modifica-scheda` | `idSchedaCrea`, `idSchedaModifica` | `scheda` | `modello-dati-npa.yaml#/…/SchedaPostPubblicazioneType` |

---

## 3. Perimetro B — schede del modello dati

### 3.1 Quadro d'insieme

- **92 schede su 147** prevedono la valorizzazione di almeno un campo temporale (159 occorrenze in totale, risolvendo i `$ref` transitivamente).
- **55 schede** non contengono campi temporali e non sono impattate dal PdL.
- Tutte le occorrenze sono `type: string` + `format: date-time`. **Nessun campo usa `format: date` o `format: time`**, nemmeno dove la semantica sarebbe di sola data (es. `dataAggiudicazione`, `dataStipula`): scelta da confermare o correggere in sede di PdL.
- **Nessuna occorrenza ha `pattern`, `minLength` o `maxLength`.**

### 3.2 Tipi già centralizzati in `modello-dati-schede-dati-comuni.yaml`

16 campi temporali sono definiti una sola volta e riusati via `$ref`: è la base su cui costruire la centralizzazione.

| Tipo centralizzato in `modello-dati-schede-dati-comuni.yaml` | Campo | `format` attuale | N. schede che lo raggiungono via `$ref` |
|---|---|---|---|
| `DatiBaseAggiudicazioneAppaltoType` | `dataAggiudicazione` | `date-time` | 28 |
| `DatiBaseComunicazioneType` | `dataInvioInviti` | `date-time` | 10 |
| `DatiBaseDurataCSDAType` | `dataFine` | `date-time` | 1 |
| `DatiBaseDurataSDAType` | `dataFine` | `date-time` | 0 |
| `DatiBaseDurataSDAType` | `dataInizio` | `date-time` | 0 |
| `DatiBaseDurataType` | `dataFine` | `date-time` | 5 |
| `DatiBaseDurataType` | `dataInizio` | `date-time` | 5 |
| `DatiBaseModificaContrattualeType` | `dataSottoscrizione` | `date-time` | 2 |
| `DatiBaseTerminiInvioSoloOraType` | `scadenzaPresentazioneOfferte` | `date-time` | 5 |
| `DatiBaseTerminiInvioSoloScadenzaType` | `scadenzaPresentazioneInvito` | `date-time` | 8 |
| `DatiTerminiInvioType` | `scadenzaPresentazioneInvito` | `date-time` | 21 |
| `DatiTerminiInvioType` | `scadenzaPresentazioneOfferte` | `date-time` | 21 |
| `ModificaContrattualeType` | `dataApprovazione` | `date-time` | 2 |
| `ModificaContrattuale_40Type` | `dataApprovazione` | `date-time` | 2 |
| `PrestazioneType` | `dataAffidamentoIncarico` | `date-time` | 1 |
| `PrestazioneType` | `dataConsegna` | `date-time` | 1 |

> `DatiBaseDurataSDAType` (`dataInizio`, `dataFine`) **non è raggiunto da alcuna scheda**: tipo orfano, da rimuovere o da collegare.

### 3.3 Dichiarazioni locali duplicate (da ricondurre al tipo centralizzato)

47 campi temporali sono dichiarati direttamente nel file della singola scheda, replicando lo stesso blocco `type`/`format`. Sono il principale target di refactoring.

> **Nota sul perimetro effettivo.** Il censimento iniziale di questo PdL è stato eseguito sul branch `appalti` e rilevava 50 dichiarazioni locali in 22 file. Il branch di lavoro `datetimeFormat` è stato creato da `main`, dove `modello-dati-schede-ID.yaml` è a uno stato precedente e non contiene `IntegrazioneDatiEsecuzioneType` con i suoi 3 campi temporali. Non si tratta quindi di una rimozione ma di una **divergenza di branch**: il perimetro B è stato applicato a quanto effettivamente presente su `datetimeFormat`, ossia **47 dichiarazioni in 21 file**. I conteggi transitivi (92 schede, 159 occorrenze) sono identici sui due branch, perché su `appalti` quel tipo non è raggiungibile da `SchedaIDType`.

| File scheda | Tipo | Campo | `format` |
|---|---|---|---|
| `modello-dati-schede-A3.3.yaml` | `AggiudicazioneA3_3Type` | `dataAdesione` | `date-time` |
| `modello-dati-schede-AC1.yaml` | `AccordoBonarioType` | `dataAccordo` | `date-time` |
| `modello-dati-schede-AD4.yaml` | `AppaltoAD4Type` | `dataAdesione` | `date-time` |
| `modello-dati-schede-CBI.yaml` | `ConclusioneType` | `dataInizio` | `date-time` |
| `modello-dati-schede-CBI.yaml` | `ConclusioneType` | `dataUltimazione` | `date-time` |
| `modello-dati-schede-CL1.yaml` | `CollaudoType` | `dataCertificato` | `date-time` |
| `modello-dati-schede-CL1.yaml` | `CollaudoType` | `dataCollaudo` | `date-time` |
| `modello-dati-schede-CL1.yaml` | `CollaudoType` | `dataDeliberaAmmissibilita` | `date-time` |
| `modello-dati-schede-CL1.yaml` | `CollaudoType` | `dataInizio` | `date-time` |
| `modello-dati-schede-CL1.yaml` | `CollaudoType` | `dataNomina` | `date-time` |
| `modello-dati-schede-CL1.yaml` | `CollaudoType` | `dataRedazioneCertificato` | `date-time` |
| `modello-dati-schede-CM3.yaml` | `ComunicazioneCM3Type` | `scadenzaPresentazioneOfferte` | `date-time` |
| `modello-dati-schede-CO1.yaml` | `ConclusioneType` | `dataEsecutivita` | `date-time` |
| `modello-dati-schede-CO1.yaml` | `ConclusioneType` | `dataInterruzioneAnticipata` | `date-time` |
| `modello-dati-schede-CO1.yaml` | `ConclusioneType` | `dataStipula` | `date-time` |
| `modello-dati-schede-CO1.yaml` | `ConclusioneType` | `dataUltimazione` | `date-time` |
| `modello-dati-schede-CO2.yaml` | `ConclusioneType` | `dataInizio` | `date-time` |
| `modello-dati-schede-CO2.yaml` | `ConclusioneType` | `dataUltimazione` | `date-time` |
| `modello-dati-schede-COC.yaml` | `ConclusioneType` | `dataInizio` | `date-time` |
| `modello-dati-schede-COC.yaml` | `ConclusioneType` | `dataUltimazione` | `date-time` |
| `modello-dati-schede-CS1.yaml` | `SubappaltoType` | `dataUltimazione` | `date-time` |
| `modello-dati-schede-ES1.yaml` | `SubappaltoType` | `dataAutorizzazione` | `date-time` |
| `modello-dati-schede-I1.yaml` | `DatiInizioType` | `dataApprovazione` | `date-time` |
| `modello-dati-schede-I1.yaml` | `DatiInizioType` | `dataAvvioPrimaFase` | `date-time` |
| `modello-dati-schede-I1.yaml` | `DatiInizioType` | `dataDisposizioneInizio` | `date-time` |
| `modello-dati-schede-I1.yaml` | `DatiInizioType` | `dataEffettivoInizio` | `date-time` |
| `modello-dati-schede-I1.yaml` | `DatiInizioType` | `dataFinePrevista` | `date-time` |
| `modello-dati-schede-I1.yaml` | `DatiInizioType` | `dataVerbaleConsegnaDefinitiva` | `date-time` |
| `modello-dati-schede-I1.yaml` | `DatiInizioType` | `dataVerbalePrimaConsegna` | `date-time` |
| `modello-dati-schede-IR1.yaml` | `RitardoType` | `dataIstanzaRecesso` | `date-time` |
| `modello-dati-schede-IR1.yaml` | `RitardoType` | `dataTermine` | `date-time` |
| `modello-dati-schede-RI1.yaml` | `SospensioneType` | `dataVerbaleRipresa` | `date-time` |
| `modello-dati-schede-S1_2.yaml` | `ElencoSoggettiType` | `dataInvito` | `date-time` |
| `modello-dati-schede-S1_2.yaml` | `ElencoSoggettiType` | `scadenzaPresentazioneOfferte` | `date-time` |
| `modello-dati-schede-S2.yaml` | `ElencoSoggettiType` | `dataInvito` | `date-time` |
| `modello-dati-schede-S2.yaml` | `ElencoSoggettiType` | `dataScadenzaPresentazioneOfferta` | `date-time` |
| `modello-dati-schede-S2R.yaml` | `ElencoSoggettiType` | `dataInvito` | `date-time` |
| `modello-dati-schede-S2R.yaml` | `ElencoSoggettiType` | `dataScadenzaPresentazioneOfferta` | `date-time` |
| `modello-dati-schede-SA1.yaml` | `AvanzamentoType` | `dataAvanzamento` | `date-time` |
| `modello-dati-schede-SA1.yaml` | `AvanzamentoType` | `dataCertificatoAnticipazione` | `date-time` |
| `modello-dati-schede-SA1.yaml` | `AvanzamentoType` | `dataCertificatoMandatoPagamento` | `date-time` |
| `modello-dati-schede-SC1.yaml` | `DatiContrattoType` | `dataDecorrenza` | `date-time` |
| `modello-dati-schede-SC1.yaml` | `DatiContrattoType` | `dataEsecutivita` | `date-time` |
| `modello-dati-schede-SC1.yaml` | `DatiContrattoType` | `dataScadenza` | `date-time` |
| `modello-dati-schede-SC1.yaml` | `DatiContrattoType` | `dataStipula` | `date-time` |
| `modello-dati-schede-SO1.yaml` | `SospensioneType` | `dataVerbaleSospensione` | `date-time` |
| `modello-dati-schede-SQ1.yaml` | `SospensioneType` | `dataSuperamento` | `date-time` |

### 3.4 Censimento completo — 159 occorrenze per scheda

Path espressi a partire dalla radice `Scheda…Type` di ciascun file; `[]` indica un elemento di array. La colonna «Dichiarato in» distingue le occorrenze già centralizzate da quelle locali.

| # | Scheda | File YAML | Path del campo (da radice `Scheda…Type`) | type | format | Dichiarato in |
|---|---|---|---|---|---|---|
| 1 | `A2.29` | `modello-dati-schede-A2.29.yaml` | `anacForm.aggiudicazioni[].datiBaseAggiudicazioneAppalto.dataAggiudicazione` | string | `date-time` | **dati-comuni** |
| 2 | `A2.30` | `modello-dati-schede-A2.30.yaml` | `anacForm.aggiudicazioni[].datiBaseAggiudicazioneAppalto.dataAggiudicazione` | string | `date-time` | **dati-comuni** |
| 3 | `A2.31` | `modello-dati-schede-A2.31.yaml` | `anacForm.aggiudicazioni[].datiBaseAggiudicazioneAppalto.dataAggiudicazione` | string | `date-time` | **dati-comuni** |
| 4 | `A2.32` | `modello-dati-schede-A2.32.yaml` | `anacForm.aggiudicazioni[].datiBaseAggiudicazioneAppalto.dataAggiudicazione` | string | `date-time` | **dati-comuni** |
| 5 | `A2.33` | `modello-dati-schede-A2.33.yaml` | `anacForm.aggiudicazioni[].datiBaseAggiudicazioneAppalto.dataAggiudicazione` | string | `date-time` | **dati-comuni** |
| 6 | `A2.34` | `modello-dati-schede-A2.34.yaml` | `anacForm.aggiudicazioni[].datiBaseAggiudicazioneAppalto.dataAggiudicazione` | string | `date-time` | **dati-comuni** |
| 7 | `A2.35` | `modello-dati-schede-A2.35.yaml` | `anacForm.aggiudicazioni[].datiBaseAggiudicazioneAppalto.dataAggiudicazione` | string | `date-time` | **dati-comuni** |
| 8 | `A2.36` | `modello-dati-schede-A2.36.yaml` | `anacForm.aggiudicazioni[].datiBaseAggiudicazioneAppalto.dataAggiudicazione` | string | `date-time` | **dati-comuni** |
| 9 | `A2.37` | `modello-dati-schede-A2.37.yaml` | `anacForm.aggiudicazioni[].datiBaseAggiudicazioneAppalto.dataAggiudicazione` | string | `date-time` | **dati-comuni** |
| 10 | `A3.1` | `modello-dati-schede-A3.1.yaml` | `anacForm.aggiudicazioni[].datiBaseAggiudicazioneAppalto.dataAggiudicazione` | string | `date-time` | **dati-comuni** |
| 11 | `A3.2` | `modello-dati-schede-A3.2.yaml` | `anacForm.aggiudicazioni[].datiBaseAggiudicazioneAppalto.dataAggiudicazione` | string | `date-time` | **dati-comuni** |
| 12 | `A3.3` | `modello-dati-schede-A3.3.yaml` | `anacForm.aggiudicazioni[].dataAdesione` | string | `date-time` | locale |
| 13 | `A3.3` | `modello-dati-schede-A3.3.yaml` | `anacForm.aggiudicazioni[].datiBaseAggiudicazioneAppalto.dataAggiudicazione` | string | `date-time` | **dati-comuni** |
| 14 | `A3.4` | `modello-dati-schede-A3.4.yaml` | `anacForm.aggiudicazioni[].datiBaseAggiudicazioneAppalto.dataAggiudicazione` | string | `date-time` | **dati-comuni** |
| 15 | `A3.5` | `modello-dati-schede-A3.5.yaml` | `anacForm.aggiudicazioni[].datiBaseAggiudicazioneAppalto.dataAggiudicazione` | string | `date-time` | **dati-comuni** |
| 16 | `A3.6` | `modello-dati-schede-A3.6.yaml` | `anacForm.aggiudicazioni[].datiBaseAggiudicazioneAppalto.dataAggiudicazione` | string | `date-time` | **dati-comuni** |
| 17 | `A4.1` | `modello-dati-schede-A4.1.yaml` | `anacForm.aggiudicazioni[].datiBaseAggiudicazioneAppalto.dataAggiudicazione` | string | `date-time` | **dati-comuni** |
| 18 | `A4.2` | `modello-dati-schede-A4.2.yaml` | `anacForm.aggiudicazioni[].datiBaseAggiudicazioneAppalto.dataAggiudicazione` | string | `date-time` | **dati-comuni** |
| 19 | `A4.3` | `modello-dati-schede-A4.3.yaml` | `anacForm.aggiudicazioni[].datiBaseAggiudicazioneAppalto.dataAggiudicazione` | string | `date-time` | **dati-comuni** |
| 20 | `A4.4` | `modello-dati-schede-A4.4.yaml` | `anacForm.aggiudicazioni[].datiBaseAggiudicazioneAppalto.dataAggiudicazione` | string | `date-time` | **dati-comuni** |
| 21 | `A4.5` | `modello-dati-schede-A4.5.yaml` | `anacForm.aggiudicazioni[].datiBaseAggiudicazioneAppalto.dataAggiudicazione` | string | `date-time` | **dati-comuni** |
| 22 | `A4.6` | `modello-dati-schede-A4.6.yaml` | `anacForm.aggiudicazioni[].datiBaseAggiudicazioneAppalto.dataAggiudicazione` | string | `date-time` | **dati-comuni** |
| 23 | `A7.1.2` | `modello-dati-schede-A7.1.2.yaml` | `anacForm.aggiudicazioni[].datiBaseAggiudicazioneAppalto.dataAggiudicazione` | string | `date-time` | **dati-comuni** |
| 24 | `AC1` | `modello-dati-schede-AC1.yaml` | `anacForm.accordoBonario.dataAccordo` | string | `date-time` | locale |
| 25 | `AD2.25` | `modello-dati-schede-AD2.25.yaml` | `anacForm.aggiudicazioni[].datiBaseAggiudicazioneAppalto.dataAggiudicazione` | string | `date-time` | **dati-comuni** |
| 26 | `AD2.26` | `modello-dati-schede-AD2.26.yaml` | `anacForm.aggiudicazioni[].datiBaseAggiudicazioneAppalto.dataAggiudicazione` | string | `date-time` | **dati-comuni** |
| 27 | `AD2.27` | `modello-dati-schede-AD2.27.yaml` | `anacForm.aggiudicazioni[].datiBaseAggiudicazioneAppalto.dataAggiudicazione` | string | `date-time` | **dati-comuni** |
| 28 | `AD2.28` | `modello-dati-schede-AD2.28.yaml` | `anacForm.aggiudicazioni[].datiBaseAggiudicazioneAppalto.dataAggiudicazione` | string | `date-time` | **dati-comuni** |
| 29 | `AD3` | `modello-dati-schede-AD3.yaml` | `anacForm.aggiudicazioni[].datiBaseAggiudicazioneAppalto.dataAggiudicazione` | string | `date-time` | **dati-comuni** |
| 30 | `AD4` | `modello-dati-schede-AD4.yaml` | `anacForm.aggiudicazioni[].datiBaseAggiudicazioneAppalto.dataAggiudicazione` | string | `date-time` | **dati-comuni** |
| 31 | `AD4` | `modello-dati-schede-AD4.yaml` | `anacForm.appalto.dataAdesione` | string | `date-time` | locale |
| 32 | `AOC` | `modello-dati-schede-AOC.yaml` | `anacForm.aggiudicazioni[].datiBaseTerminiInvio.scadenzaPresentazioneOfferte` | string | `date-time` | **dati-comuni** |
| 33 | `CBI` | `modello-dati-schede-CBI.yaml` | `anacForm.conclusione.dataInizio` | string | `date-time` | locale |
| 34 | `CBI` | `modello-dati-schede-CBI.yaml` | `anacForm.conclusione.dataUltimazione` | string | `date-time` | locale |
| 35 | `CL1` | `modello-dati-schede-CL1.yaml` | `anacForm.collaudo.dataCertificato` | string | `date-time` | locale |
| 36 | `CL1` | `modello-dati-schede-CL1.yaml` | `anacForm.collaudo.dataCollaudo` | string | `date-time` | locale |
| 37 | `CL1` | `modello-dati-schede-CL1.yaml` | `anacForm.collaudo.dataDeliberaAmmissibilita` | string | `date-time` | locale |
| 38 | `CL1` | `modello-dati-schede-CL1.yaml` | `anacForm.collaudo.dataInizio` | string | `date-time` | locale |
| 39 | `CL1` | `modello-dati-schede-CL1.yaml` | `anacForm.collaudo.dataNomina` | string | `date-time` | locale |
| 40 | `CL1` | `modello-dati-schede-CL1.yaml` | `anacForm.collaudo.dataRedazioneCertificato` | string | `date-time` | locale |
| 41 | `CM3` | `modello-dati-schede-CM3.yaml` | `anacForm.comunicazione.scadenzaPresentazioneOfferte` | string | `date-time` | locale |
| 42 | `CO1` | `modello-dati-schede-CO1.yaml` | `anacForm.conclusione.dataEsecutivita` | string | `date-time` | locale |
| 43 | `CO1` | `modello-dati-schede-CO1.yaml` | `anacForm.conclusione.dataInterruzioneAnticipata` | string | `date-time` | locale |
| 44 | `CO1` | `modello-dati-schede-CO1.yaml` | `anacForm.conclusione.dataStipula` | string | `date-time` | locale |
| 45 | `CO1` | `modello-dati-schede-CO1.yaml` | `anacForm.conclusione.dataUltimazione` | string | `date-time` | locale |
| 46 | `CO2` | `modello-dati-schede-CO2.yaml` | `anacForm.conclusione.dataInizio` | string | `date-time` | locale |
| 47 | `CO2` | `modello-dati-schede-CO2.yaml` | `anacForm.conclusione.dataUltimazione` | string | `date-time` | locale |
| 48 | `COC` | `modello-dati-schede-COC.yaml` | `anacForm.conclusione.dataInizio` | string | `date-time` | locale |
| 49 | `COC` | `modello-dati-schede-COC.yaml` | `anacForm.conclusione.dataUltimazione` | string | `date-time` | locale |
| 50 | `CS1` | `modello-dati-schede-CS1.yaml` | `anacForm.subappalto.dataUltimazione` | string | `date-time` | locale |
| 51 | `CSDA2` | `modello-dati-schede-CSDA2.yaml` | `anacForm.datiBaseDurata.dataFine` | string | `date-time` | **dati-comuni** |
| 52 | `ES1` | `modello-dati-schede-ES1.yaml` | `anacForm.subappalto.dataAutorizzazione` | string | `date-time` | locale |
| 53 | `I1` | `modello-dati-schede-I1.yaml` | `anacForm.datiInizio.dataApprovazione` | string | `date-time` | locale |
| 54 | `I1` | `modello-dati-schede-I1.yaml` | `anacForm.datiInizio.dataAvvioPrimaFase` | string | `date-time` | locale |
| 55 | `I1` | `modello-dati-schede-I1.yaml` | `anacForm.datiInizio.dataDisposizioneInizio` | string | `date-time` | locale |
| 56 | `I1` | `modello-dati-schede-I1.yaml` | `anacForm.datiInizio.dataEffettivoInizio` | string | `date-time` | locale |
| 57 | `I1` | `modello-dati-schede-I1.yaml` | `anacForm.datiInizio.dataFinePrevista` | string | `date-time` | locale |
| 58 | `I1` | `modello-dati-schede-I1.yaml` | `anacForm.datiInizio.dataVerbaleConsegnaDefinitiva` | string | `date-time` | locale |
| 59 | `I1` | `modello-dati-schede-I1.yaml` | `anacForm.datiInizio.dataVerbalePrimaConsegna` | string | `date-time` | locale |
| 60 | `IR1` | `modello-dati-schede-IR1.yaml` | `anacForm.ritardo.dataIstanzaRecesso` | string | `date-time` | locale |
| 61 | `IR1` | `modello-dati-schede-IR1.yaml` | `anacForm.ritardo.dataTermine` | string | `date-time` | locale |
| 62 | `ISDA2` | `modello-dati-schede-ISDA2.yaml` | `anacForm.lotti[].datiBaseDurata.dataFine` | string | `date-time` | **dati-comuni** |
| 63 | `ISDA2` | `modello-dati-schede-ISDA2.yaml` | `anacForm.lotti[].datiBaseDurata.dataInizio` | string | `date-time` | **dati-comuni** |
| 64 | `M1` | `modello-dati-schede-M1.yaml` | `anacForm.modificaContrattuale.dataApprovazione` | string | `date-time` | **dati-comuni** |
| 65 | `M1.40` | `modello-dati-schede-M1.40.yaml` | `anacForm.modificaContrattuale.dataApprovazione` | string | `date-time` | **dati-comuni** |
| 66 | `M2` | `modello-dati-schede-M2.yaml` | `anacForm.modificaContrattuale.dataApprovazione` | string | `date-time` | **dati-comuni** |
| 67 | `M2` | `modello-dati-schede-M2.yaml` | `anacForm.modificaContrattuale.datiBaseModificaContrattuale.dataSottoscrizione` | string | `date-time` | **dati-comuni** |
| 68 | `M2.40` | `modello-dati-schede-M2.40.yaml` | `anacForm.modificaContrattuale.dataApprovazione` | string | `date-time` | **dati-comuni** |
| 69 | `M2.40` | `modello-dati-schede-M2.40.yaml` | `anacForm.modificaContrattuale.datiBaseModificaContrattuale.dataSottoscrizione` | string | `date-time` | **dati-comuni** |
| 70 | `P2.10` | `modello-dati-schede-P2.10.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneInvito` | string | `date-time` | **dati-comuni** |
| 71 | `P2.11` | `modello-dati-schede-P2.11.yaml` | `anacForm.lotti[].datiBaseDurata.dataFine` | string | `date-time` | **dati-comuni** |
| 72 | `P2.11` | `modello-dati-schede-P2.11.yaml` | `anacForm.lotti[].datiBaseDurata.dataInizio` | string | `date-time` | **dati-comuni** |
| 73 | `P2.11` | `modello-dati-schede-P2.11.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneInvito` | string | `date-time` | **dati-comuni** |
| 74 | `P2.12` | `modello-dati-schede-P2.12.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneInvito` | string | `date-time` | **dati-comuni** |
| 75 | `P2.13` | `modello-dati-schede-P2.13.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneInvito` | string | `date-time` | **dati-comuni** |
| 76 | `P2.14` | `modello-dati-schede-P2.14.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneInvito` | string | `date-time` | **dati-comuni** |
| 77 | `P2.16` | `modello-dati-schede-P2.16.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneInvito` | string | `date-time` | **dati-comuni** |
| 78 | `P2.16` | `modello-dati-schede-P2.16.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneOfferte` | string | `date-time` | **dati-comuni** |
| 79 | `P2.17` | `modello-dati-schede-P2.17.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneInvito` | string | `date-time` | **dati-comuni** |
| 80 | `P2.17` | `modello-dati-schede-P2.17.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneOfferte` | string | `date-time` | **dati-comuni** |
| 81 | `P2.18` | `modello-dati-schede-P2.18.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneInvito` | string | `date-time` | **dati-comuni** |
| 82 | `P2.18` | `modello-dati-schede-P2.18.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneOfferte` | string | `date-time` | **dati-comuni** |
| 83 | `P2.19` | `modello-dati-schede-P2.19.yaml` | `anacForm.lotti[].datiBaseDurata.dataFine` | string | `date-time` | **dati-comuni** |
| 84 | `P2.19` | `modello-dati-schede-P2.19.yaml` | `anacForm.lotti[].datiBaseDurata.dataInizio` | string | `date-time` | **dati-comuni** |
| 85 | `P2.19` | `modello-dati-schede-P2.19.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneInvito` | string | `date-time` | **dati-comuni** |
| 86 | `P2.19` | `modello-dati-schede-P2.19.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneOfferte` | string | `date-time` | **dati-comuni** |
| 87 | `P2.20` | `modello-dati-schede-P2.20.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneInvito` | string | `date-time` | **dati-comuni** |
| 88 | `P2.20` | `modello-dati-schede-P2.20.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneOfferte` | string | `date-time` | **dati-comuni** |
| 89 | `P2.21` | `modello-dati-schede-P2.21.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneInvito` | string | `date-time` | **dati-comuni** |
| 90 | `P2.21` | `modello-dati-schede-P2.21.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneOfferte` | string | `date-time` | **dati-comuni** |
| 91 | `P2.23` | `modello-dati-schede-P2.23.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneInvito` | string | `date-time` | **dati-comuni** |
| 92 | `P2.23` | `modello-dati-schede-P2.23.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneOfferte` | string | `date-time` | **dati-comuni** |
| 93 | `P2.24` | `modello-dati-schede-P2.24.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneInvito` | string | `date-time` | **dati-comuni** |
| 94 | `P2.24` | `modello-dati-schede-P2.24.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneOfferte` | string | `date-time` | **dati-comuni** |
| 95 | `P3.1` | `modello-dati-schede-P3.1.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneInvito` | string | `date-time` | **dati-comuni** |
| 96 | `P3.1` | `modello-dati-schede-P3.1.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneOfferte` | string | `date-time` | **dati-comuni** |
| 97 | `P3.2` | `modello-dati-schede-P3.2.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneInvito` | string | `date-time` | **dati-comuni** |
| 98 | `P3.2` | `modello-dati-schede-P3.2.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneOfferte` | string | `date-time` | **dati-comuni** |
| 99 | `P3.3` | `modello-dati-schede-P3.3.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneInvito` | string | `date-time` | **dati-comuni** |
| 100 | `P3.3` | `modello-dati-schede-P3.3.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneOfferte` | string | `date-time` | **dati-comuni** |
| 101 | `P3.4` | `modello-dati-schede-P3.4.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneInvito` | string | `date-time` | **dati-comuni** |
| 102 | `P3.4` | `modello-dati-schede-P3.4.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneOfferte` | string | `date-time` | **dati-comuni** |
| 103 | `P3.5` | `modello-dati-schede-P3.5.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneInvito` | string | `date-time` | **dati-comuni** |
| 104 | `P3.5` | `modello-dati-schede-P3.5.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneOfferte` | string | `date-time` | **dati-comuni** |
| 105 | `P4.1` | `modello-dati-schede-P4.1.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneInvito` | string | `date-time` | **dati-comuni** |
| 106 | `P4.1` | `modello-dati-schede-P4.1.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneOfferte` | string | `date-time` | **dati-comuni** |
| 107 | `P4.2` | `modello-dati-schede-P4.2.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneInvito` | string | `date-time` | **dati-comuni** |
| 108 | `P4.2` | `modello-dati-schede-P4.2.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneOfferte` | string | `date-time` | **dati-comuni** |
| 109 | `P4.3` | `modello-dati-schede-P4.3.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneInvito` | string | `date-time` | **dati-comuni** |
| 110 | `P4.3` | `modello-dati-schede-P4.3.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneOfferte` | string | `date-time` | **dati-comuni** |
| 111 | `P4.4` | `modello-dati-schede-P4.4.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneInvito` | string | `date-time` | **dati-comuni** |
| 112 | `P4.4` | `modello-dati-schede-P4.4.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneOfferte` | string | `date-time` | **dati-comuni** |
| 113 | `P4.5` | `modello-dati-schede-P4.5.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneInvito` | string | `date-time` | **dati-comuni** |
| 114 | `P4.5` | `modello-dati-schede-P4.5.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneOfferte` | string | `date-time` | **dati-comuni** |
| 115 | `P4.6` | `modello-dati-schede-P4.6.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneInvito` | string | `date-time` | **dati-comuni** |
| 116 | `P4.6` | `modello-dati-schede-P4.6.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneOfferte` | string | `date-time` | **dati-comuni** |
| 117 | `P6.1` | `modello-dati-schede-P6.1.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneOfferte` | string | `date-time` | **dati-comuni** |
| 118 | `P6.2` | `modello-dati-schede-P6.2.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneOfferte` | string | `date-time` | **dati-comuni** |
| 119 | `P7.1.1` | `modello-dati-schede-P7.1.1.yaml` | `anacForm.lotti[].datiBaseComunicazione.dataInvioInviti` | string | `date-time` | **dati-comuni** |
| 120 | `P7.1.1` | `modello-dati-schede-P7.1.1.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneInvito` | string | `date-time` | **dati-comuni** |
| 121 | `P7.1.2` | `modello-dati-schede-P7.1.2.yaml` | `anacForm.lotti[].datiBaseComunicazione.dataInvioInviti` | string | `date-time` | **dati-comuni** |
| 122 | `P7.1.2` | `modello-dati-schede-P7.1.2.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneInvito` | string | `date-time` | **dati-comuni** |
| 123 | `P7.1.3` | `modello-dati-schede-P7.1.3.yaml` | `anacForm.lotti[].datiBaseComunicazione.dataInvioInviti` | string | `date-time` | **dati-comuni** |
| 124 | `P7.1.3` | `modello-dati-schede-P7.1.3.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneInvito` | string | `date-time` | **dati-comuni** |
| 125 | `P7.2` | `modello-dati-schede-P7.2.yaml` | `anacForm.lotti[].datiBaseComunicazione.dataInvioInviti` | string | `date-time` | **dati-comuni** |
| 126 | `P7.2` | `modello-dati-schede-P7.2.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneOfferte` | string | `date-time` | **dati-comuni** |
| 127 | `P7.3` | `modello-dati-schede-P7.3.yaml` | `anacForm.lotti[].datiBaseDurata.dataFine` | string | `date-time` | **dati-comuni** |
| 128 | `P7.3` | `modello-dati-schede-P7.3.yaml` | `anacForm.lotti[].datiBaseDurata.dataInizio` | string | `date-time` | **dati-comuni** |
| 129 | `PL2.1` | `modello-dati-schede-PL2.1.yaml` | `anacForm.lotti[].datiBaseComunicazione.dataInvioInviti` | string | `date-time` | **dati-comuni** |
| 130 | `PL2.2` | `modello-dati-schede-PL2.2.yaml` | `anacForm.lotti[].datiBaseComunicazione.dataInvioInviti` | string | `date-time` | **dati-comuni** |
| 131 | `PL2.3` | `modello-dati-schede-PL2.3.yaml` | `anacForm.lotti[].datiBaseComunicazione.dataInvioInviti` | string | `date-time` | **dati-comuni** |
| 132 | `PL2.7` | `modello-dati-schede-PL2.7.yaml` | `anacForm.lotti[].datiBaseComunicazione.dataInvioInviti` | string | `date-time` | **dati-comuni** |
| 133 | `PL2.7` | `modello-dati-schede-PL2.7.yaml` | `anacForm.lotti[].datiBaseDurata.dataFine` | string | `date-time` | **dati-comuni** |
| 134 | `PL2.7` | `modello-dati-schede-PL2.7.yaml` | `anacForm.lotti[].datiBaseDurata.dataInizio` | string | `date-time` | **dati-comuni** |
| 135 | `PL2.7` | `modello-dati-schede-PL2.7.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneInvito` | string | `date-time` | **dati-comuni** |
| 136 | `PL2.7` | `modello-dati-schede-PL2.7.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneOfferte` | string | `date-time` | **dati-comuni** |
| 137 | `PL2.8` | `modello-dati-schede-PL2.8.yaml` | `anacForm.lotti[].datiBaseComunicazione.dataInvioInviti` | string | `date-time` | **dati-comuni** |
| 138 | `PL2.8` | `modello-dati-schede-PL2.8.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneOfferte` | string | `date-time` | **dati-comuni** |
| 139 | `PL2.9` | `modello-dati-schede-PL2.9.yaml` | `anacForm.lotti[].datiBaseComunicazione.dataInvioInviti` | string | `date-time` | **dati-comuni** |
| 140 | `PL2.9` | `modello-dati-schede-PL2.9.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneInvito` | string | `date-time` | **dati-comuni** |
| 141 | `PL2.9` | `modello-dati-schede-PL2.9.yaml` | `anacForm.lotti[].datiBaseTerminiInvio.scadenzaPresentazioneOfferte` | string | `date-time` | **dati-comuni** |
| 142 | `RI1` | `modello-dati-schede-RI1.yaml` | `anacForm.sospensione.dataVerbaleRipresa` | string | `date-time` | locale |
| 143 | `S1_2` | `modello-dati-schede-S1_2.yaml` | `anacForm.elencoSoggetti[].dataInvito` | string | `date-time` | locale |
| 144 | `S1_2` | `modello-dati-schede-S1_2.yaml` | `anacForm.elencoSoggetti[].scadenzaPresentazioneOfferte` | string | `date-time` | locale |
| 145 | `S2` | `modello-dati-schede-S2.yaml` | `anacForm.elencoSoggetti[].dataInvito` | string | `date-time` | locale |
| 146 | `S2` | `modello-dati-schede-S2.yaml` | `anacForm.elencoSoggetti[].dataScadenzaPresentazioneOfferta` | string | `date-time` | locale |
| 147 | `S2R` | `modello-dati-schede-S2R.yaml` | `anacForm.elencoSoggetti[].dataInvito` | string | `date-time` | locale |
| 148 | `S2R` | `modello-dati-schede-S2R.yaml` | `anacForm.elencoSoggetti[].dataScadenzaPresentazioneOfferta` | string | `date-time` | locale |
| 149 | `S3` | `modello-dati-schede-S3.yaml` | `anacForm.elencoIncarichi[].prestazioni[].dataAffidamentoIncarico` | string | `date-time` | **dati-comuni** |
| 150 | `S3` | `modello-dati-schede-S3.yaml` | `anacForm.elencoIncarichi[].prestazioni[].dataConsegna` | string | `date-time` | **dati-comuni** |
| 151 | `SA1` | `modello-dati-schede-SA1.yaml` | `anacForm.avanzamento.dataAvanzamento` | string | `date-time` | locale |
| 152 | `SA1` | `modello-dati-schede-SA1.yaml` | `anacForm.avanzamento.dataCertificatoAnticipazione` | string | `date-time` | locale |
| 153 | `SA1` | `modello-dati-schede-SA1.yaml` | `anacForm.avanzamento.dataCertificatoMandatoPagamento` | string | `date-time` | locale |
| 154 | `SC1` | `modello-dati-schede-SC1.yaml` | `anacForm.datiContratto.dataDecorrenza` | string | `date-time` | locale |
| 155 | `SC1` | `modello-dati-schede-SC1.yaml` | `anacForm.datiContratto.dataEsecutivita` | string | `date-time` | locale |
| 156 | `SC1` | `modello-dati-schede-SC1.yaml` | `anacForm.datiContratto.dataScadenza` | string | `date-time` | locale |
| 157 | `SC1` | `modello-dati-schede-SC1.yaml` | `anacForm.datiContratto.dataStipula` | string | `date-time` | locale |
| 158 | `SO1` | `modello-dati-schede-SO1.yaml` | `anacForm.sospensione.dataVerbaleSospensione` | string | `date-time` | locale |
| 159 | `SQ1` | `modello-dati-schede-SQ1.yaml` | `anacForm.sospensione.dataSuperamento` | string | `date-time` | locale |

### 3.5 Schede senza campi temporali (non impattate)

`A1.29`, `A1.30`, `A1.31`, `A1.32`, `A1.33`, `A1.34`, `A1.35`, `A1.36`, `A1.37`, `A7.1.1`, `ABI`, `AD1.25`, `AD1.26`, `AD1.27`, `AD1.28`, `AD5`, `ANN`, `AVR`, `CM1`, `CM2`, `CSDA1`, `ID`, `ISDA1`, `NAG`, `P1.10`, `P1.11`, `P1.12`, `P1.13`, `P1.14`, `P1.15.1`, `P1.15.2`, `P1.16`, `P1.17`, `P1.18`, `P1.19`, `P1.20`, `P1.21`, `P1.23`, `P1.24`, `P5`, `PL1.1`, `PL1.2`, `PL1.3`, `PL1.4`, `PL1.5`, `PL1.6`, `PL1.7`, `PL1.8`, `PL1.9`, `RSU1`, `S0`, `S1`, `S4`, `SOC`, `TVR`
### 3.6 Occorrenze negli altri file del modello dati (contorno del perimetro)

Non richieste esplicitamente ma inevitabilmente coinvolte dalla centralizzazione, perché costituiscono l'involucro (`SchedaType`, `Avviso…`, `Stato…`) delle schede stesse.

| File | Tipo.campo | `format` |
|---|---|---|
| `modello-dati-npa.yaml` | `SchedaType._dataCreazione` | `date-time` |
| `modello-dati-npa.yaml` | `SchedaPostPubblicazioneType._dataModifica` | `date-time` |
| `modello-dati-npa.yaml` | `SoggettoType.dataInizio`, `SoggettoType.dataFine` | `date-time` |
| `modello-dati-npa.yaml` | `AppaltoBaseType.dataCreazione` | `date-time` |
| `modello-dati-npa.yaml` | `AvvisoCommonType.dataCreazione`, `.dataPubblicazione`, `.dataControllo` | `date-time` |
| `modello-dati-npa.yaml` | `AvvisoPVLOscuratoType._dataCreazione`, `._dataModifica`, `.dataControllo`, `.dataNotifica` | `date-time` |
| `modello-dati-npa.yaml` | `DatiPubblicazioneEUType.dataControllo`, `.dataInoltroPubblicazione`, `.dataRicezionePubblicazione`, `.dataPubblicazione` | `date-time` |
| `modello-dati-npa.yaml` | `DatiPubblicazioneITType.dataControllo`, `.dataInoltroPubblicazione`, `.dataPubblicazione` | `date-time` |
| `modello-dati-npa.yaml` | `StatoAppaltoType.dataControllo`, `StatoLottoType.dataControllo`, `StatoAvvisoType.dataControllo`, `EsitoOperazioneType.dataControllo` | `date-time` |
| `modello-dati-tipologiche.yaml` | `TipologicaSchemaEstesoType.dataInizio`, `.dataFine` | `date-time` |

**Segnalazione: 10 campi con `format` non valido.** In `modello-dati-fvoe-fva.yaml` sopravvive `format: datetime` (valore non previsto dalla specifica OpenAPI; il corretto è `date-time`). Il `CHANGELOG.md` documenta la migrazione `datetime → date-time` eseguita sul modello appalti, ma **non è stata propagata a questo file**:

| Tipo.campo (`modello-dati-fvoe-fva.yaml`) | `format` attuale | atteso |
|---|---|---|
| `FascicoloType.dataCreazione` | `datetime` | `date-time` |
| `DocumentoType.dataInserimento`, `.dataEmissione`, `.dataFineValidita`, `.dataProtocollo`, `.dataCreazione` | `datetime` | `date-time` |
| `AutorizzazioneAccessoType.dataInizio`, `.dataFine` | `datetime` | `date-time` |
| `RichiestaAccessoType.dataInizioAutorizzazione`, `.dataFineAutorizzazione` | `datetime` | `date-time` |

Nello stesso file esistono già **pattern espliciti per gli anni** (`^(19\d\d|20[0-9][0-9])$` su `DatiNominativo00004.DatiNascita.Anno`, `DatiSA00047.anno`, `DatiSA00048.anno`; `^(201[6-9]|202[0-2])$` su `DatiSA00036.annoRiferimento` — quest'ultimo con **intervallo scaduto**, non accetta il 2023 e successivi). Sono la prova che l'approccio "formato vincolato via `pattern`" è già in uso nel repository e può essere esteso.

---

## 4. Perimetro C — regole DMN

### 4.1 Quadro d'insieme

- **151 file DMN** analizzati; **58** contengono almeno una regola che tocca un campo temporale.
- **26 regole distinte** (per codice `REGnn`), per **173 istanze** complessive dovute alla replica della stessa regola su più schede.
- Tutti gli `inputExpression` dei 151 DMN hanno `typeRef="string"`: **426 occorrenze, zero `typeRef="date"` o `"dateTime"`**. Le date arrivano al motore di regole come stringhe.
- **Nessuna delle 26 regole verifica il formato del valore.** I controlli si dividono in tre classi:

| Classe | Descrizione | Regole distinte |
|---|---|---|
| **A** | Confronto temporale con conversione esplicita a `date and time` | 2 (`REG105`, `REG106`) |
| **B** | Confronto relazionale fra due campi data **trattati come stringhe** | 5 (`REG57`, `REG77`, `REG90`, `REG92`, `REG93`) |
| **C** | Solo presenza / obbligatorietà / mutua esclusione | 19 |

### 4.2 Dettaglio delle 26 regole

| Codice | Descrizione | N. file DMN | Campi data coinvolti | Classe di controllo | Controllo di formato? |
|---|---|---|---|---|---|
| `REG41` | Indicare la data dell’affidamento di incarico esterno di progettazione | 1 | `dataAffidamentoIncarico` | C - Solo presenza / obbligatorietà / mutua esclusione (`= null or = ""`) | **No** |
| `REG42` | Indicare la data di consegna del progetto | 1 | `dataConsegna` | C - Solo presenza / obbligatorietà / mutua esclusione (`= null or = ""`) | **No** |
| `REG57` | Data approvazione del progetto Esecutivo: se digitata deve essere superiore alla data di disposizione dell’inizio della prog. Esecutiva | 1 | `dataApprovazione`, `dataDisposizioneInizio` | B - Confronto relazionale fra due campi data **come stringhe** (`campoA < campoB`) | **No** — nessuna conversione a `date and time`; confronto lessicografico |
| `REG58` | Data verbale prima consegna lavori: obbligatoria in caso di consegna frazionata. | 1 | `dataVerbalePrimaConsegna` | C - Solo presenza / obbligatorietà / mutua esclusione (`= null or = ""`) | **No** |
| `REG59` | Data di avvio della prima fase dell'esecuzione del contratto: obbligatoria in caso di avvio per fasi. | 1 | `dataAvvioPrimaFase` | C - Solo presenza / obbligatorietà / mutua esclusione (`= null or = ""`) | **No** |
| `REG60` | Data verbale consegna definitiva: obbligatoria quando non c'è consegna frazionata. | 1 | `dataVerbaleConsegnaDefinitiva` | C - Solo presenza / obbligatorietà / mutua esclusione (`= null or = ""`) | **No** |
| `REG64` | Non è stata indicata la data del certificato di pagamento relativo all'anticipazione | 1 | `dataCertificatoAnticipazione` | C - Solo presenza / obbligatorietà / mutua esclusione (`= null or = ""`) | **No** |
| `REG72` | Campo data del certificato di pagamento relativo all'anticipazione non previsto. | 1 | `dataCertificatoAnticipazione` | C - Solo presenza / obbligatorietà / mutua esclusione (`= null or = ""`) | **No** |
| `REG73` | Valorizzare almeno uno dei due campi: ‘Data di autorizzazione subappalto’, ‘Motivo Mancato Subappalto | 1 | `dataAutorizzazione` | C - Solo presenza / obbligatorietà / mutua esclusione (`= null or = ""`) | **No** |
| `REG77` | la data di scadenza deve essere superiore alla data di stipula | 1 | `dataScadenza`, `dataStipula` | B - Confronto relazionale fra due campi data **come stringhe** (`campoA < campoB`) | **No** — nessuna conversione a `date and time`; confronto lessicografico |
| `REG81` | E' necessario indicare la data di ultimazione o la data di interruzione anticipata | 1 | `dataInterruzioneAnticipata`, `dataUltimazione` | C - Solo presenza / obbligatorietà / mutua esclusione (`= null or = ""`) | **No** |
| `REG86` | Certificato di regolare esecuzione non previsto in caso di collaudo tecnico/amministrativo | 1 | `dataCertificato` | C - Solo presenza / obbligatorietà / mutua esclusione (`= null or = ""`) | **No** |
| `REG87` | Specificare data del certificato di regolare esecuzione o le modalità del collaudo tecnico amministrativo | 1 | `dataCertificato` | C - Solo presenza / obbligatorietà / mutua esclusione (`= null or = ""`) | **No** |
| `REG88` | Non è stata indicata la data di nomina del collaudatore / Commissione | 1 | `dataNomina` | C - Solo presenza / obbligatorietà / mutua esclusione (`= null or = ""`) | **No** |
| `REG89` | Non è stata indicata la data di inizio delle operazioni di collaudo | 1 | `dataInizio` | C - Solo presenza / obbligatorietà / mutua esclusione (`= null or = ""`) | **No** |
| `REG90` | Data inizio operazioni di collaudo antecedente la data  di nomina della commissione di collaudo/collaudatore | 1 | `dataInizio`, `dataNomina` | B - Confronto relazionale fra due campi data **come stringhe** (`campoA < campoB`) | **No** — nessuna conversione a `date and time`; confronto lessicografico |
| `REG91` | Non è stata indicata la data di redazione del certificato di collaudo | 1 | `dataRedazioneCertificato` | C - Solo presenza / obbligatorietà / mutua esclusione (`= null or = ""`) | **No** |
| `REG92` | Data redazione certificato antecedente la data di inizio operazioni di collaudo | 1 | `dataInizio`, `dataRedazioneCertificato` | B - Confronto relazionale fra due campi data **come stringhe** (`campoA < campoB`) | **No** — nessuna conversione a `date and time`; confronto lessicografico |
| `REG93` | Data delibera di ammissibilità antecedente la data di redazione del certificato di collaudo | 1 | `dataDeliberaAmmissibilita`, `dataRedazioneCertificato` | B - Confronto relazionale fra due campi data **come stringhe** (`campoA < campoB`) | **No** — nessuna conversione a `date and time`; confronto lessicografico |
| `REG95` | Per il tipo di procedura aperta o altra procedura a fase unica il campo scadenzaPresentazioneOfferte è obbligatorio. | 17 | `scadenzaPresentazioneOfferte` | C - Solo presenza / obbligatorietà / mutua esclusione (`= null or = ""`) | **No** |
| `REG96` | E' obbligatorio inserire almeno uno dei due campi tra scadenzaPresentazioneOfferte e scadenzaPresentazioneInvito. | 24 | `scadenzaPresentazioneInvito`, `scadenzaPresentazioneOfferte` | C - Solo presenza / obbligatorietà / mutua esclusione (`= null or = ""`) | **No** |
| `REG97` | Inserire solo uno tra i campi scadenzaPresentazioneOfferte e scadenzaPresentazioneInvito. | 31 | `scadenzaPresentazioneInvito`, `scadenzaPresentazioneOfferte` | C - Solo presenza / obbligatorietà / mutua esclusione (`= null or = ""`) | **No** |
| `REG101` | indicare almeno uno dei campi di cui si richiede la modifica | 1 | `scadenzaPresentazioneOfferte` | C - Solo presenza / obbligatorietà / mutua esclusione (`= null or = ""`) | **No** |
| `REG105` | la data inserita nel campo datiBaseTerminiInvio.scadenzaPresentazioneOfferte non può essere antecedente o uguale ad oggi. | 36 | `scadenzaPresentazioneOfferte` | A - Confronto temporale con conversione: `date and time(substring before(campo,"Z")) <= date and time(today()+"T"+now())` | **No** — il formato è *assunto*: la funzione `substring before(…,"Z")` presuppone il suffisso `Z` |
| `REG106` | la data inserita nel campo datiBaseTerminiInvio.scadenzaPresentazioneInvito non può essere antecedente o uguale ad oggi. | 44 | `scadenzaPresentazioneInvito` | A - Confronto temporale con conversione: `date and time(substring before(campo,"Z")) <= date and time(today()+"T"+now())` | **No** — il formato è *assunto*: la funzione `substring before(…,"Z")` presuppone il suffisso `Z` |
| `REG138` | I campi di tipo testo non possono essere vuoti | 1 | `dataInvito`, `scadenzaPresentazioneOfferte` | C - Solo presenza / obbligatorietà / mutua esclusione (`= null or = ""`) | **No** |

### 4.3 Mappatura regola → file DMN

| Codice | File DMN in cui la regola è presente |
|---|---|
| `REG41` | `S3.dmn` |
| `REG42` | `S3.dmn` |
| `REG57` | `I1.dmn` |
| `REG58` | `I1.dmn` |
| `REG59` | `I1.dmn` |
| `REG60` | `I1.dmn` |
| `REG64` | `SA1.dmn` |
| `REG72` | `SA1.dmn` |
| `REG73` | `ES1.dmn` |
| `REG77` | `SC1.dmn` |
| `REG81` | `CO1.dmn` |
| `REG86` | `CL1.dmn` |
| `REG87` | `CL1.dmn` |
| `REG88` | `CL1.dmn` |
| `REG89` | `CL1.dmn` |
| `REG90` | `CL1.dmn` |
| `REG91` | `CL1.dmn` |
| `REG92` | `CL1.dmn` |
| `REG93` | `CL1.dmn` |
| `REG95` | `P1_16.dmn`, `P1_17.dmn`, `P1_18.dmn`, `P1_20.dmn`, `P1_21.dmn`, `P1_23.dmn`, `P1_24.dmn`, `P2_16.dmn`, `P2_17.dmn`, `P2_18.dmn`, `P2_19.dmn`, `P2_20.dmn`, `P2_21.dmn`, `P2_23.dmn`, `P2_24.dmn`, `P3_4.dmn`, `P3_5.dmn` |
| `REG96` | `P1_16.dmn`, `P1_17.dmn`, `P1_18.dmn`, `P1_19.dmn`, `P1_20.dmn`, `P1_21.dmn`, `P1_23.dmn`, `P1_24.dmn`, `P2_16.dmn`, `P2_17.dmn`, `P2_18.dmn`, `P2_19.dmn`, `P2_20.dmn`, `P2_21.dmn`, `P2_23.dmn`, `P2_24.dmn`, `P3_4.dmn`, `P3_5.dmn`, `P4_1.dmn`, `P4_2.dmn`, `P4_3.dmn`, `P4_4.dmn`, `P4_5.dmn`, `P4_6.dmn` |
| `REG97` | `P1_16.dmn`, `P1_17.dmn`, `P1_18.dmn`, `P1_19.dmn`, `P1_20.dmn`, `P1_21.dmn`, `P1_23.dmn`, `P1_24.dmn`, `P2_16.dmn`, `P2_17.dmn`, `P2_18.dmn`, `P2_19.dmn`, `P2_20.dmn`, `P2_21.dmn`, `P2_23.dmn`, `P2_24.dmn`, `P3_1.dmn`, `P3_2.dmn`, `P3_3.dmn`, `P3_4.dmn`, `P3_5.dmn`, `P4_1.dmn`, `P4_2.dmn`, `P4_3.dmn`, `P4_4.dmn`, `P4_5.dmn`, `P4_6.dmn`, `PL1_7.dmn`, `PL1_9.dmn`, `PL2_7.dmn`, `PL2_9.dmn` |
| `REG101` | `CM3.dmn` |
| `REG105` | `P1_16.dmn`, `P1_17.dmn`, `P1_18.dmn`, `P1_19.dmn`, `P1_20.dmn`, `P1_21.dmn`, `P1_23.dmn`, `P1_24.dmn`, `P2_16.dmn`, `P2_17.dmn`, `P2_18.dmn`, `P2_19.dmn`, `P2_20.dmn`, `P2_21.dmn`, `P2_23.dmn`, `P2_24.dmn`, `P3_1.dmn`, `P3_2.dmn`, `P3_3.dmn`, `P3_4.dmn`, `P3_5.dmn`, `P4_1.dmn`, `P4_2.dmn`, `P4_3.dmn`, `P4_4.dmn`, `P4_5.dmn`, `P4_6.dmn`, `P6_1.dmn`, `P6_2.dmn`, `P7_2.dmn`, `PL1_7.dmn`, `PL1_8.dmn`, `PL1_9.dmn`, `PL2_7.dmn`, `PL2_8.dmn`, `PL2_9.dmn` |
| `REG106` | `P1_10.dmn`, `P1_11.dmn`, `P1_12.dmn`, `P1_13.dmn`, `P1_14.dmn`, `P1_16.dmn`, `P1_17.dmn`, `P1_18.dmn`, `P1_19.dmn`, `P1_20.dmn`, `P1_21.dmn`, `P1_23.dmn`, `P1_24.dmn`, `P2_10.dmn`, `P2_11.dmn`, `P2_12.dmn`, `P2_13.dmn`, `P2_14.dmn`, `P2_16.dmn`, `P2_17.dmn`, `P2_18.dmn`, `P2_19.dmn`, `P2_20.dmn`, `P2_21.dmn`, `P2_23.dmn`, `P2_24.dmn`, `P3_1.dmn`, `P3_2.dmn`, `P3_3.dmn`, `P3_4.dmn`, `P3_5.dmn`, `P4_1.dmn`, `P4_2.dmn`, `P4_3.dmn`, `P4_4.dmn`, `P4_5.dmn`, `P4_6.dmn`, `P7_1_1.dmn`, `P7_1_2.dmn`, `P7_1_3.dmn`, `PL1_7.dmn`, `PL1_9.dmn`, `PL2_7.dmn`, `PL2_9.dmn` |
| `REG138` | `S1_2.dmn` |

### 4.4 Criticità tecniche sulle regole (impatto diretto sul PdL)

**C1 — `REG105`/`REG106` assumono il suffisso `Z` senza verificarlo.** Espressione attuale (identica nei 44 file):

```feel
some lotto in lotti
satisfies lotto.datiBaseTerminiInvio.scadenzaPresentazioneInvito != null
  and lotto.datiBaseTerminiInvio.scadenzaPresentazioneInvito != ""
  and date and time(substring before(lotto.datiBaseTerminiInvio.scadenzaPresentazioneInvito, "Z"))
      <= date and time(string(today()) + "T" + string(time(now().hour, now().minute, now().second)))
```

Se `v` non contiene `Z`, `substring before(v, "Z")` non restituisce un istante utilizzabile: l'engine FEEL di Camunda (`feel-scala`) restituisce la stringa vuota, altre implementazioni `null`. In entrambi i casi `date and time(…)` non produce un valore valido, il confronto degenera a `null` e **la regola non scatta**. Con un input perfettamente legittimo per `format: date-time` come `2026-12-31T10:00:00+01:00`, un termine di scadenza già passato verrebbe quindi accettato silenziosamente: è un falso negativo, non un errore visibile.

**C2 — il confronto con `today()`/`now()` mescola fusi orari.** Il lato sinistro è un istante UTC (privato della `Z`), il lato destro è costruito con l'ora locale del motore di regole. Su un server in `Europe/Rome` lo scarto è di 1–2 ore: una scadenza fissata entro le 2 ore successive alla mezzanotte UTC può essere valutata in modo errato.

**C3 — le 5 regole di classe B confrontano stringhe, non istanti.** `datiContratto.dataScadenza < datiContratto.dataStipula` (REG77) è un confronto lessicografico. È corretto **solo** se entrambi i valori hanno esattamente la stessa forma (stessa precisione, stesso offset). `2026-01-02T00:00:00Z` e `2026-01-01T23:00:00-01:00` sono lo stesso istante ma la stringa `2026-01-02…` risulta maggiore.

**C4 — nessuna regola di validazione sintattica.** Non esiste alcun `matches(campo, "^\d{4}-…")` in tutto il repository di regole. La malformazione di una data non produce mai un errore `REGnn` dedicato: viene intercettata (se lo è) dalla validazione dello schema OpenAPI a monte, che però su `format: date-time` è opzionale in molte librerie.

---

## 5. Formato canonico adottato e centralizzazione

### 5.1 Decisione

Il formato canonico deciso per il PdL prevede l'**offset dal fuso orario UTC in forma esplicita**: `2026-07-15T14:54:28+02:00`.

| Concetto | Tipo | `format` | `pattern` | Esempio |
|---|---|---|---|---|
| Data e ora | `DataOraType` | `date-time` | `^\d{4}-(0[1-9]\|1[0-2])-(0[1-9]\|[12]\d\|3[01])T([01]\d\|2[0-3]):[0-5]\d:[0-5]\d[+-]([01]\d\|2[0-3]):[0-5]\d$` | `2026-07-15T14:54:28+02:00` |
| Sola data | `DataType` | `date` | `^\d{4}-(0[1-9]\|1[0-2])-(0[1-9]\|[12]\d\|3[01])$` | `2026-07-15` |
| Sola ora | `OraType` | `time` | `^([01]\d\|2[0-3]):[0-5]\d:[0-5]\d[+-]([01]\d\|2[0-3]):[0-5]\d$` | `14:54:28+02:00` |

Il `pattern` aggiunge tre vincoli che il solo `format: date-time` non impone:

- **offset numerico obbligatorio** — l'indicatore di zona `Z` **non è ammesso** (per UTC si usa `+00:00`);
- **precisione fissa al secondo** — la frazione di secondo non è ammessa;
- **`T` maiuscola** come separatore.

Su `DataOraType` sono inoltre fissati `minLength: 25` e `maxLength: 25`, che coincidono con la lunghezza esatta della forma ammessa.

> **Conseguenza da non trascurare:** vietando `Z` si rende **certo** il malfunzionamento di `REG105`/`REG106`, che oggi si basano su `substring before(campo, "Z")` (§4.4). Non è più un rischio potenziale ma un effetto atteso: l'aggiornamento di quelle regole nei 44 file DMN è **parte integrante** del PdL e non un intervento opzionale. Vedi §5.6.

### 5.2 Punto unico di definizione

I tre tipi sono definiti in **`docs/modello-dati/modello-dati-tipologiche.yaml`**, in testa a `components.schemas`. Non viene introdotto alcun nuovo file e non viene aggiunto alcun arco al grafo delle dipendenze: `tipologiche.yaml` è **già referenziato da tutti i livelli** ed è la foglia del grafo.

| File | `$ref` YAML in uscita | È referenziato da |
|---|---|---|
| `specifiche-servizi-appalto.yaml` | `npa.yaml` (37), `tipologiche.yaml` (5 + 14 nuovi), `fvoe-fva.yaml` (1) | — |
| `modello-dati-npa.yaml` | 147 schede, `tipologiche.yaml` (19 + 23 nuovi) | specifiche (37), `fvoe-fva.yaml` (2) |
| `modello-dati-schede-dati-comuni.yaml` | `tipologiche.yaml` (69) | 139 schede (872) |
| `modello-dati-tipologiche.yaml` | **nessuno** — foglia del grafo | tutti i livelli |

`tipologiche.yaml` non contiene alcun `$ref` verso altri file YAML: i 30 collegamenti esterni presenti nel documento sono link Markdown ai file `.json` delle code list, all'interno delle `description`, e non riferimenti di schema. Essendo foglia, **nessun riferimento circolare è possibile**, qualunque file la referenzi.

La collocazione è una **deroga semantica** consapevole: `tipologiche.yaml` nasce come documento delle code list e ospita ora anche i tipi di dato base. In cambio è l'unica sede che consente una **sorgente veramente unica**:

- copre i tre livelli senza intermediazioni — specifiche, `npa.yaml` e (nel perimetro B) `dati-comuni.yaml`, che la referenzia già 69 volte;
- copre anche il **ramo FVOE**, che la referenzia 13 volte ed è dove si trovano i 10 `format: datetime` errati;
- consente di centralizzare anche i **2 campi temporali interni a `tipologiche.yaml`** (`TipologicaSchemaEstesoType.dataInizio` e `.dataFine`), che con qualunque altra collocazione avrebbero prodotto un ciclo `tipologiche → X → tipologiche` e sarebbero dovuti restare inline.

La `description` del documento è stata aggiornata per riflettere il nuovo contenuto.

Definizione inserita in `modello-dati-tipologiche.yaml`:

```yaml
components:
  schemas:
    # Tipi base per i valori temporali.
    # Costituiscono l'unica sorgente di definizione del formato dei dati temporali scambiati
    # con la PCP: sono referenziati tramite $ref da tutti i livelli - specifiche dei servizi,
    # modello dati e yaml delle schede - cosi che una modifica apportata qui si propaghi
    # automaticamente su tutti gli oggetti fruitori.
    DataOraType:
      description: |-
        Data e ora secondo ISO 8601 as profiled by RFC 3339, con offset dal fuso orario UTC
        indicato in forma esplicita e precisione al secondo.

        Forma ammessa: `YYYY-MM-DDThh:mm:ss±hh:mm` (es. `2026-07-15T14:54:28+02:00`).

        Non sono ammessi:
        * l'indicatore di zona `Z` in luogo dell'offset numerico (utilizzare `+00:00`);
        * la frazione di secondo (es. `.123`);
        * l'omissione dell'offset, ossia una data e ora priva di fuso orario.
      type: string
      format: date-time
      pattern: '^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])T([01]\d|2[0-3]):[0-5]\d:[0-5]\d[+-]([01]\d|2[0-3]):[0-5]\d$'
      minLength: 25
      maxLength: 25
      example: '2026-07-15T14:54:28+02:00'
```

`DataOraType` risulta così definito **in un solo file dell'intero repository**, con 39 fruitori attuali: 14 nelle specifiche, 23 in `npa.yaml`, 2 interni a `tipologiche.yaml`.

### 5.3 Come referenziarlo — attenzione ai `$ref` con sibling

In **OpenAPI 3.0.x** tutte le keyword sorelle di `$ref` vengono **ignorate**. Questo non funziona:

```yaml
# ERRATO in OpenAPI 3.0.x: description ed example vengono scartati
dataInizio:
  $ref: '.../modello-dati-tipologiche.yaml#/components/schemas/DataOraType'
  description: data inizio incarico soggetto
```

La forma corretta, che conserva la documentazione specifica del campo, usa `allOf`:

```yaml
# CORRETTO
dataInizio:
  description: data inizio incarico soggetto (A date-time specified by ISO 8601 as profiled by RFC 3339, with explicit UTC offset)
  allOf:
    - $ref: 'https://raw.githubusercontent.com/anticorruzione-test/npa/datetimeFormat/docs/modello-dati/modello-dati-tipologiche.yaml#/components/schemas/DataOraType'
```

Nello `schema` di un parametro, invece, la `description` risiede nell'oggetto *parameter* e non nello *schema*: lì il `$ref` nudo è sufficiente e preferibile.

Il segmento branch delle URL (`/datetimeFormat/`) è allineato automaticamente dagli hook in `.githooks`, quindi va scritto nella stessa forma già usata nel repository.

### 5.4 Parametri riusabili per i servizi

`components.parameters` di `specifiche-servizi-appalto.yaml` era vuoto, mentre `dataCreazioneDa`/`dataCreazioneA` risultavano duplicati 4 volte ciascuno. La sezione è stata creata con **10 parametri riusabili**, tutti agganciati a `DataOraType`:

```yaml
components:
  parameters:
    DataCreazioneDa:
      name: dataCreazioneDa
      in: query
      required: false
      description: Estremo inferiore (incluso) dell'intervallo di ricerca sulla data di creazione (A date-time specified by ISO 8601 as profiled by RFC 3339, with explicit UTC offset)
      schema:
        $ref: 'https://raw.githubusercontent.com/anticorruzione-test/npa/datetimeFormat/docs/modello-dati/modello-dati-tipologiche.yaml#/components/schemas/DataOraType'
```

e nelle operazioni:

```yaml
parameters:
  - $ref: '#/components/parameters/DataCreazioneDa'
  - $ref: '#/components/parameters/DataCreazioneA'
```

Effetto: **16 dichiarazioni inline → 10 parametri riusabili** (`DataCreazioneDa/A`, `DataCreazioneAvvisoDa/A`, `DataInizio`, `DataFine`, `DataInizioDa/A`, `DataFineDa/A`).

### 5.5 Propagazione: i punti di intervento

| Punto | Intervento | Occorrenze | Perimetro |
|---|---|---|---|
| 1 | `modello-dati-tipologiche.yaml` — 3 tipi canonici (sorgente unica) + i 2 campi interni | 3 + 2 | A |
| 2 | `modello-dati-npa.yaml` — 23 dichiarazioni inline sostituite da `allOf`/`$ref` | 23 | A |
| 3 | `specifiche-servizi-appalto.yaml` — `components.parameters` + `SoggettoRequest`/`EliminaSoggettoRequest` | 16 + 4 | A |
| 4 | `modello-dati-schede-dati-comuni.yaml` — 16 dichiarazioni condivise ricondotte a `DataOraType` | 16 → propaga su 92 schede | B |
| 5 | Schede con dichiarazione locale (§3.3) | 47 in 21 file | B |
| 6 | Regole DMN — allineamento di `REG105`/`REG106` e dei confronti su stringa | 26 regole in 58 file | C |
| 7 | `modello-dati-fvoe-fva.yaml` (12, di cui 10 con `format: datetime` errato) — referenzia già `tipologiche.yaml` 13 volte | 12 | da valutare |

Completati i punti 1-3, **una modifica al solo `DataOraType` si propaga su tutte le 45 occorrenze del perimetro A**, che è il requisito del PdL per questo livello.

### 5.6 Allineamento delle regole DMN

Con il formato a offset esplicito, i due interventi seguenti diventano **obbligatori** e non migliorativi.

1. **Rendere i confronti indipendenti dal formato**, convertendo entrambi gli operandi invece di manipolare stringhe. Per `REG105`/`REG106` (44 file):

   ```feel
   # ATTUALE - si rompe con l'offset esplicito
   date and time(substring before(campo, "Z"))
     <= date and time(string(today()) + "T" + string(time(now().hour, now().minute, now().second)))

   # PROPOSTO
   date and time(campo) <= now()
   ```

   `date and time(stringa)` accetta direttamente l'ISO 8601 completo con offset e restituisce un istante; `now()` è già un istante con fuso. Sparisce sia la dipendenza dal suffisso `Z` sia lo scarto di fuso descritto in §4.4 (C2).

   Allo stesso modo per le 5 regole di classe B (`REG57`, `REG77`, `REG90`, `REG92`, `REG93`):

   ```feel
   # invece di:  datiContratto.dataScadenza < datiContratto.dataStipula
   date and time(datiContratto.dataScadenza) < date and time(datiContratto.dataStipula)
   ```

2. **Nuova regola trasversale di formato** (proposta `REGxxx`), come rete di sicurezza indipendente dalla validazione di schema:

   ```feel
   campoData != null and campoData != ""
     and not(matches(campoData, "^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])T([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9][+-]([01][0-9]|2[0-3]):[0-5][0-9]$"))
   ```

Va inoltre valutato l'aggiornamento dei `typeRef` degli `inputExpression` da `string` a `dateTime` dove il campo è temporale: renderebbe il tipo esplicito al motore di regole ed eviterebbe alla radice i confronti lessicografici.

### 5.7 Impatti e cautele

- **Il `pattern` è una restrizione, non un'estensione.** Tutti i payload oggi in `Z` — la forma usata da tutti gli `example` preesistenti — diventano invalidi. Serve una verifica sui dati reali in ingresso e una finestra di comunicazione alle Stazioni Appaltanti prima dell'entrata in vigore, con l'indicazione esplicita che `Z` va sostituito da `+00:00`.
- **Sequenza di rilascio.** Le modifiche agli YAML e quelle ai DMN devono andare in esercizio **insieme**: pubblicare il nuovo formato prima di correggere `REG105`/`REG106` disattiverebbe di fatto quei controlli.
- **Valutare se `date-time` sia corretto su tutti i campi.** Per `dataStipula`, `dataAggiudicazione`, `dataNomina`, `dataCollaudo` e simili la semantica è di sola data: `DataType` sarebbe più aderente ed eliminerebbe l'ambiguità sull'ora. È una scelta che va decisa nel PdL perché **modifica il contratto d'interfaccia**.
- **`Sunset` resta in `HTTP-date`**: è imposto da RFC 7231 e non deve confluire nel tipo canonico.
- Correggere in ogni caso, indipendentemente dalla centralizzazione: il tipo orfano `DatiBaseDurataSDAType`, il `pattern` scaduto `^(201[6-9]|202[0-2])$` su `DatiSA00036.annoRiferimento`, i 10 `format: datetime` residui in `modello-dati-fvoe-fva.yaml`.
- Difetto **preesistente** emerso durante la validazione, fuori perimetro: in `modello-dati-fvoe-fva.yaml` gli oggetti `FascicoloType.numDocumenti` e `FascicoloType.numSottoFascicoli` (righe 66-83) dichiarano `minimum: 10` con `default: 0` — il default viola il proprio vincolo e rende `specifiche-servizi-fvoe-fva.yaml` non valida per OpenAPI 3.0.3. Le rispettive `description` riportano inoltre «numero della pagina da visualizzare» al posto del conteggio documenti. L'errore è identico su `HEAD` e non è introdotto da questo intervento.
- **`tipologiche.yaml` va trattata come dipendenza critica**: ospitando ora la sorgente unica del formato temporale, una modifica errata a quel file si propaga su tutti i livelli e su entrambi i rami (appalti e FVOE). Va inclusa fra i file soggetti a revisione obbligatoria in fase di merge.

---

## 6. Stato di avanzamento — perimetro A completato

### 6.1 Modifiche applicate

| File | Modifica | Occorrenze |
|---|---|---|
| `docs/modello-dati/modello-dati-tipologiche.yaml` | Creati `DataOraType`, `DataType`, `OraType` in testa a `components.schemas` — sorgente unica del formato | 3 definizioni |
| | `TipologicaSchemaEstesoType.dataInizio`/`.dataFine` → `allOf`/`$ref` interno | 2 |
| | Corretto il refuso `tipoDocumento.jsoN` nel link alla code list | 1 |
| `docs/modello-dati/modello-dati-npa.yaml` | 23 dichiarazioni inline → `allOf`/`$ref` a `DataOraType`, descrizioni uniformate | 23 |
| `docs/specifiche-interfacce/specifiche-servizi-appalto.yaml` | Creata `components.parameters` con 10 parametri riusabili | +10 |
| | Rimosse le dichiarazioni inline duplicate dei parametri temporali | −16 |
| | `SoggettoRequest.dataInizio`/`.dataFine`, `EliminaSoggettoRequest.dataInizio`/`.dataFine` → `allOf`/`$ref` | 4 |
| | Corretto il refuso `RF333` nella `description` (era riga 893) | 1 |
| `CHANGELOG.md` | Aggiunta la voce di rilascio del 29/07/2026 | — |

Dopo l'intervento in nessuno dei due file modificati resta un `format: date-time` dichiarato inline. Gli `example` puntuali sui campi temporali sono stati rimossi: l'unico esempio è ora quello di `DataOraType`, in un solo punto e nella forma prevista da OpenAPI 3.0.3 (dentro l'oggetto `schema`).

### 6.2 Verifiche eseguite

| Verifica | Esito |
|---|---|
| Parsing YAML dei tre file | OK |
| Validazione OpenAPI 3.0.3 di `specifiche-servizi-appalto.yaml` con tutti i `$ref` risolti localmente (843 riferimenti unici) | **VALID** |
| `$ref` non risolti a partire dalle specifiche | **0** |
| I 10 parametri di `components.parameters` sono tutti referenziati e tutti puntano a `DataOraType`; nessuno inutilizzato | OK |
| Coerenza `nome componente` ↔ `name` del parametro, `in: query`, `required: false` | OK 10/10 |
| `pattern` — accetta `+02:00`, `-05:00`, `+00:00`; rifiuta `Z`, frazioni di secondo, offset assente, sola data, mese 13, ora 24 | OK 10/10 casi |
| `example` dei tre tipi validati contro il rispettivo `pattern`/`minLength`/`maxLength` | OK 3/3 |
| Occorrenze residue del refuso `RF333` | **0** |
| Fine riga CRLF del working tree preservati | OK |

Il vincolo «Almeno un filtro di ricerca deve essere valorizzato», presente nelle description dei parametri di `/ricerca-piano` ora sostituiti, era già riportato nella `description` dell'operazione `idPianoRicerca`: nessuna informazione è andata persa nell'accorpamento.

### 6.3 Perimetro B completato

| File | Modifica | Occorrenze |
|---|---|---|
| `docs/modello-dati/schede/modello-dati-schede-dati-comuni.yaml` | 16 dichiarazioni condivise → `allOf`/`$ref` a `DataOraType` | 16 |
| 21 file di scheda (`A3.3`, `AC1`, `AD4`, `CBI`, `CL1`, `CM3`, `CO1`, `CO2`, `COC`, `CS1`, `ES1`, `I1`, `IR1`, `RI1`, `S1_2`, `S2`, `S2R`, `SA1`, `SC1`, `SO1`, `SQ1`) | 47 dichiarazioni locali → `allOf`/`$ref` a `DataOraType` | 47 |

Nessun nuovo arco nel grafo delle dipendenze: `dati-comuni.yaml` referenziava già `tipologiche.yaml` 69 volte, e le 21 schede la referenziano ora direttamente — `tipologiche.yaml` è foglia, quindi il riferimento diretto riduce di un salto la catena di risoluzione senza introdurre cicli.

Le `description` dei singoli campi sono state lasciate invariate: nelle schede non contenevano il richiamo al formato, che è ora documentato una sola volta nella `description` di `DataOraType`.

Dopo l'intervento **nessuna scheda dichiara più un `format` temporale inline**: in `docs/modello-dati/schede/` le occorrenze di `format: date-time` sono passate da 63 a 0.

### 6.4 Stato complessivo della centralizzazione

| Perimetro | Occorrenze ricondotte a `DataOraType` | Stato |
|---|---|---|
| A — specifiche dei servizi | 14 (10 parametri riusabili + 4 campi body) | **completato** |
| A — `modello-dati-npa.yaml` | 23 | **completato** |
| A — `modello-dati-tipologiche.yaml` (campi interni) | 2 | **completato** |
| B — `modello-dati-schede-dati-comuni.yaml` | 16 | **completato** |
| B — 21 file di scheda | 47 | **completato** |
| **Totale** | **102** | |
| C — regole DMN | 26 regole in 58 file | **da fare** |
| Ramo FVOE | 12 (di cui 10 con `format: datetime` errato) | da valutare |

### 6.5 Verifiche eseguite sul perimetro B

| Verifica | Esito |
|---|---|
| Precondizione sui 63 blocchi da convertire (`type: string` immediatamente sopra `format: date-time`, stessa indentazione; nessuna `description` con block scalar adiacente) | OK 63/63 |
| Parsing YAML di tutti i file del modello dati e delle specifiche | OK 154/154 |
| Validazione OpenAPI 3.0.3 di `specifiche-servizi-appalto.yaml` con tutti i `$ref` risolti localmente | **VALID** |
| `$ref` non risolti a partire dalle specifiche (840 riferimenti unici) | **0** |
| `format` temporali inline residui in `docs/modello-dati/schede/` | **0** |
| Definizioni di `DataOraType` nel repository | **1** |
| Dereferenziazione end-to-end su `CL1`, `SC1`, `I1`, `dati-comuni` — `pattern`, `minLength`/`maxLength`, `example` correttamente ereditati | OK |
| Fine riga CRLF del working tree preservati | OK |

### 6.6 Attenzione ai merge: dichiarazioni che rientrerebbero

Il perimetro B è stato applicato allo stato di `datetimeFormat`. Altri branch contengono ancora dichiarazioni temporali inline che un merge reintrodurrebbe, e che andranno ricondotte a `DataOraType` in fase di integrazione.

| Branch | File di scheda con `format: date-time` inline | Dichiarazioni | Delta rispetto a `datetimeFormat` |
|---|---|---|---|
| `datetimeFormat` (prima dell'intervento) | 22 | 63 | — |
| `appalti` | 23 | 66 | `modello-dati-schede-ID.yaml` (3) |
| `schedaID` | 24 | 67 | `modello-dati-schede-ID.yaml` (3), `modello-dati-schede-C7_3.yaml` (1) |

Due precisazioni utili all'integrazione:

- `modello-dati-schede-C7_3.yaml` **non esiste** su `datetimeFormat`: è una scheda introdotta su `schedaID`, con 1 campo temporale inline.
- `IntegrazioneDatiEsecuzioneType` è **orfano su `appalti`** (dichiarato ma non referenziato, quindi non raggiungibile da `SchedaIDType`), mentre su `schedaID` risulta **referenziato**. Se è la versione di `schedaID` a confluire, quei 3 campi diventano raggiungibili e vanno trattati.

In totale, un merge di `schedaID` porterebbe **4 dichiarazioni inline in 2 file** da ricondurre a `DataOraType`.

### 6.7 Prossimi passi

1. **Perimetro C** — riscrittura di `REG105`/`REG106` nei 44 file DMN e delle 5 regole di confronto su stringa (§5.6), da rilasciare **contestualmente** agli YAML.
2. **Da valutare** — `modello-dati-fvoe-fva.yaml`: 12 campi temporali, di cui 10 con `format: datetime` non valido. Il file referenzia già `tipologiche.yaml` 13 volte, quindi la centralizzazione non richiederebbe nuovi archi.
3. **Aperto dal PdL** — decidere se alcuni campi debbano passare da `DataOraType` a `DataType` (sola data): vedi §5.7.

---

## Appendice — metodo di analisi

I `$ref` verso `https://raw.githubusercontent.com/anticorruzione-test/npa/datetimeFormat/docs/modello-dati/…` sono stati risolti sui corrispondenti file locali del working tree, con rilevazione dei cicli. I conteggi per scheda derivano dalla risoluzione transitiva a partire dagli schemi radice `Scheda…Type` di ciascun file. **0 riferimenti non risolti** su 148 file di schede. I DMN sono stati analizzati via parsing XML degli `inputEntry`/`description` di ogni `<rule>`; la classificazione A/B/C deriva dal riconoscimento delle funzioni FEEL e dei confronti relazionali fra due campi temporali.
