// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String updateAvailable(Object version) {
    return 'Version $version available';
  }

  @override
  String get download => 'Download';

  @override
  String get unsupportedFormatMessage =>
      'Unsupported format: only EPUB and PDF';

  @override
  String importedBooksMessage(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count books imported from share',
      one: 'Book imported from share',
    );
    return '$_temp0';
  }

  @override
  String get myLibrary => 'My library';

  @override
  String get readingStats => 'Reading statistics';

  @override
  String get settings => 'Settings';

  @override
  String libraryErrorMessage(Object error) {
    return 'Error: $error';
  }

  @override
  String get importCancelledMessage =>
      'Import cancelled or format not yet supported';

  @override
  String get importBook => 'Import book';

  @override
  String get rename => 'Rename';

  @override
  String get moveToShelf => 'Move to shelf';

  @override
  String get statsAction => 'Statistics';

  @override
  String get delete => 'Delete';

  @override
  String get noShelf => 'No shelf';

  @override
  String get noShelfCreatedHint =>
      'No shelf created yet. Create one from the row above.';

  @override
  String get deleteBookTitle => 'Delete this book?';

  @override
  String deleteBookMessage(Object title) {
    return '\"$title\" will be removed from the library along with the copy stored on this device.';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get emptyShelfTitle => 'This shelf is empty';

  @override
  String get emptyLibraryTitle => 'No books yet';

  @override
  String get emptyShelfHint =>
      'Long-press a book in \"All books\" to move it here.';

  @override
  String get emptyLibraryHint => 'Import an EPUB or PDF file to start reading.';

  @override
  String get allBooks => 'All books';

  @override
  String get newShelf => 'New shelf';

  @override
  String get editShelf => 'Edit shelf';

  @override
  String get deleteShelf => 'Delete shelf';

  @override
  String get deleteShelfTitle => 'Delete this shelf?';

  @override
  String deleteShelfMessage(Object name) {
    return '\"$name\" will be deleted. The books inside it stay in the general library, they won\'t be deleted.';
  }

  @override
  String get shelfNameLabel => 'Name';

  @override
  String get colorLabel => 'Color';

  @override
  String get iconLabel => 'Icon';

  @override
  String get save => 'Save';

  @override
  String get createShelf => 'Create shelf';

  @override
  String get renameBookTitle => 'Rename book';

  @override
  String get statLabelRead => 'Read';

  @override
  String get statLabelAddedOn => 'Added on';

  @override
  String get statLabelLastRead => 'Last read';

  @override
  String get never => 'Never';

  @override
  String get booksInLibrary => 'Books in library';

  @override
  String get completed => 'Completed';

  @override
  String get inProgress => 'In progress';

  @override
  String get searchInBook => 'Search in book';

  @override
  String get readingFilters => 'Reading filters';

  @override
  String filtersErrorMessage(Object error) {
    return 'Filter error: $error';
  }

  @override
  String get searchInBookHint => 'Search in book…';

  @override
  String get searchInBookByChapterHint => 'Search in book (by chapter)…';

  @override
  String get noResults => 'No results';

  @override
  String chapterFallback(Object number) {
    return 'Chapter $number';
  }

  @override
  String get stopReadAloud => 'Stop reading aloud';

  @override
  String get readAloud => 'Read aloud';

  @override
  String get cbrUnsupportedOnPlatform =>
      'Format not supported on this platform';

  @override
  String get cannotOpenComic => 'Couldn\'t open this comic';

  @override
  String get noPagesFound => 'No pages found';

  @override
  String pageProgress(Object page, Object total, Object percent) {
    return 'Page $page of $total · $percent%';
  }

  @override
  String textSizeLabel(Object size) {
    return 'Text size · $size';
  }

  @override
  String lineHeightLabel(Object value) {
    return 'Line height · $value';
  }

  @override
  String brightnessLabel(Object value) {
    return 'Brightness · $value';
  }

  @override
  String contrastLabel(Object value) {
    return 'Contrast · $value';
  }

  @override
  String colorTemperatureLabel(Object state) {
    return 'Color temperature · $state';
  }

  @override
  String get warm => 'warm';

  @override
  String get cool => 'cool';

  @override
  String get neutral => 'neutral';

  @override
  String get appearance => 'Appearance';

  @override
  String get eReaderMode => 'E-reader mode';

  @override
  String get eReaderModeSubtitle =>
      'The whole app turns grayscale, like an e-reader screen';

  @override
  String get advancedFilters => 'Advanced filters';

  @override
  String get advancedFiltersHint =>
      'For quick adjustments while reading, use the sliders in the book\'s filter panel.';

  @override
  String get pageColorLabel => 'Page color (EPUB)';

  @override
  String get presetDay => 'Day';

  @override
  String get presetSepia => 'Sepia';

  @override
  String get presetNight => 'Night';

  @override
  String get dyslexiaFont => 'Dyslexia-friendly font (EPUB)';

  @override
  String get paperFilter => 'Paper filter';

  @override
  String get blueLightFilter => 'Blue light filter';

  @override
  String get colorOverlay => 'Color overlay';

  @override
  String get none => 'None';

  @override
  String get overlayYellow => 'Yellow';

  @override
  String get overlayGreen => 'Green';

  @override
  String get overlayBlue => 'Blue';

  @override
  String overlayIntensityLabel(Object percent) {
    return 'Overlay intensity · $percent%';
  }

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'Automatic (system)';

  @override
  String get languageItalian => 'Italiano';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';
}
