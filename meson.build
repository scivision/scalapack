project('SCALAPACK',
  ['c', 'fortran'],
  version: '2.0.2',
  meson_version: '>= 0.50',
  default_options : ['default_library=static', 'buildtype=release'])

cargs = '-DAdd_'
install_dir = 'scalapack-'+meson.project_version()
arith = get_option('arith')

os = host_machine.system()
cc = meson.get_compiler('c')
fc = meson.get_compiler('fortran')
ccid = cc.get_id()
if ccid == 'gcc' or ccid == 'pgi' or ccid == 'flang'
  add_global_arguments('-w', language : 'c')
  add_global_arguments('-w', language : 'fortran')
elif ccid == 'intel'
  add_global_arguments('-w0', language : 'c')
  add_global_arguments('-nowarn', language : 'fortran')
elif ccid == 'intel-cl'
  add_global_arguments('/W0', language : 'c')
  add_global_arguments('/nowarn', language : 'fortran')
endif

# == MPI

mpif = dependency('mpi', language: 'fortran')
if not fc.links('use mpi; end', dependencies: mpif)
  error('MPI is not working correctly')
endif
mpic = dependency('mpi', language: 'c')
mpiexec = find_program('mpiexec')

# == BLACS

subdir('BLACS/SRC')
blacs_test_exe = executable('blacs_test', 'tests/blacs_helloworld.f90',
  link_with: blacs_lib,
  link_language: 'fortran')
test('BLACS basic', mpiexec,
  args: ['-np', '4', blacs_test_exe],
  timeout: 15
)

# == SCALAPACK
subdir('TOOLS')  # tools files
subdir('PBLAS/SRC')  # pblas files
subdir('REDIST/SRC')  # redist files
subdir('SRC') # src files

blas = dependency('blas')
lapack = dependency('lapack', required: false)
if not lapack.found()  # create own Lapack
  subdir('TOOLS/LAPACK')
endif

# this is the only thing installed, like libscalapack.a or libscalapack.so or similar.
scalapack_lib = library('scalapack',
  sources: [blacsInternal, tools, pblas, redist, src],
  link_with: blacs_lib,
  dependencies: [lapack, blas, mpic, mpif],
  c_args : cargs,
  fortran_args : cargs,
  install: true,
  install_dir: install_dir)

# --- Scalapack test
scalapack_test_exe = executable('example1', 'tests/example1.F',
  fortran_args : '-Darith='+arith,
  link_with : scalapack_lib,
  dependencies : [mpif, lapack, blas],
  link_language: 'fortran')

test('scalapack basic', mpiexec,
  args: ['-np', '6', scalapack_test_exe],  # must be at least 6 processes or will fail
  timeout: 60
)
