set(atools iceil.f ilacpy.f ilcm.f indxg2p.f indxg2l.f indxl2g.f infog1l.f infog2l.f
npreroc.f numroc.f chk1mat.f pchkxmat.f sltimer.f desc_convert.f descinit.f descset.f SL_init.f)

set(itools picol2row.f pirow2col.f pilaprnt.f pitreecomb.f pifillpad.f pichekpad.f pielset.f
pielset2.f pielget.f)

add_library(toolsC OBJECT reshape.c SL_gridreshape.c)

set(tools ${atools} ${itools} ${toolsC})

if(BUILD_SINGLE)
list(APPEND tools
dsnrm2.f dsasum.f slatcpy.f ssdot.f smatadd.f psmatadd.f pscol2row.f psrow2col.f
pslaprnt.f pstreecomb.f psfillpad.f pschekpad.f pselset.f pselset2.f pselget.f pslaread.f pslawrite.f)
endif()

if(BUILD_DOUBLE)
list(APPEND tools dddot.f dlatcpy.f dmatadd.f pdmatadd.f pdcol2row.f pdrow2col.f pdlaprnt.f
pdtreecomb.f pdfillpad.f pdchekpad.f pdelset.f pdelset2.f pdelget.f pdlaread.f pdlawrite.f)
endif()

if(BUILD_COMPLEX)
list(APPEND tools dscnrm2.f dscasum.f ccdotu.f ccdotc.f clatcpy.f cmatadd.f pcmatadd.f
pccol2row.f pcrow2col.f pclaprnt.f pctreecomb.f pcfillpad.f pcchekpad.f pcelset.f pcelset2.f
pcelget.f pclaread.f pclawrite.f)
endif()

if(BUILD_COMPLEX16)
list(APPEND tools zzdotu.f zzdotc.f zlatcpy.f zmatadd.f pzmatadd.f pzcol2row.f pzrow2col.f
pzlaprnt.f pztreecomb.f pzfillpad.f pzchekpad.f pzelset.f pzelset2.f pzelget.f pzlaread.f pzlawrite.f)
endif()

target_sources(scalapack PRIVATE $<TARGET_OBJECTS:toolsC> ${tools})
