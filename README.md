# xtractb
##Installation
*  get translations.db file
*  install all dependent libraries using cpan
*  brew install sql-lite

##Usage:
```
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
          [-end (put reference at end)]

-------
formatb  --- formats output to desired media (ie. text or tex)

   Usage:
     --tab <0,1> (true/false)
     --wrap <0,1> (true/false)
     --nonumbers (no numbers for chapter and verses (default: on))

######################################################################
Examples of Possible Usage:
--) xtractb -t niv -b Psalms -c 1 |formatb
      looks up Psalms 1 in the niv and 
        outputs a reasonable text format to STDOUT
--) xtractb -t es -b "1 Peter" -c 5 -v 1-11 |formatb 
      extracts 1 Peter 5:1-11 
```
