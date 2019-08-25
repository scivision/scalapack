project('SCALAPACK',
  ['c', 'fortran'],
  version: '2.0.2',
  meson_version: '>= 0.50',
  default_options : ['default_library=static', 'buildtype=release', 'warning_level=0',
    'libdir=scalapack-2.0.2', 'includedir=scalapack-2.0.2/include'])

cargs = '-DAdd_'
arith = get_option('arith')
buildtype = get_option('buildtype')

os = host_machine.system()
cc = meson.get_compiler('c')
fc = meson.get_compiler('fortran')
ccid = cc.get_id()
if ['gcc', 'pgi', 'flang'].contains(ccid)
  add_project_arguments('-w', language : 'c')
  add_project_arguments('-w', language : 'fortran')
elif ccid == 'intel'
  add_project_arguments('-w0', language : 'c')
  add_project_arguments('-nowarn', language : 'fortran')
elif ccid == 'intel-cl'
  add_project_arguments('/W0', language : 'c')
  add_project_arguments('/nowarn', language : 'fortran')
endif

# == MPI
# if MPI_ROOT, assume compiler wrapper is usable
mpiroot = get_option('MPI_ROOT')
if mpiroot == ''
  mpiexec = find_program('mpiexec')
  mpif = dependency('mpi', language : 'fortran')
  mpiret = fc.run('use mpi; end', dependencies : mpif, name: 'Fortran MPI')
  if mpiret.returncode() != 0
    warning('MPI_Fortran does not link properly: ' + mpiret.stderr() + ' ' + mpiret.stdout())
  endif
else
  mpiexec = find_program(mpiroot / 'mpiexec')
  mpif = []
endif

mpic_code = '''
#include <mpi.h>
int main() { MPI_Init(NULL, NULL); MPI_Finalize(); return 0;}
'''
if mpiroot == ''
  mpic = dependency('mpi', language : 'c')
  if cc.run(mpic_code, dependencies: mpic, name: 'C MPI compiler wrapper').returncode() != 0
    warning('MPI_C does not link properly')
  endif
else
  mpic = []
endif

# == BLACS

subdir('BLACS/SRC')
if not meson.is_subproject() or buildtype == 'debug'
  blacs_test_exe = executable('blacs_test', 'tests/blacs_helloworld.f90',
    link_with: blacs_lib,
    link_language: 'fortran')
  test('BLACS basic', mpiexec,
    args: ['-np', '4', blacs_test_exe],
    timeout: 15)
endif

# == SCALAPACK
subdir('TOOLS')  # tools files
subdir('PBLAS/SRC')  # pblas files
subdir('REDIST/SRC')  # redist files
subdir('SRC') # src files

system_blas = get_option('system_blas')
if system_blas
  blas = dependency('blas', required: false)
  if not blas.found()  # Mac Homebrew
    blas = fc.find_library('blas', required: false)
  endif
  if blas.found()
    lapack = dependency('lapack', required: false)
    if not lapack.found()  # create own Lapack
      subdir('TOOLS/LAPACK')
    endif
  else
    lapack = disabler()
  endif
else
  blas = disabler()
  lapack = disabler()
endif
if not blas.found() or not lapack.found()
  lapack_proj = subproject('lapack')
  blas = lapack_proj.get_variable('blas')
  lapack = lapack_proj.get_variable('lapack')
endif

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
    args: ['-np', '6', scalapack_test_exe],  # must be at least 6 processes or will fail
    timeout: 60)
endif