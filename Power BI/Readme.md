# 1. Power BI Data Model (Setup Instructions):

To get the best results in Power BI, set up your relationships as follows:Table 1: Patients (Primary Key: Patient_ID)Table 2: Visits (Primary Key: Visit_ID, Foreign Key: Patient_ID)Relationship: Patients (1) $\rightarrow$ Visits (*) on Patient_ID.Table 3: Pharmacy_Transactions (Foreign Key: Visit_ID)Relationship: Visits (1) $\rightarrow$ Pharmacy_Transactions (*) on Visit_ID.

# 2. Dashboard KPIs

KPI Metric,Value:
Total Patient Visits: 300
Total Pharmacy Revenue:"275,407"
Avg Length of Stay: 1.41 Days

# 3. Executive Dashboard Insightsreport:

provides an analysis of patient demographics, disease patterns, and pharmacy performance for the county referral hospital. By integrating data from patient records, clinical visits, and pharmacy transactions, we have identified key trends that can assist management in resource allocation and drug inventory management.Disease Patterns and County DistributionOur analysis shows that Typhoid and Hypertension are the most prevalent conditions across the regions. Specifically, Uasin Gishu shows a significant cluster of Typhoid and Flu cases, while Kisumu has a high incidence of Hypertension. Diabetes cases are most frequently recorded in Kiambu and Mombasa. 

This suggests a need for targeted public health campaigns and specialized clinics in these specific counties.Pharmacy Revenue and Visit VolumeA critical question was whether higher visit volumes directly correlate with higher pharmacy revenue. While there is a general trend where months with more visits (like March and August) see higher revenue, the correlation is not absolute.

For instance, in August 2024, revenue reached a peak even though the visit count was lower than the March peak. This indicates that revenue is driven more by the severity of the diagnosis and the cost of specialized medication (e.g., Malaria treatments) rather than just the number of patients walking through the door.Departmental Performance and Medication ConsumptionThe Inpatient and Emergency departments are the primary drivers of pharmacy costs, contributing nearly equal amounts (approx. $94,000$ each), while the Outpatient department follows closely. Regarding demographics, the Senior age group (60+) is the largest consumer of medication, accounting for $37\%$ of all drugs dispensed.

This is likely due to the chronic nature of conditions like Hypertension and Diabetes prevalent in older populations.Efficiency: Length of Stay vs. SpendingAn interesting trend emerges when comparing hospital stays to pharmacy spending. Flu patients tend to have the longest average length of stay (nearly 2 days) but generate relatively moderate pharmacy revenue. In contrast, Malaria and Typhoid are "high-intensity" diagnoses; they involve shorter hospital stays but result in the highest average pharmacy spending per visit. This suggests that Malaria treatment is drug-intensive, whereas Flu management may be more focused on observation and bed-rest.RecommendationsInventory Optimization: Increase stock of Artemether (Malaria) and Typhoid-related antibiotics in Uasin Gishu and Kisumu.Geriatric Care: Since the 60+ age group consumes the most medication, the hospital should consider a dedicated pharmacy fast-track for seniors to improve service efficiency.Revenue Strategy: Focus on the Emergency department's drug availability, as it is a high-cost center with rapid turnover.

4.
5. <img width="1000" height="600" alt="image" src="https://github.com/user-attachments/assets/dbcc0485-5f5a-4163-b3b4-e30d1c681872" />

<img width="1000" height="600" alt="image" src="https://github.com/user-attachments/assets/fcd6f1a3-0670-4574-91e6-bf3ea3488977" />

<img width="800" height="600" alt="image" src="https://github.com/user-attachments/assets/e4b1f000-e761-4df2-ada1-8075ee809c4e" />

<img width="800" height="600" alt="image" src="https://github.com/user-attachments/assets/daccdba8-b79c-43e5-9313-4ce440cf970e" />

<img width="1000" height="600" alt="image" src="https://github.com/user-attachments/assets/f417a0fe-e97c-453b-bc34-db32f898bdb6" />


Dax Query:
```
let
    Source = List.Dates(#date(2024, 1, 1), 366, #duration(1, 0, 0, 0)),
    #"Converted to Table" = Table.FromList(Source, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Renamed Columns" = Table.RenameColumns(#"Converted to Table",{{"Column1", "Date"}}),
    #"Inserted Month Name" = Table.AddColumn(#"Renamed Columns", "Month Name", each Date.MonthName([Date]), type text),
    #"Inserted Month" = Table.AddColumn(#"Inserted Month Name", "Month Number", each Date.Month([Date]), type number),
    #"Inserted Year" = Table.AddColumn(#"Inserted Month", "Year", each Date.Year([Date]), type number)
in
    #"Inserted Year"
Age Group = 
SWITCH(TRUE(),
    'Patients'[Age] < 18, "0-17",
    'Patients'[Age] < 40, "18-39",
    'Patients'[Age] < 60, "40-59",
    "60+"
)
// 1. Core KPIs
Total Visits = DISTINCTCOUNT('Visits'[Visit_ID])
Total Pharmacy Revenue = SUM('Pharmacy_Transactions'[Total_Cost])
Avg Length of Stay = AVERAGE('Visits'[Length_of_Stay_Days])

// 2. Efficiency Analysis (Question 5)
Avg Revenue Per Visit = DIVIDE([Total Pharmacy Revenue], [Total Visits], 0)

// 3. Trends (Question 2)
Revenue Growth % = 
VAR PrevMonth = CALCULATE([Total Pharmacy Revenue], DATEADD('Calendar'[Date], -1, MONTH))
RETURN DIVIDE([Total Pharmacy Revenue] - PrevMonth, PrevMonth, 0)
```
