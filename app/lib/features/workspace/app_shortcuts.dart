import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../core/platform.dart';

/// The keys the app keeps for itself on desktop. Everything else reaches
/// the program in the terminal, which is why these all carry two modifiers
/// or Alt with a digit:
/// Ctrl+W, Ctrl+T, Ctrl+B and Ctrl+D mean something in a shell or tmux and
/// stay theirs.
abstract final class AppShortcuts {
  static const newTab = SingleActivator(LogicalKeyboardKey.keyT, control: true, shift: true);
  static const closePane = SingleActivator(LogicalKeyboardKey.keyW, control: true, shift: true);
  static const nextTab = SingleActivator(LogicalKeyboardKey.tab, control: true);
  static const previousTab = SingleActivator(LogicalKeyboardKey.tab, control: true, shift: true);
  static const splitRight = SingleActivator(LogicalKeyboardKey.keyD, control: true, shift: true);
  static const splitDown = SingleActivator(LogicalKeyboardKey.keyE, control: true, shift: true);
  static const hostsPanel = SingleActivator(LogicalKeyboardKey.keyB, control: true, shift: true);
  static const palette = SingleActivator(LogicalKeyboardKey.keyP, control: true, shift: true);
  static const find = SingleActivator(LogicalKeyboardKey.keyF, control: true, shift: true);
  static const copy = SingleActivator(LogicalKeyboardKey.keyC, control: true, shift: true);
  static const paste = SingleActivator(LogicalKeyboardKey.keyV, control: true, shift: true);
  static const quit = SingleActivator(LogicalKeyboardKey.keyQ, control: true, shift: true);
  /// Ctrl+Alt+arrows move between panes, and Cmd+Option+arrows on a Mac
  /// or iPad. Alt (Option) with an arrow alone is the shell's: it moves by
  /// a word in zsh, fish and on a Mac, and tmux binds it too.
  static SingleActivator get focusLeft => _pane(LogicalKeyboardKey.arrowLeft);
  static SingleActivator get focusRight => _pane(LogicalKeyboardKey.arrowRight);
  static SingleActivator get focusUp => _pane(LogicalKeyboardKey.arrowUp);
  static SingleActivator get focusDown => _pane(LogicalKeyboardKey.arrowDown);

  static SingleActivator _pane(LogicalKeyboardKey arrow) => isApplePlatform
      ? SingleActivator(arrow, meta: true, alt: true)
      : SingleActivator(arrow, control: true, alt: true);
  static const zoomIn = SingleActivator(LogicalKeyboardKey.equal, control: true);
  static const zoomOut = SingleActivator(LogicalKeyboardKey.minus, control: true);
  static const zoomReset = SingleActivator(LogicalKeyboardKey.digit0, control: true);

  static const _digits = [
    LogicalKeyboardKey.digit1,
    LogicalKeyboardKey.digit2,
    LogicalKeyboardKey.digit3,
    LogicalKeyboardKey.digit4,
    LogicalKeyboardKey.digit5,
    LogicalKeyboardKey.digit6,
    LogicalKeyboardKey.digit7,
    LogicalKeyboardKey.digit8,
    LogicalKeyboardKey.digit9,
  ];

  /// Alt+1 to Alt+9 pick a tab; Cmd+1 to Cmd+9 on a Mac or iPad, where
  /// Option+digit types characters such as `#` on a UK Mac.
  static SingleActivator tab(int index) =>
      isApplePlatform ? SingleActivator(_digits[index], meta: true) : SingleActivator(_digits[index], alt: true);

  static final _ctrlShiftLetters = <LogicalKeyboardKey>{
    LogicalKeyboardKey.keyT,
    LogicalKeyboardKey.keyW,
    LogicalKeyboardKey.keyD,
    LogicalKeyboardKey.keyE,
    LogicalKeyboardKey.keyB,
    LogicalKeyboardKey.keyP,
    LogicalKeyboardKey.keyQ,
    LogicalKeyboardKey.tab,
  };

  /// True for a key press the terminal must leave alone so the window
  /// around it can act. Copy, paste, find and zoom are the terminal
  /// view's own and are not listed here.
  static bool isReserved(KeyEvent event) {
    final hw = HardwareKeyboard.instance;
    final key = event.logicalKey;
    if (hw.isControlPressed && key == LogicalKeyboardKey.tab) return true;
    if (hw.isControlPressed && hw.isShiftPressed && _ctrlShiftLetters.contains(key)) return true;
    // Exactly the keys the pane shortcuts take: with Shift as well, say,
    // they don't act, so the key stays the terminal's.
    if ([focusLeft, focusRight, focusUp, focusDown].any((a) => a.accepts(event, hw))) return true;
    final tabModifier = isApplePlatform ? hw.isMetaPressed : hw.isAltPressed && !hw.isControlPressed;
    if (tabModifier && _digits.contains(key)) return true;
    return false;
  }
}
