import csv
import glob

MAX_LABEL_LENGTH = 20

translations = {}
default_translation = {}

def process_file( name ):
    values = {}
    with open(name, newline='') as csvfile:
        csvreader = csv.reader(csvfile)
        for row in csvreader:
            values[row[0]] = row[1]

    csvfile.close()
    return values

def compare_dict( dict1, dict2 ):
    dict1 = list(dict1.keys())
    dict2 = list(dict2.keys())
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

    differences = {
        'keys': {},
        'length': {}
    }
    for lang in trans:
        result = compare_dict(default_trans, trans[lang])
        if result[0]:
            if bool(result[1]):
                differences['keys']['(-) default > '+ lang] = result[1]
            if bool(result[2]):
                differences['keys']['(+) default < '+ lang] = result[2]

        msgs_length = check_msg_length(trans[lang], MAX_LABEL_LENGTH)
        if bool(msgs_length):
            differences['length']['(&) too long labels '+ lang] = msgs_length



    return differences

def check_msg_length(dict, max_length):
    result = {}
    for label in dict:
        length = len(dict[label])
        if label.startswith('LABEL_') and length > max_length:
            result[label] = length

    return result


def compact_translations(directory, output_file_name):
    output = {}

    default_trans = translations.pop('en')
    for row in default_trans:
        output[row] = [default_trans[row]]

    for lang in sorted(translations):
        translation = translations[lang]
        for row in translation:
            output[row].append(translation[row])

    with open(directory + output_file_name, 'w') as csvfile:
        csvwriter = csv.writer(csvfile, delimiter=',', quotechar='"', quoting=csv.QUOTE_ALL)
        for row in sorted(output):
            csvwriter.writerow([row] + output[row])

def print_differences(differences, directory):
    print('')
    print ('Directory: ' + directory)
    print ('---------------------------------------')
    for diffs in differences:
        print(diffs + ': ')
        print(", ".join(differences[diffs]))
    print ('---------------------------------------')
    print('')

def execute(directory, input_files_prefix, output_file_name):
    translations.clear()
    default_translation.clear()

    differences = validate(directory, input_files_prefix)
    if bool(differences['length']):
        print ('Warning - translation files have too long labels')
        print_differences(differences['length'], directory)
    if bool(differences['keys']):
        print ('Error - translation files are different')
        print_differences(differences['keys'], directory)
    else:
        compact_translations(directory, output_file_name)
        print ('Translations in directory: ' + directory + ' compacted!')


# EXECUTE
execute('translations/', 'translations', 'translations.csv')
execute('translations/campaigns/', 'campaign', 'campaign.csv')
# -------

