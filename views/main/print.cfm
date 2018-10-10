
<cfheader name="Content-Disposition" value="inline;filename=#dateformat(now(),"yyyymmdd")##timeformat(now(),"hhmm")#_codechecker.xls">
<cfcontent type="application/vnd.ms-excel" variable="#prc.binary#">








