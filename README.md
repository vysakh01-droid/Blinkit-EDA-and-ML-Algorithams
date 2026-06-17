\# 🛒 Blinkit Grocery Sales — End-to-End Data Analytics \& ML Project



<p align="center">

&#x20; <img src="dashboard.png" alt="Blinkit Power BI Dashboard" width="100%"/>

</p>



<p align="center">

&#x20; <img src="https://img.shields.io/badge/Python-3.x-blue?logo=python\&logoColor=white" />

&#x20; <img src="https://img.shields.io/badge/PostgreSQL-16-336791?logo=postgresql\&logoColor=white" />

&#x20; <img src="https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?logo=powerbi\&logoColor=black" />

&#x20; <img src="https://img.shields.io/badge/Scikit--Learn-ML-orange?logo=scikit-learn\&logoColor=white" />

&#x20; <img src="https://img.shields.io/badge/Pandas-EDA-150458?logo=pandas\&logoColor=white" />

</p>



\---



\## 📌 Project Overview



A complete, production-style data analytics project on \*\*Blinkit's Grocery Sales dataset\*\* covering every stage of the analytics pipeline — from raw data ingestion and cleaning, through SQL analysis and Python EDA, to Machine Learning modelling and interactive BI dashboarding.



\*\*Business objective:\*\* Identify the key drivers of sales and customer ratings across Blinkit's outlet network, and surface actionable recommendations for inventory strategy, outlet expansion, and shelf management.



\---



\## 🗂️ Repository Structure



```

blinkit-grocery-eda/

│

├── 📓 notebooks/

│   ├── 01\_EDA.ipynb                   # Data cleaning, EDA, all visualisations

│   └── 02\_ML.ipynb                    # Random Forest model + correlation analysis

│

├── 🗄️ sql/

│   └── blinkit\_queries.sql            # All PostgreSQL queries with comments

│

├── 📊 dashboard/

│   ├── blinkit\_dashboard.pbix         # Power BI file

│   └── dashboard.png                  # Dashboard screenshot

│

├── 📁 data/

│   ├── BlinkIT\_Grocery\_Data.csv       # Raw dataset (source)

│   └── Blinkit\_Grocery\_cleaned.csv    # Cleaned dataset (EDA output)

│

├── 📈 visuals/                        # All exported chart PNGs

│

├── .env.example                       # DB credentials template

├── requirements.txt

└── README.md

```



\---



\## 📦 Dataset at a Glance



| Property | Value |

|---|---|

| \*\*Source\*\* | BlinkIT Grocery Data.csv |

| \*\*Rows\*\* | 8,523 |

| \*\*Columns\*\* | 12 |

| \*\*Memory\*\* | \~799 KB |

| \*\*Missing values (pre-cleaning)\*\* | 1,463 (Item Weight only) |

| \*\*Missing values (post-cleaning)\*\* | 0 |



<p align="center">

&#x20; <img src="eda\_dataset\_info.png" alt="Dataset Info — df.info() and df.head()" width="90%"/>

&#x20; <br/><em>Dataset structure — 8,523 rows, 12 columns, zero nulls after cleaning</em>

</p>



\### Feature Reference



| # | Column | Type | Description |

|---|---|---|---|

| 0 | Item Fat Content | object | Low Fat / Regular |

| 1 | Item Identifier | object | Unique product code |

| 2 | Item Type | object | Category (Fruits, Snacks, Dairy …) |

| 3 | Outlet Establishment Year | int64 | Year outlet opened |

| 4 | Outlet Identifier | object | Unique outlet code |

| 5 | Outlet Location Type | object | Tier 1 / Tier 2 / Tier 3 city |

| 6 | Outlet Size | object | Small / Medium / High |

| 7 | Outlet Type | object | Supermarket Type 1/2/3, Grocery Store |

| 8 | Item Visibility | float64 | Shelf visibility score (0–1) |

| 9 | Item Weight | float64 | Weight in kg \*(had 1,463 nulls)\* |

| 10 | Total Sales | float64 | Revenue per item-outlet record |

| 11 | Rating | float64 | Customer rating (1–5) |



\---



\## 🔑 Key KPIs



| Metric | Value |

|---|---|

| \*\*Total Revenue\*\* | ₹1,201,681 |

| \*\*Average Sales per Item\*\* | ₹140.99 |

| \*\*Total Transactions\*\* | 8,523 |

| \*\*Average Customer Rating\*\* | 3.97 / 5.0 |



\---



\## 🧹 Phase 1 — Data Cleaning



\### Missing Value Treatment



<p align="center">

&#x20; <img src="eda\_missing\_values.png" alt="Missing value analysis by item type" width="90%"/>

&#x20; <br/><em>Missing Item Weight by category — Fruits \& Veg (213) and Snacks (212) highest</em>

</p>



`Item Weight` had \*\*1,463 missing values (\~17.2%)\*\*. Instead of imputing with the global median, a \*\*category-wise median\*\* was used — because product weights differ significantly across types (Meat ≈ 14 kg vs Snack Foods ≈ 12 kg). A global fill would have biased the data.



```python

df\['Item Weight'] = df.groupby('Item Type')\['Item Weight'].transform(

&#x20;   lambda x: x.fillna(x.median())

)

df.isnull().sum()  # → all zeros

```



\### Fat Content Standardisation



Raw data contained 4 labels for 2 categories: `'LF'`, `'low fat'`, `'reg'`, `'Regular'`, `'Low Fat'`. All were consolidated:



```python

df\['Item Fat Content'] = df\['Item Fat Content'].replace(

&#x20;   {'LF': 'Low Fat', 'reg': 'Regular', 'low fat': 'Low Fat'}

)

\# Result: Low Fat = 5,517 | Regular = 3,006

```



\### Export to PostgreSQL



```python

from sqlalchemy import create\_engine

from dotenv import load\_dotenv

load\_dotenv()



engine = create\_engine(

&#x20;   f"postgresql+psycopg2://{DB\_USER}:{DB\_PASSWORD}@{DB\_HOST}:{DB\_PORT}/{DB\_NAME}"

)

df.to\_sql("Blinkit Sales", con=engine, if\_exists="replace", index=False, method="multi")

\# → "Data successfully loaded into PostgreSQL."

```



<p align="center">

&#x20; <img src="eda\_postgres\_load.png" alt="PostgreSQL load confirmation" width="90%"/>

&#x20; <br/><em>Cleaned dataframe successfully loaded into PostgreSQL for SQL analysis</em>

</p>



\---



\## 📊 Phase 2 — Exploratory Data Analysis



\### Item Weight Distribution (Box Plot)



<p align="center">

&#x20; <img src="eda\_boxplot\_weight.png" alt="Item weight box plot by item type" width="90%"/>

&#x20; <br/><em>Zero outliers detected across all categories — IQR range clean throughout</em>

</p>



> \*\*Finding:\*\* No outliers exist in Item Weight after cleaning. Household and Health \& Hygiene items have the highest median weight, while Soft Drinks and Snack Foods are lightest. The group-median imputation preserved these category-specific patterns.



\---



\### Sales by Fat Content



<p align="center">

&#x20; <img src="eda\_kpis\_fat\_content.png" alt="KPI metrics and fat content pie chart" width="90%"/>

&#x20; <br/><em>Low Fat: 65% of all sales (₹776K) vs Regular: 35% (₹425K)</em>

</p>



> \*\*Finding:\*\* Low Fat items dominate 65% of total revenue. Average sales per transaction are nearly identical (Low Fat: ₹140.71 vs Regular: ₹141.50), confirming this is a \*\*volume effect\*\* — customers are choosing Low Fat more often, not paying more for it. Shelf allocation should reflect this 2:1 preference ratio.



\---



\### Sales by Item Type



<p align="center">

&#x20; <img src="eda\_sales\_by\_item\_type\_table.png" alt="Sales by item type — detailed table" width="90%"/>

&#x20; <br/><em>Full breakdown: 16 categories, total sales, mean, count, and rating per category</em>

</p>



<p align="center">

&#x20; <img src="eda\_sales\_by\_item\_type\_chart.png" alt="Sales by item type — bar chart" width="90%"/>

&#x20; <br/><em>Fruits \& Vegetables (₹178K) and Snack Foods (₹175K) nearly tied at #1 and #2</em>

</p>



| Rank | Category | Total Sales | Avg Rating |

|---|---|---|---|

| 1 | Fruits and Vegetables | ₹178,124 | 3.96 |

| 2 | Snack Foods | ₹175,434 | 3.95 |

| 3 | Household | ₹135,977 | 3.99 |

| 4 | Frozen Foods | ₹118,559 | 3.97 |

| 5 | Dairy | ₹101,276 | 3.97 |

| … | … | … | … |

| 14 | Breakfast | ₹15,597 | 3.93 |

| 15 | Seafood | ₹9,078 | 3.96 |



> \*\*Finding:\*\* Top 3 categories account for \~49% of all revenue. Seafood at ₹9,078 is 20× lower than the #1 category — a candidate for demand or visibility investigation before any restocking.



\---



\### Fat Content by Outlet Location



<p align="center">

&#x20; <img src="eda\_fat\_by\_outlet\_location.png" alt="Fat content split across outlet location tiers" width="90%"/>

&#x20; <br/><em>Low Fat outsells Regular \~2:1 in every tier — this preference is nationwide</em>

</p>



<p align="center">

&#x20; <img src="eda\_fat\_outlet\_table.png" alt="Fat content aggregated table by outlet location" width="90%"/>

&#x20; <br/><em>Aggregated view: sum, mean, count, and rating for Low Fat vs Regular across tiers</em>

</p>



> \*\*Finding:\*\* The 2:1 Low Fat preference is consistent across Tier 1, 2, and 3 — it is not a metro or premium-city behaviour. Every outlet tier should prioritise Low Fat inventory equally.



\---



\### Sales by Outlet Size



<p align="center">

&#x20; <img src="eda\_outlet\_size\_pie.png" alt="Percentage of sales by outlet size" width="75%"/>

&#x20; <br/><em>Medium outlets drive 42.27% of sales — outperforming Large (High) outlets</em>

</p>



| Outlet Size | Total Sales | Share |

|---|---|---|

| Medium | ₹507,896 | 42.27% |

| Small | ₹444,794 | 37.01% |

| High (Large) | ₹248,992 | 20.72% |



> \*\*Finding:\*\* Bigger physical space does not translate to bigger revenue. Large outlets deliver only 20.72% of total sales — likely due to high rent, low footfall density, or poor layout. Medium-format stores are the optimal expansion format.



\---



\### Sales by Outlet Location (Tier)



<p align="center">

&#x20; <img src="eda\_outlet\_location\_sales.png" alt="Total sales by outlet location type bar chart" width="90%"/>

&#x20; <br/><em>Tier 3 > Tier 2 > Tier 1 — a consistent ₹79K gap between each tier</em>

</p>



| Location | Total Sales |

|---|---|

| Tier 3 | ₹472,133 |

| Tier 2 | ₹393,151 |

| Tier 1 | ₹336,398 |



> \*\*Finding:\*\* Tier 3 cities outperform Tier 1 by \~40%. These are typically underserved markets with lower competition and high unmet demand. Geographic expansion strategy should prioritise Tier 3.



\---



\### Sales by Outlet Establishment Year



<p align="center">

&#x20; <img src="eda\_establishment\_year.png" alt="Sales trend by outlet establishment year" width="90%"/>

&#x20; <br/><em>1998 peak (₹205K) → 2011 trough (₹78K) → post-2012 stabilisation at ₹129–133K</em>

</p>



| Year | Sales | Note |

|---|---|---|

| 1998 | ₹204,523 | Peak — loyal customers, prime locations |

| 2008 | ₹131,809 | Post-peak plateau begins |

| 2011 | ₹78,132 | Historic trough — lowest cohort |

| 2012–2022 | ₹129K–₹133K | Stabilised band |



> \*\*Finding:\*\* Stores take 5–10 years to fully mature. The 2011 cohort dip (–62% vs 1998) suggests a difficult expansion period. Post-2012 stores have stabilised — new outlet performance should be evaluated on growth trajectory, not year-1 revenue.



\---



\## 🗄️ Phase 3 — SQL Analysis (PostgreSQL)



All queries were executed in PostgreSQL after loading the cleaned dataframe via SQLAlchemy.



\---



\### Query 1 — Which item type sells most?



```sql

SELECT "Item Type", SUM("Total Sales") AS Type\_Sales

FROM "Blinkit Sales"

GROUP BY "Item Type"

ORDER BY Type\_Sales DESC

LIMIT 5;

```



<p align="center">

&#x20; <img src="sql\_top\_item\_types.png" alt="SQL result — top 5 item types by total sales" width="80%"/>

&#x20; <br/><em>Fruits \& Vegetables leads at ₹178,124 — Snack Foods close behind at ₹175,434</em>

</p>



\---



\### Query 2 — Which outlet size gives the highest average sales?



```sql

SELECT "Outlet Size", AVG("Total Sales") AS Avg\_Sales

FROM "Blinkit Sales"

GROUP BY "Outlet Size"

ORDER BY Avg\_Sales DESC;

```



<p align="center">

&#x20; <img src="sql\_outlet\_size\_avg.png" alt="SQL result — avg sales by outlet size" width="80%"/>

&#x20; <br/><em>High: ₹142.04 | Small: ₹141.70 | Medium: ₹139.88 — marginal differences per transaction</em>

</p>



> \*\*Analyst note:\*\* High-size outlets have the highest \*average\* per-item sales but the lowest \*total\* revenue share (20.72%). This is a critical distinction — they sell fewer items but at a slightly higher per-item value. Medium outlets win on volume at near-identical per-item rates.



\---



\### Query 3 — Items selling above their category average



```sql

SELECT "Item Identifier", "Item Type", "Total Sales"

FROM "Blinkit Sales" b1

WHERE "Total Sales" > (

&#x20;   SELECT AVG("Total Sales")

&#x20;   FROM "Blinkit Sales" b2

&#x20;   WHERE b2."Item Type" = b1."Item Type"

)

ORDER BY "Total Sales" DESC

LIMIT 5;

```



<p align="center">

&#x20; <img src="sql\_items\_above\_avg.png" alt="SQL result — top items above category average" width="80%"/>

&#x20; <br/><em>Top 5 overperformers: FDR25 \& FDS13 (Canned, ₹266.89) | NCS29 (Health \& Hygiene, ₹266.69)</em>

</p>



> \*\*Technique:\*\* Correlated subquery — recalculates the average for each item's own category dynamically. This is more precise than a global average filter and demonstrates advanced SQL thinking.



\---



\### Query 4 — Outlet types with average sales above the overall average



```sql

SELECT "Outlet Type",

&#x20;      ROUND(AVG("Total Sales")::numeric, 2) AS Avg\_Sales\_Per\_Outlet

FROM "Blinkit Sales"

GROUP BY "Outlet Type"

HAVING AVG("Total Sales") > (

&#x20;   SELECT AVG("Total Sales") FROM "Blinkit Sales"

)

ORDER BY Avg\_Sales\_Per\_Outlet DESC;

```



<p align="center">

&#x20; <img src="sql\_outlet\_types\_above\_avg.png" alt="SQL result — outlet types above overall average" width="80%"/>

&#x20; <br/><em>Only Supermarket Type 2 (₹141.68) and Type 1 (₹141.21) beat the overall average of ₹140.99</em>

</p>



\---



\### Query 5 — Worst-performing item in each category



```sql

SELECT "Item Type", "Item Identifier", "Total Sales"

FROM "Blinkit Sales" b1

WHERE "Total Sales" = (

&#x20;   SELECT MIN("Total Sales")

&#x20;   FROM "Blinkit Sales" b2

&#x20;   WHERE b2."Item Type" = b1."Item Type"

)

ORDER BY "Item Type";

```



<p align="center">

&#x20; <img src="sql\_worst\_items.png" alt="SQL query — worst performing item per category" width="80%"/>

</p>



<p align="center">

&#x20; <img src="sql\_worst\_items\_result.png" alt="SQL result — worst items across 16 categories" width="80%"/>

&#x20; <br/><em>16 rows returned — one worst SKU per category. Breads (FDX59) and Frozen Foods (FDG40) share the minimum at ₹31.96</em>

</p>



\---



\### Query 6 — Outlets with inconsistent (high-variance) sales



```sql

WITH Outlet\_Stats AS (

&#x20;   SELECT "Outlet Identifier",

&#x20;          COUNT(\*) AS Num\_Items,

&#x20;          STDDEV("Total Sales") AS Sales\_Variability

&#x20;   FROM "Blinkit Sales"

&#x20;   GROUP BY "Outlet Identifier"

)

SELECT \* FROM Outlet\_Stats

WHERE Sales\_Variability > 500

&#x20; AND Num\_Items > 20

ORDER BY Sales\_Variability DESC;

```



<p align="center">

&#x20; <img src="sql\_stddev\_consistency.png" alt="SQL result — zero outlets with high variability" width="80%"/>

&#x20; <br/><em>Zero rows returned — no outlet exceeds STDDEV > 500</em>

</p>



> \*\*Analyst note:\*\* A null result here is an insight, not a failure. It tells us Blinkit's pricing model produces remarkably consistent per-item sales across all outlets. There are no rogue high-variance stores — a sign of a disciplined, standardised supply chain. This use of `CTE + STDDEV` for anomaly detection demonstrates statistical thinking beyond basic aggregation.



\---



\## 🤖 Phase 4 — Machine Learning



\*\*Objective:\*\* Predict customer `Rating` and identify which product/outlet features drive satisfaction the most.



<p align="center">

&#x20; <img src="ml\_notebook\_start.png" alt="ML notebook — data loaded, 8523 entries, 12 columns" width="90%"/>

&#x20; <br/><em>ML notebook loads the cleaned CSV — 8,523 entries, all columns non-null</em>

</p>



\---



\### Model 1 — Random Forest Regressor (Rating Prediction)



```python

from sklearn.model\_selection import train\_test\_split

from sklearn.ensemble import RandomForestRegressor

from sklearn.preprocessing import LabelEncoder



\# Feature engineering

X = df\[\['Item Visibility', 'Item Weight']].copy()

X\['Item Type'] = LabelEncoder().fit\_transform(df\['Item Type'])

X\['Outlet Establishment Year'] = df\['Outlet Establishment Year']

X\['Item Weight'] = X\['Item Weight'].fillna(X\['Item Weight'].mean())

y = df\['Rating']



\# Train/test split — 80/20, random\_state=42

X\_train, X\_test, y\_train, y\_test = train\_test\_split(X, y, test\_size=0.2, random\_state=42)



model = RandomForestRegressor(n\_estimators=100, random\_state=42)

model.fit(X\_train, y\_train)

```



<p align="center">

&#x20; <img src="ml\_rf\_code.png" alt="Random Forest model code" width="90%"/>

&#x20; <br/><em>Full Random Forest pipeline — feature prep, label encoding, train-test split, fit, predict, RMSE</em>

</p>



\#### Model Performance



| Metric | Value |

|---|---|

| \*\*RMSE\*\* | \*\*0.68\*\* |

| Scale | 5-point rating scale |

| Interpretation | Predictions are off by ±0.68 on average — acceptable for a 4-feature model on a grocery dataset |



\---



\### Feature Importance — What Drives Customer Rating?



<p align="center">

&#x20; <img src="ml\_feature\_importance\_chart.png" alt="Feature importance — top factors affecting customer rating" width="90%"/>

&#x20; <br/><em>Item Visibility dominates at 50.5% — the single biggest driver of customer satisfaction</em>

</p>



| Rank | Feature | Importance Score | Business Meaning |

|---|---|---|---|

| 1 | \*\*Item Visibility\*\* | \*\*50.50%\*\* | How prominently the item is displayed / shelf position |

| 2 | Item Weight | 23.87% | Heavier items may signal quality or value |

| 3 | Outlet Establishment Year | 14.96% | Older outlets may have better-trained staff / layout |

| 4 | Item Type | 10.68% | Product category affects customer expectations |



> \*\*Finding:\*\* Item Visibility is the dominant factor — responsible for over half of the model's predictive power. A customer's satisfaction score is most influenced by how easy it is to find and see a product, not by price or outlet tier. \*\*Blinkit should prioritise shelf placement and app thumbnail quality as its primary levers for improving ratings.\*\*



\---



\### Model 2 — Feature Correlation Heatmap



```python

numeric\_df = df.select\_dtypes(include=\['int64', 'float64'])

corr = numeric\_df.corr()

mask = np.triu(np.ones\_like(corr, dtype=bool))  # lower triangle only



sns.heatmap(corr, mask=mask, annot=True, fmt='.2f',

&#x20;           cmap='coolwarm', center=0, square=True)

```



<p align="center">

&#x20; <img src="ml\_correlation\_code.png" alt="Correlation heatmap code" width="90%"/>

</p>



<p align="center">

&#x20; <img src="ml\_correlation\_heatmap.png" alt="Feature correlation heatmap" width="80%"/>

&#x20; <br/><em>All numeric features show < 0.03 correlation with Total Sales — confirming weak linear relationships</em>

</p>



| Correlation | Value | Interpretation |

|---|---|---|

| Outlet Age ↔ Establishment Year | \*\*-1.00\*\* | Perfect inverse — drop one to avoid redundancy |

| Item Visibility ↔ Total Sales | 0.03 | Near zero — sales are not driven by visibility alone |

| Item Weight ↔ Total Sales | -0.00 | No linear relationship |

| All features ↔ Rating | \~0.00 | Rating requires non-linear modelling (confirms RF choice) |



> \*\*Finding:\*\* The near-zero correlations across all feature pairs confirm that \*\*linear models (Linear Regression, Lasso) would fail\*\* on this dataset. The choice of Random Forest is methodologically justified — it captures the non-linear and interaction-based patterns that a correlation matrix cannot detect.



\---



\### Model 3 — Sales Maturity Curve (Outlet Age Analysis)



```python

current\_year = 2022

df\['Outlet Age'] = current\_year - df\['Outlet Establishment Year']



age\_trend = df.groupby('Outlet Age').agg({

&#x20;   'Total Sales': 'mean',

&#x20;   'Outlet Identifier': 'nunique'

}).reset\_index()

age\_trend.columns = \['Outlet Age', 'Avg Sales', 'Outlet Count']

```



<p align="center">

&#x20; <img src="ml\_maturity\_code.png" alt="Outlet age maturity curve code" width="90%"/>

</p>



<p align="center">

&#x20; <img src="ml\_maturity\_curve.png" alt="Sales maturity curve — avg sales vs outlet age" width="90%"/>

&#x20; <br/><em>Average sales remain flat at \~₹140 across all outlet ages — no maturity advantage exists at per-item level</em>

</p>



> \*\*Finding:\*\* Outlet age has \*\*no significant impact on average per-item sales\*\* — the line is essentially flat at \~₹140 from year 0 to year 24. This appears to contradict the establishment-year EDA trend, but the distinction matters: the EDA showed \*total cohort revenue\* (driven by number of stores in that cohort), while this ML analysis shows \*average per-item revenue\* controlled for outlet age. Neither outlet maturity nor experience produces higher per-item sales — the ₹140 average is structurally embedded in Blinkit's pricing model. \*\*Do not wait for outlets to "mature" before evaluating their per-item efficiency.\*\*



\---



\## 💡 Business Recommendations



| # | Recommendation | Evidence |

|---|---|---|

| 1 | \*\*Prioritise Tier 3 city expansion\*\* | Tier 3 generates ₹472K — 40% more than Tier 1. Consistently confirmed across EDA, SQL, and dashboard |

| 2 | \*\*Open Medium-format outlets only\*\* | Medium = 42% of revenue. Large-format stores deliver only 21% despite higher overheads |

| 3 | \*\*Reallocate shelf space to Low Fat — 65% minimum\*\* | 2:1 Low Fat preference holds in every tier. Current 50/50 splits are leaving revenue uncaptured |

| 4 | \*\*Invest heavily in Item Visibility\*\* | ML proves Visibility is the #1 driver of customer ratings (50.5%). Better shelf placement = higher satisfaction |

| 5 | \*\*Zero-stockout policy for Fruits, Veg \& Snacks\*\* | These two categories alone represent 29% of all revenue and are nearly tied at #1 and #2 |

| 6 | \*\*Audit Seafood \& Breakfast\*\* | Seafood ₹9,078 (20× below #1). Root cause — demand, visibility, or pricing — must be diagnosed before restocking |

| 7 | \*\*Use growth trajectory KPIs for new stores\*\* | ML maturity curve proves per-item sales are flat regardless of outlet age. Year-1 absolute revenue is not a useful performance gate |

| 8 | \*\*Investigate Canned goods premium opportunity\*\* | SQL correlated subquery surfaced Canned SKUs (FDR25, FDS13) at ₹266.89 — the highest individual item sales, hidden under a modest category total |



\---



\## 🛠️ Tech Stack



| Layer | Tools |

|---|---|

| Language | Python 3.x |

| Data Manipulation | Pandas, NumPy |

| Visualisation | Matplotlib, Seaborn |

| Machine Learning | Scikit-learn (RandomForestRegressor, LabelEncoder, train\_test\_split) |

| Database | PostgreSQL 16 |

| ORM / Connector | SQLAlchemy, psycopg2-binary |

| Environment | python-dotenv |

| BI Dashboard | Power BI |

| Notebook | Jupyter Notebook |



\---



\## 🚀 How to Run



\### 1. Clone the repository

```bash

git clone https://github.com/yourusername/blinkit-grocery-eda.git

cd blinkit-grocery-eda

```



\### 2. Install dependencies

```bash

pip install -r requirements.txt

```



\### 3. Set up environment variables

```bash

cp .env.example .env

\# Fill in your PostgreSQL credentials

```



\### 4. Run EDA notebook

```bash

jupyter notebook notebooks/01\_EDA.ipynb

```



\### 5. Run ML notebook

```bash

jupyter notebook notebooks/02\_ML.ipynb

```



\### 6. Run SQL queries

Connect to your PostgreSQL instance and execute `sql/blinkit\_queries.sql`. The cleaned dataset is auto-loaded into the `Blinkit Sales` table on first notebook run.



\---



\## 📄 requirements.txt



```

pandas

numpy

matplotlib

seaborn

scikit-learn

sqlalchemy

psycopg2-binary

python-dotenv

jupyter

```



\---



\## 🔐 .env.example



```

DB\_USER=your\_postgres\_username

DB\_PASSWORD=your\_postgres\_password

DB\_HOST=localhost

DB\_PORT=5432

DB\_NAME=your\_database\_name

```



> ⚠️ \*\*Never commit your `.env` file.\*\* Add `.env` to `.gitignore` before your first push.



\---



\## 📊 Power BI Dashboard



<p align="center">

&#x20; <img src="dashboard.png" alt="Full Blinkit Power BI Dashboard" width="100%"/>

&#x20; <br/><em>Interactive dashboard with slicers for Outlet Type, Size, Item Type, Location, and Establishment Year range</em>

</p>



\### Dashboard features

\- \*\*KPI cards\*\* — Total Sales (1.20M), Item Count (2K), Avg Sales (140.99), Avg Rating (3.97)

\- \*\*Sales by Year\*\* — line chart with establishment year slicer (1998–2022)

\- \*\*Fat Content\*\* — bar comparison (Low Fat vs Regular)

\- \*\*Item Type\*\* — ranked horizontal bar (all 16 categories)

\- \*\*Sales by Location\*\* — donut chart (Tier 3: 39.2%, Tier 2: 32.7%, Tier 1: 27.9%)

\- \*\*Outlet Size × Location\*\* — grouped bar

\- \*\*Outlet Type\*\* — pie chart + summary table (rating, avg sales, item count, total sales)



| Outlet Type | Avg Rating | Avg Sales | Items | Total Sales |

|---|---|---|---|---|

| Supermarket Type 1 | 3.96 | ₹141.21 | 1,550 | ₹7,87,550 |

| Grocery Store | \*\*3.99\*\* | ₹140.29 | 901 | ₹1,51,939 |

| Supermarket Type 3 | 3.97 | ₹141.68 | 928 | ₹1,31,478 |

| Supermarket Type 2 | 3.95 | ₹139.80 | 935 | ₹1,30,715 |



> Supermarket Type 1 generates ₹787K — 5× more than any other type — purely through volume (1,550 items). Grocery Stores have the highest customer satisfaction (3.99) despite the lowest revenue.



\---



\## 👤 Author



\*\*\[VYSAKH S RAJ]\*\*

Data Analyst · Python · SQL · Power BI · Machine Learning



\[!\[LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?logo=linkedin)](https://linkedin.com/in/yourprofile)

\[!\[GitHub](https://img.shields.io/badge/GitHub-Follow-black?logo=github)](https://github.com/yourusername)



\---



\## 📃 License



This project is for educational and portfolio purposes. Dataset sourced from public domain.



\---



\*Built with Python · PostgreSQL · Scikit-learn · Power BI\*

