# Tanks of Freedom Community Translations Guide

## About this guide
This file is meant to be a guide for any and all ToF community members wanting to import own translations into the game

## About Translation mechanism
Godot uses csv (comma separated values) files for importing translations.
Languages are distinguished by i18 identifier - list of all identifiers can be found at:
http://www.i18nguy.com/unicode/language-identifiers.html

For ToF  we are creating separate files for each language, and then we compact them into two source files.
Those files (translations.csv and campaign.csv) can be imported into Godot project and converted to binary format (*.xl files)

Translations are placed in translations/ (general translations) and translations/campaigns/ (missions) directories.

## About compacting script
ToF uses custom compacting Python 3.x script for generating source files.
Script checks differences between translation keys in all languages (using english file as a base) and constrains to translation types. Script should indicate differences in keys between different files, although there are some known issues, where script fails to run, if differences are too big.
After successful run two files will be created (translations/translations.csv and translations/campaigns/campaign.csv)

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

Godot 2.1 note: it seems, that Editor rebuilds .xl files on it's own after .csv files are updated and compacted.

## About contributing translations

Due to translations files being auto-generated from apropriate country-coded ones, please create pull requests only containing modified files for a particular language, or adding new ones. Please do not add compacted files to the PR. If possible, please run the compacting script before creating PR to make sure, that there aren't any missing keys, and labels are not too long.

