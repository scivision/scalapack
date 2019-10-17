project('SCALAPACK',
  ['c', 'fortran'],
  version: '2.0.2',
  meson_version: '>= 0.50',
  default_options : ['default_library=static', 'buildtype=release', 'warning_level=0',
    'libdir=scalapack-2.0.2', 'includedir=scalapack-2.0.2/include'])

cargs = '-DAdd_'
arith = get_option('arith')
buildtype = get_option('buildtype')

message('SCALAPACK arith: ' + arith)

os = host_machine.system()
cc = meson.get_compiler('c')
fc = meson.get_compiler('fortran')

quiet_f = fc.first_supported_argument(['-w', '-nowarn', '/nowarn'])
add_project_arguments(quiet_f, language: 'fortran')
quiet_c = cc.first_supported_argument(['-w', '-w0', '/W0'])
add_project_arguments(quiet_c, language: 'fortran')

# == MPI
# if MPI_ROOT, assume compiler wrapper is usable
mpiroot = get_option('MPI_ROOT')
if mpiroot == ''
  mpiexec = find_program('mpiexec')
  mpif = dependency('mpi', language : 'fortran')
  if not fc.links('use mpi; end', name: 'Fortran MPI', dependencies: mpif)
    mpif = disabler()
    mpiexec = disabler()
  endif
else
  fc.run('use mpi; integer :: i; call mpi_init(i); call mpi_finalize(i); end', name: 'Fortran MPI wrapper check')
  mpiexec = find_program(mpiroot / 'mpiexec')
  mpif = []
endif

mpic_code = '''
#include <mpi.h>
int main(int argc, char *argv[]) { MPI_Init(&argc, &argv); MPI_Finalize(); return 0;}
'''
if mpiroot == ''
  mpic = dependency('mpi', language : 'c')
  if not cc.links(mpic_code, dependencies: mpic, name: 'C MPI')
    mpic = disabler()
  endif
else
  cc.run(mpic_code, name: 'C MPI compiler wrapper')
  mpic = []
endif

# == BLACS

subdir('BLACS/SRC')
if not (meson.is_subproject() or get_option('CI'))
  blacs_test_exe = executable('blacs_test', 'tests/blacs_helloworld.f90',
    link_with: blacs_lib,
    dependencies: mpif,
    link_language: 'fortran')

  test('BLACS basic', mpiexec,
    args: ['-np', '4', '--oversubscribe', blacs_test_exe],
    timeout: 15)
endif

# == SCALAPACK
subdir('TOOLS')  # tools files
subdir('PBLAS/SRC')  # pblas files
subdir('REDIST/SRC')  # redist files
subdir('SRC') # src files

subdir('TOOLS/LAPACK')

# this is the only thing installed: libscalapack.{a,so,dylib,lib}
scalapack_lib = library('scalapack',
  sources: [blacsInternal, tools, pblas, redist, src],
  link_with: blacs_lib,
  dependencies: [lapack, blas, mpic, mpif],
  c_args : cargs,
  fortran_args : cargs,
  install: true)

# --- generate pkg-config
pkg = import('pkgconfig')
pkg.generate(scalapack_lib,
  url: 'https://github.com/scivision/scalapack',
  subdirs: 'scalapack',
  description: 'Netlib SCALAPACK')

# --- Scalapack test
if not meson.is_subproject() or buildtype == 'debug'
  scalapack_test_exe = executable('example1', 'tests/example1.F',
    fortran_args : '-Darith='+arith,
    link_with : scalapack_lib,
    dependencies : [mpif, lapack, blas],
    link_language: 'fortran')
  test('scalapack basic', mpiexec,
    args: ['-np', '6', '--oversubscribe', scalapack_test_exe],  # must be at least 6 processes or will fail
    timeout: 60)
endif