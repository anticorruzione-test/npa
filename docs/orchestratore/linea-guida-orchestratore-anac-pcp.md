# Linea Guida Orchestratore ANAC PCP

> Guida di riferimento per la lettura, verifica e aggiornamento dell'orchestratore delle schede ANAC. È pensata per essere fruibile senza conoscenze tecniche specifiche: descrive, colonna per colonna, il significato dei valori inseriti in ciascuna cella e il comportamento che il sistema ne deriva.

---

## Indice

1. [Introduzione](#1-introduzione)
2. [Come è organizzato l'orchestratore](#2-come-è-organizzato-lorchestratore)
3. [Come il sistema legge una riga](#3-come-il-sistema-legge-una-riga)
4. [Convenzioni e simboli utilizzati](#4-convenzioni-e-simboli-utilizzati)
5. [Descrizione delle colonne](#5-descrizione-delle-colonne)
   - 5.1 [Identificazione e anagrafica della scheda](#51-identificazione-e-anagrafica-della-scheda)
   - 5.2 [Contesto procedurale: fase, settore e regime](#52-contesto-procedurale-fase-settore-e-regime)
   - 5.3 [Contenuto documentale e pubblicazione](#53-contenuto-documentale-e-pubblicazione)
   - 5.4 [Contesto d'invio della scheda e attribuzione CIG](#54-contesto-dinvio-della-scheda-e-attribuzione-cig)
   - 5.5 [Transizioni tra schede e flusso della procedura](#55-transizioni-tra-schede-e-flusso-della-procedura)
   - 5.6 [Evoluzione degli stati e correlazioni tra schede](#56-evoluzione-degli-stati-e-correlazioni-tra-schede)
   - 5.7 [Validità temporale, annullamento e rettifica](#57-validità-temporale-annullamento-e-rettifica)
   - 5.8 [Sottofasi della fase di Esecuzione](#58-sottofasi-della-fase-di-esecuzione)
6. [Esempio di lettura di una riga completa](#6-esempio-di-lettura-di-una-riga-completa)
7. [Punti di attenzione nella compilazione](#7-punti-di-attenzione-nella-compilazione)

---

## 1. Introduzione

### Scopo del documento
Questa guida descrive, colonna per colonna, come il sistema interpreta i valori presenti nelle celle di ciascuna riga dell'orchestratore. L'obiettivo è rendere trasparente il comportamento del sistema rispetto a ogni valore inserito, in modo da poter leggere, verificare o aggiornare l'orchestratore con piena consapevolezza degli effetti.

### A chi si rivolge
La guida è pensata per l'utente che ha il compito di leggere, verificare o aggiornare l'orchestratore e desidera comprendere che effetto produce ogni singolo valore. Non presuppone conoscenze tecniche specifiche.

### Contenuto in sintesi
- Ogni **riga** dell'orchestratore rappresenta una **scheda ANAC**.
- Ogni **colonna** rappresenta un attributo o una regola che governa il comportamento della scheda all'interno del ciclo di vita di un appalto, tra cui:
  - identificazione della scheda,
  - pubblicazione,
  - transizioni ammesse verso altre schede,
  - appartenenza ai flussi,
  - evoluzione degli stati di appalto, lotto e contratto,
  - validità temporale,
  - annullabilità e rettificabilità.

---

## 2. Come è organizzato l'orchestratore

### Struttura del foglio
- Le **prime due righe** contengono l'intestazione delle colonne e una descrizione estesa di ciascuna di esse: non rappresentano schede.
- **Dalla terza riga in poi**, ogni riga descrive una singola scheda ANAC, identificata dal suo codice.

### Ruolo delle colonne
Ogni colonna esprime una specifica caratteristica della scheda che il sistema utilizza per decidere:
- se e come la scheda può essere inviata,
- quali schede possono seguirla o precederla,
- a quali flussi appartiene,
- come deve essere composto il suo contenuto (eForm, ESPD, anacForm),
- come evolvono gli stati di appalto, lotto e contratto,
- in quale finestra temporale la scheda è valida.

---

## 3. Come il sistema legge una riga

Per ciascuna riga (scheda), il sistema esegue i seguenti passi:

1. Legge il **codice della scheda** e le informazioni anagrafiche.
2. Determina il **contesto procedurale** (fase, settore, regime).
3. Interpreta i **vincoli di contenuto** (eForm, ESPD, anacForm).
4. Costruisce il **grafo delle transizioni ammesse** (schede successive, flussi di appartenenza).
5. Applica le **regole di stato** (nuovo stato di appalto, lotto, contratto).
6. Considera la **validità temporale** della scheda e le sue proprietà di lifecycle (annullabilità, rettificabilità).

> Le sezioni successive spiegano, colonna per colonna, come ogni valore viene interpretato e che effetto produce.

---

## 4. Convenzioni e simboli utilizzati

Queste convenzioni si applicano trasversalmente a tutte le colonne, salvo dove diversamente specificato nella descrizione della singola colonna.

### Righe da considerare
- Le prime due righe descrivono l'orchestratore stesso e non vengono considerate schede.
- Una riga viene interpretata come scheda solo se il codice scheda è valorizzato e se sono definite una o più schede successive.

### Normalizzazione dei codici scheda
- I punti presenti nei codici vengono trasformati in underscore. Esempio: `A1.29` diventa `A1_29`.
- La normalizzazione si applica a tutte le colonne che contengono codici scheda (codice principale, schede successive, schede correlate).

### Valori booleani (colonne SI/NO)
- `SI` viene interpretato come vero.
- `NO` viene interpretato come falso.
- Cella vuota o valore diverso da `SI` / `NO` viene interpretato come non specificato (comportamento di default definito per la specifica colonna).

### Elenchi multi-valore
Nelle colonne che ammettono più valori (per esempio schede successive, flussi di appartenenza, regole, codici correlati) i valori sono **separati da virgola**. Gli spazi in eccesso vengono rimossi.

### Legenda dei valori speciali

| Simbolo | Significato |
|---|---|
| `*` (asterisco) | Rappresenta l'insieme completo dei valori possibili nel dominio della colonna (per esempio "tutte le schede note" o "tutti i flussi noti"). |
| `!` (punto esclamativo) come prefisso | Esclude dall'insieme il valore indicato subito dopo (per esempio `!110` esclude il flusso 110). |
| `STATO FINALE` | Nella colonna delle schede successive indica che la scheda chiude il percorso. |

---

## 5. Descrizione delle colonne

Le colonne dell'orchestratore sono raggruppate per funzione. Ogni sottosezione descrive un gruppo omogeneo, spiegando cosa rappresenta il valore inserito nella cella e come il sistema lo utilizza durante l'elaborazione della scheda.

### 5.1 Identificazione e anagrafica della scheda

Le colonne di questo gruppo descrivono la scheda dal punto di vista informativo. Sono i valori che permettono di riconoscere univocamente la scheda e di documentarne il contenuto.

| Colonna | Come viene interpretato il valore | Effetto sul sistema |
|---|---|---|
| **Cod Area Funzionale** | Codice testuale dell'area funzionale a cui appartiene la scheda. | Classificazione della scheda per area; utilizzato nelle viste di consultazione. |
| **Cod Famiglie di funzionalità** | Codice testuale della famiglia di funzionalità. | Classificazione della scheda per famiglia; utilizzato nelle viste di consultazione. |
| **evento** | Descrizione dell'evento che genera l'invio della scheda. | Metadato descrittivo associato alla scheda. |
| **schedaCodice** | Identificativo univoco della scheda. | Chiave con cui la scheda viene ricercata e referenziata in tutti i processi (schede successive, correlate, verifiche di coerenza). |
| **schedaVersione** | Versione della scheda. Identifica il corrispettivo modello dati YAML da utilizzare per l'invio a sistema dei dati della scheda. | Consente la coesistenza di più versioni della stessa scheda. La versione viene utilizzata, in concomitanza con l'intervallo di validità temporale definito da `dataInizio` e `dataFine`, per stabilire se una scheda può essere inviata a sistema alla data corrente: una versione è valida se la data di invio ricade nell'intervallo di validità associato. |
| **schedaDescrizione** | Descrizione estesa del contenuto della scheda. | Etichetta mostrata nelle viste di consultazione e nel percorso guidato. |
| **schedaNormativa** | Riferimenti normativi che regolano la scheda. | Metadato informativo di natura normativa. |

### 5.2 Contesto procedurale: fase, settore e regime

Queste colonne inquadrano la scheda all'interno dell'appalto: a quale fase appartiene, a quale settore e regime si applica.

| Colonna | Come viene interpretato il valore | Effetto sul sistema |
|---|---|---|
| **Settore-regime** | Testo che identifica il settore (ordinari, speciali, difesa e sicurezza, concessioni) e il regime (ordinario, alleggerito) del contratto. | Determina l'ambito procedurale della scheda; utilizzato per filtri, percorso guidato e coerenza normativa. |
| **fase** | Uno o più identificativi di fase separati da virgola. Il valore rappresenta la fase (o le fasi) in cui la scheda può essere collocata all'interno della procedura. | La fase è un'informazione di consultazione: la fase corrente di una procedura viene determinata in base alla scheda più avanzata inviata. Se una scheda dichiara più fasi, può essere inviata in ognuna di esse purché consentito dalla sequenza di schede ammesse (vedi `schedaSuccessiva`). |

#### Fasi della procedura e loro ordinamento
Le fasi previste, elencate nell'ordine logico progressivo, sono:

1. Pianificazione
2. Affidamento
3. Pubblicazione
4. Aggiudicazione
5. Esecuzione

> **Nota — Le fasi non sono strettamente sequenziali.**
> Una procedura può saltare una o più fasi in funzione del proprio profilo. Alcuni esempi tipici:
> - Un ciclo può essere `2 - 4 - 5` (senza Pianificazione né Pubblicazione).
> - Gli Affidamenti Diretti non attraversano mai la fase `1` (Pianificazione) né la fase `3` (Pubblicazione).
> - Le pubblicazioni tipicamente seguono il ciclo `3 - 4 - 5`, ma alcune si fermano alla fase `3`.
> - Le pianificazioni possono seguire il ciclo `1 - 3 - 4 - 5`, ma non attraversano mai la fase `2` (Affidamento).
> - Il ciclo non inizia necessariamente dalla fase `1`: può iniziare dalla `2` o dalla `3`, e non è garantito che termini con la `5`.

#### Sottofasi della fase di Esecuzione
La fase `5 - Esecuzione` viene ulteriormente suddivisa nelle seguenti sottofasi, rappresentate nella colonna `sottofaseEsecuzione`:

- `1.0` Anticipata
- `1.1` Sottoscrizione
- `2` Inizio Lavori
- `2.1` Avanzamento
- `3` Conclusione
- `4` Collaudo
- `5` Conclusione Finale

> **Nota — I codici numerici sono solo indicatori di livello.**
> Le sottofasi sono identificate esclusivamente dalle rispettive etichette testuali. I codici `1.0`, `1.1`, `2`, `2.1`, ecc. indicati come prefisso rappresentano il livello/sottolivello nella gerarchia e non costituiscono l'identificativo della sottofase.

**Prescrizioni sull'ordine delle sottofasi di Esecuzione:**
- `1.0 Anticipata` e `1.1 Sottoscrizione` sono mutuamente esclusive.
- Dopo `1.0 Anticipata` o `1.1 Sottoscrizione` segue necessariamente `2 Inizio Lavori`.
- Dopo `2 Inizio Lavori` può seguire `2.1 Avanzamento` oppure direttamente `3 Conclusione`.
- Dopo `3 Conclusione` deve seguire `4 Collaudo`.
- Dopo `4 Collaudo` deve seguire `5 Conclusione Finale`.

### 5.3 Contenuto documentale e pubblicazione

Le colonne di questo gruppo definiscono come la scheda si deve presentare in termini di contenuti pubblicabili (eForm per TED, ESPD, anacForm) e su quali canali di pubblicazione operare.

| Colonna | Come viene interpretato il valore | Effetto sul sistema |
|---|---|---|
| **pubblicazioneTED** | `SI` = la scheda deve essere pubblicata su TED e la eForm è obbligatoria. `NO` = la scheda non va su TED e la eForm non deve essere presente. Vuoto = pubblicazione facoltativa: se la eForm è presente viene inoltrata, ma non è obbligatoria. | Governa la presenza obbligatoria / facoltativa / vietata della eForm nel contenuto della scheda. |
| **eForm** | Elenco dei subtype eForm ammessi per la scheda. Ogni voce può essere un semplice codice numerico oppure la coppia `codice:vincoloFlusso`. Il valore `nonPrevista` indica che nessun subtype è associato. | Limita quali subtype eForm sono accettati nel contenuto della scheda. Se è presente un vincolo di flusso, la eForm è ammessa solo se coerente con il codice indicato. |
| **includeESPD** | `SI` = l'ESPD-request è obbligatorio nel contenuto della scheda. `NO` / vuoto = non obbligatorio; se presente comunque, viene validato. | Controlla presenza e validità del documento ESPD nel contenuto. |
| **includeAnacForm** | `SI` = l'anacForm deve essere presente nel contenuto della scheda. `NO` / vuoto = non richiesto. | Controlla la presenza obbligatoria dell'anacForm nel contenuto. |
| **pubblicazioneNazionale** | `SI` / `NO` = indica se la scheda può essere pubblicata sulla piattaforma di pubblicità legale nazionale. | Attributo esposto e utilizzato per orientare la pubblicazione nazionale. |

### 5.4 Contesto d'invio della scheda e attribuzione CIG

Queste colonne determinano il contesto di servizi attraverso cui la scheda può essere inviata e gestita, e se la conferma della scheda comporta l'attribuzione del CIG ai lotti.

Le colonne `schedaPreinformazione`, `schedaDiIndizione` e `schedaGestioneElenco` associano ciascuna la scheda a uno specifico contesto d'invio. Quando nessuna di esse è valorizzata a `SI`, la scheda viene inviata e gestita attraverso i servizi di `comunicaPostPubblicazione`.

| Colonna | Come viene interpretato il valore | Effetto sul sistema |
|---|---|---|
| **schedaPreinformazione** | `SI` = la scheda appartiene al contesto di Pianificazione. `NO` / vuoto = non appartiene a questo contesto. | La scheda può essere inviata e gestita esclusivamente attraverso i servizi del contesto `pianificazioneAppalto`. |
| **schedaDiIndizione** | `SI` = la scheda appartiene al contesto di Appalto. `NO` / vuoto = non appartiene a questo contesto. | La scheda può essere inviata e gestita esclusivamente attraverso i servizi del contesto `comunicaAppalto`. |
| **schedaGestioneElenco** | `SI` = la scheda appartiene al contesto di Gestione Elenchi Operatori Economici. `NO` / vuoto = non appartiene a questo contesto. | La scheda può essere inviata e gestita esclusivamente attraverso i servizi del contesto `gestioneElenchi`. |
| **attribuisceCIG** | `SI` = alla conferma della scheda il sistema attribuisce il CIG ai lotti. `NO` / vuoto = nessuna attribuzione automatica di CIG. | Determina l'attivazione dell'attribuzione CIG lato sistema. |

> **Contesto d'invio di default.**
> Tutte le schede per cui `schedaPreinformazione`, `schedaDiIndizione` e `schedaGestioneElenco` risultano non valorizzate (o valorizzate a `NO`) vengono inviate e gestite tramite i servizi di `comunicaPostPubblicazione`.

### 5.5 Transizioni tra schede e flusso della procedura

Queste colonne descrivono il grafo delle transizioni: quali schede possono seguire quella corrente, a quali flussi appartiene, quali regole (tabelle decisionali) si applicano.

| Colonna | Come viene interpretato il valore | Effetto sul sistema |
|---|---|---|
| **schedaSuccessiva** | Elenco dei codici delle schede ammesse come successive rispetto alla scheda corrente, separati da virgola. Può contenere `*` per indicare tutte le schede note. Il valore `STATO FINALE` indica che il percorso si chiude e la scheda corrente non ammette schede successive. | Definisce quali schede possono essere inviate dopo la scheda corrente. Se la scheda in ingresso non è presente in questo elenco, il sistema la rifiuta. |
| **flussoAppartenenza** | Valore numerico che identifica il flusso di appartenenza della scheda. Le schede di preinformazione e di indizione appartengono a un singolo flusso, ad eccezione di alcune schede di indizione che possono presentare doppio flusso di appartenenza (caso in cui la scheda di indizione debba seguire una precedente scheda di preinformazione). Sono supportati anche `*` (tutti i flussi noti) e il prefisso `!` per escludere specifici flussi (per esempio `!110` esclude il flusso 110). | Il sistema verifica che la scheda in ingresso e la scheda precedente condividano almeno un flusso di appartenenza: se non c'è intersezione la scheda viene rifiutata, garantendo la coerenza di flusso lungo l'intera sequenza della procedura. |
| **flussoUscita** | Codice del flusso che la scheda determina per l'appalto una volta ricevuta. | Attributo informativo del cambio di flusso associato alla scheda. |
| **regole** | Elenco dei codici di regola (tabelle decisionali) applicabili alla scheda, separati da virgola. | Il sistema espone tali codici come tabelle decisionali associate alla scheda per la valutazione di condizioni di ammissibilità. |

**Riepilogo dei valori speciali per queste colonne:**
- `*` sostituisce l'insieme completo dei valori del dominio (tutte le schede o tutti i flussi noti).
- `!X` rimuove il valore `X` dall'insieme risultante.
- `STATO FINALE` (colonna schede successive) segnala la chiusura del percorso.

#### Logica di sequenza delle schede in una procedura
1. La sequenza di schede di una procedura ha origine da una scheda di preinformazione e/o da una scheda di indizione.
2. Ogni scheda successiva può essere inviata solo se il suo codice risulta ammesso nella colonna `schedaSuccessiva` della scheda immediatamente precedente della stessa procedura.
3. Ogni scheda inviata all'interno della procedura deve appartenere allo stesso flusso di appartenenza della scheda iniziale (preinformazione o indizione) che ha originato la sequenza: in altri termini, l'intera sequenza di una procedura deve essere coerente in termini di `flussoAppartenenza`.
4. Le schede di indizione che ammettono doppio flusso di appartenenza sono quelle che possono a loro volta essere precedute da una scheda di preinformazione: in questo caso il flusso della sequenza è determinato dalla scheda di preinformazione iniziale, e la scheda di indizione deve condividere quel flusso.

### 5.6 Evoluzione degli stati e correlazioni tra schede

Le colonne di questo gruppo indicano come cambia lo stato di appalto, lotto e contratto in seguito alla ricezione della scheda, e quali altre schede sono ad essa funzionalmente correlate.

| Colonna | Come viene interpretato il valore | Effetto sul sistema |
|---|---|---|
| **nuovoStatoAppalto** | Codice testuale dello stato in cui transita l'appalto a valle della pubblicazione della scheda. | Determina il nuovo stato dell'appalto; il testo viene normalizzato in maiuscolo. |
| **nuovoStatoLotto** | Codice testuale dello stato in cui transita il lotto alla conferma della scheda o alla sua avvenuta pubblicazione. | Determina il nuovo stato del lotto; il testo viene normalizzato in maiuscolo. |
| **nuovoStatoContratto** | Codice testuale dello stato in cui transita il contratto alla conferma della scheda o alla sua avvenuta pubblicazione. | Determina il nuovo stato del contratto; il testo viene normalizzato in maiuscolo. |
| **codiciSchedeCorrelate** | Elenco dei codici delle schede che devono essere referenziate dalla scheda in invio. Il riferimento va valorizzato nel campo `idScheda` del modello dati YAML della scheda che si sta inviando. | Il sistema verifica, all'atto dell'invio, che nel payload YAML della scheda sia presente il riferimento (tramite `idScheda`) alla scheda correlata attesa nell'ambito della stessa procedura. Se il riferimento è assente o non corrisponde a una scheda ammessa, la scheda in invio viene rifiutata. |

#### Esempi di applicazione di `codiciSchedeCorrelate`
- Schede `ES1` (`ES1_1`, `ES1_2`): devono necessariamente referenziare la scheda `RSU1` della stessa procedura, valorizzando il campo `idScheda` del proprio YAML con l'identificativo della `RSU1` già inviata; a seguire, la scheda `CS1` deve referenziare la scheda `ES1`.
- Scheda `I1_1`: deve referenziare la scheda `SAE`; a sua volta la scheda `SC1_1` deve referenziare la `I1_1`.
- Schede `SQ1` e `RI1` dopo una `SO1`: la scheda `SO1` attiva una "Sospensione", a cui può seguire una "Ripresa" `RI1` oppure, in alternativa, la sequenza `SQ1` (superamento quarto) e poi `RI1`. Quindi:
  - la scheda `SQ1` deve referenziare la scheda `SO1`;
  - la scheda `RI1` può referenziare una sola tra `SQ1` e `SO1`, in base al percorso effettivamente seguito.

### 5.7 Validità temporale, annullamento e rettifica

Le colonne di questo gruppo regolano la finestra temporale in cui la scheda è valida e le sue proprietà di annullabilità e rettificabilità.

| Colonna | Come viene interpretato il valore | Effetto sul sistema |
|---|---|---|
| **dataInizio** | Data di inizio validità della scheda. Deve essere una cella in formato data. | La scheda è selezionabile solo se la data corrente è successiva o uguale a `dataInizio`. |
| **dataFine** | Data di fine validità della scheda. Deve essere una cella in formato data. | La scheda è selezionabile solo se la data corrente è precedente o uguale a `dataFine`. |
| **schedaAnnullabile** | `SI` = la scheda può essere candidata all'annullamento tramite il servizio `rollback-scheda` del contesto `serviziComuni`, a condizione che siano soddisfatti anche i requisiti generali di annullabilità (vedi nota successiva). `NO` / vuoto = la scheda non è mai annullabile. | Abilita l'operazione di rollback della scheda solo se, oltre al valore `SI`, sono verificati gli altri requisiti previsti dal sistema. |
| **servizioPostAnnullamento** | Campo ad uso esclusivamente interno di sistema. Il valore riportato identifica il servizio e/o l'operazione da eseguire al termine dell'operazione di annullamento scheda invocata tramite `rollback-scheda`. Cella vuota = nessuna invocazione post-annullamento. *Esempio d'uso:* valorizzare un servizio ad-hoc quando si vuole poter annullare schede che prevedono pubblicazione e, contestualmente, dover inoltrare la comunicazione (su TED o su PVL) di un avviso che notifichi la cancellazione della scheda su PCP. | Al termine del rollback, il sistema invoca il servizio / operazione indicato per eseguire le azioni post-annullamento previste (per esempio la notifica di cancellazione su canali di pubblicazione esterni). |
| **schedaRettificabile** | `SI` = la scheda può essere candidata alla rettifica tramite il servizio di rettifica-avviso, a condizione che siano soddisfatti anche i requisiti generali di rettificabilità (vedi nota successiva). `NO` / vuoto = la scheda non è mai rettificabile. | Abilita la rettifica della scheda solo se, oltre al valore `SI`, sono verificati gli altri requisiti previsti dal sistema. |

#### Note sulla validità temporale
- Se `dataInizio` o `dataFine` non sono valorizzate, il sistema applica una finestra di default molto ampia in modo che la scheda risulti sempre valida (equivalente a: nessun vincolo temporale).
- Solo la scheda valida alla data corrente viene restituita nelle interrogazioni dell'orchestratore per un dato codice.

#### Condizioni per l'annullamento (rollback) di una scheda
L'operazione di annullamento di una scheda, invocabile tramite il servizio `rollback-scheda` del contesto `serviziComuni`, è consentita dal sistema solo se sono verificate contemporaneamente tutte le seguenti condizioni:

1. La colonna `schedaAnnullabile` è valorizzata a `SI`.
2. La scheda oggetto di annullamento è l'ultima scheda inviata a sistema per la procedura di riferimento (non possono essere annullate schede intermedie).
3. Non risultano già effettuate due operazioni di rollback consecutive: non è ammesso un terzo rollback consecutivo sulla stessa procedura.

> Se anche una sola di queste condizioni non è verificata, il sistema non ammette l'operazione di rollback sulla scheda.

#### Condizioni per la rettifica di una scheda
La rettifica di una scheda è consentita dal sistema solo se sono verificate contemporaneamente tutte le seguenti condizioni:

1. La scheda prevede pubblicazione: è quindi ammessa alla rettifica ogni scheda per cui è prevista una forma di pubblicazione (colonna `pubblicazioneTED` valorizzata a `SI` oppure colonna `pubblicazioneNazionale` valorizzata a `SI`).
2. La colonna `schedaRettificabile` è valorizzata a `SI`.
3. La procedura si trova ancora nella stessa fase (colonna `fase`) di appartenenza della scheda che si intende rettificare. Se la procedura ha nel frattempo superato quella fase (perché è stata inviata una scheda appartenente a una fase successiva), la rettifica non è più consentita.

> Se anche una sola di queste condizioni non è verificata, il sistema non ammette l'operazione di rettifica sulla scheda.

### 5.8 Sottofasi della fase di Esecuzione

Le colonne di questo gruppo descrivono la suddivisione della fase `5 - Esecuzione` in sottofasi e i controlli da eseguire per il loro avvio. L'elenco completo delle sottofasi e le regole di successione sono descritti in [Sottofasi della fase di Esecuzione](#sottofasi-della-fase-di-esecuzione) all'interno della sezione 5.2.

| Colonna | Come viene interpretato il valore | Effetto sul sistema |
|---|---|---|
| **sottofaseEsecuzione** | Etichetta testuale della sottofase di Esecuzione a cui la scheda appartiene, riferita all'intera fase di Esecuzione. Valori possibili: `Anticipata`, `Sottoscrizione`, `Inizio Lavori`, `Avanzamento`, `Conclusione`, `Collaudo`, `Conclusione Finale`. Può contenere più etichette separate da virgola quando la scheda copre più sottofasi. Se la scheda ha `avvioSottofase` = `SI`, questa colonna deve contenere una sola etichetta. | Classifica la scheda all'interno della o delle sottofasi della fase di Esecuzione. |
| **avvioSottofase** | `SI` = la scheda è abilitata ad avviare la sottofase di Esecuzione indicata nella colonna `sottofaseEsecuzione`: è cioè una delle schede (talvolta l'unica) che possono determinare il passaggio a quella sottofase. `NO` / vuoto = la scheda non avvia alcuna sottofase. | Il sistema, in occasione di un cambio di sottofase di Esecuzione, ammette il passaggio solo se la scheda ricevuta ha `avvioSottofase` = `SI` e la sottofase indicata in `sottofaseEsecuzione` corrisponde alla nuova sottofase attesa. Se più schede sono abilitate ad avviare la stessa sottofase, è sufficiente inviarne una tra quelle ammesse. |
| **codiciSchedaDaverificare** | Elenco dei codici delle schede che identificano sottoprocessi la cui corretta chiusura deve essere verificata prima di poter inviare la scheda corrente. La valorizzazione è tipicamente prevista per la scheda di sottofase `Collaudo` e per alcune schede di sottofase `Conclusione`. Ogni codice indicato rappresenta un sottoprocesso che, se aperto / inviato a sistema per la procedura, deve risultare correttamente concluso (chiuso) attraverso l'invio delle relative schede correlate secondo quanto definito nella colonna `codiciSchedeCorrelate`. | All'atto dell'invio della scheda, il sistema verifica per ciascun codice indicato che il corrispondente sottoprocesso risulti chiuso; se anche uno solo dei sottoprocessi risulta aperto, la scheda in ingresso viene rifiutata. |

#### Note sull'avvio delle sottofasi di Esecuzione
- Le colonne `sottofaseEsecuzione` e `avvioSottofase` vanno lette in coppia: il cambio di sottofase avviene tramite la scheda che, con `avvioSottofase` = `SI`, dichiara in `sottofaseEsecuzione` la sottofase da avviare.
- Una stessa sottofase può essere avviata da più schede: in tal caso, per effettuare il cambio, deve essere inviata una sola scheda tra quelle abilitate.
- Se una scheda ha `avvioSottofase` = `SI`, la colonna `sottofaseEsecuzione` deve contenere un solo valore (una scheda "di avvio" non può essere associata a più sottofasi).

#### Logica di verifica di `codiciSchedaDaverificare`
Per ciascun codice indicato in `codiciSchedaDaverificare` (chiamiamolo `X`), il sistema controlla che l'eventuale sottoprocesso attivato da `X` sia stato correttamente chiuso. La verifica di chiusura si esegue navigando la catena delle correlazioni definite dalla colonna `codiciSchedeCorrelate`, procedendo a ritroso e in avanti a partire dalla scheda `X`:

1. Il sistema individua le schede che riferiscono `X` come correlata (cioè le schede che hanno `X` in `codiciSchedeCorrelate`) e verifica se una di queste risulta presente a sistema per la procedura in corso.
2. Se ne trova una, prosegue individuando le schede che riferiscono a loro volta quella scheda come correlata, e ripete il controllo di presenza.
3. La catena viene percorsa fino a raggiungere la scheda di chiusura attesa per il sottoprocesso: solo in quel momento il sottoprocesso è considerato chiuso.

**Esempio applicato all'invio della scheda `CL1`:**
- La colonna `codiciSchedaDaverificare` di `CL1` contiene, tra gli altri, il codice `RSU1`.
- Il sistema verifica se per la procedura in corso è stata inviata una scheda che referenzia `RSU1` come correlata (secondo `codiciSchedeCorrelate`): nell'esempio, `ES1_1` o `ES1_2`.
- Se una tra `ES1_1` / `ES1_2` risulta presente a sistema, il sistema verifica quali schede referenziano a loro volta quella scheda come correlata (per esempio `CS1` che referenzia `ES1_1`) e ne controlla la presenza per la procedura.
- Solo quando tutti i passaggi della catena risultano presenti e coerenti, il sottoprocesso avviato da `RSU1` è considerato chiuso e la scheda `CL1` può essere inviata.

---

## 6. Esempio di lettura di una riga completa

Consideriamo una scheda ipotetica con codice `P1_10`:

| Colonna | Valore | Significato |
|---|---|---|
| `schedaCodice` | `P1_10` | Il sistema registra la scheda con questo identificativo (i punti sarebbero stati convertiti in underscore). |
| `schedaDiIndizione` | `SI` | La scheda istanzia una nuova procedura, quindi non deve avere una scheda precedente. |
| `pubblicazioneTED` + `eForm` | `SI` + `10` | La scheda deve essere pubblicata su TED, la eForm è obbligatoria e il subtype ammesso è `10`. |
| `schedaSuccessiva` | `S1, A1_29, ID` | Dopo la scheda `P1_10` sono accettate solo `S1`, `A1_29` e `ID`. |
| `flussoAppartenenza` | `110` | La scheda appartiene al flusso `110`; ogni scheda successiva dovrà condividere questo flusso. |
| `nuovoStatoAppalto` | `PUBB` | La ricezione della scheda porta l'appalto nello stato `PUBB`. |
| `dataInizio` + `dataFine` | valorizzate | La scheda è utilizzabile solo se la data corrente rientra nell'intervallo. |

---

## 7. Punti di attenzione nella compilazione

- Usare esclusivamente `SI` o `NO` (o cella vuota) nelle colonne booleane per evitare interpretazioni ambigue.
- Fare attenzione all'uso di `*` e del prefisso `!`: possono ampliare o restringere significativamente le transizioni ammesse.
- Assicurarsi che i codici scheda referenziati (schede successive, correlate, da verificare) esistano effettivamente come righe dell'orchestratore.
- Verificare la coerenza tra `flussoAppartenenza` delle schede consecutive: schede senza flussi comuni non possono essere concatenate.
- Valorizzare `dataInizio` e `dataFine` con celle in formato data; testi liberi non vengono interpretati come date.
- Ricordare che valori come `nuovoStatoAppalto` / `nuovoStatoLotto` / `nuovoStatoContratto` vengono normalizzati in maiuscolo dal sistema: differenze di formattazione non producono effetti.
