import duckdb
from pathlib import Path

# --- paths ---
BASE_DIR = Path(__file__).resolve().parents[1]  # main_pipeline/
DB_PATH = BASE_DIR / "lw.duckdb"
EXPORT_PATH = BASE_DIR / "docs/exports"

EXPORT_PATH.mkdir(parents=True, exist_ok=True)

# --- connect ---
conn = duckdb.connect(str(DB_PATH))

# --- query (IMPORTANT: schema qualified) ---
query = """
select *
from fct_mrr_by_school_use_case_country_month
"""

df = conn.execute(query).fetch_df()

df["mrr_usd"] = df["mrr_usd"].round(2)

# --- export ---
output_file = EXPORT_PATH / "fct_mrr_by_school_use_case_country_month.csv"
df.to_csv(output_file, index=False)

print(f"Export complete: {output_file}")