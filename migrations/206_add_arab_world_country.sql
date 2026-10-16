-- 206: add "الوطن العربى" as a selectable group in the library tree (sidebar).
-- countries is a reference table (see 011): adding an entry is a plain INSERT.
-- Code 'XA' is in the ISO 3166-1 user-assigned range (XA-XZ), so it can never collide with a real
-- country code and still satisfies the two-capital-letters pattern (country-code.ts) used by laws
-- and guidance. Pan-Arab instruments (conventions, unified laws) will be stored with country_code = 'XA'.
-- Idempotent: safe to run more than once.
INSERT INTO countries (code, name_ar, name_en, display_order) VALUES
  ('XA', 'الوطن العربى', 'Arab World', 6)
ON CONFLICT (code) DO NOTHING;
