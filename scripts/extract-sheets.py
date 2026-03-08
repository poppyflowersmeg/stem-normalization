#!/usr/bin/env python3
"""
Extract data from all spreadsheets using Google Sheets CSV export.
Downloads each tab as CSV and saves to outputs/csv/ for processing.

Usage: python3 scripts/extract-sheets.py
"""

import csv
import io
import os
import urllib.request
import urllib.error

# ============================================================
# Spreadsheet configuration — GIDs verified from browser
# Format: (name, spreadsheet_id, [(tab_name, gid), ...])
# ============================================================
SPREADSHEETS = [
    ("dv-poppy-rfp", "1ga-2A85YXOkQopXNkhl7IwyUgdkv82zo8XzH6vUM7_w", [
        ("DV_Pricing_Request_Final_combined", "1155006049"),
        ("Orig_Poppy_list", "1674041915"),
        ("DV_Additional", "63740439"),
        ("DV_Pricing_Request_FINAL_not_updated", "82755506"),
    ]),
    ("elite-x-poppy", "1lVfGUsMHOSVOK0W5GmvwHi4l5q1SheVFyy3agoAkJKA", [
        ("Pack_Sizes", "1598230691"),
        ("Combo_Box", "1625703940"),
        ("Freight", "710311821"),
        ("SO_Fob_Bog_2026_Roses", "907643339"),
        ("SO_Fob_Bog_2026_Other_Product", "1899989671"),
    ]),
    ("magic-pricing", "1ZD39haO0oljWA4x-rsg44KZGfx0RA96qhIaKkxEyu24", [
        ("Sheet1", "0"),
    ]),
    ("stem-cost-database", "1l1KO4nboVVdhm1eyR1iQ3B7QrF3UTjizZmKxlwFEYM4", [
        ("Summary", "1158184359"),
        ("Agrogana", "0"),
        ("Mayesh", "1395084864"),
        ("Magic", "187378562"),
    ]),
    ("stem-pricing-master", "1752RqpPhhJ3LnSI6N7fTnCMDQPNuPxWZV3COjrw-Dkk", [
        ("FLOWERS_MASTER", "973410587"),
        ("Agrogana_Master_List", "663672256"),
    ]),
    ("metabase-raw-data", "10vJj8h87CSPGQwA7YYnjZDK5gV2N5W3ggYCEjdb2zOg", [
        ("Sheet1", "0"),
    ]),
]

OUTPUT_DIR = "outputs/csv"


def download_csv(spreadsheet_id, gid, name=""):
    """Download a single tab as CSV from Google Sheets."""
    url = f"https://docs.google.com/spreadsheets/d/{spreadsheet_id}/export?format=csv&gid={gid}"
    try:
        req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
        with urllib.request.urlopen(req, timeout=30) as response:
            data = response.read().decode("utf-8-sig")  # Handle BOM
            return data
    except urllib.error.HTTPError as e:
        print(f"  ❌ HTTP {e.code} for {name} (gid={gid})")
        return None
    except Exception as e:
        print(f"  ❌ Error for {name}: {e}")
        return None


def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    total_tabs = 0
    total_rows = 0
    successful = 0
    failed = 0

    for spreadsheet_name, spreadsheet_id, tabs in SPREADSHEETS:
        print(f"\n📊 {spreadsheet_name} ({len(tabs)} tabs)")
        spreadsheet_dir = os.path.join(OUTPUT_DIR, spreadsheet_name)
        os.makedirs(spreadsheet_dir, exist_ok=True)

        for tab_name, gid in tabs:
            total_tabs += 1
            print(f"  ⬇️  {tab_name}...", end=" ", flush=True)
            csv_data = download_csv(spreadsheet_id, gid, f"{spreadsheet_name}/{tab_name}")

            if csv_data:
                filepath = os.path.join(spreadsheet_dir, f"{tab_name}.csv")
                with open(filepath, "w", encoding="utf-8") as f:
                    f.write(csv_data)

                # Count non-empty rows
                reader = csv.reader(io.StringIO(csv_data))
                rows = [r for r in reader if any(cell.strip() for cell in r)]
                row_count = max(0, len(rows) - 1)  # Exclude header
                total_rows += row_count
                successful += 1
                print(f"✅ {row_count} rows")
            else:
                failed += 1

    print(f"\n{'='*50}")
    print(f"✅ Downloaded: {successful}/{total_tabs} tabs")
    print(f"📊 Total rows (non-empty): {total_rows}")
    if failed:
        print(f"❌ Failed: {failed} tabs")
    print(f"📁 Output: {OUTPUT_DIR}/")


if __name__ == "__main__":
    main()
