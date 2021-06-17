add_subdirectory(PBBLAS)
add_subdirectory(PTZBLAS)
add_subdirectory(PTOOLS)

add_library(appblas OBJECT pilaenv.f)
#---------------------------------------------------------------------------
#  Level 1 PBLAS.
#---------------------------------------------------------------------------
set(piblas1 picopy_.c)

set(blas1)
if("s" IN_LIST arith)
list(APPEND blas1 psswap_.c psscal_.c pscopy_.c psaxpy_.c psdot_.c psnrm2_.c psasum_.c psamax_.c)
endif()

if("c" IN_LIST arith)
list(APPEND blas1 pcscal_.c pcsscal_.c pccopy_.c pcaxpy_.c pcdotu_.c pcdotc_.c pscnrm2_.c pscasum_.c pcamax_.c)
endif()

if("d" IN_LIST arith)
list(APPEND blas1 pdswap_.c pdscal_.c pdcopy_.c pdaxpy_.c pddot_.c pdnrm2_.c pdasum_.c pdamax_.c)
endif()

if("z" IN_LIST arith)
list(APPEND blas1 pzswap_.c pzscal_.c pzdscal_.c pzcopy_.c pzaxpy_.c pzdotu_.c pzdotc_.c pdznrm2_.c pdzasum_.c pzamax_.c)
endif()

#---------------------------------------------------------------------------
#  Level 2 PBLAS.
#---------------------------------------------------------------------------

set(blas2)

if("s" IN_LIST arith)
list(APPEND blas2 psgemv_.c psger_.c pssymv_.c pssyr_.c pssyr2_.c pstrmv_.c pstrsv_.c psagemv_.c psasymv_.c psatrmv_.c)
endif()

if("c" IN_LIST arith)
list(APPEND blas2 pcgemv_.c pcgerc_.c pcgeru_.c pchemv_.c pcher_.c pcher2_.c pctrmv_.c pctrsv_.c pcagemv_.c pcahemv_.c pcatrmv_.c)
endif()

if("d" IN_LIST arith)
list(APPEND blas2 pdgemv_.c pdger_.c pdsymv_.c pdsyr_.c pdsyr2_.c pdtrmv_.c pdtrsv_.c pdagemv_.c pdasymv_.c pdatrmv_.c)
endif()

if("z" IN_LIST arith)
list(APPEND blas2 pzgemv_.c pzgerc_.c pzgeru_.c pzhemv_.c pzher_.c pzher2_.c pztrmv_.c pztrsv_.c pzagemv_.c pzahemv_.c pzatrmv_.c)
endif()

#---------------------------------------------------------------------------
#  Level 3 PBLAS.
#---------------------------------------------------------------------------
set(blas3)

if("s" IN_LIST arith)
list(APPEND blas3 psgeadd_.c psgemm_.c pssymm_.c pssyr2k_.c pssyrk_.c pstradd_.c pstran_.c pstrmm_.c pstrsm_.c)
endif()

if("c" IN_LIST arith)
list(APPEND blas3 pcgeadd_.c pcgemm_.c pchemm_.c pcher2k_.c pcherk_.c pcsymm_.c pcsyr2k_.c pcsyrk_.c pctradd_.c pctranc_.c pctranu_.c pctrmm_.c pctrsm_.c)
endif()

if("d" IN_LIST arith)
list(APPEND blas3 pdgeadd_.c pdgemm_.c pdsymm_.c pdsyr2k_.c pdsyrk_.c pdtradd_.c pdtran_.c pdtrmm_.c pdtrsm_.c)
endif()

if("z" IN_LIST arith)
list(APPEND blas3 pzgeadd_.c pzgemm_.c pzhemm_.c pzher2k_.c pzherk_.c pzsymm_.c pzsyr2k_.c pzsyrk_.c pztradd_.c pztranc_.c pztranu_.c pztrmm_.c pztrsm_.c)
endif()

add_library(scalapack_blas OBJECT ${piblas1} ${blas1} ${blas2} ${blas3})

target_sources(scalapack PRIVATE $<TARGET_OBJECTS:appblas> $<TARGET_OBJECTS:scalapack_blas>)
