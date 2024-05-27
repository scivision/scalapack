set(_p ${PROJECT_SOURCE_DIR}/scalapack/PBLAS/SRC/PTZBLAS/)

set(APBTZ ${_p}pxerbla.f)

set(IPBTZ)
foreach(i IN ITEMS immadd.f immdda.f immtadd.f immddat.f)
  list(APPEND IPBTZ ${_p}${i})
endforeach()

set(pbtz)

if(BUILD_SINGLE)
foreach(i IN ITEMS
    svasum.f       sset.f         scshft.f       srshft.f
    svvdot.f       smmadd.f       smmcadd.f      smmtadd.f
    smmtcadd.f     smmdda.f       smmddac.f      smmddat.f
    smmddact.f     stzpad.f       stzpadcpy.f    stzscal.f
    sagemv.f       sasymv.f       satrmv.f)
    list(APPEND pbtz ${_p}${i})
endforeach()
endif()

if(BUILD_SINGLE OR BUILD_COMPLEX)
list(APPEND pbtz ${_p}sasqrtb.f ${_p}sascal.f)
endif()

if(BUILD_COMPLEX)
  foreach(i IN ITEMS   scvasum.f      cset.f         ccshft.f       crshft.f
    cvvdotu.f      cvvdotc.f      cmmadd.f       cmmcadd.f
    cmmtadd.f      cmmtcadd.f     cmmdda.f       cmmddac.f
    cmmddat.f      cmmddact.f     ctzpad.f       ctzpadcpy.f
    chescal.f      ctzscal.f      ctzcnjg.f      cagemv.f
    cahemv.f       catrmv.f       casymv.f       csymv.f
    csyr.f         csyr2.f)
    list(APPEND pbtz ${_p}${i})
  endforeach()
endif()


if(BUILD_DOUBLE)
  foreach(i IN ITEMS
    dvasum.f       dset.f         dcshft.f       drshft.f
    dvvdot.f       dmmadd.f       dmmcadd.f      dmmtadd.f
    dmmtcadd.f     dmmdda.f       dmmddac.f      dmmddat.f
    dmmddact.f     dtzpad.f       dtzpadcpy.f    dtzscal.f
    dagemv.f       dasymv.f       datrmv.f)
    list(APPEND pbtz ${_p}${i})
  endforeach()
endif()

if(BUILD_DOUBLE OR BUILD_COMPLEX16)
  list(APPEND pbtz    ${_p}dasqrtb.f      ${_p}dascal.f)
endif()

if(BUILD_COMPLEX16)
  foreach(i IN ITEMS
    dzvasum.f      zset.f         zcshft.f       zrshft.f
    zvvdotu.f      zvvdotc.f      zmmadd.f       zmmcadd.f
    zmmtadd.f      zmmtcadd.f     zmmdda.f       zmmddac.f
    zmmddat.f      zmmddact.f     ztzpad.f       ztzpadcpy.f
    zhescal.f      ztzscal.f      ztzcnjg.f      zagemv.f
    zahemv.f       zatrmv.f       zasymv.f       zsymv.f
    zsyr.f         zsyr2.f)
        list(APPEND pbtz ${_p}${i})
  endforeach()
endif()

target_sources(scalapack PRIVATE ${APBTZ} ${IPBTZ} ${pbtz})
