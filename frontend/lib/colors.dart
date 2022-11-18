import 'package:flutter/material.dart';

final colors = AppColors(Latte(), Latte().blue);

final colorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: colors.main.surface0,
  onPrimary: colors.main.text,
  secondary: colors.main.overlay0,
  onSecondary: colors.main.subtext0,
  error: colors.main.overlay0,
  onError: colors.main.red,
  background: colors.main.base,
  onBackground: colors.main.text,
  surface: colors.main.surface0,
  onSurface: colors.main.text,
);

class AppColors {
  final latte = Latte();
  final frappe = Frappe();
  final macchiato = Macchiato();
  final mocha = Mocha();
  final CatppuccinPallete main;
  final Color highlight;

  AppColors(CatppuccinPallete _main, Color _highlight)
      : main = _main,
        highlight = _highlight;
}

class CatppuccinPallete {
  final Color rosewater = Color(0xffffffff);
  final Color flamingo = Color(0xffffffff);
  final Color pink = Color(0xffffffff);
  final Color mauve = Color(0xffffffff);
  final Color red = Color(0xffffffff);
  final Color maroon = Color(0xffffffff);
  final Color peach = Color(0xffffffff);
  final Color yellow = Color(0xffffffff);
  final Color green = Color(0xffffffff);
  final Color teal = Color(0xffffffff);
  final Color sky = Color(0xffffffff);
  final Color sapphire = Color(0xffffffff);
  final Color blue = Color(0xffffffff);
  final Color lavender = Color(0xffffffff);
  final Color text = Color(0xffffffff);
  final Color subtext1 = Color(0xffffffff);
  final Color subtext0 = Color(0xffffffff);
  final Color overlay2 = Color(0xffffffff);
  final Color overlay1 = Color(0xffffffff);
  final Color overlay0 = Color(0xffffffff);
  final Color surface2 = Color(0xffffffff);
  final Color surface1 = Color(0xffffffff);
  final Color surface0 = Color(0xffffffff);
  final Color base = Color(0xffffffff);
  final Color mantle = Color(0xffffffff);
  final Color crust = Color(0xffffffff);
}

class Latte extends CatppuccinPallete {
  final Color rosewater = Color(0xffdc8a78);
  final Color flamingo = Color(0xffdd7878);
  final Color pink = Color(0xffea76cb);
  final Color mauve = Color(0xff8839ef);
  final Color red = Color(0xffd20f39);
  final Color maroon = Color(0xffe64553);
  final Color peach = Color(0xfffe640b);
  final Color yellow = Color(0xffdf8e1d);
  final Color green = Color(0xff40a02b);
  final Color teal = Color(0xff179299);
  final Color sky = Color(0xff04a5e5);
  final Color sapphire = Color(0xff209fb5);
  final Color blue = Color(0xff1e66f5);
  final Color lavender = Color(0xff7287fd);
  final Color text = Color(0xff4c4f69);
  final Color subtext1 = Color(0xff5c5f77);
  final Color subtext0 = Color(0xff6c6f85);
  final Color overlay2 = Color(0xff7c7f93);
  final Color overlay1 = Color(0xff8c8fa1);
  final Color overlay0 = Color(0xff9ca0b0);
  final Color surface2 = Color(0xffacb0be);
  final Color surface1 = Color(0xffbcc0cc);
  final Color surface0 = Color(0xffccd0da);
  final Color base = Color(0xffeff1f5);
  final Color mantle = Color(0xffe6e9ef);
  final Color crust = Color(0xffdce0e8);

  Latte();
}

class Frappe extends CatppuccinPallete {
  final Color rosewater = Color(0xfff2d5cf);
  final Color flamingo = Color(0xffeebebe);
  final Color pink = Color(0xfff4b8e4);
  final Color mauve = Color(0xffca9ee6);
  final Color red = Color(0xffe78284);
  final Color maroon = Color(0xffea999c);
  final Color peach = Color(0xffef9f76);
  final Color yellow = Color(0xffe5c890);
  final Color green = Color(0xffa6d189);
  final Color teal = Color(0xff81c8be);
  final Color sky = Color(0xff99d1db);
  final Color sapphire = Color(0xff85c1dc);
  final Color blue = Color(0xff8caaee);
  final Color lavender = Color(0xffbabbf1);
  final Color text = Color(0xffc6d0f5);
  final Color subtext1 = Color(0xffb5bfe2);
  final Color subtext0 = Color(0xffa5adce);
  final Color overlay2 = Color(0xff949cbb);
  final Color overlay1 = Color(0xff838ba7);
  final Color overlay0 = Color(0xff737994);
  final Color surface2 = Color(0xff626880);
  final Color surface1 = Color(0xff51576d);
  final Color surface0 = Color(0xff414559);
  final Color base = Color(0xff303446);
  final Color mantle = Color(0xff292c3c);
  final Color crust = Color(0xff232634);

  Frappe();
}

class Macchiato extends CatppuccinPallete {
  final Color rosewater = Color(0xfff4dbd6);
  final Color flamingo = Color(0xfff0c6c6);
  final Color pink = Color(0xfff5bde6);
  final Color mauve = Color(0xffc6a0f6);
  final Color red = Color(0xffed8796);
  final Color maroon = Color(0xffee99a0);
  final Color peach = Color(0xfff5a97f);
  final Color yellow = Color(0xffeed49f);
  final Color green = Color(0xffa6da95);
  final Color teal = Color(0xff8bd5ca);
  final Color sky = Color(0xff91d7e3);
  final Color sapphire = Color(0xff7dc4e4);
  final Color blue = Color(0xff8aadf4);
  final Color lavender = Color(0xffb7bdf8);
  final Color text = Color(0xffcad3f5);
  final Color subtext1 = Color(0xffb8c0e0);
  final Color subtext0 = Color(0xffa5adcb);
  final Color overlay2 = Color(0xff939ab7);
  final Color overlay1 = Color(0xff8087a2);
  final Color overlay0 = Color(0xff6e738d);
  final Color surface2 = Color(0xff5b6078);
  final Color surface1 = Color(0xff494d64);
  final Color surface0 = Color(0xff363a4f);
  final Color base = Color(0xff24273a);
  final Color mantle = Color(0xff1e2030);
  final Color crust = Color(0xff181926);

  Macchiato();
}

class Mocha extends CatppuccinPallete {
  final Color rosewater = Color(0xfff5e0dc);
  final Color flamingo = Color(0xfff2cdcd);
  final Color pink = Color(0xfff5c2e7);
  final Color mauve = Color(0xffcba6f7);
  final Color red = Color(0xfff38ba8);
  final Color maroon = Color(0xffeba0ac);
  final Color peach = Color(0xfffab387);
  final Color yellow = Color(0xfff9e2af);
  final Color green = Color(0xffa6e3a1);
  final Color teal = Color(0xff94e2d5);
  final Color sky = Color(0xff89dceb);
  final Color sapphire = Color(0xff74c7ec);
  final Color blue = Color(0xff89b4fa);
  final Color lavender = Color(0xffb4befe);
  final Color text = Color(0xffcdd6f4);
  final Color subtext1 = Color(0xffbac2de);
  final Color subtext0 = Color(0xffa6adc8);
  final Color overlay2 = Color(0xff9399b2);
  final Color overlay1 = Color(0xff7f849c);
  final Color overlay0 = Color(0xff6c7086);
  final Color surface2 = Color(0xff585b70);
  final Color surface1 = Color(0xff45475a);
  final Color surface0 = Color(0xff313244);
  final Color base = Color(0xff1e1e2e);
  final Color mantle = Color(0xff181825);
  final Color crust = Color(0xff11111b);

  Mocha();
}
