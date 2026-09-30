# Changelog

## 0.3.0

- Add the bounded `perPage` option to grouped search requests.
- Apply the official Dart formatter across the public models and services.

## 0.2.0

- Split excerpt-only `PoemSummary` list/search results from full-text `Poem` details.
- Add typed calendar-quota errors that are not retried automatically.

## 0.1.1

- Use the dedicated API host's canonical base URL: `https://api.aldiwan.net/v1`.

## 0.1.0

- Initial typed Dart and Flutter API client for the current developer API.
- Bearer API-key authentication, poems, poets, search, discovery, pagination, typed errors, timeout handling, and bounded `429` retries.
