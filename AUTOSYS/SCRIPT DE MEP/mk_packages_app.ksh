#!/usr/bin/ksh
rep=/apps/hp3/resdata/au1/packages/MEP/CompApp
rep_sto=${rep}/archives
exclusion=${rep}/exclusion
log=${rep}/mk_pack_log

> $log


# Archives Jobsets

# noyau 
cd /apps/atlas/atlas2v0/au1/jobset   
gtar -cvzf ${rep_sto}/adoat_cdu.tgz ???? *A6* -X ${exclusion}  		>>$log  2>&1
cd /apps/atlas/atlas2v0/au1/site/jobset
gtar -cvzf ${rep_sto}/adoat_cdsu.tgz ???? ex-* *A6* -X ${exclusion}  	>>$log  2>&1

# Orion 
cd /apps/orion/031/au1/jobset        
gtar -cvzf ${rep_sto}/orion_cdu.tgz ???? *A6* -X ${exclusion}  		>>$log  2>&1
cd /apps/orion/031/au1/site/jobset      
gtar -cvzf ${rep_sto}/orion_cdsu.tgz ???? ex-* *A6* -X ${exclusion}  	>>$log  2>&1

# ptcom 
cd /apps/ptcom/041/au1/jobset        
gtar -cvzf ${rep_sto}/ptcom_cdu.tgz ???? *A6* -X ${exclusion}  		>>$log  2>&1
cd /apps/ptcom/041/au1/site/jobset      
gtar -cvzf ${rep_sto}/ptcom_cdsu.tgz ???? ex-* *A6* -X ${exclusion}  	>>$log  2>&1

# rfper 
cd /apps/rfper/040/au1/jobset        
gtar -cvzf ${rep_sto}/rfper_cdu.tgz ???? *A6* -X ${exclusion}  		>>$log  2>&1
cd /apps/rfper/040/au1/site/jobset      
gtar -cvzf ${rep_sto}/rfper_cdsu.tgz ???? ex-* *A6* -X ${exclusion}  	>>$log  2>&1

# argos 
cd /apps/argos/020/au1/jobset        
gtar -cvzf ${rep_sto}/argos_cdu.tgz ???? *A6* -X ${exclusion}  		>>$log  2>&1

# inter 
cd /apps/inter/010/au1/jobset 
gtar -cvzf ${rep_sto}/inter_cdu.tgz ???? *A6* -X ${exclusion}  		>>$log  2>&1
cd /apps/inter/010/au1/site/jobset      
gtar -cvzf ${rep_sto}/inter_cdsu.tgz ???? ex-* *A6* -X ${exclusion}  	>>$log  2>&1

# sonar 
cd /apps/sonar/020/au1/jobset 
gtar -cvzf ${rep_sto}/sonar_cdu.tgz ???? *A6* -X ${exclusion}  		>>$log  2>&1
cd /apps/sonar/020/au1/site/jobset      
gtar -cvzf ${rep_sto}/sonar_cdsu.tgz ???? ex-* *A6* -X ${exclusion}  	>>$log  2>&1

# evatl 
cd /apps/evatl/001/au1/jobset 
gtar -cvzf ${rep_sto}/evatl_cdu.tgz ???? *A6* -X ${exclusion}  		>>$log  2>&1
















