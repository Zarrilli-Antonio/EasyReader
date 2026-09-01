// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String updateAvailable(Object version) {
    return 'Versión $version disponible';
  }

  @override
  String get download => 'Descargar';

  @override
  String get unsupportedFormatMessage =>
      'Formato no compatible: solo EPUB y PDF';

  @override
  String importedBooksMessage(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count libros importados desde el uso compartido',
      one: 'Libro importado desde el uso compartido',
    );
    return '$_temp0';
  }

  @override
  String get myLibrary => 'Mi biblioteca';

  @override
  String get readingStats => 'Estadísticas de lectura';

  @override
  String get settings => 'Ajustes';

  @override
  String libraryErrorMessage(Object error) {
    return 'Error: $error';
  }

  @override
  String get importCancelledMessage =>
      'Importación cancelada o formato aún no compatible';

  @override
  String get importBook => 'Importar libro';

  @override
  String get rename => 'Renombrar';

  @override
  String get moveToShelf => 'Mover a una estantería';

  @override
  String get statsAction => 'Estadísticas';

  @override
  String get delete => 'Eliminar';

  @override
  String get noShelf => 'Sin estantería';

  @override
  String get noShelfCreatedHint =>
      'Aún no has creado ninguna estantería. Crea una desde la fila superior.';

  @override
  String get deleteBookTitle => '¿Eliminar este libro?';

  @override
  String deleteBookMessage(Object title) {
    return '\"$title\" se eliminará de la biblioteca junto con la copia guardada en este dispositivo.';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get emptyShelfTitle => 'Esta estantería está vacía';

  @override
  String get emptyLibraryTitle => 'Todavía no hay libros';

  @override
  String get emptyShelfHint =>
      'Mantén pulsado un libro en \"Todos los libros\" para moverlo aquí.';

  @override
  String get emptyLibraryHint =>
      'Importa un archivo EPUB o PDF para empezar a leer.';

  @override
  String get allBooks => 'Todos los libros';

  @override
  String get newShelf => 'Nueva estantería';

  @override
  String get editShelf => 'Editar estantería';

  @override
  String get deleteShelf => 'Eliminar estantería';

  @override
  String get deleteShelfTitle => '¿Eliminar esta estantería?';

  @override
  String deleteShelfMessage(Object name) {
    return '\"$name\" se eliminará. Los libros que contiene permanecerán en la biblioteca general, no se eliminarán.';
  }

  @override
  String get shelfNameLabel => 'Nombre';

  @override
  String get colorLabel => 'Color';

  @override
  String get iconLabel => 'Icono';

  @override
  String get save => 'Guardar';

  @override
  String get createShelf => 'Crear estantería';

  @override
  String get renameBookTitle => 'Renombrar libro';

  @override
  String get statLabelRead => 'Leído';

  @override
  String get statLabelAddedOn => 'Añadido el';

  @override
  String get statLabelLastRead => 'Última lectura';

  @override
  String get never => 'Nunca';

  @override
  String get booksInLibrary => 'Libros en la biblioteca';

  @override
  String get completed => 'Completados';

  @override
  String get inProgress => 'En lectura';

  @override
  String get searchInBook => 'Buscar en el libro';

  @override
  String get readingFilters => 'Filtros de lectura';

  @override
  String filtersErrorMessage(Object error) {
    return 'Error de filtros: $error';
  }

  @override
  String get searchInBookHint => 'Buscar en el libro…';

  @override
  String get searchInBookByChapterHint => 'Buscar en el libro (por capítulo)…';

  @override
  String get noResults => 'Sin resultados';

  @override
  String chapterFallback(Object number) {
    return 'Capítulo $number';
  }

  @override
  String get stopReadAloud => 'Detener lectura en voz alta';

  @override
  String get readAloud => 'Leer en voz alta';

  @override
  String get cbrUnsupportedOnPlatform =>
      'Formato no compatible en esta plataforma';

  @override
  String get cannotOpenComic => 'No se pudo abrir este cómic';

  @override
  String get noPagesFound => 'No se encontraron páginas';

  @override
  String pageProgress(Object page, Object total, Object percent) {
    return 'Página $page de $total · $percent%';
  }

  @override
  String textSizeLabel(Object size) {
    return 'Tamaño del texto · $size';
  }

  @override
  String lineHeightLabel(Object value) {
    return 'Interlineado · $value';
  }

  @override
  String brightnessLabel(Object value) {
    return 'Brillo · $value';
  }

  @override
  String contrastLabel(Object value) {
    return 'Contraste · $value';
  }

  @override
  String colorTemperatureLabel(Object state) {
    return 'Temperatura de color · $state';
  }

  @override
  String get warm => 'cálido';

  @override
  String get cool => 'frío';

  @override
  String get neutral => 'neutro';

  @override
  String get appearance => 'Apariencia';

  @override
  String get eReaderMode => 'Modo e-reader';

  @override
  String get eReaderModeSubtitle =>
      'Toda la app pasa a escala de grises, como la pantalla de un e-reader';

  @override
  String get advancedFilters => 'Filtros avanzados';

  @override
  String get advancedFiltersHint =>
      'Para ajustes rápidos mientras lees, usa los deslizadores del panel de filtros del libro.';

  @override
  String get pageColorLabel => 'Color de página (EPUB)';

  @override
  String get presetDay => 'Día';

  @override
  String get presetSepia => 'Sepia';

  @override
  String get presetNight => 'Noche';

  @override
  String get dyslexiaFont => 'Fuente para dislexia (EPUB)';

  @override
  String get paperFilter => 'Filtro de papel';

  @override
  String get blueLightFilter => 'Filtro de luz azul';

  @override
  String get colorOverlay => 'Superposición de color';

  @override
  String get none => 'Ninguno';

  @override
  String get overlayYellow => 'Amarillo';

  @override
  String get overlayGreen => 'Verde';

  @override
  String get overlayBlue => 'Azul';

  @override
  String overlayIntensityLabel(Object percent) {
    return 'Intensidad de la superposición · $percent%';
  }

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Automático (sistema)';

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
  String get discoverBooks => 'Descubrir libros en línea';

  @override
  String get discoverBooksSourceLabel =>
      'Project Gutenberg y Standard Ebooks vía Internet Archive, más Wikisource en italiano — dominio público';

  @override
  String get discoverBooksSourceFilterLabel => 'Fuente';

  @override
  String get discoverBooksSourceFilterAny => 'Todas';

  @override
  String get discoverBooksUnlockedMessage =>
      'Sección \"Descubrir libros en línea\" desbloqueada';

  @override
  String get discoverBooksHiddenMessage =>
      'Sección \"Descubrir libros en línea\" oculta de nuevo';

  @override
  String get discoverBooksSearchHint => 'Busca por título o autor…';

  @override
  String get discoverBooksEmptyHint =>
      'Busca un título o un autor para encontrar libros de dominio público para descargar.';

  @override
  String get discoverBooksNoResults => 'No se encontraron libros';

  @override
  String get discoverBooksLoadMore => 'Cargar más resultados';

  @override
  String get discoverBooksSearchButton => 'Buscar';

  @override
  String get discoverBooksFilters => 'Filtros';

  @override
  String get discoverBooksLanguageLabel => 'Idioma';

  @override
  String get discoverBooksLanguageAny => 'Todos los idiomas';

  @override
  String get discoverBooksSubjectLabel => 'Género';

  @override
  String get discoverBooksSubjectHint => 'ej. poesía, aventura…';

  @override
  String get discoverBooksFileTypeLabel => 'Tipo de archivo';

  @override
  String get discoverBooksFileTypeAny => 'Todos';

  @override
  String discoverBooksSearchError(Object error) {
    return 'Búsqueda fallida: $error';
  }

  @override
  String get downloading => 'Descargando…';

  @override
  String downloadSuccessMessage(Object title) {
    return '\"$title\" descargado y añadido a la biblioteca';
  }

  @override
  String get downloadErrorMessage => 'Descarga fallida, inténtalo de nuevo';

  @override
  String downloadErrorMessageDetailed(Object error) {
    return 'Descarga fallida: $error';
  }
}
