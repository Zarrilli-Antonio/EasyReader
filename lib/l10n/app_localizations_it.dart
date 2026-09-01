// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String updateAvailable(Object version) {
    return 'Versione $version disponibile';
  }

  @override
  String get download => 'Scarica';

  @override
  String get unsupportedFormatMessage =>
      'Formato non supportato: solo EPUB e PDF';

  @override
  String importedBooksMessage(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count libri importati dalla condivisione',
      one: 'Libro importato dalla condivisione',
    );
    return '$_temp0';
  }

  @override
  String get myLibrary => 'La mia libreria';

  @override
  String get readingStats => 'Statistiche di lettura';

  @override
  String get settings => 'Impostazioni';

  @override
  String libraryErrorMessage(Object error) {
    return 'Errore: $error';
  }

  @override
  String get importCancelledMessage =>
      'Importazione annullata o formato non ancora supportato';

  @override
  String get importBook => 'Importa libro';

  @override
  String get rename => 'Rinomina';

  @override
  String get moveToShelf => 'Sposta in libreria';

  @override
  String get statsAction => 'Statistiche';

  @override
  String get delete => 'Elimina';

  @override
  String get noShelf => 'Nessuna libreria';

  @override
  String get noShelfCreatedHint =>
      'Nessuna libreria creata. Creane una dalla riga in alto.';

  @override
  String get deleteBookTitle => 'Eliminare il libro?';

  @override
  String deleteBookMessage(Object title) {
    return '\"$title\" verrà rimosso dalla libreria insieme al file copiato sul dispositivo.';
  }

  @override
  String get cancel => 'Annulla';

  @override
  String get emptyShelfTitle => 'Questa libreria è vuota';

  @override
  String get emptyLibraryTitle => 'Nessun libro ancora';

  @override
  String get emptyShelfHint =>
      'Tieni premuto su un libro in \"Tutti i libri\" per spostarlo qui.';

  @override
  String get emptyLibraryHint =>
      'Importa un file EPUB o PDF per iniziare a leggere.';

  @override
  String get allBooks => 'Tutti i libri';

  @override
  String get newShelf => 'Nuova libreria';

  @override
  String get editShelf => 'Modifica libreria';

  @override
  String get deleteShelf => 'Elimina libreria';

  @override
  String get deleteShelfTitle => 'Eliminare la libreria?';

  @override
  String deleteShelfMessage(Object name) {
    return '\"$name\" verrà eliminata. I libri al suo interno restano nella libreria generale, senza essere cancellati.';
  }

  @override
  String get shelfNameLabel => 'Nome';

  @override
  String get colorLabel => 'Colore';

  @override
  String get iconLabel => 'Icona';

  @override
  String get save => 'Salva';

  @override
  String get createShelf => 'Crea libreria';

  @override
  String get renameBookTitle => 'Rinomina libro';

  @override
  String get statLabelRead => 'Letto';

  @override
  String get statLabelAddedOn => 'Aggiunto il';

  @override
  String get statLabelLastRead => 'Ultima lettura';

  @override
  String get never => 'Mai';

  @override
  String get booksInLibrary => 'Libri in libreria';

  @override
  String get completed => 'Completati';

  @override
  String get inProgress => 'In lettura';

  @override
  String get searchInBook => 'Cerca nel libro';

  @override
  String get readingFilters => 'Filtri di lettura';

  @override
  String filtersErrorMessage(Object error) {
    return 'Errore filtri: $error';
  }

  @override
  String get searchInBookHint => 'Cerca nel libro…';

  @override
  String get searchInBookByChapterHint => 'Cerca nel libro (per capitolo)…';

  @override
  String get noResults => 'Nessun risultato';

  @override
  String chapterFallback(Object number) {
    return 'Capitolo $number';
  }

  @override
  String get stopReadAloud => 'Interrompi lettura vocale';

  @override
  String get readAloud => 'Leggi ad alta voce';

  @override
  String get cbrUnsupportedOnPlatform =>
      'Formato non supportato su questa piattaforma';

  @override
  String get cannotOpenComic => 'Impossibile aprire questo fumetto';

  @override
  String get noPagesFound => 'Nessuna pagina trovata';

  @override
  String pageProgress(Object page, Object total, Object percent) {
    return 'Pagina $page di $total · $percent%';
  }

  @override
  String textSizeLabel(Object size) {
    return 'Dimensione testo · $size';
  }

  @override
  String lineHeightLabel(Object value) {
    return 'Interlinea · $value';
  }

  @override
  String brightnessLabel(Object value) {
    return 'Luminosità · $value';
  }

  @override
  String contrastLabel(Object value) {
    return 'Contrasto · $value';
  }

  @override
  String colorTemperatureLabel(Object state) {
    return 'Temperatura colore · $state';
  }

  @override
  String get warm => 'caldo';

  @override
  String get cool => 'freddo';

  @override
  String get neutral => 'neutro';

  @override
  String get appearance => 'Aspetto';

  @override
  String get eReaderMode => 'Modalità e-reader';

  @override
  String get eReaderModeSubtitle =>
      'Tutta l\'app diventa in scala di grigi, come lo schermo di un e-reader';

  @override
  String get advancedFilters => 'Filtri avanzati';

  @override
  String get advancedFiltersHint =>
      'Per la regolazione rapida mentre leggi, usa gli slider nel pannello filtri del libro.';

  @override
  String get pageColorLabel => 'Colore pagina (EPUB)';

  @override
  String get presetDay => 'Giorno';

  @override
  String get presetSepia => 'Seppia';

  @override
  String get presetNight => 'Notte';

  @override
  String get dyslexiaFont => 'Font per dislessia (EPUB)';

  @override
  String get paperFilter => 'Filtro carta';

  @override
  String get blueLightFilter => 'Filtro luce blu';

  @override
  String get colorOverlay => 'Overlay colorato';

  @override
  String get none => 'Nessuno';

  @override
  String get overlayYellow => 'Giallo';

  @override
  String get overlayGreen => 'Verde';

  @override
  String get overlayBlue => 'Azzurro';

  @override
  String overlayIntensityLabel(Object percent) {
    return 'Intensità overlay · $percent%';
  }

  @override
  String get language => 'Lingua';

  @override
  String get languageSystem => 'Automatico (sistema)';

  @override
  String get languageItalian => 'Italiano';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get discoverBooks => 'Scopri libri online';

  @override
  String get discoverBooksSourceLabel =>
      'Project Gutenberg e Standard Ebooks via Internet Archive, più Wikisource in italiano — pubblico dominio';

  @override
  String get discoverBooksSourceFilterLabel => 'Fonte';

  @override
  String get discoverBooksSourceFilterAny => 'Tutte';

  @override
  String get discoverBooksUnlockedMessage =>
      'Sezione \"Scopri libri online\" sbloccata';

  @override
  String get discoverBooksHiddenMessage =>
      'Sezione \"Scopri libri online\" nascosta di nuovo';

  @override
  String get discoverBooksSearchHint => 'Cerca per titolo o autore…';

  @override
  String get discoverBooksEmptyHint =>
      'Cerca un titolo o un autore per trovare libri di pubblico dominio da scaricare.';

  @override
  String get discoverBooksNoResults => 'Nessun libro trovato';

  @override
  String get discoverBooksLoadMore => 'Carica altri risultati';

  @override
  String get discoverBooksSearchButton => 'Cerca';

  @override
  String get discoverBooksFilters => 'Filtri';

  @override
  String get discoverBooksLanguageLabel => 'Lingua';

  @override
  String get discoverBooksLanguageAny => 'Tutte le lingue';

  @override
  String get discoverBooksSubjectLabel => 'Genere';

  @override
  String get discoverBooksSubjectHint => 'es. poesia, avventura…';

  @override
  String get discoverBooksFileTypeLabel => 'Tipo di file';

  @override
  String get discoverBooksFileTypeAny => 'Tutti';

  @override
  String discoverBooksSearchError(Object error) {
    return 'Ricerca non riuscita: $error';
  }

  @override
  String get downloading => 'Scaricamento…';

  @override
  String downloadSuccessMessage(Object title) {
    return '\"$title\" scaricato e aggiunto alla libreria';
  }

  @override
  String get downloadErrorMessage => 'Download non riuscito, riprova';

  @override
  String downloadErrorMessageDetailed(Object error) {
    return 'Download non riuscito: $error';
  }
}
