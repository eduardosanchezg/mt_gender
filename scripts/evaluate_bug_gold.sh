#!/bin/bash
# Usage:
#   evaluate_all_languages.sh <corpus> <output-folder>
set -e

corpus_fn=/private/home/eduardosanchez/phd_workplace/repos/mt_gender/data/aggregates/bug_gold_mhbcut.txt
out_folder=/private/home/eduardosanchez/phd_workplace/repos/mt_gender/output


#langs=("ar" "uk" "he" "ru" "it" "fr" "es" "de")
#mt_systems=("sota" "aws" "bing" "google" "systran" )

langs=("ar" "uk" "ru" "it" "cs" "es" "de")
mt_systems=("bug_gold_llama_fem" "bug_gold_llama_masc" "bug_gold_nllb" "bug_gold_llama_unsp")


# Make sure systran has all translations
# for lang in ${langs[@]}
# do
#     echo "Translating $lang with systran..."
#     ../scripts/systran_language.sh $corpus_fn $lang
# done

for trans_sys in ${mt_systems[@]}
do
    for lang in ${langs[@]}
    do
        echo "evaluating $trans_sys, $lang"
        if [[ "$lang" == "uk" && "$trans_sys" == "aws" ]]; then
            echo "skipping.."
            continue
        fi

        if [[ "$trans_sys" == "sota" ]]; then
            if [[ "$lang" != "de" && "$lang" != "fr" ]]; then
                echo "skipping.."
                continue
            fi
        fi

        # Run evaluation
        mkdir -p $out_folder/$trans_sys
        out_file=$out_folder/$trans_sys/$lang.log
        echo "Evaluating $lang into $out_file"
        ../scripts/evaluate_language.sh /private/home/eduardosanchez/phd_workplace/repos/mt_gender/data/aggregates/${lang}/bug_gold_mhbcut.txt $lang $trans_sys > $out_file
    done
done

echo "DONE!"
