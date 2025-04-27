# Responsive UI Guide

## Overview

This guide explains the approach to creating responsive and adaptive user interfaces in the Flutter MVVM Base project. The project uses a combination of tools and techniques to ensure that the UI looks and functions well across different screen sizes, orientations, and platforms.

## Tools and Libraries

The project uses the following tools and libraries for responsive UI:

1. **Flutter ScreenUtil**: For responsive sizing and scaling
2. **Responsive Framework**: For adaptive layouts and breakpoints
3. **MediaQuery**: For accessing device metrics
4. **LayoutBuilder**: For building widgets based on parent constraints
5. **Flex Widgets**: For flexible layouts with Row and Column

## ScreenUtil Configuration

ScreenUtil is configured in the `App` widget to provide consistent sizing across different devices:

```dart
ScreenUtilInit(
  designSize: const Size(360, 690), // Base design size
  minTextAdapt: true,
  splitScreenMode: true,
  builder: (context, child) {
    return MaterialApp(
      // App configuration
      builder: (context, child) {
        // Additional builders
        return child!;
      },
    );
  },
)
```

### Usage

ScreenUtil provides extension methods for responsive sizing:

```dart
// Responsive width and height
Container(
  width: 100.w,  // 100% of design width
  height: 50.h,  // 50% of design height
  child: Text(
    'Responsive Text',
    style: TextStyle(fontSize: 16.sp), // Responsive font size
  ),
)

// Responsive padding and margin
Padding(
  padding: EdgeInsets.all(16.r), // Responsive padding
  child: Container(
    margin: EdgeInsets.symmetric(
      horizontal: 8.w,
      vertical: 12.h,
    ),
    child: const Text('Content'),
  ),
)
```

## Responsive Framework

ResponsiveFramework is configured in the `App` widget to provide breakpoints and responsive behaviors:

```dart
MaterialApp(
  builder: (context, child) {
    // First wrap with ResponsiveBreakpoints
    final Widget responsiveChild = ResponsiveBreakpoints.builder(
      breakpoints: [
        const Breakpoint(start: 0, end: 450, name: MOBILE),
        const Breakpoint(start: 451, end: 800, name: TABLET),
        const Breakpoint(start: 801, end: 1920, name: DESKTOP),
        const Breakpoint(
          start: 1921,
          end: double.infinity,
          name: '4K',
        ),
      ],
      child: child!,
    );
    
    // Apply MediaQuery to ensure proper scaling
    final mediaQuery = MediaQuery.of(context);
    final scale = mediaQuery.textScaler;
    
    return MediaQuery(
      data: mediaQuery.copyWith(
        textScaler: scale.clamp(
          minScaleFactor: 0.8,
          maxScaleFactor: 1.0,
        ),
      ),
      child: responsiveChild,
    );
  },
)
```

### Usage

ResponsiveFramework provides utilities for checking the current breakpoint:

```dart
Widget build(BuildContext context) {
  // Check current breakpoint
  final bool isMobile = ResponsiveBreakpoints.of(context).isMobile;
  final bool isTablet = ResponsiveBreakpoints.of(context).isTablet;
  final bool isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
  
  // Adjust layout based on breakpoint
  return isMobile
      ? MobileLayout()
      : isTablet
          ? TabletLayout()
          : DesktopLayout();
}
```

## Responsive Layout Patterns

### Responsive Scaffold

The project includes a `ResponsiveScaffold` widget that adapts to different screen sizes:

```dart
class ResponsiveScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? drawer;
  
  const ResponsiveScaffold({
    Key? key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.drawer,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final bool isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final bool isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
        // Adjust app bar height for desktop
        toolbarHeight: isDesktop ? 64 : 56,
      ),
      // Show drawer on mobile, side navigation on desktop
      drawer: isMobile ? drawer : null,
      body: Row(
        children: [
          // Side navigation for desktop
          if (!isMobile && drawer != null)
            SizedBox(
              width: 250,
              child: drawer!,
            ),
          // Main content
          Expanded(child: body),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
```

### Responsive Grid

The project includes a `ResponsiveGrid` widget for creating responsive grid layouts:

```dart
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  
  const ResponsiveGrid({
    Key? key,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Determine number of columns based on screen width
    final width = MediaQuery.of(context).size.width;
    int crossAxisCount;
    
    if (width < 600) {
      crossAxisCount = 1; // Mobile
    } else if (width < 900) {
      crossAxisCount = 2; // Tablet
    } else if (width < 1200) {
      crossAxisCount = 3; // Small desktop
    } else {
      crossAxisCount = 4; // Large desktop
    }
    
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: runSpacing,
        childAspectRatio: 1.0,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}
```

### Conditional Layout

The project uses conditional layouts to adapt to different screen sizes:

```dart
Widget build(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  
  // Stack layout for mobile, side-by-side for larger screens
  if (width < 600) {
    return Column(
      children: [
        ImageSection(),
        ContentSection(),
      ],
    );
  } else {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ImageSection(),
        ),
        Expanded(
          flex: 3,
          child: ContentSection(),
        ),
      ],
    );
  }
}
```

## Adaptive Widgets

The project includes adaptive widgets that adjust their appearance and behavior based on the platform and screen size:

### Adaptive Button

```dart
class AdaptiveButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isPrimary;
  
  const AdaptiveButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.isPrimary = true,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    
    // Use platform-specific button styles
    if (platform == TargetPlatform.iOS) {
      return CupertinoButton(
        onPressed: onPressed,
        color: isPrimary ? Theme.of(context).primaryColor : null,
        child: Text(label),
      );
    } else {
      return isPrimary
          ? ElevatedButton(
              onPressed: onPressed,
              child: Text(label),
            )
          : TextButton(
              onPressed: onPressed,
              child: Text(label),
            );
    }
  }
}
```

### Adaptive Dialog

```dart
Future<T?> showAdaptiveDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required List<AdaptiveDialogAction> actions,
}) {
  final platform = Theme.of(context).platform;
  
  if (platform == TargetPlatform.iOS) {
    return showCupertinoDialog<T>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: actions.map((action) => CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(action.value),
          isDefaultAction: action.isDefault,
          isDestructiveAction: action.isDestructive,
          child: Text(action.label),
        )).toList(),
      ),
    );
  } else {
    return showDialog<T>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: actions.map((action) => TextButton(
          onPressed: () => Navigator.of(context).pop(action.value),
          child: Text(action.label),
        )).toList(),
      ),
    );
  }
}

class AdaptiveDialogAction {
  final String label;
  final dynamic value;
  final bool isDefault;
  final bool isDestructive;
  
  const AdaptiveDialogAction({
    required this.label,
    required this.value,
    this.isDefault = false,
    this.isDestructive = false,
  });
}
```

## Orientation Handling

The project handles different orientations to ensure a good user experience in both portrait and landscape modes:

```dart
Widget build(BuildContext context) {
  final orientation = MediaQuery.of(context).orientation;
  
  return orientation == Orientation.portrait
      ? PortraitLayout()
      : LandscapeLayout();
}

class PortraitLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeaderSection(),
        Expanded(child: ContentSection()),
        FooterSection(),
      ],
    );
  }
}

class LandscapeLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        HeaderSection(),
        Expanded(child: ContentSection()),
        FooterSection(),
      ],
    );
  }
}
```

## Text Scaling

The project handles text scaling to ensure readability while maintaining layout integrity:

```dart
MaterialApp(
  builder: (context, child) {
    final mediaQuery = MediaQuery.of(context);
    final scale = mediaQuery.textScaler;
    
    return MediaQuery(
      data: mediaQuery.copyWith(
        textScaler: scale.clamp(
          minScaleFactor: 0.8,
          maxScaleFactor: 1.0,
        ),
      ),
      child: child!,
    );
  },
)
```

## Device Preview

For testing responsive layouts during development, the project can use the [device_preview](https://pub.dev/packages/device_preview) package:

```dart
void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const App(),
    ),
  );
}
```

## Best Practices

### 1. Design for Mobile First

Start with mobile layouts and then adapt for larger screens. This ensures a good experience on the most constrained devices.

### 2. Use Relative Sizing

Use relative sizing (e.g., percentages, flex) rather than fixed sizes to ensure layouts adapt to different screen sizes.

```dart
Container(
  width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
  child: const Text('Responsive Width'),
)
```

### 3. Test on Multiple Devices

Test your layouts on a variety of devices and screen sizes to ensure they look good everywhere.

### 4. Use Constraints

Use constraints to ensure widgets have reasonable sizes:

```dart
ConstrainedBox(
  constraints: const BoxConstraints(
    maxWidth: 600, // Maximum width
  ),
  child: const TextField(),
)
```

### 5. Avoid Fixed Heights

Avoid fixed heights for widgets that contain text, as text size can vary based on user settings and translations.

### 6. Use LayoutBuilder

Use LayoutBuilder to build widgets based on the available space:

```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < 600) {
      return MobileLayout();
    } else {
      return DesktopLayout();
    }
  },
)
```

### 7. Handle Text Overflow

Handle text overflow to prevent layout issues:

```dart
Text(
  'This is a long text that might overflow',
  overflow: TextOverflow.ellipsis,
  maxLines: 2,
)
```

### 8. Use Flexible and Expanded

Use Flexible and Expanded widgets to create layouts that adapt to available space:

```dart
Row(
  children: [
    Flexible(
      flex: 1,
      child: Container(color: Colors.red),
    ),
    Flexible(
      flex: 2,
      child: Container(color: Colors.blue),
    ),
  ],
)
```

### 9. Consider Accessibility

Ensure that your responsive layouts work well with accessibility features like larger text sizes and screen readers.

### 10. Use Named Breakpoints

Use named breakpoints for consistency across the application:

```dart
class AppBreakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

Widget build(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  
  if (width < AppBreakpoints.mobile) {
    return MobileLayout();
  } else if (width < AppBreakpoints.tablet) {
    return TabletLayout();
  } else {
    return DesktopLayout();
  }
}
```

## Conclusion

Creating responsive and adaptive UIs in Flutter requires a combination of tools, techniques, and best practices. By following the guidelines in this document, you can ensure that your Flutter MVVM Base project provides a great user experience across a wide range of devices and screen sizes.
