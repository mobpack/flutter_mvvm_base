/// Defines all route paths used in the application.
/// This centralizes route definitions for easier maintenance.
class RoutePaths {
  // Auth routes
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  
  // Main app routes
  static const home = '/';
  static const profile = '/profile';
  static const settings = '/settings';
  static const dynamicForm = '/dynamic-form';
  
  // Nested routes example
  static const nestedFeature = '/nested-feature';
  static const nestedFeatureDetail = '/nested-feature/detail';
  
  // Error routes
  static const notFound = '/404';
  static const error = '/error';
  
  // Public routes that don't require authentication
  static const List<String> publicRoutes = [
    splash,
    login,
    register,
    forgotPassword,
    notFound,
    error,
  ];
  
  /// Check if a route is public (doesn't require authentication)
  static bool isPublicRoute(String route) {
    return publicRoutes.any((path) => route.startsWith(path));
  }
}
