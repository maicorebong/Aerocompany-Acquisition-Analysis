# Proposal Documentation

## Introduction
This project is based on the case study from the 2024 ASCM Case Competition, which integrates elements of both merger & acquisition and supply chain management. The primary focus is on developing and executing an immediate supply chain turnaround strategy for the client, Capital Group Precision (CGP), an aeronautical parts manufacturer. This strategy seeks to enhance operational performance and financial stability while securing the bank's confidence as a financier and avoiding bankruptcy or a fire-sale scenario.

As third-party consultants, our objective is to provide actionable recommendations for CGP's future direction. Comprehensive analyses have been undertaken to evaluate the company's current health, identify marketable operational strengths, assess its valuation, and outline strategic next steps.

To uphold confidentiality, customer names have been anonymized and replaced with fictional aeronautical companies. Additionally, the dataset itself will not be uploaded. Findings will instead comprise SQL scripts, results tables, and Power BI charts presenting aggregated data to deliver a clear and concise summary of the analyses conducted.

## Technologies
- Database and GUI: MySQL Workbench
- Data Visualization: Power BI

## Data Architecture
<img width="809" alt="workflow" src="https://github.com/user-attachments/assets/f6da143b-8e60-42f8-bddf-a1e8dcde4755" />

1. Data (transaction history and inventory list) were provided by client via CSV
2. Flat files were imported to MySQL Workbench for feature engineering and exploratory data analysis
3. Analyses were done and generated as tables
4. Only aggregated tables were fed to Power BI via MySQL ODBC API, maintaining dashboard performance and avoid overloading visuals
