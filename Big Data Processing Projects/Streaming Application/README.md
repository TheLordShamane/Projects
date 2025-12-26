# Real-Time Traffic Violation Detection System (AWAS)

A comprehensive streaming data pipeline for automated traffic violation detection using Apache Kafka, Apache Spark Structured Streaming, and MongoDB.

## 🎯 Project Overview

This project implements an **Automated Traffic Violation Detection System (AWAS)** that processes real-time camera event data to detect speeding violations on highways. The system uses a microservices architecture with multiple Kafka producers simulating traffic cameras, a Spark Structured Streaming application for real-time processing, and MongoDB for persistent storage.

## 🏗️ System Architecture

```
┌─────────────┐     ┌─────────────┐     ┌─────────────────────┐     ┌─────────────┐
│   CAMERAS   │     │             │     │                     │     │             │
│  (SENSORS)  ├────►│    KAFKA    ├────►│  SPARK STRUCTURED   ├────►│   MONGODB   │
│  Producer   │     │  (STREAMS)  │     │     STREAMING       │     │  (STORAGE)  │
│   A/B/C     │     │             │     │                     │     │             │
└─────────────┘     └─────────────┘     └─────────────────────┘     └─────────────┘
                                                 │
                                                 ▼
                                        ┌─────────────────┐
                                        │  VIOLATION      │
                                        │  DETECTION      │
                                        │  ALGORITHMS     │
                                        └─────────────────┘
```

## 🚀 Key Implementations

### 1. Data Collection Design (MongoDB Schema)
Designed a comprehensive MongoDB data model optimized for real-time streaming:

| Collection | Purpose | Key Features |
|------------|---------|--------------|
| **Vehicles** | Vehicle metadata & ownership history | Unique car_plate index, owner history tracking |
| **Cameras** | Camera locations & speed limits | GeoJSON spatial indexing, 2dsphere queries |
| **Violations** | Detected speed violations | Compound sharding, daily aggregation |
| **Camera Event Buffer** | Temporary event storage | TTL auto-cleanup, correlation processing |
| **Unmatched Events** | Audit trail for troubleshooting | 7-day retention, automatic expiration |

### 2. Kafka Producers (Data Ingestion)
Implemented three parallel Kafka producers simulating traffic cameras:
- **Producer A, B, C**: Each reads from separate CSV files and streams camera events
- **Batch Processing**: Events sent in configurable batch intervals
- **Key-based Partitioning**: Uses `car_plate` as partition key for consistent routing
- **Metadata Enrichment**: Adds producer info, timestamps, and event dates

### 3. Spark Structured Streaming (Real-Time Processing)
Built a robust streaming pipeline with:
- **Watermarking**: 5-minute delay tolerance for out-of-order events
- **Event Correlation**: 10-minute join window for multi-camera matching
- **Micro-batch Processing**: 10-second processing intervals
- **Checkpoint Recovery**: Fault-tolerant state management

### 4. Violation Detection Algorithms

#### Instantaneous Speed Violations
```python
# Detects vehicles exceeding speed limits at individual cameras
def detect_instantaneous_violations(events_df, camera_df):
    joined_df = events_df.join(camera_df, on="camera_id")
    violations = joined_df.filter(
        col("speed_reading") > col("speed_limit") + SPEED_VIOLATION_MARGIN
    )
    return violations.withColumn("violation_type", lit("instantaneous_speed"))
```

#### Average Speed Violations
- Correlates events from multiple cameras
- Calculates distance traveled between camera positions
- Computes average speed over the journey segment
- Detects violations when average speed exceeds the lower of two speed limits

### 5. Real-Time Data Visualization
Implemented live dashboard with matplotlib showing:
- Speed readings over time per producer
- Violation count trends
- Moving average indicators
- Min/Max annotations
- Speed limit threshold highlighting

## 🛠️ Technical Skills Demonstrated

| Category | Technologies & Skills |
|----------|----------------------|
| **Stream Processing** | Apache Kafka, Spark Structured Streaming, Watermarking |
| **Database Design** | MongoDB Schema Design, Sharding Strategies, TTL Indexes |
| **Data Engineering** | ETL Pipelines, Event Correlation, Batch Processing |
| **Real-Time Systems** | Micro-batch Architecture, Checkpoint Recovery, Fault Tolerance |
| **Python** | PySpark, PyMongo, Pandas, Matplotlib, Type Hints |
| **System Design** | Microservices, Event-Driven Architecture, Data Modeling |

## 📊 Data Model Design Principles

### Sharding Strategies
- **Vehicles**: Hashed sharding on `car_plate` for even distribution
- **Violations**: Compound key `{car_plate, violation_date}` for co-location
- **Event Buffer**: Hashed `car_plate` for write distribution

### Indexing Strategy
- **Unique indexes** on natural keys (car_plate, camera_id)
- **Compound indexes** for common query patterns
- **TTL indexes** for automatic data cleanup
- **2dsphere indexes** for geospatial camera queries

### Data Retention Policies
| Collection | Retention | Rationale |
|------------|-----------|-----------|
| Vehicles | Permanent | Critical reference data |
| Cameras | Permanent | Static infrastructure data |
| Violations | 3-5 years | Legal compliance requirements |
| Event Buffer | 30 minutes | Correlation window + margin |
| Unmatched Events | 7 days | Audit and troubleshooting |

## 💡 Key Design Decisions

### Idempotent Write Patterns
- Natural key upserts prevent duplicate records
- Event deduplication via unique `event_id`
- Atomic array updates for violation consolidation

### Fault Tolerance Features
- Watermark-based late data handling
- Unmatched events collection for audit trails
- Checkpoint-based streaming recovery
- Comprehensive exception handling

### Performance Optimizations
- Bulk write operations for efficiency
- Strategic denormalization (embedded speed_limit)
- Compound indexes for query optimization
- TTL-based automatic cleanup

## 📁 Project Structure

```
Streaming Application/
├── data_design_streaming.ipynb    # Main streaming app & MongoDB schema design
├── producer_a.ipynb               # Kafka Producer A
├── producer_b.ipynb               # Kafka Producer B
├── producer_c.ipynb               # Kafka Producer C
├── data_visualisation.ipynb       # Real-time visualization dashboard
├── README.md                      # Documentation
├── data/                          # Source data files
│   ├── camera_event_A.csv
│   ├── camera_event_B.csv
│   ├── camera_event_C.csv
│   ├── camera_event_historic.csv
│   ├── camera.csv
│   └── vehicle.csv
└── MongoDB/                       # MongoDB data files
```

## 🔧 Configuration Parameters

| Parameter | Value | Purpose |
|-----------|-------|---------|
| `WATERMARK_DELAY` | 5 minutes | Late event tolerance |
| `JOIN_WINDOW` | 10 minutes | Event correlation window |
| `BATCH_INTERVAL` | 10 seconds | Micro-batch frequency |
| `SPEED_VIOLATION_MARGIN` | 5 km/h | Sensor accuracy tolerance |
| `UNMATCHED_THRESHOLD` | 10 minutes | Timeout before flagging as unmatched |
| `EVENT_BUFFER_TTL` | 30 minutes | Auto-cleanup of processed events |

## 🔗 Technologies Used

- **Apache Kafka 2.8.0** - Distributed event streaming
- **Apache Spark 3.1.1** - Structured streaming engine
- **MongoDB 5.0** - Document database
- **PySpark** - Python API for Spark
- **PyMongo** - MongoDB Python driver
- **Pandas** - Data manipulation
- **Matplotlib** - Real-time visualization

## 🎓 Learning Outcomes

Through this project, I gained hands-on experience with:

1. **Stream Processing Concepts**: Watermarking, windowing, late data handling
2. **Distributed Systems**: Kafka partitioning, Spark parallelism, MongoDB sharding
3. **Data Modeling**: Schema design for time-series streaming data
4. **Fault Tolerance**: Checkpoint recovery, idempotent operations, audit trails
5. **Real-Time Analytics**: Live dashboards, event correlation, violation detection
6. **System Integration**: Connecting Kafka, Spark, and MongoDB in a cohesive pipeline

## 📈 Sample Violation Detection Flow

1. **Event Ingestion**: Camera captures vehicle → Producer sends to Kafka
2. **Stream Processing**: Spark consumes event → Applies watermarking
3. **Instant Check**: Compare speed reading vs camera speed limit
4. **Buffer Storage**: Store event for correlation processing
5. **Average Speed**: Correlate with previous events from same vehicle
6. **Violation Record**: Create violation document if thresholds exceeded
7. **Visualization**: Update real-time dashboard with violation metrics

---

*This project demonstrates practical applications of streaming data processing, showcasing the design and implementation of a production-ready traffic monitoring system.*
