set(_p ${PROJECT_SOURCE_DIR}/scalapack/TOOLS/LAPACK/)

set(ALLAUX ${_p}icopy.f)

set(SCATGEN ${_p}slatm1.f ${_p}slaran.f ${_p}slarnd.f)

set(SMATGEN ${_p}slatms.f ${_p}slagge.f ${_p}slagsy.f ${_p}slarot.f)

set(CMATGEN ${_p}clarnv.f ${_p}clatm1.f ${_p}clatms.f ${_p}clagge.f ${_p}claghe.f ${_p}clagsy.f ${_p}clarot.f ${_p}clarnd.f)

set(DZATGEN ${_p}dlatm1.f ${_p}dlaran.f ${_p}dlarnd.f)

set(DMATGEN ${_p}dlatms.f ${_p}dlagge.f ${_p}dlagsy.f ${_p}dlarot.f)

set(ZMATGEN ${_p}zlarnv.f ${_p}zlatm1.f ${_p}zlatms.f ${_p}zlagge.f ${_p}zlaghe.f ${_p}zlagsy.f ${_p}zlarot.f ${_p}zlarnd.f)

set(extra_lapack ${ALLAUX})

if(BUILD_SINGLE)
list(APPEND extra_lapack ${SCATGEN} ${SMATGEN})
endif()

if(BUILD_COMPLEX)
list(APPEND extra_lapack ${SCATGEN} ${CMATGEN})
endif()

if(BUILD_DOUBLE)
list(APPEND extra_lapack ${DZATGEN} ${DMATGEN})
endif()

if(BUILD_COMPLEX16)
list(APPEND extra_lapack ${DZATGEN} ${ZMATGEN})
endif()

target_sources(scalapack PRIVATE ${extra_lapack})
