# Event Storming - Событийная архитектура "Будущее 2.0"

## Обзор

Event Storming - это метод моделирования бизнес-процессов через события. В этом документе представлена событийная архитектура системы «Будущее 2.0».

### Легенда

- 🟠 **Event** (Событие) - что-то произошло в системе
- 🔵 **Command** (Команда) - действие пользователя или системы
- 🟡 **Aggregate** (Агрегат) - бизнес-сущность, обрабатывающая команды
- 🟢 **Policy** (Политика) - автоматическая реакция на событие
- 🔴 **External System** (Внешняя система)
- 👤 **Actor** (Актор) - пользователь или система

---

## Event Flow Diagram

```mermaid
graph LR
    subgraph "Medical Domain"
        U1[👤 Пациент] -->|RegisterPatient| C1[🔵 Register]
        C1 --> A1[🟡 Patient]
        A1 --> E1[🟠 PatientRegistered]

        U2[👤 Пациент] -->|ScheduleAppointment| C2[🔵 Schedule]
        C2 --> A2[🟡 Appointment]
        A2 --> E2[🟠 AppointmentScheduled]

        U3[👤 Врач] -->|SignRecord| C3[🔵 Sign]
        C3 --> A3[🟡 MedicalRecord]
        A3 --> E3[🟠 MedicalRecordSigned]

        U4[👤 Лаборант] -->|UploadImage| C4[🔵 Upload]
        C4 --> A4[🟡 MedicalImage]
        A4 --> E4[🟠 MedicalImageUploaded]
    end

    subgraph "Fintech Domain"
        E2 -->|🟢 CreateInvoicePolicy| C6[🔵 CreateInvoice]
        C6 --> A6[🟡 Invoice]
        A6 --> E6[🟠 InvoiceCreated]

        U5[👤 Пациент] -->|MakePayment| C7[🔵 InitiatePayment]
        C7 --> A7[🟡 Payment]
        A7 --> E7[🟠 PaymentCompleted]

        E7 -->|🟢 UpdateInvoicePolicy| A6
        A6 --> E8[🟠 InvoiceFullyPaid]
    end

    subgraph "AI Domain"
        E4 -->|🟢 RequestAIAnalysisPolicy| C8[🔵 RequestAnalysis]
        C8 --> A8[🟡 AIAnalysis]
        A8 --> E9[🟠 AIAnalysisCompleted]

        A8 --> E10[🟠 AIFindingDetected]
    end

    subgraph "Data Domain"
        E1 --> DI[📥 Event Consumer]
        E2 --> DI
        E7 --> DI
        E9 --> DI
        DI --> DP[🟡 DataPipeline]
        DP --> E12[🟠 PipelineCompleted]
        E12 --> DS[💾 Data Lake/DWH/OLAP]
    end

    style E1 fill:#ff9900
    style E2 fill:#ff9900
    style E3 fill:#ff9900
    style E4 fill:#ff9900
    style E6 fill:#ff9900
    style E7 fill:#ff9900
    style E8 fill:#ff9900
    style E9 fill:#ff9900
    style E10 fill:#ff9900
    style E12 fill:#ff9900
```

---

## Детальные Event Flows

### 1. Patient Registration Flow (Регистрация пациента)

```mermaid
graph TD
    Actor[👤 Пациент] -->|RegisterPatient| Cmd1[🔵 RegisterPatientCommand]
    Cmd1 --> Agg1[🟡 Patient Aggregate]
    Agg1 -->|validates & creates| Evt1[🟠 PatientRegistered]
    Evt1 -->|🟢 SendWelcomeEmailPolicy| Notif[📧 Notification Service]
    Evt1 -->|stream| Data[📊 Data Lake]

    style Evt1 fill:#ff9900
    style Cmd1 fill:#4a90e2
    style Agg1 fill:#f5d742
    style Actor fill:#e8f5e9
```

**Участники:**
- **Actor**: Пациент, Оператор
- **Aggregate**: Patient
- **Events**: PatientRegistered
- **Policies**: SendWelcomeEmailPolicy
- **Downstream**: Notification Service, Data Lake

---

### 2. Appointment Scheduling Flow (Запись на прием)

```mermaid
graph TD
    Actor[👤 Пациент] -->|ScheduleAppointment| Cmd1[🔵 ScheduleAppointmentCommand]
    Cmd1 --> Agg1[🟡 Appointment Aggregate]
    Agg1 -->|checks availability & creates| Evt1[🟠 AppointmentScheduled]

    Evt1 -->|🟢 CreateInvoicePolicy| Invoice[💰 Invoice Service]
    Evt1 -->|🟢 SendReminderPolicy| Notif[📧 Notification Service]
    Evt1 -->|🟢 BlockTimeSlotPolicy| Calendar[📅 Calendar Service]
    Evt1 -->|stream| Data[📊 Data Lake]

    Payment[🟠 PaymentCompleted] -->|🟢 ConfirmAppointmentPolicy| Cmd2[🔵 ConfirmAppointmentCommand]
    Cmd2 --> Agg1
    Agg1 --> Evt2[🟠 AppointmentConfirmed]

    style Evt1 fill:#ff9900
    style Evt2 fill:#ff9900
    style Payment fill:#ff9900
    style Cmd1 fill:#4a90e2
    style Cmd2 fill:#4a90e2
    style Agg1 fill:#f5d742
```

**Участники:**
- **Actor**: Пациент, Оператор
- **Aggregate**: Appointment, Schedule
- **Events**: AppointmentScheduled, AppointmentConfirmed, TimeSlotBlocked
- **Policies**: CreateInvoicePolicy, SendReminderPolicy, BlockTimeSlotPolicy, ConfirmAppointmentPolicy
- **Downstream**: Fintech (Invoice, Payment), Platform (Notifications), Data

---

### 3. Medical Treatment Flow (Медицинское лечение)

```mermaid
graph TD
    Doctor[👤 Врач] -->|CreateMedicalRecord| Cmd1[🔵 CreateMedicalRecordCommand]
    Cmd1 --> Agg1[🟡 MedicalRecord Aggregate]
    Agg1 --> Evt1[🟠 MedicalRecordCreated]
    Evt1 --> Data[📊 Data Lake]

    Doctor -->|AddDiagnosis| Cmd2[🔵 AddDiagnosisCommand]
    Cmd2 --> Agg1
    Agg1 --> Evt2[🟠 DiagnosisAdded]
    Evt2 --> Analytics[📈 Analytics Service]

    Doctor -->|SignRecord| Cmd3[🔵 SignRecordCommand]
    Cmd3 --> Agg1
    Agg1 --> Evt3[🟠 MedicalRecordSigned]
    Evt3 -->|🟢 CreateInvoicePolicy| Invoice[💰 Billing Service]
    Evt3 --> Audit[🔍 Audit Service]

    style Evt1 fill:#ff9900
    style Evt2 fill:#ff9900
    style Evt3 fill:#ff9900
    style Cmd1 fill:#4a90e2
    style Cmd2 fill:#4a90e2
    style Cmd3 fill:#4a90e2
    style Agg1 fill:#f5d742
```

**Участники:**
- **Actor**: Врач
- **Aggregate**: MedicalRecord
- **Events**: MedicalRecordCreated, DiagnosisAdded, MedicalRecordSigned
- **Policies**: CreateInvoicePolicy
- **Downstream**: Billing Service, Analytics Service, Audit Service, Data Lake

---

### 4. Medical Imaging & AI Analysis Flow (Медицинские снимки и AI анализ)

```mermaid
graph TD
    Lab[👤 Лаборант] -->|UploadImage| Cmd1[🔵 UploadImageCommand]
    Cmd1 --> Agg1[🟡 MedicalImage Aggregate]
    Agg1 -->|validates & stores| Evt1[🟠 MedicalImageUploaded]

    Evt1 -->|🟢 RequestAIAnalysisPolicy| Cmd2[🔵 RequestAIAnalysis]
    Cmd2 --> Agg2[🟡 AIAnalysis Aggregate]
    Agg2 --> Evt2[🟠 AIAnalysisStarted]

    Agg2 -->|analyzes with ML| Evt3[🟠 AIFindingDetected]
    Evt3 -->|if urgent| Notif[📧 Urgent Notification]

    Agg2 --> Evt4[🟠 AIAnalysisCompleted]
    Evt4 --> MedImg[🏥 Medical Image Service]
    Evt4 --> Data[📊 Data Lake]

    style Evt1 fill:#ff9900
    style Evt2 fill:#ff9900
    style Evt3 fill:#ff9900
    style Evt4 fill:#ff9900
    style Cmd1 fill:#4a90e2
    style Cmd2 fill:#4a90e2
    style Agg1 fill:#f5d742
    style Agg2 fill:#f5d742
```

**Участники:**
- **Actor**: Лаборант, AI System
- **Aggregate**: MedicalImage, AIAnalysis
- **Events**: MedicalImageUploaded, AIAnalysisStarted, AIFindingDetected, AIAnalysisCompleted
- **Policies**: RequestAIAnalysisPolicy
- **Downstream**: AI Analysis Service, Medical Image Service, Notification Service, Data Lake

---

### 5. Payment Processing Flow (Обработка платежей)

```mermaid
graph TD
    InvEvt[🟠 InvoiceCreated] -->|🟢 SendPaymentLinkPolicy| Notif1[📧 Send Payment Link]

    Patient[👤 Пациент] -->|MakePayment| Cmd1[🔵 InitiatePaymentCommand]
    Cmd1 --> Agg1[🟡 Payment Aggregate]
    Agg1 --> Evt1[🟠 PaymentInitiated]

    Evt1 --> Gateway[🔴 Payment Gateway]
    Gateway -->|success| Evt2[🟠 PaymentCompleted]
    Gateway -->|failure| Evt3[🟠 PaymentFailed]

    Evt2 -->|🟢 UpdateInvoicePolicy| Invoice[💰 Invoice Service]
    Evt2 -->|🟢 ConfirmAppointmentPolicy| Appt[📅 Appointment Service]
    Evt2 -->|🟢 SendReceiptPolicy| Notif2[📧 Send Receipt]
    Evt2 --> Data[📊 Data Lake]

    Evt3 -->|🟢 RetryPaymentPolicy| Retry[🔄 Retry Service]
    Evt3 -->|🟢 NotifyPatientPolicy| Notif3[📧 Notify Failure]

    style InvEvt fill:#ff9900
    style Evt1 fill:#ff9900
    style Evt2 fill:#ff9900
    style Evt3 fill:#ff9900
    style Cmd1 fill:#4a90e2
    style Agg1 fill:#f5d742
    style Gateway fill:#ff6b6b
```

**Участники:**
- **Actor**: Пациент
- **Aggregate**: Payment
- **Events**: PaymentInitiated, PaymentCompleted, PaymentFailed
- **Policies**: SendPaymentLinkPolicy, UpdateInvoicePolicy, ConfirmAppointmentPolicy, SendReceiptPolicy, RetryPaymentPolicy, NotifyPatientPolicy
- **Downstream**: Invoice Service, Appointment Service, Notification Service, Data Lake
- **External**: Payment Gateway

---

### 6. Loan Application Flow (Заявка на кредит)

```mermaid
graph TD
    Patient[👤 Пациент] -->|ApplyForLoan| Cmd1[🔵 SubmitLoanApplicationCommand]
    Cmd1 --> Agg1[🟡 LoanApplication Aggregate]
    Agg1 --> Evt1[🟠 LoanApplicationSubmitted]

    Evt1 -->|🟢 AssessCreditScorePolicy| Credit[💳 Credit Scoring Service]
    Credit --> Evt2[🟠 CreditScoreCalculated]

    Evt2 -->|🟢 ApproveLoanPolicy| Cmd2[🔵 ApproveLoanCommand]
    Cmd2 --> Agg1
    Agg1 --> Evt3[🟠 LoanApplicationApproved]

    Evt3 --> Payment[💰 Payment Service]
    Evt3 --> Notif[📧 Notification Service]
    Evt3 --> Contract[📄 Contract Service]
    Evt3 --> Data[📊 Data Lake]

    Evt2 -->|if rejected| Evt4[🟠 LoanApplicationRejected]
    Evt4 --> Notif

    style Evt1 fill:#ff9900
    style Evt2 fill:#ff9900
    style Evt3 fill:#ff9900
    style Evt4 fill:#ff9900
    style Cmd1 fill:#4a90e2
    style Cmd2 fill:#4a90e2
    style Agg1 fill:#f5d742
```

**Участники:**
- **Actor**: Пациент
- **Aggregate**: LoanApplication
- **Events**: LoanApplicationSubmitted, LoanApplicationApproved, LoanApplicationRejected
- **Policies**: AssessCreditScorePolicy, ApproveLoanPolicy
- **Downstream**: Credit Scoring Service, Payment Service, Notification Service, Contract Service, Data Lake

---

### 7. Data Analytics Flow (Аналитика данных)

```mermaid
graph TD
    Events[🟠 Domain Events] -->|Kafka| Consumer[📥 Event Consumer]
    Consumer --> Agg1[🟡 DataPipeline Aggregate]

    Agg1 --> Evt1[🟠 PipelineStarted]
    Agg1 -->|transforms & aggregates| Evt2[🟠 PipelineCompleted]
    Agg1 -->|on error| Evt3[🟠 PipelineFailed]

    Evt2 --> Lake[💾 Data Lake]
    Evt2 --> DWH[💾 Data Warehouse]
    Evt2 --> OLAP[💾 OLAP]

    Evt3 --> Monitor[📊 Monitoring Service]
    Evt3 --> OnCall[🚨 On-Call Service]

    %% Аналитик работает с обработанными данными
    Analyst[👤 Аналитик] -->|GenerateReport| Cmd1[🔵 GenerateReportCommand]
    Cmd1 --> Agg2[🟡 AnalyticsReport Aggregate]

    %% Отчет читает данные из хранилищ
    DWH -.->|reads data| Agg2
    OLAP -.->|reads data| Agg2

    Agg2 --> Evt4[🟠 ReportGenerated]
    Evt4 --> Portal[📊 Data Portal]
    Evt4 --> Analyst

    style Evt1 fill:#ff9900
    style Evt2 fill:#ff9900
    style Evt3 fill:#ff9900
    style Evt4 fill:#ff9900
    style Cmd1 fill:#4a90e2
    style Agg1 fill:#f5d742
    style Agg2 fill:#f5d742
```

**Участники:**
- **Actor**: Аналитик
- **Aggregate**: DataPipeline, AnalyticsReport
- **Events**: PipelineStarted, PipelineCompleted, PipelineFailed, ReportGenerated
- **Policies**: None (event-driven processing)
- **Upstream**: All domain events via Kafka
- **Storage**: Data Lake, Data Warehouse, OLAP

---

## Event Catalog Summary

### Medical Domain Events

| Event | Aggregate | Trigger | Subscribers |
|-------|-----------|---------|-------------|
| PatientRegistered | Patient | RegisterPatient command | Appointment Service, Billing Service, Analytics Service, Notification Service |
| PatientInfoUpdated | Patient | UpdatePatient command | Notification Service, Analytics Service |
| AppointmentScheduled | Appointment | ScheduleAppointment command | Billing Service, Notification Service, Calendar Service, Analytics Service |
| AppointmentConfirmed | Appointment | PaymentCompleted event | Notification Service, Analytics Service |
| AppointmentCancelled | Appointment | CancelAppointment command | Billing Service, Notification Service, Calendar Service, Analytics Service |
| AppointmentCompleted | Appointment | CompleteAppointment command | Medical Record Service, Billing Service, Analytics Service |
| MedicalRecordCreated | MedicalRecord | CreateMedicalRecord command | Analytics Service, Audit Service |
| DiagnosisAdded | MedicalRecord | AddDiagnosis command | Analytics Service, Clinical Decision Support, Quality Assurance |
| PrescriptionAdded | MedicalRecord | AddPrescription command | Pharmacy Service, Drug Interaction Service, Analytics Service |
| MedicalRecordSigned | MedicalRecord | SignRecord command | Audit Service, Analytics Service, Patient Portal |
| MedicalImageUploaded | MedicalImage | UploadImage command | AI Analysis Service, PACS Integration, Analytics Service |
| AIAnalysisRequested | MedicalImage | RequestAIAnalysis command | AI Analysis Service |

### Fintech Domain Events

| Event | Aggregate | Trigger | Subscribers |
|-------|-----------|---------|-------------|
| InvoiceCreated | Invoice | CreateInvoice command | Payment Service, Notification Service, Analytics Service |
| InvoiceIssued | Invoice | IssueInvoice command | Notification Service, Payment Service, Analytics Service |
| InvoiceFullyPaid | Invoice | PaymentCompleted event | Notification Service, Analytics Service, Accounting Service |
| PaymentInitiated | Payment | InitiatePayment command | Payment Gateway, Analytics Service |
| PaymentCompleted | Payment | Payment Gateway response | Invoice Service, Notification Service, Analytics Service, Accounting Service |
| PaymentFailed | Payment | Payment Gateway response | Notification Service, Analytics Service, Retry Service |
| LoanApplicationSubmitted | LoanApplication | SubmitApplication command | Credit Scoring Service, Notification Service, Analytics Service |
| LoanApplicationApproved | LoanApplication | ApproveApplication command | Payment Service, Notification Service, Analytics Service, Contract Service |
| LoanApplicationRejected | LoanApplication | RejectApplication command | Notification Service, Analytics Service |

### AI Domain Events

| Event | Aggregate | Trigger | Subscribers |
|-------|-----------|---------|-------------|
| AIAnalysisStarted | AIAnalysis | StartProcessing command | Monitoring Service, Analytics Service |
| AIFindingDetected | AIAnalysis | AI detection | Medical Record Service, Notification Service, Analytics Service |
| AIAnalysisCompleted | AIAnalysis | CompleteAnalysis command | Medical Image Service, Notification Service, Analytics Service, Quality Assurance |
| AIModelRegistered | AIModel | RegisterModel command | Model Monitoring Service, Analytics Service |
| ModelPromotedToProduction | AIModel | PromoteToProduction command | AI Analysis Service, Notification Service, Analytics Service |

### Data Domain Events

| Event | Aggregate | Trigger | Subscribers |
|-------|-----------|---------|-------------|
| ReportGenerated | AnalyticsReport | GenerateReport command | Notification Service, Audit Service |
| PipelineStarted | DataPipeline | StartPipeline command | Monitoring Service, Analytics Service |
| PipelineCompleted | DataPipeline | Pipeline completion | Monitoring Service, Analytics Service, Data Quality Service |
| PipelineFailed | DataPipeline | Pipeline error | Monitoring Service, Data Quality Service, On-Call Service |

### Platform Domain Events

| Event | Aggregate | Trigger | Subscribers |
|-------|-----------|---------|-------------|
| UserLoggedIn | User | Login command | Audit Service, Security Service, Analytics Service |
| UserLoggedOut | User | Logout command | Audit Service, Analytics Service |
| SystemHealthCheckFailed | HealthCheck | Health check failure | Alerting Service, Incident Management, On-Call Service |

---

## Event Patterns

### 1. Event Sourcing
Некоторые агрегаты (Payment, Loan) используют Event Sourcing для полной истории изменений.

### 2. CQRS
Разделение команд (write) и запросов (read) через события и read models.

### 3. Saga Pattern
Распределенные транзакции через события (например, Payment → Invoice → Appointment).

### 4. Event Notification
Простое уведомление о произошедшем событии.

### 5. Event-Carried State Transfer
События содержат достаточно данных для обработки без дополнительных запросов.

---

## Преимущества событийной архитектуры

1. **Слабая связанность**: Домены не знают друг о друге
2. **Масштабируемость**: Легко добавлять новых подписчиков
3. **Аудит**: Полная история событий
4. **Отказоустойчивость**: Сбой одного домена не влияет на другие
5. **Гибкость**: Легко изменять бизнес-процессы
6. **Real-time**: Near-real-time обработка событий
