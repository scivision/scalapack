set(pbblas)

if("s" IN_LIST arith)
list(APPEND pbblas pbstran.f pbsmatadd.f pbstrsrt.f pbstrget.f pbstrnv.f pbsvecadd.f pbstrst1.f)
endif()

if("c" IN_LIST arith)
list(APPEND pbblas pbctran.f pbcmatadd.f pbctrsrt.f pbctrget.f pbctrnv.f pbcvecadd.f pbctrst1.f)
endif()

if("d" IN_LIST arith)
list(APPEND pbblas pbdtran.f pbdmatadd.f pbdtrsrt.f pbdtrget.f pbdtrnv.f pbdvecadd.f pbdtrst1.f)
endif()

if("z" IN_LIST arith)
list(APPEND pbblas pbztran.f pbzmatadd.f pbztrsrt.f pbztrget.f pbztrnv.f pbzvecadd.f pbztrst1.f)
endif()

target_sources(scalapack PRIVATE ${pbblas})
