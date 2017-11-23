# kdb+tick+

## Overview of kdb+tick+

Tickerplant code from kxsystems/kdb-tick, formatted into lines, simplified where possible, and given a liberal sprinkle of comments.

## Contains

 - doc/
 - lib/
 - schema/
 - tick.q
 - r.q
 - chainedtick.q
 - chainedr.q
 - pub.q

## Quickstart

```
$ q tick.q sym .    -p 5010       # tick
$ q r.q :5010       -p 5011       # rdb
$ q sym             -p 5012       # hdb
$ q chainedtick.q   -p 5110       # chained tick
$ q chainedr.q      -p 5111       # chained tick
$ q pub.q                         # dummy publisher
```

## Changes from kdb-tick

**BREAKING**
Changes that affect processes outside of tick:
 - `time` column is now expected to be `timestamp`, not `timespan`

**SEMI-BREAKING**
Changes that affect processes inside of tick:
 - `.u.w` renamed to `.u.subs`
 - renamed `.u.m` to `.u.h`, `h` for handle

**NON-BREAKING**
Changes that are purely internal:
 - comments... comments everywhere!
 - whilst `time` and `sym` column are required, they do not need to be the first two columns of a table
