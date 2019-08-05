subdir('PBBLAS')
subdir('PTZBLAS')
subdir('PTOOLS')
appblas = files('pilaenv.f')
#---------------------------------------------------------------------------
#  Level 1 PBLAS.
#---------------------------------------------------------------------------
piblas1 = files('picopy_.c')
psblas1 = files('psswap_.c', 'psscal_.c', 'pscopy_.c', 'psaxpy_.c', 'psdot_.c', 'psnrm2_.c', 'psasum_.c', 'psamax_.c')
pcblas1 = files('pcswap_.c', 'pcscal_.c', 'pcsscal_.c', 'pccopy_.c', 'pcaxpy_.c', 'pcdotu_.c', 'pcdotc_.c', 'pscnrm2_.c', 'pscasum_.c', 'pcamax_.c')
pdblas1 = files('pdswap_.c', 'pdscal_.c', 'pdcopy_.c', 'pdaxpy_.c', 'pddot_.c', 'pdnrm2_.c', 'pdasum_.c', 'pdamax_.c')
pzblas1 = files('pzswap_.c', 'pzscal_.c', 'pzdscal_.c', 'pzcopy_.c', 'pzaxpy_.c', 'pzdotu_.c', 'pzdotc_.c', 'pdznrm2_.c', 'pdzasum_.c', 'pzamax_.c')
#---------------------------------------------------------------------------
#  Level 2 PBLAS.
#---------------------------------------------------------------------------
psblas2 = files('psgemv_.c', 'psger_.c', 'pssymv_.c', 'pssyr_.c', 'pssyr2_.c', 'pstrmv_.c', 'pstrsv_.c', 'psagemv_.c', 'psasymv_.c', 'psatrmv_.c')
pcblas2 = files('pcgemv_.c', 'pcgerc_.c', 'pcgeru_.c', 'pchemv_.c', 'pcher_.c', 'pcher2_.c', 'pctrmv_.c', 'pctrsv_.c', 'pcagemv_.c', 'pcahemv_.c', 'pcatrmv_.c')
pdblas2 = files('pdgemv_.c', 'pdger_.c', 'pdsymv_.c', 'pdsyr_.c', 'pdsyr2_.c', 'pdtrmv_.c', 'pdtrsv_.c', 'pdagemv_.c', 'pdasymv_.c', 'pdatrmv_.c')
pzblas2 = files('pzgemv_.c', 'pzgerc_.c', 'pzgeru_.c', 'pzhemv_.c', 'pzher_.c', 'pzher2_.c', 'pztrmv_.c', 'pztrsv_.c', 'pzagemv_.c', 'pzahemv_.c', 'pzatrmv_.c')
#---------------------------------------------------------------------------
#  Level 3 PBLAS.
#---------------------------------------------------------------------------
psblas3 = files('psgeadd_.c', 'psgemm_.c', 'pssymm_.c', 'pssyr2k_.c', 'pssyrk_.c', 'pstradd_.c', 'pstran_.c', 'pstrmm_.c', 'pstrsm_.c')
pcblas3 = files('pcgeadd_.c', 'pcgemm_.c', 'pchemm_.c', 'pcher2k_.c', 'pcherk_.c', 'pcsymm_.c', 'pcsyr2k_.c', 'pcsyrk_.c', 'pctradd_.c', 'pctranc_.c', 'pctranu_.c', 'pctrmm_.c', 'pctrsm_.c')
pdblas3 = files('pdgeadd_.c', 'pdgemm_.c', 'pdsymm_.c', 'pdsyr2k_.c', 'pdsyrk_.c', 'pdtradd_.c', 'pdtran_.c', 'pdtrmm_.c', 'pdtrsm_.c')
pzblas3 = files('pzgeadd_.c', 'pzgemm_.c', 'pzhemm_.c', 'pzher2k_.c', 'pzherk_.c', 'pzsymm_.c', 'pzsyr2k_.c', 'pzsyrk_.c', 'pztradd_.c', 'pztranc_.c', 'pztranu_.c', 'pztrmm_.c', 'pztrsm_.c')
#---------------------------------------------------------------------------
pblas = [piblas1, psblas1, pcblas1, pdblas1, pzblas1, psblas2, pcblas2, pdblas2, pzblas2, psblas3, pcblas3, pdblas3, pzblas3, appblas,
  pbblas, ptzblas, ptools]
