Alternate Arabic OCR model (Tesseract "fast" LSTM, 2019, version string 4.00.00alpha:ara:synth20170629).
Source: tesseract-ocr/tessdata_fast (Apache License 2.0), taken from the Debian/Ubuntu package tesseract-ocr-ara 1:4.1.0-2.
sha256: e3206d3dc87fd50c24a0fb9f01838615911d25168f4e64415244b67d2bb3e729   (ara.fast.traineddata)

Why it is here: the Arabic model shipped with Alpine's tesseract-ocr-data-ara reads some underlined, stretched clause headings of scanned
contracts differently from this model; each one drops headings the other reads. The OCR service reads every page with both and keeps,
per page, the reading with more heading-like lines (OCR_TESSDATA_ALT, see src/documents/ocr.service.ts).
The Dockerfile copies this file to /opt/tessdata-alt/ara.traineddata and adds the English model beside it.
