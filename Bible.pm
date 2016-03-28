##############################################################################
package Bible;
#########################################################
## Change the following for localization
$swap_dir = $ENV{'BIBLE_SWAP_DIR'};
$swap_dir ||= "/tmp";
$root_dir = $ENV{'BIBLE_LIB_DIR'};
$root_dir ||= "";
##
#########################################################
use strict;
use Text::Abbrev;

BEGIN {
    use Exporter ();
    use vars qw(@ISA @EXPORT @EXPORTVARS);

    @ISA = qw(Exporter);
    @EXPORT = qw(&decompressb &Handle_Int &Handler $swap_dir
                 $root_dir %abbrev2name $debug &opendbm $file
                 %book2num %num2book &initBook2num %abbrev2translation
                 @translations &initTranslations &bible2num &num2bible
                );
}
    use vars @EXPORT;


    my $books;
    my @otlbooks = (
       '1 Chronicles', '1 Kings', '1 Samuel', '2 Chronicles',
       '2 Kings', '2 Samuel', 'Song of Solomon');
    my @ntlbooks = (
       '1 Corinthians', '1 John', '1 Peter', '1 Thessalonians',
       '1 Timothy', '2 Corinthians', '2 John', '2 Peter', 
       '2 Thessalonians', '2 Timothy', '3 John');
    my @ntsbooks = qw(
       Acts      Colossians
       Ephesians 
       Galatians 
       Hebrews      
       James     John
       Jude         
       Luke        Mark      Matthew
       Philemon  Philippians Revelation
       Romans    Titus        
    );
    my @otsbooks = qw(
       Amos        
       Daniel    Deuteronomy Ecclesiastes Esther
       Exodus    Ezekiel     Ezra         Genesis
       Habakkuk  Haggai      Hosea     Isaiah
       Jeremiah    Job          Joel      
       Jonah     Joshua      Judges    Lamentations
       Leviticus Malachi      
       Micah     Nahum       Nehemiah     Numbers   Obadiah
       Proverbs     Psalms    
       Ruth        Zechariah Zephaniah
    );
    my @ntbooks = (@ntsbooks, @ntlbooks);
    my @otbooks = (@otsbooks, @otlbooks);
#    foreach (@otbooks) {
#      $books{$_} = "ot";
#    }
#    foreach (@ntbooks) {
#      $books{$_} = "nt";
#    }
  my %numen2book = ( 13,'1 Chronicles', 46,'1 Corinthians', 62,'1 John', 11,'1 Kings', 60,'1 Peter', 9,'1 Samuel', 52,'1 Thessalonians', 54,'1 Timothy', 14,'2 Chronicles', 47,'2 Corinthians', 63,'2 John', 12,'2 Kings', 61,'2 Peter', 10,'2 Samuel', 53,'2 Thessalonians', 55,'2 Timothy', 64,'3 John', 44,'Acts', 30,'Amos', 51,'Colossians', 27,'Daniel', 5,'Deuteronomy', 21,'Ecclesiastes', 49,'Ephesians', 17,'Esther', 2,'Exodus', 26,'Ezekiel', 15,'Ezra', 48,'Galatians', 1,'Genesis', 35,'Habakkuk', 37,'Haggai', 58,'Hebrews', 28,'Hosea', 23,'Isaiah', 59,'James', 24,'Jeremiah', 18,'Job', 29,'Joel', 43,'John', 32,'Jonah', 6,'Joshua', 65,'Jude', 7,'Judges', 25,'Lamentations', 3,'Leviticus', 42,'Luke', 39,'Malachi', 41,'Mark', 40,'Matthew', 33,'Micah', 34,'Nahum', 16,'Nehemiah', 4,'Numbers', 31,'Obadiah', 57,'Philemon', 50,'Philippians', 20,'Proverbs', 19,'Psalms', 66,'Revelation', 45,'Romans', 8,'Ruth', 22,'Song of Solomon', 56,'Titus', 38,'Zechariah', 36,'Zephaniah');

    my %numgr2book = (54, '1 Timotheus', 33, 'Micha', 6, 'Josua', 50, 'Philipper', 30, 'Amos', 7, 'Richter', 21, 'Prediger', 1, '1 Mose', 62, '1 Johannes', 43, 'Johannes', 35, 'Habakuk', 5, '5 Mose', 16, 'Nehemia', 56, 'Titus', 25, 'klagelieder', 53, '2 Thessalonicher', 24, 'Jeremia', 48, 'Galater', 18, 'Hiob', 10, '2 Samuel', 29, 'Joel', 23, 'Jesaja', 59, 'Jakobus', 51, 'Kolosser', 41, 'Markus', 2, '2 Mose', 63, '2 Johannes', 47, '2 Korinther', 52, '1 Thessalonicher', 20, 'Sprueche', 42, 'Lukas', 31, 'Obadja', 37, 'Haggai', 55, '2 Timotheus', 17, 'Ester', 61, '2 Petrus', 9, '1 Samuel', 32, 'Jona', 26, 'Hesekiel', 22, 'Hoholied', 40, 'Matthaeus', 49, 'Epheser', 66, 'Offenbarung', 44, 'Apostelgeschichte', 36, 'Zephanja', 39, 'Maleachi', 3, '3 Mose', 64, '3 Johannes', 8, 'Rut', 57, 'Philemon', 19, 'Psalm', 58, 'Hebraeer', 11, '1 Koenige', 12, '2 Koenige', 60, '1 Petrus', 45, 'Roemer', 15, 'Esra', 13, '1 Chronik', 27, 'Daniel', 14, '2 Chronik', 28, 'Hosea', 46, '1 Korinther', 4, '4 Mose', 65, 'Judas', 34, 'Nahum', 38, 'Sacharja');

    my %numsp2book = (26, 'Ezequiel', 36, 'Sofonías', 35, 'Habacuc', 14, '2 Crónicas', 6, 'Josué', 49, 'Efesios', 54, '1 Timoteo', 55, '2 Timoteo', 30, 'Amós', 10, '2 Samuel', 21, 'Eclesiastés', 5, 'Deuteronomio', 12, '2 Reyes', 48, 'Gálatas', 34, 'Nahúm', 62, '1 Juan', 15, 'Esdras', 37, 'Hageo', 29, 'Joel', 60, '1 Pedro', 46, '1 Corintios', 43, 'Juan', 53, '2 Tesalonicenses', 50, 'Filipenses', 38, 'Zacarías', 24, 'Jeremías', 42, 'Lucas', 9, '1 Samuel', 32, 'Jonás', 51, 'Colosenses', 23, 'Isaías', 2, 'Exodo', 63, '2 Juan', 17, 'Ester', 31, 'Abdías', 58, 'Hebreos', 20, 'Proverbios', 22, 'Cantares', 52, '1 Tesalonicenses', 59, 'Santiago', 11, '1 Reyes', 44, 'Hechos', 8, 'Rut', 7, 'Jueces', 56, 'Tito', 64, '3 Juan', 39, 'Malaquías', 25, 'Lamentaciones', 3, 'Levítico', 41, 'Marcos', 13, '1 Crónicas', 47, '2 Corintios', 61, '2 Pedro', 27, 'Daniel', 16, 'Nehemías', 4, 'Números', 57, 'Filemón', 19, 'Salmos', 1, 'Génesis', 33, 'Miqueas', 40, 'Mateo', 65, 'Judas', 66, 'Apocalipsis', 28, 'Oseas', 18, 'Job', 45, 'Romanos', );



    ############################  
    ### initialize abbreviations and book2num/num2book
sub initBook2num {
    my $language = $_[0];
    if ($language =~ /^English$/) {
       %num2book = %numen2book;
       #special cases
    } elsif ($language =~ /^Spanish$/) {
       %num2book = %numsp2book;
    } elsif ($language =~ /^German$/) {
       %num2book = %numgr2book;
    } else {
      die "Unknown language\n";
    }

    foreach (keys %num2book)
    {
       $book2num{$num2book{$_}}= $_;
    }
    foreach (keys %book2num) {
      my $tmpvar = $book2num{$_};
      my $tmpvar2 = $_;
      $tmpvar2 =~ s/\s*//g;
      $book2num{$tmpvar2}=$tmpvar;

      $tmpvar2 = $_;
      $tmpvar2 =~ tr/A-Z/a-z/; 
      $book2num{$tmpvar2}=$tmpvar;
      $tmpvar2 =~ s/\s*//g;
      $book2num{$tmpvar2}=$tmpvar;
    }
    %abbrev2name = abbrev(keys %book2num);
    $abbrev2name{"mt"} = "Matthew";
    $abbrev2name{"pv"} = "Proverbs";
    $abbrev2name{"mr"} = "Mark";
    $abbrev2name{"mk"} = "Mark";
    $abbrev2name{"jas"} = "James";
    $abbrev2name{"php"} = "Philippians";
    $abbrev2name{"so"} = "Song of Solomon";
    initTranslations();
}

sub initTranslations{

    @translations = ('english_nasb','english_esv','english_niv','english_kjv','english_strongs','english_asv','english_ylt','spanish','spanish_sev','albanian', 'bulgarian', 'chinese_union_trad', 'croatian', 'danish', 'finnish', 'french', 'french_darby', 'german_luther', 'greek_nt', 'hebrew_ot', 'hungarian', 'italian', 'korean', 'latvian_nt', 'norwegian', 'portuguese', 'rumanian', 'russian', 'swahili_nt', 'swedish', 'ukrainian', 'vietnamese');

    @translations = ('nasb','esv','nlt','niv','kjv');

    %abbrev2translation = abbrev(@translations);
    $abbrev2translation{"dar"} = "french_darby";
    $abbrev2translation{"sev"} = "spanish_sev";
    $abbrev2translation{"spanish"} = "spanish";
    $abbrev2translation{"spa"} = "spanish";
    $abbrev2translation{"french"} = "french";
    $abbrev2translation{"fre"} = "french";
}



    ############################  
    ### Decompress translation
    sub decompressb{
        my $file  = $_[0];
        my $tmpfile = "$root_dir/$file.gz";
        print STDERR "Decompressing ${tmpfile}....\n" if $debug; 
        $file              = "$swap_dir/${file}";
        die ("Input file non-existant:$tmpfile\n") if (! -f $tmpfile);
        die ("Output dir non-existant:$swap_dir\n") if (! -d $swap_dir);

        if (! -f $file) {
          my $command = "gunzip -c $tmpfile > $file";
          print STDERR "$command\n" if $debug;
          system($command); wait();
        } else {
          print STDERR "$file already decompressed...\n" if $debug;
        }
    }

    ############################  
    sub Handle_Int{
       my @sig = ('HUP','INT','QUIT','ILL','TRAP','IOT',
                  'FPE','PIPE','BUS','SEGV','TERM','USR1',
                  'USR2','XCPU','XFSZ');
       foreach (@sig) {$SIG{$_}= 'Handler';}
    }  
    sub Handler{
       print(STDERR "\n$0: Dying on signal $_[0]\n");
       $debug = 1;
       Cleanup();
       exit(1);
    }

    ############################  
    sub bible2num{
      my ($book,$chapter,$verse) =@_;
      $_ = $book*1000000+$chapter*1000+$verse;
    }
    ############################  
    sub num2bible{
      my ($num) = @_;
      my ($book,$chapter,$verse);
      $verse = $num%1000;
      $chapter = ($num%1000000-$verse)/1000;
      $book = ($num-$chapter*1000-$verse)/1000000;
      @_ = ($book,$chapter,$verse);
    }
    ############################  
    sub Cleanup{
      $debug = 1;
      if ($file) {
        if (-e $file) {
            print STDERR "Removing decompressed file....\n" if $debug;
            my $command = "rm -f $file";
            print STDERR "$command\n" if $debug;
            system($command); wait();
        } else {
            print STDERR "$file already removed....\n" if $debug;
        }
      }
    }

1;

