# Healthcare SQL Data Cleaning Project

This project focuses on cleaning a Synthetic healthcare dataset using **MySQL**. The dataset contains over 1,000 records of patient information, diagnoses, admissions, and more.

---

## Objective

To clean raw healthcare data and make it analysis-ready by removing inconsistencies, nulls, duplicates, and formatting issues using SQL.

---

##  Tasks Performed

- Tried to removed duplicate patient records using `ROW_NUMBER()` and CTEs (No duplicate found)
- Standardized date formats with `STR_TO_DATE()`
- Filled null values with `COALESCE()` where appropriate
- Trimmed text fields and applied proper casing
  
---

## Files

- `raw_healthcare_data.csv` – Original dataset
- `cleaned_healthcare_data.csv` – Final cleaned version
- `healthcare sql script` – contains SQL queries for each cleaning step

---

##  Before vs After Snapshot

## Before
![2025-04-04 (1)](https://github.com/user-attachments/assets/3053d325-5a17-41cc-bc92-24fbb85cd0ff)

## After
![2025-04-04 (2)](https://github.com/user-attachments/assets/f45c2063-f392-452f-808e-4951d8cb40b0)


---

## Key Takeaway

Clean data is crucial, especially in healthcare where analysis supports life-impacting decisions. SQL alone is powerful enough to handle complex data wrangling at scale.

---

## 🛠️ Tools Used

- MySQL  



