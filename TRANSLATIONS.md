# Tanks of Freedom Community Translations Guide

## About this guide
This file is meant to be a guide for any and all ToF community members wanting to import own translations into the game

## About Translation mechanism
Godot use csv (coma separated values) files for storing translations. 
Languages are distinguished by i18 identifier - list of all identifiers can be found at:
http://www.i18nguy.com/unicode/language-identifiers.html
 
For ToF  we are using files for each language and then we compact them to two source files. 
Those files (translations.csv and campaign.csv) can be imported by Godot engine and converted to its own format (*.xl files)

Translations are located in translations/ (general translations) and translations/campaigns/ (missions) directories. 

## About compacting script
ToF use custom compacting Python 3.x script for generating source files. 
Script check differences in translation keys (using english file as a base) and constrains to translation types.
After successful use two files are created (translations/translations.csv and translations/campaigns/campaign.csv)

### Translations types and constraints
- labels (with LABEL_ prefix) - up to 20 chars of text
- texts - without limit

### Requirements for script
Python 3.x

## Creating translation process
- add translation file based on english version (copy current translation_en.csv and use language identifier)
- make changes

- use compact script to generate files ready for import as above:
python bin/compact.py

- open Godot Editor
- go to import tab  -> translations 
- choose source file (translation.csv) and choose target path (translations/_imported/)
- import
- choose source file (campaigns/campaign.csv) and choose target path (translations/_imported/)
- import
- add translation identifier to translations/languages.gd file in in_develop array


 
 