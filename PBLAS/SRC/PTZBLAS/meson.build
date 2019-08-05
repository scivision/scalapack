apbtz = files('pxerbla.f')
ipbtz = files('immadd.f', 'immdda.f', 'immtadd.f', 'immddat.f')

if arith.contains('s')
pbtz = files('svasum.f', 'sset.f', 'scshft.f', 'srshft.f', 'svvdot.f', 'smmadd.f', 'smmcadd.f', 'smmtadd.f', 'smmtcadd.f', 'smmdda.f', 'smmddac.f', 'smmddat.f', 'smmddact.f', 'stzpad.f', 'stzpadcpy.f', 'stzscal.f', 'sagemv.f', 'sasymv.f', 'satrmv.f')
endif

if arith.contains('c')
pbtz = files('scvasum.f', 'cset.f', 'ccshft.f', 'crshft.f', 'cvvdotu.f', 'cvvdotc.f', 'cmmadd.f', 'cmmcadd.f', 'cmmtadd.f', 'cmmtcadd.f', 'cmmdda.f', 'cmmddac.f', 'cmmddat.f', 'cmmddact.f', 'ctzpad.f', 'ctzpadcpy.f', 'chescal.f', 'ctzscal.f', 'ctzcnjg.f', 'cagemv.f', 'cahemv.f', 'catrmv.f', 'casymv.f', 'csymv.f', 'csyr.f', 'csyr2.f')
endif

if arith.contains('s') or arith.contains('c')
  pbtz += files('sasqrtb.f', 'sascal.f')
endif


if arith.contains('d')
pbtz = files('dvasum.f', 'dset.f', 'dcshft.f', 'drshft.f', 'dvvdot.f', 'dmmadd.f', 'dmmcadd.f', 'dmmtadd.f', 'dmmtcadd.f', 'dmmdda.f', 'dmmddac.f', 'dmmddat.f', 'dmmddact.f', 'dtzpad.f', 'dtzpadcpy.f', 'dtzscal.f', 'dagemv.f', 'dasymv.f', 'datrmv.f')
endif

if arith.contains('z')
pbtz = files('dzvasum.f', 'zset.f', 'zcshft.f', 'zrshft.f', 'zvvdotu.f', 'zvvdotc.f', 'zmmadd.f', 'zmmcadd.f', 'zmmtadd.f', 'zmmtcadd.f', 'zmmdda.f', 'zmmddac.f', 'zmmddat.f', 'zmmddact.f', 'ztzpad.f', 'ztzpadcpy.f', 'zhescal.f', 'ztzscal.f', 'ztzcnjg.f', 'zagemv.f', 'zahemv.f', 'zatrmv.f', 'zasymv.f', 'zsymv.f', 'zsyr.f', 'zsyr2.f')
endif

if arith.contains('d') or arith.contains('z')
  pbtz += files('dasqrtb.f', 'dascal.f')
endif

ptzblas = [apbtz, ipbtz, pbtz]
