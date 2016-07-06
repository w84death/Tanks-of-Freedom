import csv
import glob

translations = {}
default_translation = {}

def process_file( name ):
    values = {}
    with open(name, newline='') as csvfile:
        csvreader = csv.reader(csvfile, delimiter=',', quotechar='|')
        for row in csvreader:
            values[row[0]] = row[1]

    csvfile.close()
    return values

def compare_dict( dict1, dict2 ):
    dict1 = list(dict1.values())
    dict2 = list(dict2.values())
    #remove lang
    dict1.pop(0)
    dict2.pop(0)

    dict1 = set(dict1)
    dict2 = set(dict2)

    diff_12 = dict1 - dict2
    diff_21 = dict2 - dict1

    return (bool(diff_12 | diff_21), diff_12, diff_21)

def get_translations_files(dir, input_files_prefix):
    return glob.glob( dir + "/" + input_files_prefix + "_*.csv")

def get_lang(filename):
    return filename[-6:-4]

def validate(directory, input_file_prefix):
    files = get_translations_files(directory, input_file_prefix)
    for file in files:
        translations[get_lang(file)] = process_file(file)

    if 'en' not in translations:
        print ('Error - default translation is not found!!')

    trans = translations.copy()
    default_trans = trans.pop('en')

    differences = {}
    for lang in trans:
        result = compare_dict(default_trans, trans[lang])
        if result[0]:
            if bool(result[1]):
                differences[' default > '+ lang] = result[1]
            if bool(result[2]):
                differences[' default < '+ lang] = result[2]

    return differences

def compact_translations(directory, output_file_name):
    output = {}
    for lang in translations:
        translation = translations[lang]
        for row in translation:
            if row in output:
                output[row].append(translation[row])
            else:
                output[row] = [translation[row]]

    with open(directory + output_file_name, 'w') as csvfile:
        csvwriter = csv.writer(csvfile, delimiter=',', quotechar='|', quoting=csv.QUOTE_MINIMAL)
        for row in sorted(output):
            csvwriter.writerow([row] + output[row])


def execute(directory, input_files_prefix, output_file_name):
    translations.clear()
    default_translation.clear()

    differences = validate(directory, input_files_prefix)
    if bool(differences):
        print ('Error - translation files are different')
        print ('Directory: ' + directory)
        print ('---------------------------------------')
        for diffs in differences:
            print(diffs + ": ")
        print ('---------------------------------------')
    else:
        compact_translations(directory, output_file_name)
        print ('Translations in directory: ' + directory + ' compacted!')


# EXECUTE
execute('../translations/', 'translations', 'translations.csv')
execute('../maps/translations/', 'campaign', 'campaign.csv')
# -------

