# xtractb
To install:
*  in Bible.pm change $rootdir to the location of the files 
* create off of $rootdir a lib/ directory
 *     and add translations.db to directory lib/

Usage:

xtractb --- extracts verse from the bible.. output in 'database' format

   Usage:
      xtractb -b <book> -c <chapter> -v <verse>
      (or) -b <book>
      (or) -b <book-book>
      (or) -b <book> -c <chapter>
      (or) -b <book> -c <chapter-chapter>
      (or) -b <book> -c <chapter> -v <verse-verse>
      (or) -range <range: nt,ot,entire>
          [-t <translation: niv,nasb,kjv,esv>]

-------
formatb  --- formats output to desired media (ie. text or tex)

   Usage:
      formatb [-o <output format: txt,tex default: txt>] < input_file
            [-g(reek input (tex mode only))]
            [-i(gnore printing the tex macro information (tex mode only))]
            [-p(oetry)] [-n(o numbers for chapter and verses)]
            [-k( highlight in color)]

   Notes:
      -i: does not print the macro information for creating a tex file
          this is useful if combining several files into one
          so you don't have to delete all the tex information
      -p: poetry is used with the tex option to make Psalms look 
          normal (not like prose... each line centered)
      -n: no numbers for chapter and verses doesn't print the numbers for 
          the chapter and verse
      -k: colorizes words on terminals that support the escape
          characters (ansi?)

######################################################################
Examples of Possible Usage:
--) xtractb -t niv -b Psalms -c 1 |formatb
      looks up Psalms 1 in the niv and 
        outputs a reasonable text format to STDOUT
--) xtractb -t es -b "1 Peter" -c 5 -v 1-11 |formatb 
      extracts 1 Peter 5:1-11 
