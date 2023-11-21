DATASET CLOSE ALL.
OUTPUT CLOSE ALL.

* Normal distribution.

INPUT PROGRAM.
LOOP #id=1 TO 100.
- COMPUTE draw=RV.NORMAL(0,1).
- END CASE.
END LOOP.
END FILE.
END INPUT PROGRAM.
DATASET NAME NORMAL.
DATASET ACTIVATE NORMAL WINDOW=FRONT.

DATASET ACTIVATE NORMAL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=draw MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  GUIDE: axis(dim(1), label("draw"))
  GUIDE: axis(dim(2), label("Frequency"))
  GUIDE: text.title(label("Simple Histogram of draw"))
  ELEMENT: interval(position(summary.count(bin.rect(draw))), shape.interior(shape.square))
  ELEMENT: line(position(density.normal(draw)))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=draw MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  DATA: id=col(source(s), name("$CASENUM"), unit.category())
  COORD: rect(dim(1))
  GUIDE: axis(dim(1), label("draw"))
  GUIDE: text.title(label("1-D Boxplot of draw"))
  ELEMENT: schema(position(bin.quantile.letter(draw)), label(id))
END GPL.

SORT CASES BY draw(D).

STRING  labvar (A8).
IF  ($CASENUM = 1) labvar="test".
EXECUTE.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=draw labvar MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  COORD: rect(dim(1), transpose())
  GUIDE: axis(dim(1), label("draw"))
  GUIDE: text.title(label("1-D Boxplot of draw"))
  ELEMENT: schema(position(bin.quantile.letter(draw)))
  ELEMENT: point.dodge.symmetric(position(bin.dot(draw, dim(1))), color(color.red), label(labvar))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=draw labvar MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  GUIDE: axis(dim(1), label("draw"))
  GUIDE: axis(dim(2), label("Frequency"))
  GUIDE: text.title(label("Simple Line of draw"))
  ELEMENT: line(position(smooth.spline(summary.count(bin.rect(draw)))), missing.wings())
  ELEMENT: line(position(density.normal(draw)))
  ELEMENT: point.dodge.symmetric(position(bin.dot(draw, dim(1))), color(color.red), label(labvar))
END GPL.
