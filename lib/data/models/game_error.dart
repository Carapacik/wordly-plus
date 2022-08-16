import 'package:flutter/material.dart';
import 'package:wordly/resources/resources.dart';

enum GameError {
  notFound,
  tooShort;

  const GameError();

  String getName(BuildContext context) {
    switch (this) {
      case GameError.notFound:
        return context.r.word_not_found;
      case GameError.tooShort:
        return context.r.word_too_short;
    }
  }
}
