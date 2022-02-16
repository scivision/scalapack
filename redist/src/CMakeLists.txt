set(ALLAUX pgemraux.c)

set(IMRSRC pigemr.c pigemr2.c pitrmr.c pitrmr2.c)

set(mrsrc
$<$<IN_LIST:s,${arith}>:psgemr.c psgemr2.c pstrmr.c pstrmr2.c>
$<$<IN_LIST:c,${arith}>:pcgemr.c pcgemr2.c pctrmr.c pctrmr2.c>
$<$<IN_LIST:d,${arith}>:pdgemr.c pdgemr2.c pdtrmr.c pdtrmr2.c>
$<$<IN_LIST:z,${arith}>:pzgemr.c pzgemr2.c pztrmr.c pztrmr2.c>
)

add_library(scalapack_redist OBJECT ${ALLAUX} ${IMRSRC} ${mrsrc})

target_sources(scalapack PRIVATE $<TARGET_OBJECTS:scalapack_redist>)
