# Технический радар

Adopt — используем; Trial — проверяем на пилоте; Hold — не расширяем.

| технология / паттерн | статус | назначение |
|---|---|---|
| Yandex Cloud: VM, сеть, Object Storage | Adopt | облачные среды и хранение |
| Terraform, GitLab CI | Adopt | развёртывание и удалённое состояние |
| PostgreSQL | Adopt | отдельные БД доменов |
| Kafka, каталог схем | Trial | события и версии контрактов |
| Event-Driven Architecture | Trial | независимые реакции доменов |
| Outbox, защита от повторов | Adopt | надёжная доставка и обработка |
| Strangler Fig, ACL | Adopt | постепенная замена легаси |
| Data Mesh, контракты и каталог продуктов | Trial | ответственность доменов за данные |
| S3 / Parquet | Adopt | история для пересчёта |
| ClickHouse | Trial | отчётные витрины |
| Self-service BI, Superset | Trial | отчёты и конструктор |
| Python / SQL | Adopt | обработка данных и ИИ |
| Go / Java | Adopt | существующие финтех-сервисы |
| SSO/OIDC, роли и аудит | Adopt | доступ к порталу и данным |
| SQL Server 2008, PowerBuilder, Camel, Power BI | Hold | поддержка до замены сценариев |
