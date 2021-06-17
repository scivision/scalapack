set(ALLAUX icopy.f)

set(SCATGEN slatm1.f slaran.f slarnd.f)

set(SMATGEN slatms.f slagge.f slagsy.f slarot.f)

set(CMATGEN clarnv.f clatm1.f clatms.f clagge.f claghe.f clagsy.f clarot.f clarnd.f)

set(DZATGEN dlatm1.f dlaran.f dlarnd.f)

set(DMATGEN dlatms.f dlagge.f dlagsy.f dlarot.f)

set(ZMATGEN zlarnv.f zlatm1.f zlatms.f zlagge.f zlaghe.f zlagsy.f zlarot.f zlarnd.f)

set(extra_lapack ${ALLAUX})

if("s" IN_LIST arith)
list(APPEND extra_lapack ${SCATGEN} ${SMATGEN})
endif()
if("c" IN_LIST arith)
list(APPEND extra_lapack ${SCATGEN} ${CMATGEN})
endif()
if("d" IN_LIST arith)
list(APPEND extra_lapack ${DZATGEN} ${DMATGEN})
endif()
if("z" IN_LIST arith)
list(APPEND extra_lapack ${DZATGEN} ${ZMATGEN})
endif()

target_sources(scalapack PRIVATE ${extra_lapack})
