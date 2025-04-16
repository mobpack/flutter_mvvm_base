// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:widgetbook/widgetbook.dart' as _i1;
import 'package:widgetbook_workspace/buttons/widgetbook_filled_button.dart'
    as _i2;
import 'package:widgetbook_workspace/colors/widgetbook_colors.dart' as _i4;
import 'package:widgetbook_workspace/screen/widgetbook_form_screen.dart' as _i3;

final directories = <_i1.WidgetbookNode>[
  _i1.WidgetbookFolder(
    name: 'material',
    children: [
      _i1.WidgetbookLeafComponent(
        name: 'FilledButton',
        useCase: _i1.WidgetbookUseCase(
          name: 'Default',
          builder: _i2.buildAppFilledButtonUseCase,
        ),
      ),
    ],
  ),
  _i1.WidgetbookFolder(
    name: 'ui',
    children: [
      _i1.WidgetbookFolder(
        name: 'common',
        children: [
          _i1.WidgetbookFolder(
            name: 'forms',
            children: [
              _i1.WidgetbookFolder(
                name: 'dynamic_form',
                children: [
                  _i1.WidgetbookLeafComponent(
                    name: 'ExampleFormScreen',
                    useCase: _i1.WidgetbookUseCase(
                      name: 'Default',
                      builder: _i3.buildWidgetbookFormUseCase,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  _i1.WidgetbookFolder(
    name: 'widgets',
    children: [
      _i1.WidgetbookLeafComponent(
        name: 'Widget',
        useCase: _i1.WidgetbookUseCase(
          name: 'Color Scheme',
          builder: _i4.buildColorSchemeUseCase,
        ),
      ),
    ],
  ),
];
