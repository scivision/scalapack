set (APBTZ
    pxerbla.f)

set (IPBTZ
    immadd.f       immdda.f       immtadd.f      immddat.f)

set(pbtz)

if("s" IN_LIST arith)
list(APPEND pbtz
    svasum.f       sset.f         scshft.f       srshft.f
    svvdot.f       smmadd.f       smmcadd.f      smmtadd.f
    smmtcadd.f     smmdda.f       smmddac.f      smmddat.f
    smmddact.f     stzpad.f       stzpadcpy.f    stzscal.f
    sagemv.f       sasymv.f       satrmv.f)
endif()

if(("s" IN_LIST arith) OR ("c" IN_LIST arith))
list(APPEND pbtz sasqrtb.f      sascal.f)
endif()

if("c" IN_LIST arith)
list(APPEND pbtz
    scvasum.f      cset.f         ccshft.f       crshft.f
    cvvdotu.f      cvvdotc.f      cmmadd.f       cmmcadd.f
    cmmtadd.f      cmmtcadd.f     cmmdda.f       cmmddac.f
    cmmddat.f      cmmddact.f     ctzpad.f       ctzpadcpy.f
    chescal.f      ctzscal.f      ctzcnjg.f      cagemv.f
    cahemv.f       catrmv.f       casymv.f       csymv.f
    csyr.f         csyr2.f)
endif()


if("d" IN_LIST arith)
list(APPEND pbtz
    dvasum.f       dset.f         dcshft.f       drshft.f
    dvvdot.f       dmmadd.f       dmmcadd.f      dmmtadd.f
    dmmtcadd.f     dmmdda.f       dmmddac.f      dmmddat.f
    dmmddact.f     dtzpad.f       dtzpadcpy.f    dtzscal.f
    dagemv.f       dasymv.f       datrmv.f)
endif()

if(("d" IN_LIST arith) OR ("z" IN_LIST arith))
list(APPEND pbtz    dasqrtb.f      dascal.f)
endif()

if("z" IN_LIST arith)
list(APPEND pbtz
    dzvasum.f      zset.f         zcshft.f       zrshft.f
    zvvdotu.f      zvvdotc.f      zmmadd.f       zmmcadd.f
    zmmtadd.f      zmmtcadd.f     zmmdda.f       zmmddac.f
    zmmddat.f      zmmddact.f     ztzpad.f       ztzpadcpy.f
    zhescal.f      ztzscal.f      ztzcnjg.f      zagemv.f
    zahemv.f       zatrmv.f       zasymv.f       zsymv.f
    zsyr.f         zsyr2.f)
endif()

target_sources(scalapack PRIVATE ${APBTZ} ${IPBTZ} ${pbtz})
