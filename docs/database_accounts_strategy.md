# Стратегия БД для учетных записей пользователей

## Что уже есть в проекте
- В мобильном приложении используется локальная БД Drift/SQLite (`AppDatabase`) и таблица `Users` с полями `email`, `password`, `role`.
- Логин сейчас проходит через `AppStateViewModel`/репозиторий и может работать с remote API через `ApiConfig.enableRemote`.

Важно: хранить пароль в виде plain text на клиенте нельзя для production — это годится только для локального демо-режима.

## Рекомендация по серверной БД
Для нового backend-а учетных записей лучше выбрать **MySQL** (или PostgreSQL). Между MySQL и SQL Server для этого проекта:

- **MySQL — предпочтительный вариант**:
  - проще и дешевле в эксплуатации (особенно Linux/Docker);
  - широкая поддержка в облаках и хостингах;
  - удобен для типового auth (users, sessions, refresh tokens, roles).
- **SQL Server** имеет смысл, если:
  - у вас уже корпоративный стек Microsoft (AD, SSIS, лицензии, DBA-практики);
  - нужны специфичные возможности экосистемы Microsoft.

Если инфраструктурных ограничений нет, стартуйте с MySQL.

## Минимальная схема auth (server-side)
1. `users`: `id`, `email (unique)`, `password_hash`, `role`, `status`, `created_at`, `updated_at`.
2. `user_profiles`: персональные поля, отдельно от auth-данных.
3. `refresh_tokens` (или `sessions`): `id`, `user_id`, `token_hash`, `expires_at`, `revoked_at`, `device_info`.

## Что поменять в приложении
1. Оставить Drift как offline cache/демо-режим.
2. Для remote auth:
   - пароль отправлять только на backend по HTTPS;
   - backend возвращает `access_token` + `refresh_token`;
   - хранить токены в secure storage, не в SQLite.
3. В локальной таблице `Users`:
   - убрать/не использовать поле `password` в production;
   - заменить на `passwordHash` только если реально нужен офлайн-логин (обычно не нужен).

## Этапы внедрения
1. Поднять backend auth API (`/auth/login`, `/auth/refresh`, `/auth/logout`, `/auth/me`).
2. Переключить `ApiConfig.enableRemote = true` и реализовать реальный `SchoolRemoteDataSource` для auth.
3. Добавить безопасное хранение токенов в приложении.
4. Включить миграции БД на backend (Flyway/Liquibase/Prisma migrations и т.п.).
5. После стабилизации удалить plain-text пароли из локальной БД и seed-данных.
