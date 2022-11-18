set(pbblas)

if(BUILD_SINGLE)
list(APPEND pbblas pbstran.f pbsmatadd.f pbstrsrt.f pbstrget.f pbstrnv.f pbsvecadd.f pbstrst1.f)
endif()

if(BUILD_COMPLEX)
list(APPEND pbblas pbctran.f pbcmatadd.f pbctrsrt.f pbctrget.f pbctrnv.f pbcvecadd.f pbctrst1.f)
endif()

if(BUILD_DOUBLE)
list(APPEND pbblas pbdtran.f pbdmatadd.f pbdtrsrt.f pbdtrget.f pbdtrnv.f pbdvecadd.f pbdtrst1.f)
endif()

if(BUILD_COMPLEX16)
list(APPEND pbblas pbztran.f pbzmatadd.f pbztrsrt.f pbztrget.f pbztrnv.f pbzvecadd.f pbztrst1.f)
endif()

target_sources(scalapack PRIVATE ${pbblas})
