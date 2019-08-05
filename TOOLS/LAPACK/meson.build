allaux = files('icopy.f')
scatgen = files('slatm1.f', 'slaran.f', 'slarnd.f')
smatgen = files('slatms.f', 'slagge.f', 'slagsy.f', 'slarot.f')
cmatgen = files('clarnv.f', 'clatm1.f', 'clatms.f', 'clagge.f', 'claghe.f', 'clagsy.f', 'clarot.f', 'clarnd.f')
dzatgen = files('dlatm1.f', 'dlaran.f', 'dlarnd.f')
dmatgen = files('dlatms.f', 'dlagge.f', 'dlagsy.f', 'dlarot.f')
zmatgen = files('zlarnv.f', 'zlatm1.f', 'zlatms.f', 'zlagge.f', 'zlaghe.f', 'zlagsy.f', 'zlarot.f', 'zlarnd.f')

extra_lapack = [allaux, scatgen, smatgen, cmatgen, dzatgen, dmatgen, zmatgen]

lapack_lib = library('lapack', extra_lapack,
  link_with: blas,
  install: true,
  install_dir: install_dir)
lapack = declare_dependency(link_with: lapack_lib)