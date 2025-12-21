
class OAuthConfig {
  // GitHub OAuth Configuration
  static const String githubClientId = 'Ov23lih6jQxyV9TEeRtN';
  static const String githubClientSecret = 'c706f2df1ea2c58a30ade7643573183e78731070';
  static const String githubRedirectUri = 'autopaleis://oauth-callback';
  static const String githubAuthorizationEndpoint = 'https://github.com/login/oauth/authorize';
  static const String githubTokenEndpoint = 'https://github.com/login/oauth/access_token';
  static const String githubUserEndpoint = 'https://api.github.com/user';
  
  // Scopes for GitHub OAuth
  static const List<String> githubScopes = ['read:user', 'user:email'];
  
  // Backend OAuth endpoint
  static const String backendOAuthEndpoint = 'http://localhost:8080/api/oauth/github';
}
