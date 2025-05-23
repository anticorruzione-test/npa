
## Introduzione

Con la nuova operazione esposta /richiedi-documenti la SA potrà richiedere la documentazione verso gli enti certificanti.
In base alla tipologia del documento l'ente certificante potrebbe richiedere delle informazioni aggiuntive non presenti nell'anagrafica di ANAC.
Nel presente documento vengono riportati i tipi documento e il rispettivo modello dati che riporta tali informazioni aggiuntive che la SA deve popolare per una corretta elaborazione della richiesta.

## Tipi Documenti Richiedibili

Vengono riportati per ogni tipologia di documento richiedibile all'ente certificante il modello dati che arricchisce le informazioni, dove non presente, le informazioni implicitamente passate nella richiesta (Esempio Denominazione OE, Sede Legale, ecc) sono esaustive per l'eleborazione della richiesta per l'ente cerificante.

Tutti i modelli dati sono presenti nel file [modello-dati-fvoe-fva.yaml](https://github.com/anticorruzione-test/npa/tree/main/docs/modello-dati/modello-dati-fvoe-fva.yaml)


°Note: La lista verrà aggiornata in base alle nuove integrazioni 

| `Data Esercizio`  | `Codice Documento`  | `Descrizione Documento` | `Modello Dati` | `Ente Certificante` |
| :-------------: | :---------------: | :-------------------- | ----------------- | ----------------- | 
| `23/01/2024`    | `00033` | `Estratto del casellario informatico ANAC`  | `-` | `Anac` |
| `23/01/2024`    | `00004` | `Certificato integrale del casellario giudiziario`  | `DatiSA_00004` | `Min.Giustizia` |
| `23/01/2024`    | `00021` | `Comunicazione regolarità fiscale` | `-` | `Agenzia delle Entrate` |
| `23/01/2024`    | `00034` | `Visura al registo delle imprese`   | `-` | `Unioncamere` |
| `23/01/2024`    | `00005` | `Anagrafe delle sanzioni amministrative dipendenti da reato`  | `DatiSA_00020` | `Min. Giustizia` |
| `23/01/2024`    | `00038` | `DURC inarcassa professionista`  | `-` | `Inarcassa` |
| `23/01/2024`    | `00039` | `DURC inarcassa impresa`  | `-` | `Inarcassa` |
| `23/01/2024`    | `00035` | `Dati reddituali società di persone`  | `DatiSA_00036` | `Agenzia delle Entrate` |
| `23/01/2024`    | `00036` | `Consistenza media personale`  | `DatiSA_00047` | `Inps` |
| `23/01/2024`    | `00037` | `Costo complessivo personale`  | `DatiSA_00048` | `Inps` |
| `23/01/2024`    | `00001` | `Comunicazione antimafia`  | `DatiSA_00050` | `Min. Interno` |
| `23/01/2024`    | `00041` | `Dati reddituali impresa individuale` | `DatiSA_00036`| `Agenzia delle Entrate` |
| `23/01/2024`    | `00899` | `Documento Generico OE`  | `DatiSA_00899` | `Operatore Econimico` |
| `16/09/2024`    | `00042` | `Carichi Fiscali Pendenti` | `-` | `Agenzia delle Entrate` |
| `07/11/2024`    | `00007` | `Iscrizione WhiteList antimafia` | `-` | `Min. Interno` |
| `02/08/2024`    | `00008` | `DURC emesso in corso di validità` | `-` | `Inps` |
| `25/09/2024`    | `00010` | `Verifica esistenza prospetto informativo disabili` | `-` | `Ministero del Lavoro` |
| `25/09/2024`    | `00011` | `Verifica esistenza rapporto parità di genere` | `-` | `Ministero del Lavoro` |
| `In Progress`   | `00009` | `Sanzioni Ispettorato del lavoro` | `-` | `Isp. Naz. Lavoro` |

## Casi di test

Vengono qui riportati i casi di test in ambiente PDND di collaudo degli enti certificanti che li hanno messi a disposizione


| `Codice Documento`  | `Descrizione Documento` | `Ente Certificante` | `Caso di test` |
| :-------------: | :---------------: | :-------------------- | ----------------- | 
| `00004` | `Certificato integrale del casellario giudiziario`  | `Min.Giustizia` | `1) Cognome: CESARE	Nome: AUGUSTO		Nato il 02/04/1957 a ROMA (ITALIA) CF: CSRGST57D02H501Q, 2) NERONE POMPEO, 01/01/1977, ROMA (ITALIA), NRNPMP77A01H501U, 3) MARCANTONIO GIULIO, 01/05/1971, ROMA (ITALIA), MRCGLI71E01H501B 4) AGRIPPA	MENENIO, 05/01/1968, ROMA (ITALIA), GRPMNN68A05H501H` |
| `00010` | `Verifica esistenza prospetto informativo disabili` | `Ministero del Lavoro` | `Codice fiscale 48863580097` |
| `00011` | `Verifica esistenza rapporto parità di genere` | `Ministero del Lavoro` | `Codice fiscale 48863580097` |
| `00008` | `DURC emesso in corso di validità` | `Inps` | `Codici fiscali 00385090485, 05836271212, SNCFNC59A06F284S` |
