#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
دمج golden_test_set_v2.json (137 سؤالاً) مع golden_test_set_v3_extension.json
(دفعة 2026-09-04، 72 سؤالاً) لإنتاج golden_test_set_v3.json الكامل.
سكربت بسيط ومباشر — لا يعيد ترقيم الـid (كلاهما مصمم مسبقاً بلا تعارض،
تحقَّق منه scripts/verify_golden_v3 قبل الدمج).
"""
import json

BASE_PATH = "/home/claude/LEGAL_repo_fresh/golden_test_set_v2.json"
EXT_PATH = "/home/claude/LEGAL_repo_fresh/golden_test_set_v3_extension.json"
OUT_PATH = "/home/claude/LEGAL_repo_fresh/golden_test_set_v3.json"


def main():
    base = json.load(open(BASE_PATH, encoding="utf-8"))
    ext = json.load(open(EXT_PATH, encoding="utf-8"))

    base_ids = {it["id"] for it in base["items"]}
    ext_ids = {it["id"] for it in ext["items"]}
    collision = base_ids & ext_ids
    if collision:
        raise SystemExit(f"REFUSING TO MERGE: id collision {collision}")

    items = base["items"] + ext["items"]
    positive_count = sum(1 for it in items if it["expected_behavior"] == "answer")
    negative_count = len(items) - positive_count

    positive_by_law = {}
    positive_by_style = {"full": 0, "short": 0, "paraphrase": 0}
    for it in items:
        if it["expected_behavior"] != "answer":
            continue
        key = f"{it['law_no']}/{it['law_year']}"
        positive_by_law[key] = positive_by_law.get(key, 0) + 1
        positive_by_style[it["phrasing_style"]] += 1

    merged = {
        "meta": {
            "created_at": "2026-09-04",
            "purpose": (
                "دمج golden_test_set_v2.json (137، حتى 2026-09-02) مع "
                "golden_test_set_v3_extension.json (دفعة 2026-09-04، 72 سؤالاً "
                "تغطى 5 قوانين aml_cft/consumer_protection كانت بلا تغطية "
                "إطلاقاً). لا يزال هدف 300-500 (البند رقم 5 فى خارطة الطريق) "
                "غير مكتمل — هذا تجميع تراكمى، لا نهاية المسار."
            ),
            "methodology": "راجع meta فى كل من الملفين المصدر للتفاصيل الكاملة لكل دفعة.",
            "total": len(items),
            "positive_count": positive_count,
            "negative_count": negative_count,
            "positive_by_law": positive_by_law,
            "positive_by_phrasing_style": positive_by_style,
            "run_status": (
                "لم يُشغَّل بعد ضد الإنتاج الحى — هذه الحاوية السحابية لا تملك "
                "اتصالاً شبكياً بـRailway. يحتاج تشغيلاً عبر run_golden_eval_v2.js "
                "من جهاز له اتصال فعلى."
            ),
            "source_files": ["golden_test_set_v2.json", "golden_test_set_v3_extension.json"],
        },
        "items": items,
    }

    with open(OUT_PATH, "w", encoding="utf-8") as f:
        json.dump(merged, f, ensure_ascii=False, indent=2)

    print(f"merged {len(items)} items ({positive_count} positive, {negative_count} negative) -> {OUT_PATH}")


if __name__ == "__main__":
    main()
