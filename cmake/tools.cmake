set(_p ${PROJECT_SOURCE_DIR}/scalapack/TOOLS/)

set(atools)

foreach(i IN ITEMS iceil.f ilacpy.f ilcm.f indxg2p.f indxg2l.f indxl2g.f infog1l.f infog2l.f
    npreroc.f numroc.f chk1mat.f pchkxmat.f sltimer.f desc_convert.f descinit.f descset.f SL_init.f
    picol2row.f pirow2col.f pilaprnt.f pitreecomb.f pifillpad.f pichekpad.f pielset.f pielset2.f pielget.f)
  list(APPEND tools ${_p}${i})
endforeach()

add_library(toolsC OBJECT ${_p}reshape.c ${_p}SL_gridreshape.c)

if(BUILD_SINGLE)
foreach(i IN ITEMS dsnrm2.f dsasum.f slatcpy.f ssdot.f smatadd.f psmatadd.f pscol2row.f psrow2col.f
    pslaprnt.f pstreecomb.f psfillpad.f pschekpad.f pselset.f pselset2.f pselget.f pslaread.f pslawrite.f)
  list(APPEND tools ${_p}${i})
endforeach()
endif()

if(BUILD_DOUBLE)
foreach(i IN ITEMS dddot.f dlatcpy.f dmatadd.f pdmatadd.f pdcol2row.f pdrow2col.f pdlaprnt.f
    pdtreecomb.f pdfillpad.f pdchekpad.f pdelset.f pdelset2.f pdelget.f pdlaread.f pdlawrite.f)
  list(APPEND tools ${_p}${i})
endforeach()
endif()

if(BUILD_COMPLEX)
foreach(i IN ITEMS dscnrm2.f dscasum.f ccdotu.f ccdotc.f clatcpy.f cmatadd.f pcmatadd.f
    pccol2row.f pcrow2col.f pclaprnt.f pctreecomb.f pcfillpad.f pcchekpad.f pcelset.f pcelset2.f
    pcelget.f pclaread.f pclawrite.f)
  list(APPEND tools ${_p}${i})
endforeach()
endif()

if(BUILD_COMPLEX16)
foreach(i IN ITEMS zzdotu.f zzdotc.f zlatcpy.f zmatadd.f pzmatadd.f pzcol2row.f pzrow2col.f
    pzlaprnt.f pztreecomb.f pzfillpad.f pzchekpad.f pzelset.f pzelset2.f pzelget.f pzlaread.f pzlawrite.f)
  list(APPEND tools ${_p}${i})
endforeach()
endif()

target_sources(scalapack PRIVATE $<TARGET_OBJECTS:toolsC> ${tools})
