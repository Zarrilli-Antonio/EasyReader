import 'package:flutter/material.dart';

/// Profilo di comfort visivo applicato alla pagina in lettura, su un unico
/// profilo globale: colore sfondo, overlay colorato, luminosità, contrasto,
/// temperatura colore, filtro luce blu, filtro carta, dimensione font,
/// interlinea e font per dislessia (questi ultimi due solo EPUB).
class FilterProfile {
  final String id;
  final String name;
  final Color backgroundColor;
  final Color overlayColor;
  final double overlayOpacity;
  final double brightness;
  final double contrast;
  final double colorTemperature;
  final double fontSize;
  final double lineHeight;
  final bool paperFilterEnabled;
  final bool blueLightFilterEnabled;
  final bool useDyslexiaFont;
  final bool eInkModeEnabled;
  final bool isDefault;

  const FilterProfile({
    required this.id,
    required this.name,
    required this.backgroundColor,
    required this.overlayColor,
    required this.overlayOpacity,
    required this.brightness,
    required this.contrast,
    required this.colorTemperature,
    required this.fontSize,
    required this.lineHeight,
    required this.paperFilterEnabled,
    required this.blueLightFilterEnabled,
    required this.useDyslexiaFont,
    required this.eInkModeEnabled,
    required this.isDefault,
  });

  factory FilterProfile.standard({required String id}) => FilterProfile(
    id: id,
    name: 'Predefinito',
    backgroundColor: Colors.white,
    overlayColor: Colors.amber,
    overlayOpacity: 0,
    brightness: 0,
    contrast: 1,
    colorTemperature: 0,
    fontSize: 16,
    lineHeight: 1.4,
    paperFilterEnabled: false,
    blueLightFilterEnabled: false,
    useDyslexiaFont: false,
    eInkModeEnabled: false,
    isDefault: true,
  );

  FilterProfile copyWith({
    Color? backgroundColor,
    Color? overlayColor,
    double? overlayOpacity,
    double? brightness,
    double? contrast,
    double? colorTemperature,
    double? fontSize,
    double? lineHeight,
    bool? paperFilterEnabled,
    bool? blueLightFilterEnabled,
    bool? useDyslexiaFont,
    bool? eInkModeEnabled,
  }) {
    return FilterProfile(
      id: id,
      name: name,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      overlayColor: overlayColor ?? this.overlayColor,
      overlayOpacity: overlayOpacity ?? this.overlayOpacity,
      brightness: brightness ?? this.brightness,
      contrast: contrast ?? this.contrast,
      colorTemperature: colorTemperature ?? this.colorTemperature,
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      paperFilterEnabled: paperFilterEnabled ?? this.paperFilterEnabled,
      blueLightFilterEnabled:
          blueLightFilterEnabled ?? this.blueLightFilterEnabled,
      useDyslexiaFont: useDyslexiaFont ?? this.useDyslexiaFont,
      eInkModeEnabled: eInkModeEnabled ?? this.eInkModeEnabled,
      isDefault: isDefault,
    );
  }
}
