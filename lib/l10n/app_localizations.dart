import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('it'),
  ];

  /// No description provided for @updateAvailable.
  ///
  /// In it, this message translates to:
  /// **'Versione {version} disponibile'**
  String updateAvailable(Object version);

  /// No description provided for @download.
  ///
  /// In it, this message translates to:
  /// **'Scarica'**
  String get download;

  /// No description provided for @unsupportedFormatMessage.
  ///
  /// In it, this message translates to:
  /// **'Formato non supportato: solo EPUB e PDF'**
  String get unsupportedFormatMessage;

  /// No description provided for @importedBooksMessage.
  ///
  /// In it, this message translates to:
  /// **'{count, plural, =1{Libro importato dalla condivisione} other{{count} libri importati dalla condivisione}}'**
  String importedBooksMessage(num count);

  /// No description provided for @myLibrary.
  ///
  /// In it, this message translates to:
  /// **'La mia libreria'**
  String get myLibrary;

  /// No description provided for @readingStats.
  ///
  /// In it, this message translates to:
  /// **'Statistiche di lettura'**
  String get readingStats;

  /// No description provided for @settings.
  ///
  /// In it, this message translates to:
  /// **'Impostazioni'**
  String get settings;

  /// No description provided for @libraryErrorMessage.
  ///
  /// In it, this message translates to:
  /// **'Errore: {error}'**
  String libraryErrorMessage(Object error);

  /// No description provided for @importCancelledMessage.
  ///
  /// In it, this message translates to:
  /// **'Importazione annullata o formato non ancora supportato'**
  String get importCancelledMessage;

  /// No description provided for @importBook.
  ///
  /// In it, this message translates to:
  /// **'Importa libro'**
  String get importBook;

  /// No description provided for @rename.
  ///
  /// In it, this message translates to:
  /// **'Rinomina'**
  String get rename;

  /// No description provided for @moveToShelf.
  ///
  /// In it, this message translates to:
  /// **'Sposta in libreria'**
  String get moveToShelf;

  /// No description provided for @statsAction.
  ///
  /// In it, this message translates to:
  /// **'Statistiche'**
  String get statsAction;

  /// No description provided for @delete.
  ///
  /// In it, this message translates to:
  /// **'Elimina'**
  String get delete;

  /// No description provided for @noShelf.
  ///
  /// In it, this message translates to:
  /// **'Nessuna libreria'**
  String get noShelf;

  /// No description provided for @noShelfCreatedHint.
  ///
  /// In it, this message translates to:
  /// **'Nessuna libreria creata. Creane una dalla riga in alto.'**
  String get noShelfCreatedHint;

  /// No description provided for @deleteBookTitle.
  ///
  /// In it, this message translates to:
  /// **'Eliminare il libro?'**
  String get deleteBookTitle;

  /// No description provided for @deleteBookMessage.
  ///
  /// In it, this message translates to:
  /// **'\"{title}\" verrà rimosso dalla libreria insieme al file copiato sul dispositivo.'**
  String deleteBookMessage(Object title);

  /// No description provided for @cancel.
  ///
  /// In it, this message translates to:
  /// **'Annulla'**
  String get cancel;

  /// No description provided for @emptyShelfTitle.
  ///
  /// In it, this message translates to:
  /// **'Questa libreria è vuota'**
  String get emptyShelfTitle;

  /// No description provided for @emptyLibraryTitle.
  ///
  /// In it, this message translates to:
  /// **'Nessun libro ancora'**
  String get emptyLibraryTitle;

  /// No description provided for @emptyShelfHint.
  ///
  /// In it, this message translates to:
  /// **'Tieni premuto su un libro in \"Tutti i libri\" per spostarlo qui.'**
  String get emptyShelfHint;

  /// No description provided for @emptyLibraryHint.
  ///
  /// In it, this message translates to:
  /// **'Importa un file EPUB o PDF per iniziare a leggere.'**
  String get emptyLibraryHint;

  /// No description provided for @allBooks.
  ///
  /// In it, this message translates to:
  /// **'Tutti i libri'**
  String get allBooks;

  /// No description provided for @newShelf.
  ///
  /// In it, this message translates to:
  /// **'Nuova libreria'**
  String get newShelf;

  /// No description provided for @editShelf.
  ///
  /// In it, this message translates to:
  /// **'Modifica libreria'**
  String get editShelf;

  /// No description provided for @deleteShelf.
  ///
  /// In it, this message translates to:
  /// **'Elimina libreria'**
  String get deleteShelf;

  /// No description provided for @deleteShelfTitle.
  ///
  /// In it, this message translates to:
  /// **'Eliminare la libreria?'**
  String get deleteShelfTitle;

  /// No description provided for @deleteShelfMessage.
  ///
  /// In it, this message translates to:
  /// **'\"{name}\" verrà eliminata. I libri al suo interno restano nella libreria generale, senza essere cancellati.'**
  String deleteShelfMessage(Object name);

  /// No description provided for @shelfNameLabel.
  ///
  /// In it, this message translates to:
  /// **'Nome'**
  String get shelfNameLabel;

  /// No description provided for @colorLabel.
  ///
  /// In it, this message translates to:
  /// **'Colore'**
  String get colorLabel;

  /// No description provided for @iconLabel.
  ///
  /// In it, this message translates to:
  /// **'Icona'**
  String get iconLabel;

  /// No description provided for @save.
  ///
  /// In it, this message translates to:
  /// **'Salva'**
  String get save;

  /// No description provided for @createShelf.
  ///
  /// In it, this message translates to:
  /// **'Crea libreria'**
  String get createShelf;

  /// No description provided for @renameBookTitle.
  ///
  /// In it, this message translates to:
  /// **'Rinomina libro'**
  String get renameBookTitle;

  /// No description provided for @statLabelRead.
  ///
  /// In it, this message translates to:
  /// **'Letto'**
  String get statLabelRead;

  /// No description provided for @statLabelAddedOn.
  ///
  /// In it, this message translates to:
  /// **'Aggiunto il'**
  String get statLabelAddedOn;

  /// No description provided for @statLabelLastRead.
  ///
  /// In it, this message translates to:
  /// **'Ultima lettura'**
  String get statLabelLastRead;

  /// No description provided for @never.
  ///
  /// In it, this message translates to:
  /// **'Mai'**
  String get never;

  /// No description provided for @booksInLibrary.
  ///
  /// In it, this message translates to:
  /// **'Libri in libreria'**
  String get booksInLibrary;

  /// No description provided for @completed.
  ///
  /// In it, this message translates to:
  /// **'Completati'**
  String get completed;

  /// No description provided for @inProgress.
  ///
  /// In it, this message translates to:
  /// **'In lettura'**
  String get inProgress;

  /// No description provided for @searchInBook.
  ///
  /// In it, this message translates to:
  /// **'Cerca nel libro'**
  String get searchInBook;

  /// No description provided for @readingFilters.
  ///
  /// In it, this message translates to:
  /// **'Filtri di lettura'**
  String get readingFilters;

  /// No description provided for @filtersErrorMessage.
  ///
  /// In it, this message translates to:
  /// **'Errore filtri: {error}'**
  String filtersErrorMessage(Object error);

  /// No description provided for @searchInBookHint.
  ///
  /// In it, this message translates to:
  /// **'Cerca nel libro…'**
  String get searchInBookHint;

  /// No description provided for @searchInBookByChapterHint.
  ///
  /// In it, this message translates to:
  /// **'Cerca nel libro (per capitolo)…'**
  String get searchInBookByChapterHint;

  /// No description provided for @noResults.
  ///
  /// In it, this message translates to:
  /// **'Nessun risultato'**
  String get noResults;

  /// No description provided for @chapterFallback.
  ///
  /// In it, this message translates to:
  /// **'Capitolo {number}'**
  String chapterFallback(Object number);

  /// No description provided for @stopReadAloud.
  ///
  /// In it, this message translates to:
  /// **'Interrompi lettura vocale'**
  String get stopReadAloud;

  /// No description provided for @readAloud.
  ///
  /// In it, this message translates to:
  /// **'Leggi ad alta voce'**
  String get readAloud;

  /// No description provided for @cbrUnsupportedOnPlatform.
  ///
  /// In it, this message translates to:
  /// **'Formato non supportato su questa piattaforma'**
  String get cbrUnsupportedOnPlatform;

  /// No description provided for @cannotOpenComic.
  ///
  /// In it, this message translates to:
  /// **'Impossibile aprire questo fumetto'**
  String get cannotOpenComic;

  /// No description provided for @noPagesFound.
  ///
  /// In it, this message translates to:
  /// **'Nessuna pagina trovata'**
  String get noPagesFound;

  /// No description provided for @pageProgress.
  ///
  /// In it, this message translates to:
  /// **'Pagina {page} di {total} · {percent}%'**
  String pageProgress(Object page, Object total, Object percent);

  /// No description provided for @textSizeLabel.
  ///
  /// In it, this message translates to:
  /// **'Dimensione testo · {size}'**
  String textSizeLabel(Object size);

  /// No description provided for @lineHeightLabel.
  ///
  /// In it, this message translates to:
  /// **'Interlinea · {value}'**
  String lineHeightLabel(Object value);

  /// No description provided for @brightnessLabel.
  ///
  /// In it, this message translates to:
  /// **'Luminosità · {value}'**
  String brightnessLabel(Object value);

  /// No description provided for @contrastLabel.
  ///
  /// In it, this message translates to:
  /// **'Contrasto · {value}'**
  String contrastLabel(Object value);

  /// No description provided for @colorTemperatureLabel.
  ///
  /// In it, this message translates to:
  /// **'Temperatura colore · {state}'**
  String colorTemperatureLabel(Object state);

  /// No description provided for @warm.
  ///
  /// In it, this message translates to:
  /// **'caldo'**
  String get warm;

  /// No description provided for @cool.
  ///
  /// In it, this message translates to:
  /// **'freddo'**
  String get cool;

  /// No description provided for @neutral.
  ///
  /// In it, this message translates to:
  /// **'neutro'**
  String get neutral;

  /// No description provided for @appearance.
  ///
  /// In it, this message translates to:
  /// **'Aspetto'**
  String get appearance;

  /// No description provided for @eReaderMode.
  ///
  /// In it, this message translates to:
  /// **'Modalità e-reader'**
  String get eReaderMode;

  /// No description provided for @eReaderModeSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Tutta l\'app diventa in scala di grigi, come lo schermo di un e-reader'**
  String get eReaderModeSubtitle;

  /// No description provided for @advancedFilters.
  ///
  /// In it, this message translates to:
  /// **'Filtri avanzati'**
  String get advancedFilters;

  /// No description provided for @advancedFiltersHint.
  ///
  /// In it, this message translates to:
  /// **'Per la regolazione rapida mentre leggi, usa gli slider nel pannello filtri del libro.'**
  String get advancedFiltersHint;

  /// No description provided for @pageColorLabel.
  ///
  /// In it, this message translates to:
  /// **'Colore pagina (EPUB)'**
  String get pageColorLabel;

  /// No description provided for @presetDay.
  ///
  /// In it, this message translates to:
  /// **'Giorno'**
  String get presetDay;

  /// No description provided for @presetSepia.
  ///
  /// In it, this message translates to:
  /// **'Seppia'**
  String get presetSepia;

  /// No description provided for @presetNight.
  ///
  /// In it, this message translates to:
  /// **'Notte'**
  String get presetNight;

  /// No description provided for @dyslexiaFont.
  ///
  /// In it, this message translates to:
  /// **'Font per dislessia (EPUB)'**
  String get dyslexiaFont;

  /// No description provided for @paperFilter.
  ///
  /// In it, this message translates to:
  /// **'Filtro carta'**
  String get paperFilter;

  /// No description provided for @blueLightFilter.
  ///
  /// In it, this message translates to:
  /// **'Filtro luce blu'**
  String get blueLightFilter;

  /// No description provided for @colorOverlay.
  ///
  /// In it, this message translates to:
  /// **'Overlay colorato'**
  String get colorOverlay;

  /// No description provided for @none.
  ///
  /// In it, this message translates to:
  /// **'Nessuno'**
  String get none;

  /// No description provided for @overlayYellow.
  ///
  /// In it, this message translates to:
  /// **'Giallo'**
  String get overlayYellow;

  /// No description provided for @overlayGreen.
  ///
  /// In it, this message translates to:
  /// **'Verde'**
  String get overlayGreen;

  /// No description provided for @overlayBlue.
  ///
  /// In it, this message translates to:
  /// **'Azzurro'**
  String get overlayBlue;

  /// No description provided for @overlayIntensityLabel.
  ///
  /// In it, this message translates to:
  /// **'Intensità overlay · {percent}%'**
  String overlayIntensityLabel(Object percent);

  /// No description provided for @language.
  ///
  /// In it, this message translates to:
  /// **'Lingua'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In it, this message translates to:
  /// **'Automatico (sistema)'**
  String get languageSystem;

  /// No description provided for @languageItalian.
  ///
  /// In it, this message translates to:
  /// **'Italiano'**
  String get languageItalian;

  /// No description provided for @languageEnglish.
  ///
  /// In it, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageSpanish.
  ///
  /// In it, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// No description provided for @languageFrench.
  ///
  /// In it, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// No description provided for @languageGerman.
  ///
  /// In it, this message translates to:
  /// **'Deutsch'**
  String get languageGerman;

  /// No description provided for @discoverBooks.
  ///
  /// In it, this message translates to:
  /// **'Scopri libri online'**
  String get discoverBooks;

  /// No description provided for @discoverBooksSourceLabel.
  ///
  /// In it, this message translates to:
  /// **'Project Gutenberg e Standard Ebooks via Internet Archive, più Wikisource in italiano — pubblico dominio'**
  String get discoverBooksSourceLabel;

  /// No description provided for @discoverBooksSourceFilterLabel.
  ///
  /// In it, this message translates to:
  /// **'Fonte'**
  String get discoverBooksSourceFilterLabel;

  /// No description provided for @discoverBooksSourceFilterAny.
  ///
  /// In it, this message translates to:
  /// **'Tutte'**
  String get discoverBooksSourceFilterAny;

  /// No description provided for @discoverBooksUnlockedMessage.
  ///
  /// In it, this message translates to:
  /// **'Sezione \"Scopri libri online\" sbloccata'**
  String get discoverBooksUnlockedMessage;

  /// No description provided for @discoverBooksHiddenMessage.
  ///
  /// In it, this message translates to:
  /// **'Sezione \"Scopri libri online\" nascosta di nuovo'**
  String get discoverBooksHiddenMessage;

  /// No description provided for @discoverBooksSearchHint.
  ///
  /// In it, this message translates to:
  /// **'Cerca per titolo o autore…'**
  String get discoverBooksSearchHint;

  /// No description provided for @discoverBooksEmptyHint.
  ///
  /// In it, this message translates to:
  /// **'Cerca un titolo o un autore per trovare libri di pubblico dominio da scaricare.'**
  String get discoverBooksEmptyHint;

  /// No description provided for @discoverBooksNoResults.
  ///
  /// In it, this message translates to:
  /// **'Nessun libro trovato'**
  String get discoverBooksNoResults;

  /// No description provided for @discoverBooksLoadMore.
  ///
  /// In it, this message translates to:
  /// **'Carica altri risultati'**
  String get discoverBooksLoadMore;

  /// No description provided for @discoverBooksSearchButton.
  ///
  /// In it, this message translates to:
  /// **'Cerca'**
  String get discoverBooksSearchButton;

  /// No description provided for @discoverBooksFilters.
  ///
  /// In it, this message translates to:
  /// **'Filtri'**
  String get discoverBooksFilters;

  /// No description provided for @discoverBooksLanguageLabel.
  ///
  /// In it, this message translates to:
  /// **'Lingua'**
  String get discoverBooksLanguageLabel;

  /// No description provided for @discoverBooksLanguageAny.
  ///
  /// In it, this message translates to:
  /// **'Tutte le lingue'**
  String get discoverBooksLanguageAny;

  /// No description provided for @discoverBooksSubjectLabel.
  ///
  /// In it, this message translates to:
  /// **'Genere'**
  String get discoverBooksSubjectLabel;

  /// No description provided for @discoverBooksSubjectHint.
  ///
  /// In it, this message translates to:
  /// **'es. poesia, avventura…'**
  String get discoverBooksSubjectHint;

  /// No description provided for @discoverBooksFileTypeLabel.
  ///
  /// In it, this message translates to:
  /// **'Tipo di file'**
  String get discoverBooksFileTypeLabel;

  /// No description provided for @discoverBooksFileTypeAny.
  ///
  /// In it, this message translates to:
  /// **'Tutti'**
  String get discoverBooksFileTypeAny;

  /// No description provided for @discoverBooksSearchError.
  ///
  /// In it, this message translates to:
  /// **'Ricerca non riuscita: {error}'**
  String discoverBooksSearchError(Object error);

  /// No description provided for @downloading.
  ///
  /// In it, this message translates to:
  /// **'Scaricamento…'**
  String get downloading;

  /// No description provided for @downloadSuccessMessage.
  ///
  /// In it, this message translates to:
  /// **'\"{title}\" scaricato e aggiunto alla libreria'**
  String downloadSuccessMessage(Object title);

  /// No description provided for @downloadErrorMessage.
  ///
  /// In it, this message translates to:
  /// **'Download non riuscito, riprova'**
  String get downloadErrorMessage;

  /// No description provided for @downloadErrorMessageDetailed.
  ///
  /// In it, this message translates to:
  /// **'Download non riuscito: {error}'**
  String downloadErrorMessageDetailed(Object error);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
