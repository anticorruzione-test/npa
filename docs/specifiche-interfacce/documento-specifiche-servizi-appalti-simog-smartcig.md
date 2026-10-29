# 1 Definizioni, acronimi e riferimenti
  ## 1.1 Definizioni e acronimi

  | Termine/Acronimo | Descrizione |
  | ------------- | ------------- |
  | ANAC  | Autorità Nazionale Anticorruzione |
  | AgID  | Agenzia per l'Italia Digitale |
  | PCP  | Piattaforma Contratti Pubblici |
  | SA  | Stazione Appaltante |
  | RP  | Responsabile del progetto |
  | CIG  | Codice Identificativo Gara |
  | SIMOG  | Sistema ANAC per l'erogazione del CIG e il monitoraggio del ciclo di vita dei contratti, i cui servizi sono concentrati nella PCP |
  | SmartCIG  | Sistema ANAC per l'erogazione del CIG, i cui servizi sono concentrati nella PCP |

  ## 1.2 Riferimenti
   - [Documento di specifiche dei servizi NPA](documento-specifiche-servizi-npa.md) (servizi ordinari oggetto di certificazione AgID)
   - [Specifiche di interfaccia YAML](specifiche-servizi-appalto.yaml) (operazioni con tag `gestioneAppalti`)
   - [AgID - Certificazione componenti piattaforme](https://www.agid.gov.it/it/piattaforme/procurement/certificazione-componenti-piattaforme)

# 2 Obiettivo del documento
Il presente documento descrive, in modo autonomo e separato rispetto al [documento di specifiche dei servizi NPA](documento-specifiche-servizi-npa.md), le specifiche di interfaccia dei servizi "Appalti SIMOG e SMARTCIG" (contesto gestioneAppalti).

Tali servizi sono richiamabili dalla SA per la consultazione degli appalti presenti nei sistemi SIMOG e SmartCIG e per la migrazione delle relative procedure verso la PCP.

# 3 Perimetro e distinzione dai servizi ordinari
I servizi descritti nel presente documento non rientrano tra i servizi ordinari della piattaforma oggetto di certificazione AgID. I servizi ordinari restano descritti nel [documento di specifiche dei servizi NPA](documento-specifiche-servizi-npa.md).

| Elemento | Servizi ordinari della piattaforma | Servizi Appalti SIMOG e SMARTCIG |
|-------------|-------------|-------------|
| Documento di riferimento | [documento-specifiche-servizi-npa.md](documento-specifiche-servizi-npa.md) | Presente documento |
| Contesti | gestioneUtenti, pianificazioneAppalto, comunicaAppalto, pubblicaAvviso, comunicaPostPubblicazione, FVA, FVOE, gestioneElenchi, gestioneContratto, codeList, Servizi comuni | gestioneAppalti |
| Oggetto di certificazione AgID | Sì | No |
| Specifiche di interfaccia (YAML) | [specifiche-servizi-appalto.yaml](specifiche-servizi-appalto.yaml), [specifiche-servizi-fvoe-fva.yaml](specifiche-servizi-fvoe-fva.yaml) | [specifiche-servizi-appalto.yaml](specifiche-servizi-appalto.yaml) (tag `gestioneAppalti`) |

# 4 Servizi e ruoli
Nella tabella seguente si riporta l'elenco dei servizi Appalti SIMOG e SMARTCIG richiamabili dalle Stazioni Appaltanti:

| Contesto | Servizio | Metodo | Modalità | operationId | Ruolo |
|-------------|-------------|-------------|-------------|-------------|-------------|
|**gestioneAppalti**| appalti/simog | GET | SINCRONO | consultaAppaltiSimog | RP |
|**gestioneAppalti**| appalti/smartcig | GET | SINCRONO | consultaAppaltiSmartCig | RP |
|**gestioneAppalti**| appalti/migraProcedura | POST | ASINCRONO | migraProcedura | RP |
|**gestioneAppalti**| appalti/migrazione/{numeroGara} | GET | SINCRONO | getMigrazione | RP |
|**gestioneAppalti**| appalti/verificaRup | GET | SINCRONO | verificaRup | RP |
|**gestioneAppalti**| appalti/verificaIdoneita | GET | SINCRONO | verificaIdoneita | RP |
|**gestioneAppalti**| modifica-scheda-simog | POST | SINCRONO | idModificaSchedaSimog | RP |

# 5 Contesto gestioneAppalti
In questo contesto rientrano i servizi richiamabili dalla SA per la consultazione degli appalti presenti nei sistemi SIMOG e SmartCIG e per la migrazione delle relative procedure verso la PCP.

**Descrizione dei servizi**

I servizi che possono essere invocati in questo contesto sono i seguenti:
- appalti/simog: servizio che consente la consultazione della lista degli appalti presenti nel sistema SIMOG di competenza della SA che sta operando;
- appalti/smartcig: servizio che consente la consultazione della lista degli appalti presenti nel sistema SmartCIG di competenza della SA che sta operando;
- appalti/migraProcedura: servizio che consente la migrazione di una procedura di appalto, identificata dal numero gara, dal sistema sorgente (SIMOG o SmartCIG) verso la PCP;
- appalti/migrazione/{numeroGara}: servizio che consente la consultazione dello stato di migrazione di una procedura SIMOG/SmartCIG verso la PCP, identificata per numero gara;
- appalti/verificaRup: servizio che verifica se l’utente risulta tra gli incaricati della procedura SIMOG con ruolo RUP/RP;
- appalti/verificaIdoneita: servizio che verifica se la procedura SIMOG è perfezionata e quindi migrabile in PCP;
- modifica-scheda-simog: servizio che consente la modifica di una scheda dati per un appalto migrato da SIMOG.

# 6 Modello dati
Il modello dati dei servizi Appalti SIMOG e SMARTCIG è descritto nelle seguenti cartelle:
- Schede SIMOG: [schede_SIMOG](../modello-dati/schede_SIMOG/)
- Schede SMARTCIG: [schede_SMARTCIG](../modello-dati/schede_SMARTCIG/)
- Regole SIMOG (DMN): [regole_SIMOG](../modello-dati/regole_SIMOG/)
- Regole SMARTCIG (DMN): [regole_SMARTCIG](../modello-dati/regole_SMARTCIG/)
- Tipologiche SIMOG: [tipologiche_SIMOG](../modello-dati/tipologiche_SIMOG/)
- Tipologiche SMARTCIG: [tipologiche_SMARTCIG](../modello-dati/tipologiche_SMARTCIG/)

# 7 Interfaccia servizi
Le interfacce dei servizi sono definite secondo gli standard di interoperabilità ModI, come descritto nel capitolo [Interfaccia servizi](documento-specifiche-servizi-npa.md#16interfaccia-servizi) del documento di specifiche dei servizi NPA.

Le operazioni sono definite nel file [specifiche-servizi-appalto.yaml](specifiche-servizi-appalto.yaml) con il tag `gestioneAppalti`.

# 8 Contesto di sicurezza
Ai servizi Appalti SIMOG e SMARTCIG si applica il medesimo schema di sicurezza dei servizi ordinari (`apiKeyAuth`, definito nel file YAML).
Per i dettagli si rimanda al capitolo [Contesto di sicurezza](documento-specifiche-servizi-npa.md#17contesto-di-sicurezza) del documento di specifiche dei servizi NPA.
