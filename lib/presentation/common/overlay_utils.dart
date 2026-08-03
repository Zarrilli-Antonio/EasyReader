/// Aspetta che un dialog o un bottom sheet appena chiuso finisca la sua
/// animazione di uscita, prima di eseguire un'azione che può far ripartire
/// una ricostruzione della schermata sottostante (es. una scrittura su
/// drift che aggiorna uno stream ascoltato dalla UI). Farlo troppo vicino
/// nello stesso frame fa scattare un assert interno di Flutter sugli
/// InheritedWidget ("_dependents.isEmpty" in framework.dart).
Future<void> settleAfterOverlayClose() {
  return Future<void>.delayed(const Duration(milliseconds: 250));
}
