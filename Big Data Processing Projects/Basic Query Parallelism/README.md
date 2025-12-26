# Basic Query Parallelism

A comprehensive implementation of parallel query processing algorithms for efficient big data operations using Python's multiprocessing capabilities.

## 🎯 Project Overview

This project demonstrates the implementation of parallelism techniques to improve the speed and efficiency of querying large datasets. Using a healthcare dataset with patient records, doctor information, and treatment costs, I developed and optimized parallel algorithms to extract meaningful insights at scale.

## 🚀 Key Implementations

### 1. Parallel Search Algorithms
- **Linear Search**: Multi-attribute search supporting both column-based and row-based strategies
- **Hash-Based Partitioning**: Custom hash function for distributing data across processors
- **Parallel Search**: Extended linear search with hash partitioning for concurrent query execution
- **Support for Complex Queries**: Basic criteria (AND/OR operations) and advanced criteria (custom filter functions)

### 2. Parallel Join Algorithms
- **DOJA (Duplication Outer Join Algorithm)**: Implementation of a sophisticated parallel join strategy
  - Replication phase for broadcasting smaller tables
  - Local inner join execution on each processor
  - Distribution phase with reshuffling based on hash keys
  - Support for LEFT, RIGHT, and FULL outer joins
- **Delta Update Processing**: Handling incremental data changes (insert, update, delete operations)

### 3. Parallel Sort Algorithms
- **Round-Robin Partitioning**: Even distribution of data across processors
- **K-Way Merge**: Heap-based merging of sorted partitions
- **Serial Sorting with External Merge Sort**: Buffer-based sorting for memory efficiency
- **Parallel Binary Merge-Sort**: Two-phase sorting with local sort and pipelined binary merging

### 4. Parallel GroupBy Algorithms
- **Serial GroupBy**: Foundation for aggregation operations
- **Parallel Merge-All GroupBy**: Hash-partitioned parallel aggregation with:
  - Local aggregation on each processor
  - Global merge of partial results
  - Support for custom aggregation functions (SUM, AVG, COUNT)

## 🛠️ Technical Skills Demonstrated

| Category | Skills |
|----------|--------|
| **Parallel Computing** | Multiprocessing, Process Pools, Async Execution |
| **Data Structures** | Hash Tables, Heaps, Custom Dataset Class |
| **Algorithm Design** | Partitioning Strategies, Merge Algorithms, Join Algorithms |
| **Python** | Type Hints, Functional Programming, OOP |
| **Big Data Concepts** | Data Partitioning, Distributed Joins, Parallel Aggregation |

## 📊 Dataset Schema

The project works with a healthcare database consisting of:
- **main.csv**: Patient visit records with diagnosis, treatment, and costs
- **delta.csv**: Incremental changes (insert/update/delete operations)
- **patient.csv**: Patient demographics
- **doctor.csv**: Doctor information and specialties
- **hospital.csv**: Hospital branch details

## 💡 Key Concepts Applied

### Hash-Based Partitioning
```python
def hash_partition(data, n_processors, *keys):
    # Distributes data across n partitions based on hash of key columns
    # Ensures related records are co-located for efficient joins
```

### Parallel Search with Criteria
```python
# Basic criteria: OR between dictionaries, AND within
basic_crit = [{"diagnosis": "covid-19"}, {"treatment_cost": 100}]

# Advanced criteria: Custom filter functions
advanced_crit = lambda row: row["doctor_id"] == row["patient_id"]
```

### DOJA Algorithm
1. **Replicate** smaller table to all processors
2. **Local Join** on each partition
3. **Redistribute** results by join key
4. **Outer Join** to handle unmatched records

### Parallel Merge Sort Complexity
- **Sorting Phase**: O(N log N) - fully parallelized
- **Merging Phase**: O(N log P) - pipelined binary merge
- **Overall**: O(N log N) with improved wall-clock time through parallelism

## 🔧 Usage Examples

### Parallel Search
```python
# Find COVID-19 patients with treatment cost ≤ $100
results = parallel_search(
    main_data, 
    n_processor=4,
    advanced_crit=lambda r: r["diagnosis"].lower() == "covid-19" and r["treatment_cost"] <= 100
)
```

### Parallel Join
```python
# Left outer join patient records with doctor information
joined = doja(
    main_data, doctor_data, 
    n_process=4, 
    join="left",
    left_attributes=["doctor_id"], 
    right_attributes=["uuid"]
)
```

### Parallel GroupBy
```python
# Calculate total treatment cost per hospital
results = parallel_merge_all_groupby(
    dataset, n_process=4,
    group_keys=["hospital_id"],
    value_key="treatment_cost",
    operation=lambda x, y: x + y
)
```

## 📈 Performance Considerations

- **Hash Partitioning**: Ensures even data distribution and enables parallel processing
- **Broadcast Join**: Optimizes joins when one table is significantly smaller
- **Pipelined Merging**: Reduces memory footprint during sort operations
- **Local Aggregation**: Minimizes data transfer between processors

## 🎓 Learning Outcomes

Through this project, I gained hands-on experience with:
- Designing and implementing parallel algorithms from scratch
- Understanding trade-offs between different partitioning strategies
- Optimizing query performance through parallelism
- Handling complex data operations (joins, sorts, aggregations) at scale
- Analyzing computational complexity in parallel computing contexts

## 📁 Project Structure

```
Basic Query Parallelism/
├── Basic Query Parallelism.ipynb    # Main implementation notebook
├── README.md                         # Project documentation
└── data/                            # Dataset files
    ├── main.csv
    ├── delta.csv
    ├── patient.csv
    ├── doctor.csv
    ├── hospital.csv
    └── impl.csv
```

## 🔗 Technologies Used

- **Python 3.x**
- **multiprocessing** - Parallel execution
- **collections** - defaultdict for efficient data structures
- **heapq** - Priority queue for k-way merge
- **functools** - Partial functions for flexible operations
- **pandas** - Data visualization and validation

---

*This project demonstrates practical applications of parallel computing concepts in big data processing, showcasing both theoretical understanding and implementation skills.*
