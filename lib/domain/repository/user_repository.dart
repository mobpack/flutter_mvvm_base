/// Interface for user-related operations with Supabase
abstract class IUserRepository {
  /// Fetches the user data from the Supabase 'users' table by user ID
  /// Returns a Map of user data or null if not found
  Future<Map<String, dynamic>?> getUserData(String userId);

  /// Updates user data in the Supabase 'users' table
  /// Returns the updated user data
  Future<Map<String, dynamic>> updateUserData(
    String userId,
    Map<String, dynamic> data,
  );

  /// Creates a new user record in the Supabase 'users' table
  /// This is typically called after a new user signs up
  Future<Map<String, dynamic>> createUserData(
    String userId,
    Map<String, dynamic> data,
  );
}
