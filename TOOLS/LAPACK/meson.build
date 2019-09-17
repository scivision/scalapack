allaux = files('icopy.f')

atgen = []
matget = []

if arith.contains('s')
atgen += files('slatm1.f', 'slaran.f', 'slarnd.f')
matgen += files('slatms.f', 'slagge.f', 'slagsy.f', 'slarot.f')
endif

if arith.contains('c')
atgen += files('clatms.f', 'clarnv.f', 'clarnd.f')
matgen += files('clatm1.f', 'clagge.f', 'clagsy.f', 'clarot.f', 'claghe.f')
endif

if arith.contains('d')
atgen += files('dlatm1.f', 'dlaran.f', 'dlarnd.f')
matgen += files('dlatms.f', 'dlagge.f', 'dlagsy.f', 'dlarot.f',
  'dlassq.f', 'dlamch.f', 'dlacpy.f')
endif

if arith.contains('z')
atgen += files('zlatm1.f', 'zlarnd.f', 'zlarnv.f')
matgen += files('zlatms.f', 'zlagge.f', 'zlagsy.f', 'zlarot.f', 'zlaghe.f')
endif

lapack_lib = library('lapack',
  sources: [allaux, atgen, matgen],
  dependencies: blas,
  install: true)
lapack = declare_dependency(link_with: lapack_lib)