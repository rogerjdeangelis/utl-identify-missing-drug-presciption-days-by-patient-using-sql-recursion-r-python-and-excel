%let pgm=utl-identify-missing-drug-presciption-days-by-patient-using-sql-recursion-r-python-and-excel;

%stop_submission;

Identify missing drug presciption days by patient using sql r python and excel

      CONTENTS

         1 simple example of recursion
         2 identify gaps
           see https://tinyurl.com/4e6yaap8
           for python and excel

github
https://tinyurl.com/3738ptnn
https://github.com/rogerjdeangelis/utl-identify-missing-drug-presciption-days-by-patient-using-sql-recursion-r-python-and-excel

SOAPBOX ON

Sas proc sql does not support recursion or Common Table Expressions (CTEs).
However embeded macro code inside proc sql can do psuedo recusion.
CTEs and recusion are useful contraucts

SOAPBOX OFF

related to (but different)
communities.sas
https://tinyurl.com/4c8u68yy
https://communities.sas.com/t5/SAS-Programming/Creating-observation-for-days-without-drugs/m-p/818800#M323218

/**************************************************************************************************************************/
/*          INPUT                   |            PROCESS                            |  OUTPUT                             */
/*          =====                   |            =======                            |  ======                             */
/*                                  |                                               |                                     */
/* %let bday=5;                     |  1 SIMPLE EXAMPLE                             |     NUM                             */
/* %let eday=8;                     |  =================                            |                                     */
/*                                  |                                               | 1   5                               */
/*                                  |  %utl_submit_r64x("                           | 2   6                               */
/*                                  |  library(haven);                              | 3   7                               */
/*                                  |  library(sqldf);                              | 4   8                               */
/*                                  |  have<-read_sas('d:/sd1/have.sas7bdat');      |                                     */
/*                                  |  want<- sqldf('                               |                                     */
/*                                  |  with recursive numbers(num) as (             |                                     */
/*                                  |    select                                     |                                     */
/*                                  |       &bday                                   |                                     */
/*                                  |    union                                      |                                     */
/*                                  |       all                                     |                                     */
/*                                  |    select                                     |                                     */
/*                                  |       num + 1                                 |                                     */
/*                                  |    from                                       |                                     */
/*                                  |       numbers                                 |                                     */
/*                                  |    where                                      |                                     */
/*                                  |       num < &eday                             |                                     */
/*                                  |  )                                            |                                     */
/*                                  |  select num from numbers                      |                                     */
/*                                  |  ');                                          |                                     */
/*                                  |  want;                                        |                                     */
/*                                  |  ");                                          |                                     */
/*                                  |                                               |                                     */
/*----------------------------------|-------------------------------------------------------------------------------------*/
/*  SD1.HAVE                        |  2 IDENTIFY MISSED PRESCIPTIONS               |  SAS                                */
/*                                  |                                               |                                     */
/*  ID    BDAY    EDAY              |                                               |  ID ALLNUMS SUBNUMS                 */
/*                                  |  Generate all days between                    |                                     */
/*   1      1       3               |  min(bday) to max(eday) by ID                 |   1       1       1                 */
/*   1      6       8               |  and BDAY (each observation)                  |   1       2       2                 */
/*   2      3       5               |                                               |   1       3       3                 */
/*   2      7       9               |  Gernerate all days between                   |   1       4      NA missed          */
/*                                  |  min(bday) to max(eday) by just ID            |   1       5      NA missed          */
/*                                  |                                               |   1       6       6                 */
/* options validvarname=upcase;     |  Left jointwo tables                          |   1       7       7                 */
/* libname sd1 "d:/sd1";            |  by ID & and by ID BDAY                       |   1       8       8                 */
/* data sd1.have;                   |                                               |                                     */
/*  input  id bday eday ;           |                                               |   2       3       3                 */
/* cards4;                          |  proc datasets lib=sd1 nolist nodetails;      |   2       4       4                 */
/* 1 1 3                            |   delete want;                                |   2       5       5                 */
/* 1 6 8                            |  run;quit;                                    |   2       6      NA missed          */
/* 2 3 5                            |                                               |   2       7       7                 */
/* 2 7 9                            |  %utl_rbeginx;                                |   2       8       8                 */
/* ;;;;                             |  parmcards4;                                  |   2       9       9                 */
/* run;quit;                        |  library(haven)                               |                                     */
/*                                  |  library(sqldf)                               |   SAS                               */
/*                                  |  source("c:/oto/fn_tosas9x.R")                |   ID    ALLNUMS    SUBNUMS          */
/*                                  |  options(sqldf.dll = "d:/dll/sqlean.dll")     |                                     */
/*                                  |  have<-read_sas("d:/sd1/have.sas7bdat")       |    1       1          1             */
/*                                  |  print(have)                                  |    1       2          2             */
/*                                  |  want<-sqldf('                                |    1       3          3             */
/*                                  |  WITH maxmin AS (                             |    1       4          .             */
/*                                  |    SELECT                                     |    1       5          .             */
/*                                  |      id                                       |    1       6          6             */
/*                                  |     ,min(bday) as daymin                      |    1       7          7             */
/*                                  |     ,MAX(eday) as daymax                      |    1       8          8             */
/*                                  |    FROM                                       |    2       3          3             */
/*                                  |      have                                     |    2       4          4             */
/*                                  |    GROUP                                      |    2       5          5             */
/*                                  |      BY id                                    |    2       6          .             */
/*                                  |  ),                                           |    2       7          7             */
/*                                  |  sequence AS (                                |    2       8          8             */
/*                                  |    SELECT                                     |    2       9          9             */
/*                                  |      id                                       |                                     */
/*                                  |     ,daymin as num                            |                                     */
/*                                  |     ,daymax                                   |                                     */
/*                                  |    from                                       |                                     */
/*                                  |      maxmin                                   |                                     */
/*                                  |    union                                      |                                     */
/*                                  |      all                                      |                                     */
/*                                  |    SELECT                                     |                                     */
/*                                  |      id                                       |                                     */
/*                                  |     ,num + 1                                  |                                     */
/*                                  |     ,daymax                                   |                                     */
/*                                  |    FROM sequence                              |                                     */
/*                                  |    WHERE num < daymax                         |                                     */
/*                                  |  ),                                           |                                     */
/*                                  |  sequencebday AS (                            |                                     */
/*                                  |    SELECT                                     |                                     */
/*                                  |      id                                       |                                     */
/*                                  |     ,bday                                     |                                     */
/*                                  |     ,bday as num                              |                                     */
/*                                  |     ,eday                                     |                                     */
/*                                  |    from                                       |                                     */
/*                                  |      have                                     |                                     */
/*                                  |    union                                      |                                     */
/*                                  |      all                                      |                                     */
/*                                  |    SELECT                                     |                                     */
/*                                  |      id                                       |                                     */
/*                                  |     ,bday                                     |                                     */
/*                                  |     ,num + 1                                  |                                     */
/*                                  |     ,eday                                     |                                     */
/*                                  |    FROM                                       |                                     */
/*                                  |      sequencebday                             |                                     */
/*                                  |    WHERE                                      |                                     */
/*                                  |       num < eday                              |                                     */
/*                                  |  ),                                           |                                     */
/*                                  |  subs as (                                    |                                     */
/*                                  |    select                                     |                                     */
/*                                  |      *                                        |                                     */
/*                                  |    from                                       |                                     */
/*                                  |      sequencebday                             |                                     */
/*                                  |    order                                      |                                     */
/*                                  |      by id, bday                              |                                     */
/*                                  |    )                                          |                                     */
/*                                  |    select                                     |                                     */
/*                                  |      l.id                                     |                                     */
/*                                  |     ,l.num as allnums                         |                                     */
/*                                  |     ,r.num as subnums                         |                                     */
/*                                  |    from                                       |                                     */
/*                                  |      sequence as l                            |                                     */
/*                                  |    left join                                  |                                     */
/*                                  |      sequencebday as r                        |                                     */
/*                                  |    on                                         |                                     */
/*                                  |      l.id = r.id and                          |                                     */
/*                                  |      l.num=r.num                              |                                     */
/*                                  |    order                                      |                                     */
/*                                  |      by l.id, l.num, r.num                    |                                     */
/*                                  |                                               |                                     */
/*                                  |  ')                                           |                                     */
/*                                  |  want                                         |                                     */
/*                                  |                                               |                                     */
/*                                  |  fn_tosas9x(                                  |                                     */
/*                                  |        inp    = want                          |                                     */
/*                                  |       ,outlib ="d:/sd1/"                      |                                     */
/*                                  |       ,outdsn ="want"                         |                                     */
/*                                  |       )                                       |                                     */
/*                                  |  ;;;;                                         |                                     */
/*                                  |  %utl_rendx;                                  |                                     */
/*                                  |                                               |                                     */
/*                                  |  proc print data=sd1.want;                    |                                     */
/*                                  |  run;quit;                                    |                                     */
/**************************************************************************************************************************/

/*       _                 _                                     _
/ |  ___(_)_ __ ___  _ __ | | ___   _ __ ___  ___ _   _ _ __ ___(_) ___  _ __
| | / __| | `_ ` _ \| `_ \| |/ _ \ | `__/ _ \/ __| | | | `__/ __| |/ _ \| `_ \
| | \__ \ | | | | | | |_) | |  __/ | | |  __/ (__| |_| | |  \__ \ | (_) | | | |
|_| |___/_|_| |_| |_| .__/|_|\___| |_|  \___|\___|\__,_|_|  |___/_|\___/|_| |_|
                    |_|
 _                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

%let bday=5;
%let eday=8;

/*
 _ __  _ __ ___   ___ ___  ___ ___
| `_ \| `__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
*/

%utl_submit_r64x("
library(haven);
library(sqldf);
have<-read_sas('d:/sd1/have.sas7bdat');
want<- sqldf('
with recursive numbers(num) as (
  select
     &bday
  union
     all
  select
     num + 1
  from
     numbers
  where
     num < &eday
)
select num from numbers
');
want;
");

/**************************************************************************************************************************/
/*   num                                                                                                                  */
/*                                                                                                                        */
/* 1   5                                                                                                                  */
/* 2   6                                                                                                                  */
/* 3   7                                                                                                                  */
/* 4   8                                                                                                                  */
/**************************************************************************************************************************/

/*___    _           _            _   _  __
|___ \  (_)_ __   __| | ___ _ __ | |_(_)/ _|_   _    __ _  __ _ _ __  ___
  __) | | | `_ \ / _` |/ _ \ `_ \| __| | |_| | | |  / _` |/ _` | `_ \/ __|
 / __/  | | | | | (_| |  __/ | | | |_| |  _| |_| | | (_| | (_| | |_) \__ \
|_____| |_|_| |_|\__,_|\___|_| |_|\__|_|_|  \__, |  \__, |\__,_| .__/|___/
                                            |___/   |___/      |_|
*/

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
 input  id bday eday ;
cards4;
1 1 3
1 6 8
2 3 5
2 7 9
;;;;
run;quit;

/**************************************************************************************************************************/
/*  SD1.HAVE                                                                                                              */
/*                                                                                                                        */
/*  ID    BDAY    EDAY                                                                                                    */
/*                                                                                                                        */
/*   1      1       3                                                                                                     */
/*   1      6       8                                                                                                     */
/*   2      3       5                                                                                                     */
/*   2      7       9                                                                                                     */
/**************************************************************************************************************************/

/*
 _ __  _ __ ___   ___ ___  ___ ___
| `_ \| `__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
*/

proc datasets lib=sd1 nolist nodetails;
 delete want;
run;quit;

%utl_rbeginx;
parmcards4;
library(haven)
library(sqldf)
source("c:/oto/fn_tosas9x.R")
options(sqldf.dll = "d:/dll/sqlean.dll")
have<-read_sas("d:/sd1/have.sas7bdat")
print(have)
want<-sqldf('
WITH maxmin AS (
  SELECT
    id
   ,min(bday) as daymin
   ,MAX(eday) as daymax
  FROM
    have
  GROUP
    BY id
),
sequence AS (
  SELECT
    id
   ,daymin as num
   ,daymax
  from
    maxmin
  union
    all
  SELECT
    id
   ,num + 1
   ,daymax
  FROM sequence
  WHERE num < daymax
),
sequencebday AS (
  SELECT
    id
   ,bday
   ,bday as num
   ,eday
  from
    have
  union
    all
  SELECT
    id
   ,bday
   ,num + 1
   ,eday
  FROM
    sequencebday
  WHERE
     num < eday
),
subs as (
  select
    *
  from
    sequencebday
  order
    by id, bday
  )
  select
    l.id
   ,l.num as allnums
   ,r.num as subnums
  from
    sequence as l
  left join
    sequencebday as r
  on
    l.id = r.id and
    l.num=r.num
  order
    by l.id, l.num, r.num

')
want

fn_tosas9x(
      inp    = want
     ,outlib ="d:/sd1/"
     ,outdsn ="want"
     )
;;;;
%utl_rendx;

proc print data=sd1.want;
run;quit;


/**************************************************************************************************************************/
/* R                       |  SAS                                                                                         */
/*    id allnums subnums   |  ROWNAMES    ID    ALLNUMS    SUBNUMS                                                        */
/*                         |                                                                                              */
/* 1   1       1       1   |      1        1       1          1                                                           */
/* 2   1       2       2   |      2        1       2          2                                                           */
/* 3   1       3       3   |      3        1       3          3                                                           */
/* 4   1       4      NA   |      4        1       4          .                                                           */
/* 5   1       5      NA   |      5        1       5          .                                                           */
/* 6   1       6       6   |      6        1       6          6                                                           */
/* 7   1       7       7   |      7        1       7          7                                                           */
/* 8   1       8       8   |      8        1       8          8                                                           */
/* 9   2       3       3   |      9        2       3          3                                                           */
/* 10  2       4       4   |     10        2       4          4                                                           */
/* 11  2       5       5   |     11        2       5          5                                                           */
/* 12  2       6      NA   |     12        2       6          .                                                           */
/* 13  2       7       7   |     13        2       7          7                                                           */
/* 14  2       8       8   |     14        2       8          8                                                           */
/* 15  2       9       9   |     15        2       9          9                                                           */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
