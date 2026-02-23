# Технический радар "Будущее 2.0"

## Статусы

| Статус | Описание | Действие |
|--------|----------|----------|
| **ADOPT** | Проверенные технологии | Использовать в новых проектах |
| **TRIAL** | Пилотирование | Пробовать в некритичных проектах |
| **ASSESS** | Оценка | Изучать, экспериментировать |
| **HOLD** | Отказ | Не использовать в новых проектах |

## Сводная таблица

### Архитектурные паттерны

| Технология/Паттерн | Статус | Приоритет | Применение |
|-------------------|--------|-----------|------------|
| Event-Driven Architecture | **ADOPT** | Высокий | Интеграция доменов, real-time обработка |
| Domain-Driven Design | **ADOPT** | Высокий | Проектирование bounded contexts |
| Microservices | **ADOPT** | Высокий | Архитектура всех сервисов |
| CQRS | **ADOPT** | Средний | Оптимизация read/write |
| Event Sourcing | **ADOPT** | Средний | Аудит, история изменений |
| API Gateway | **ADOPT** | Средний | Единая точка входа |
| Strangler Fig | **ADOPT** | Высокий | Миграция с legacy |
| Saga Pattern | **TRIAL** | Средний | Распределённые транзакции |
| Data Mesh | **TRIAL** | Средний | Децентрализация данных |
| Service Mesh | **ASSESS** | Низкий | Service-to-service коммуникация |
| Serverless | **ASSESS** | Низкий | Event handlers |
| Monolith | **HOLD** | - | Мигрируем на микросервисы |

### Платформы и инфраструктура

| Технология | Статус | Приоритет | Применение |
|-----------|--------|-----------|------------|
| Yandex Cloud | **ADOPT** | Высокий | Основная облачная платформа |
| Kubernetes | **ADOPT** | Высокий | Оркестрация контейнеров |
| Docker | **ADOPT** | Высокий | Контейнеризация |
| Terraform | **ADOPT** | Высокий | Infrastructure as Code |
| Yandex Managed K8s | **ADOPT** | Высокий | Managed Kubernetes |
| Yandex Object Storage | **ADOPT** | Высокий | Хранение изображений, архив |
| Helm | **ADOPT** | Средний | Пакетный менеджер K8s |
| ArgoCD | **TRIAL** | Средний | GitOps |
| Istio | **ASSESS** | Низкий | Service mesh |
| AWS | **HOLD** | - | Не соответствует ФЗ-152 |

### Данные и аналитика

| Технология | Статус | Приоритет | Применение |
|-----------|--------|-----------|------------|
| Apache Kafka | **ADOPT** | Высокий | Event streaming |
| PostgreSQL | **ADOPT** | Высокий | Operational databases |
| ClickHouse | **ADOPT** | Высокий | OLAP, аналитика |
| Redis | **ADOPT** | Средний | Кэширование |
| Elasticsearch | **ADOPT** | Средний | Логирование, поиск |
| Apache Spark | **TRIAL** | Средний | Обработка данных |
| Apache Airflow | **TRIAL** | Средний | Оркестрация pipelines |
| dbt | **TRIAL** | Средний | Трансформация данных |
| Apache Superset | **TRIAL** | Средний | BI платформа |
| Metabase | **ASSESS** | Низкий | Альтернатива Superset |
| MongoDB | **HOLD** | - | Не требуется |

### Разработка и DevOps

| Технология | Статус | Приоритет | Применение |
|-----------|--------|-----------|------------|
| Java/Spring Boot | **ADOPT** | Высокий | Backend микросервисы |
| Python | **ADOPT** | Высокий | AI/ML, data processing |
| TypeScript/Node.js | **ADOPT** | Средний | BFF, real-time сервисы |
| React | **ADOPT** | Средний | Frontend |
| GitHub Actions | **ADOPT** | Высокий | CI/CD |
| Prometheus | **ADOPT** | Высокий | Мониторинг |
| Grafana | **ADOPT** | Высокий | Визуализация метрик |
| Jaeger | **ADOPT** | Средний | Distributed tracing |
| ELK Stack | **ADOPT** | Средний | Централизованное логирование |
| Go | **TRIAL** | Средний | CLI tools, легковесные API |

### AI/ML

| Технология | Статус | Приоритет | Применение |
|-----------|--------|-----------|------------|
| PyTorch | **ADOPT** | Высокий | Deep learning |
| MLflow | **ADOPT** | Высокий | ML lifecycle management |
| MONAI | **ADOPT** | Высокий | Медицинские изображения |
| TensorFlow | **TRIAL** | Средний | Альтернатива PyTorch |
| Kubeflow | **ASSESS** | Низкий | ML platform для K8s |

## Roadmap внедрения

### 2026 Q1-Q2 (Фаза 1: Пилот)

**ADOPT:**
- Event-Driven Architecture (Kafka)
- Domain-Driven Design
- Microservices
- Yandex Cloud + Kubernetes
- PostgreSQL, Redis
- Java/Spring Boot, Python
- PyTorch, MLflow, MONAI
- GitHub Actions, Prometheus, Grafana

**TRIAL:**
- Saga Pattern (пилот на Payment)
- Data Mesh (пилот в Medical)

### 2026 Q3-Q4 (Фаза 2: Расширение)

**ADOPT:**
- CQRS, Event Sourcing
- ClickHouse
- Jaeger, ELK Stack

**TRIAL:**
- Apache Spark, Airflow
- dbt, Superset
- ArgoCD, Go

**ASSESS → TRIAL:**
- Service Mesh (Istio)
- Serverless

### 2027 Q1-Q2 (Фаза 3: Оптимизация)

**TRIAL → ADOPT:**
- Saga Pattern, Data Mesh
- Apache Spark, Airflow
- dbt, Superset

## Ключевые принципы

1. **Open Source First** - предпочтение open source решениям
2. **Cloud-Native** - Yandex Cloud + Kubernetes
3. **API-First** - все сервисы через API
4. **Security by Design** - безопасность с самого начала
5. **Compliance** - соответствие ФЗ-152, ФЗ-323

## Метрики успеха

**Технические:**
- API latency: p95 < 200ms
- Availability: 99.9%
- Deployment frequency: > 10/день

**Бизнес:**
- Time to market: -50%
- Infrastructure cost: -20%
- Developer productivity: +30%

---

**Следующее обновление:** Май 2026
