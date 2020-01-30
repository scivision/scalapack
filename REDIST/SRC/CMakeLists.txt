set (ALLAUX
   pgemraux.c)

set (IMRSRC
   pigemr.c pigemr2.c pitrmr.c pitrmr2.c)

set(mrsrc)

if("s" IN_LIST arith)
list(APPEND mrsrc psgemr.c psgemr2.c pstrmr.c pstrmr2.c)
endif()

if("c" IN_LIST arith)
list(APPEND pcgemr.c pcgemr2.c pctrmr.c pctrmr2.c)
endif()

if("d" IN_LIST arith)
list(APPEND pdgemr.c pdgemr2.c pdtrmr.c pdtrmr2.c)
endif()

if("z" IN_LIST arith)
list(APPEND pzgemr.c pzgemr2.c pztrmr.c pztrmr2.c)
endif()

target_sources(scalapack PRIVATE ${ALLAUX} ${IMRSRC} ${mrsrc})
