set(ALLAUX pgemraux.c)

set(IMRSRC pigemr.c pigemr2.c pitrmr.c pitrmr2.c)

set(mrsrc
$<$<BOOL:${BUILD_SINGLE}>:psgemr.c psgemr2.c pstrmr.c pstrmr2.c>
$<$<BOOL:${BUILD_COMPLEX}>:pcgemr.c pcgemr2.c pctrmr.c pctrmr2.c>
$<$<BOOL:${BUILD_DOUBLE}>:pdgemr.c pdgemr2.c pdtrmr.c pdtrmr2.c>
$<$<BOOL:${BUILD_COMPLEX16}>:pzgemr.c pzgemr2.c pztrmr.c pztrmr2.c>
)

add_library(scalapack_redist OBJECT ${ALLAUX} ${IMRSRC} ${mrsrc})
target_compile_definitions(scalapack_redist PRIVATE ${cargs})

target_sources(scalapack PRIVATE $<TARGET_OBJECTS:scalapack_redist>)
