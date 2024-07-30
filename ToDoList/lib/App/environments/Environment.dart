import 'dart:io';

abstract class Environment {
  final Configurations? config;
  final String? domain;
  final String? oauthUrl;
  final String? publicUrl;
  final String Function(String)? appUrl;
  final String? webAppUrl;
  final String? msGraphUrl;
  final String? notificationsUrl;
  final Map<String, String>? authExp;
  final Map<String, String>? authNonExp;
  final Map<String, String>? authMsExp;
  final Duration? imgStoreCacheLifetimeDuration;
  final Duration? fileStoreCacheLifetimeDuration;
  final Set<String>? msLoginSupportedCompanyUrls;
  final String? workspace;
  final bool localLoggingEnabled;
  static const maxServerCallsPerPeriod = 1;
  static const maxServerCallsPeriod = Duration(milliseconds: 100);

  const Environment({
    required this.localLoggingEnabled,
  this.config,
    this.domain,
    this.oauthUrl,
    this.publicUrl,
    this.appUrl,
    this.webAppUrl,
    this.msGraphUrl,
    this.authExp,
    this.notificationsUrl,
    this.authNonExp,
    this.authMsExp,
    this.imgStoreCacheLifetimeDuration,
    this.fileStoreCacheLifetimeDuration,
    this.msLoginSupportedCompanyUrls,
    this.workspace,
  });
}

class DebugEnvironment extends Environment {
  DebugEnvironment()
      : super(
            config: Configurations.dev,
            domain: 'raiser.work',
            oauthUrl: 'https://auth.raiser.work/',
            publicUrl: 'https://auth.raiser.work/api/',
            appUrl: (version) => 'https://api.raiser.work/api/v$version/m/',
            webAppUrl: 'https://api.raiser.work/api/',
            msGraphUrl: 'https://graph.microsoft.com/v1.0/',
            notificationsUrl: 'https://notification.raiser.work/api/',
            workspace: 'test',
            authExp: const {
              'scope': 'api3 offline_access',
              'client_secret': 'secret',
              'client_id': 'angularapi1',
            },
            authNonExp: const {
              'scope': 'api3 offline_access',
              'client_secret': 'secret',
              'client_id': 'mobileapi1',
            },
            authMsExp: const {
              'scope': 'api3 offline_access',
              'client_secret': 'secret',
              'client_id': 'oidc',
            },
            localLoggingEnabled: true,
            imgStoreCacheLifetimeDuration: const Duration(microseconds: 1),
            fileStoreCacheLifetimeDuration: const Duration(minutes: 10));
}

class StageEnvironment extends Environment {
//  https://alenastagetest2.raiser.fun/#/login
//  alenastagetest2@yopmail.com
//  Volo12345

  StageEnvironment()
      : super(
            config: Configurations.stage,
            domain: 'raiser.fun',
            oauthUrl: 'https://auth.raiser.fun/',
            publicUrl: 'https://auth.raiser.fun/api/',
            appUrl: (version) => 'https://api.raiser.fun/api/v$version/m/',
            webAppUrl: 'https://api.raiser.fun/api/',
            msGraphUrl: 'https://graph.microsoft.com/v1.0/',
            notificationsUrl: 'https://notification.raiser.fun/api/',
            workspace: 'alenastagetest2',
            authExp: const {
              'scope': 'api3 offline_access',
              'client_secret': 'secret',
              'client_id': 'angularapi1',
            },
            authNonExp: const {
              'scope': 'api3 offline_access',
              'client_secret': 'secret',
              'client_id': 'mobileapi1',
            },
            authMsExp: const {
              'scope': 'api3 offline_access',
              'client_secret': 'secret',
              'client_id': 'oidc',
            },
            localLoggingEnabled: false,
            imgStoreCacheLifetimeDuration: const Duration(minutes: 1),
            fileStoreCacheLifetimeDuration: const Duration(days: 1));
}

class ProdEnvironment extends Environment {
  // robert.apikyan@volo.global
  ProdEnvironment()
      : super(
            config: Configurations.prod,
            domain: 'raiser.global',
            oauthUrl: 'https://auth.raiser.global/',
            publicUrl: 'https://auth.raiser.global/api/',
            appUrl: (version) => 'https://api.raiser.global/api/v$version/m/',
            webAppUrl: 'https://api.raiser.global/api/',
            msGraphUrl: 'https://graph.microsoft.com/v1.0/',
            notificationsUrl: 'https://notification.raiser.global/api/',
            workspace: 'volo',
            authExp: const {
              'scope': 'api3 offline_access',
              'client_secret': 'secret',
              'client_id': 'angularapi1',
            },
            authNonExp: const {
              'scope': 'api3 offline_access',
              'client_secret': 'secret',
              'client_id': 'mobileapi1',
            },
            authMsExp: const {
              'scope': 'api3 offline_access',
              'client_secret': 'secret',
              'client_id': 'oidc',
            },
            localLoggingEnabled: false,//TODO(@Tumsyan):Local events enabled
            imgStoreCacheLifetimeDuration: const Duration(minutes: 1),
            fileStoreCacheLifetimeDuration: const Duration(days: 1),
            msLoginSupportedCompanyUrls: {'volo'});
}

enum Configurations { dev, stage, prod }
