set(_p ${PROJECT_SOURCE_DIR}/scalapack/PBLAS/SRC/PBBLAS/)

set(pbblas)

if(BUILD_SINGLE)
  foreach(i IN ITEMS pbstran.f pbsmatadd.f pbstrsrt.f pbstrget.f pbstrnv.f pbsvecadd.f pbstrst1.f)
    list(APPEND pbblas ${_p}${i})
  endforeach()
endif()

if(BUILD_COMPLEX)
  foreach(i IN ITEMS pbctran.f pbcmatadd.f pbctrsrt.f pbctrget.f pbctrnv.f pbcvecadd.f pbctrst1.f)
    list(APPEND pbblas ${_p}${i})
  endforeach()
endif()

if(BUILD_DOUBLE)
  foreach(i IN ITEMS pbdtran.f pbdmatadd.f pbdtrsrt.f pbdtrget.f pbdtrnv.f pbdvecadd.f pbdtrst1.f)
    list(APPEND pbblas ${_p}${i})
  endforeach()
endif()

if(BUILD_COMPLEX16)
  foreach(i IN ITEMS pbztran.f pbzmatadd.f pbztrsrt.f pbztrget.f pbztrnv.f pbzvecadd.f pbztrst1.f)
    list(APPEND pbblas ${_p}${i})
  endforeach()
endif()


target_sources(scalapack PRIVATE ${pbblas})
