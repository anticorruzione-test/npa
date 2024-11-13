# SDK 1.10.0 Release Notes

This release of the SDK does not contain any backwards incompatible changes: software that was able to use version 1.9.0 should also be able to use this version.

!!!!
As new rules were added, a notice that was valid with SDK 1.9.x might not be valid with this version.
!!!!

## Additional information

---

## Updated metadata content

---

### Schema, nodes, fields and notice type definitions

#### Schemas

#### Fields
* Updated fields and nodes properties to allow for multiple direct award justifications.
   * il bt-136 in dati comuni è già ripetibile

#### Notice type definitions

---

### Rules

* Reactivated various conditional rules related to: Framework agreements, GPA coverage, change-related fields, business registration, title and description of groups of lots, classification type, additional nature, address components, group framework values, EU Funds, and vehicles.
    * review delle regole di tutti i bt presenti nei dati comuni
* Added rules to check that the procedure type (BT-105-Procedure) is consistent with the notice subtype.
    * impatto sul modello dati - rimuovere il campo dove non è più richiesto e aggiungerlo dove è stato inserito. fare poi check scheda per scheda con ANAC.
* Added rules on various fields to check that their value is unique in the notice, in particular for identifiers.
    * verificare se inserire gli stessi controlli su lotIdentifier (unico id del ted presente nei dati comuni. verificare impatto su notice id)
* Updated rules on accelerated procedure (BT-106-Procedure and BT-105-Procedure).
    * review delle regole di tutti i bt presenti nei dati comuni
* Corrected the rule on CPV codes for subsidized contracts.
    * review delle regole di tutti i bt presenti nei dati comuni
* Reduced the minimum period between Notice Dispatch Date (BT-05-notice) and Preferred Publication Date (BT-738-notice) from 2 to 0 days.
    * possibile impatto di business
* Modified the rule on dispatch date to use "Notice Dispatch Date eSender" (BT-803) when it exists, and Dispatch Date (BT-05) otherwise.
    * possibile impatto di business
* Modified rules on Duration fields (BT-36-Lot, BT-536-Lot, BT-537-Lot, BT-538-Lot) to be less restrictive and allow for various combinations without absolutely requiring the Duration Start Date (BT-536-Lot). 
    * review delle regole di tutti i bt presenti nei dati comuni
* Added "Notice Dispatch Date eSender" to the display for all notice subtypes.
    * possibile impatto di business

# SDK 1.11.0 Release Notes

---

## Additional information

---

## Updated metadata content

---

### Schema, nodes, fields and notice type definitions

#### Schemas

#### Fields

#### Notice type definitions

* The node ND-Modification was corrected to not be repeatable.
    * indagare meglio ma credo non ci sia impatto
* The notice type definitions for subtypes 14 and 15 were updated for the fields related to the second stage invitation.
    * indagare

### Rules

* Have an interdependency between BT-26 and BT-262 for the main classification.
    * review delle regole di tutti i bt presenti nei dati comuni
* Update condition on rule BR-BT-00630-0150 to allow for change publication after Deadline Receipt Expression (BT-630) has passed.
    * review delle regole di tutti i bt presenti nei dati comuni. verificare impatto sulle regole di business relative alla data di pubblicazione
* Allow Winner Decision (BT-1451) to be on the same day the notice is submitted (BT-05) and the contract is signed (BT-145).
    * review delle regole di tutti i bt presenti nei dati comuni
* Allow for 2nd stage Business Terms for Notice Subtype 14 instead of 15 and activate 2nd stage conditional rules.
    * possibile impatto di business
* Align the BT-106-Procedure conditional Rules with the agreed upon table for procedure accelerated.
    * review delle regole di tutti i bt presenti nei dati comuni
* Update the Sections/Parts reference options in Contract Modification and Changed Sections.
    * verificare possibile impatto sulle schede M
* Update message for Schematron rule on dispatch date.
    * verificare se aggiornare i messaggi sulle date.
* Align the rules expressions for identifiers uniqueness (does not affect actual validation).
    * verificare se c'è impatto su lotIdentifier (unico id del ted presente nei dati comuni. verificare impatto su notice id)
* Remove manual Schematron that make request to old TED website API.
    * possibile impatto di business
* Make BT-131 optional for Notice Subtype 8.
    * capire se renderlo opzionale anche nel sottosoglia del PL2_8, campo datiBaseTerminiInvio.oraScadenzaPresentazioneOfferta oppure se introdurre una regola di obbligatorietà sulla scheda PL1_8
* Allow "cancel-intent" to be used also once submission deadline has passed.
    * possibile impatto di business
* Remove the constraint on DPS that enforced the Participation Request Deadline to match the end of the DPS.
    * SDA -- indagare
* Reject values with leading or trailing whitespace for some fields.
    * verificare se inserire lo stesso controllo sui dati comuni
* Forbid DPS termination (BT-119-LotResult) when there is no DPS.
    * SDA -- aggiungere questa regola se non presente
* Update rule BR-BT-00127-0100 on Future Notice (BT-127) to allow for change publication even when the Future Notice date has passed.
    * BT-127 non in dati comuni ma verificare possibile impatto di business
* Make Accessibility justification (BT-755) required when "accessibility criteria not considered and intended to be used by natural person".
    * review delle regole
* Remove constraints on Framework Agreement values for Contract Modification notices.
    * nn credo ci sia impatto - verificare 
* Make Tender Value, Highest & Lowest (BT-720, BT-711, BT-710) forbidden when competition ongoing; Tender Value (BT-720) mandatory if no FA or contracts within a FA; FA Re-calculated Max Value or Re-estimated Value (BT-709, BT-660) mandatory for a FA.
    * review delle regole

# SDK 1.12.0 Release Notes

---

## Additional information

---

## Updated metadata content

---

### Schema, nodes, fields and notice type definitions

#### Schemas

#### Fields

* Defined field for the attribute listName of BT-23-Lot.
    * verificare

#### Notice type definitions

* The Fields related to the CVD in the lot were added to the contract modification notice types.
    * verificare se dato di interesse da inserire nei dati comuni delle schede M
* The structure of the "planned duration" group in the PIN-only parts has been aligned with the one in the lots.
    * approfondire
* The node ND-ProcedureProcurementScope has been added to all the subtypes where it was missing (1, 2, 3, 4, 5, 6, 7, 8, 9, 15, 16, CEI, T01, T02), to facilitate the identification of rules related to the fields (issue #870).

### Rules

* Updated rules for Exclusion & Selection Criteria.
    * review delle regole
* Updated contexts for rules on: BT-135-Procedure, BT-109-Lot, BT-111-Lot, BT-113-Lot, BT-106-Procedure, BT-773-Tender, and OPT-321-Tender. This is to ensure that mandatory rules trigger also in absence of the parent element.
    * review delle regole
* Updated context for rules on BT-76-Lot and BT-771-Lot.
* Defined rule to check for Tender - Result consistency.
    * review delle regole
* Removed ineffective rules trying to fetch other notices.
    * review delle regole
* Restriction of mandatory rules for BT-543-LotsGroup and BT-539-LotsGroup to CVS.
    * review delle regole
* Updated rules that still referred to "eforms-xxx" lists.

### Codelists

* **cpv** (cpv.gc)
    - INFO
        - modificate e/o aggiunte label in lingua croata (hrv)
* **esitoProcedura** (winner-selection-status.gc)
    - INFO
        - modificate label in lingua francese (fra) per le occorrenze *clos-nw*, *open-nw*
* **giustificazioniAggiudicazioneDiretta** (direct-award-justification.gc)
    - INFO
        - modificata swe_label su *artistic*, *below-thres*, *closure*, *crisis*, *dir24-list*, *dir81-annexii*, *energy-supply*, *exclusive*, *existing*, *in-house*, *irregular*, *rd*, *repetition*, *technical*, *unsuitable*, *ugency*, *water-purch*
    - MODIFICHE PCP
        - modificate TUTTE le label su *below-thres-sme*, *int-oper*, *tra-ser* --> modificare le label *it* e *en* su collection *tipologica*
        - aggiunte occorrenze *char-imp*, *exc-circ-rail*, *sim-infra* --> da inserire nella collection *tipologica*
        - rimossa occorrenza *rail* --> da rimuovere dalla collection *tipologica*
* **tipoProcedura** (procurement-procedure-type.gc)
    - MODIFICHE PCP
        - modificate TUTTE le label su *comp-tend* --> modificare le label *it* e *en* su collection *tipologica*
        - aggiunta occorrenzea *exp-int-rail* --> da inserire nella collection *tipologica*
