import 'package:flutter/material.dart';

/// Profilo di comfort visivo applicato alla pagina in lettura.
///
/// Fase 1 espone i controlli essenziali della roadmap (colore sfondo,
/// overlay colorato, luminosità, dimensione font, filtro carta) su un unico
/// profilo globale; temperatura colore, contrasto e tipografia estesa
/// arrivano in Fase 2 come nuovi campi dello stesso modello.
class FilterProfile {
  final String id;
  final String name;
  final Color backgroundColor;
  final Color overlayColor;
  final double overlayOpacity;
  final double brightness;
  final double fontSize;
  final bool paperFilterEnabled;
  final bool isDefault;

  const FilterProfile({
    required this.id,
    required this.name,
    required this.backgroundColor,
    required this.overlayColor,
    required this.overlayOpacity,
    required this.brightness,
    required this.fontSize,
    required this.paperFilterEnabled,
    required this.isDefault,
  });

  factory FilterProfile.standard({required String id}) => FilterProfile(
    id: id,
    name: 'Predefinito',
    backgroundColor: Colors.white,
    overlayColor: Colors.amber,
    overlayOpacity: 0,
    brightness: 0,
    fontSize: 16,
    paperFilterEnabled: false,
    isDefault: true,
  );

  FilterProfile copyWith({
    Color? backgroundColor,
    Color? overlayColor,
    double? overlayOpacity,
    double? brightness,
    double? fontSize,
    bool? paperFilterEnabled,
  }) {
    return FilterProfile(
      id: id,
      name: name,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      overlayColor: overlayColor ?? this.overlayColor,
      overlayOpacity: overlayOpacity ?? this.overlayOpacity,
      brightness: brightness ?? this.brightness,
      fontSize: fontSize ?? this.fontSize,
      paperFilterEnabled: paperFilterEnabled ?? this.paperFilterEnabled,
      isDefault: isDefault,
    );
  }
}
