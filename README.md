<p align="center">
  <img src="assets/icon/icon.png" width="112" alt="Icona EasyReader">
</p>

<h1 align="center">EasyReader</h1>

<p align="center">
  Un lettore di ebook pensato attorno a un'unica idea: il <strong>benessere di lettura</strong>.<br>
  Filtri di comfort visivo personalizzabili, librerie organizzate, statistiche di lettura.
</p>

<p align="center">
  <img alt="Flutter" src="https://img.shields.io/badge/Flutter-3.44-02569B?logo=flutter&logoColor=white">
  <img alt="Piattaforme" src="https://img.shields.io/badge/piattaforme-Android%20%7C%20macOS-informational">
  <img alt="Stato" src="https://img.shields.io/badge/stato-in%20sviluppo-yellow">
</p>

---

## Cos'è

EasyReader è un lettore EPUB/PDF con un focus preciso: rendere la lettura più
comoda per gli occhi tramite filtri di pagina regolabili in tempo reale,
invece di limitarsi alla solita modalità chiara/scura. È un progetto
personale, sviluppato in Flutter per restare multipiattaforma fin dalla
base architetturale.

## Funzionalità

**Lettura**
- Formati supportati: **EPUB** e **PDF**
- Filtri di pagina in tempo reale: colore di sfondo, overlay colorato
  (utile anche per esigenze di comfort visivo come la dislessia), luminosità,
  filtro carta con texture, dimensione del testo
- Barra di avanzamento persistente con percentuale letta e, per i PDF,
  pagina corrente su totale
- Ripresa automatica dal punto esatto in cui si era interrotta la lettura

**Libreria**
- Griglia a colonne adattive in base allo spazio disponibile (2 su
  smartphone, di più su una finestra desktop più larga)
- Copertine automatiche: estratte dal manifest per gli EPUB, renderizzate
  dalla prima pagina per i PDF
- Librerie personalizzate per organizzare i libri, ciascuna con nome,
  colore e icona a scelta
- Rinomina, sposta in libreria, elimina — tutto da un tocco prolungato
- Import diretto da file, oppure **condividendo** un EPUB/PDF da un'altra
  app o aprendolo direttamente con EasyReader

**Statistiche**
- Per ogni libro: tempo di lettura, numero di sessioni, percentuale,
  data di aggiunta e ultima lettura
- Vista d'insieme: libri in libreria, completati, in lettura, tempo di
  lettura totale, libri più letti

## Stack tecnico

| Livello | Scelta |
|---|---|
| UI | Flutter, [Riverpod](https://riverpod.dev) |
| Persistenza | [drift](https://drift.simonbinder.eu) (SQLite) |
| Motore EPUB | [flutter_epub_viewer](https://pub.dev/packages/flutter_epub_viewer) |
| Motore PDF | [syncfusion_flutter_pdfviewer](https://pub.dev/packages/syncfusion_flutter_pdfviewer) + [pdfx](https://pub.dev/packages/pdfx) (copertine) |
| Copertine EPUB | [archive](https://pub.dev/packages/archive) + [xml](https://pub.dev/packages/xml) (lettura del manifest) |
| Condivisione | [receive_sharing_intent](https://pub.dev/packages/receive_sharing_intent) |

Architettura a tre livelli (`domain` → `data` → `presentation`), con i
repository dietro interfacce per tenere la logica applicativa indipendente
dal motore di rendering o dal database.

```
lib/
├── domain/            # entità, interfacce dei repository, use case
├── data/              # implementazioni drift, estrazione copertine, filtri
└── presentation/       # schermate e widget, organizzati per funzionalità
```

## Piattaforme

Sviluppato Android-first, con macOS come seconda piattaforma già
funzionante grazie alla natura multipiattaforma di Flutter — l'unico punto
che richiede un adattamento nativo è la conversione di formati futuri come
MOBI/AZW3.

## Sviluppo

```bash
flutter pub get
dart run build_runner build   # genera il codice drift
```

Build:

```bash
flutter build apk --debug     # Android
flutter build macos --debug   # macOS (richiede Xcode e CocoaPods)
```

Verifica:

```bash
flutter analyze
flutter test
```

## Roadmap

- [ ] Supporto MOBI, AZW3, FB2 (tramite conversione)
- [ ] Temperatura colore e contrasto tra i filtri
- [ ] Font dedicati alla leggibilità (es. dislessia)
- [ ] Promemoria pausa in lettura
- [ ] Windows e Linux

## Licenza

Progetto personale, non ancora distribuito. Nessuna licenza pubblica al
momento.
