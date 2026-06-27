#* ------------------------------------------------------------------------- *
#*                                                                           *
#*                Copyright (c) 2008 CA.  All rights reserved.               *
#*                                                                           *
#* This software and all information contained therein is confidential and   *
#* proprietary and shall not be duplicated, used, disclosed or disseminated  *
#* in any way except as authorized by the applicable license agreement,      *
#* without the express written permission of CA. All authorized              *
#* reproductions must be marked with this language.                          *
#*                                                                           *
#* EXCEPT AS SET FORTH IN THE APPLICABLE LICENSE AGREEMENT, TO THE EXTENT    *
#* PERMITTED BY APPLICABLE LAW, CA PROVIDES THIS SOFTWARE WITHOUT WARRANTY   *
#* OF ANY KIND, INCLUDING WITHOUT LIMITATION, ANY IMPLIED WARRANTIES OF      *
#* MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL    *
#* CA BE LIABLE TO THE END USER OR ANY THIRD PARTY FOR ANY LOSS OR DAMAGE,   *
#* DIRECT OR INDIRECT, FROM THE USE OF THIS SOFTWARE, INCLUDING WITHOUT      *
#* LIMITATION, LOST PROFITS, BUSINESS INTERRUPTION, GOODWILL, OR LOST DATA,  *
#* EVEN IF CA IS EXPRESSLY ADVISED OF SUCH LOSS OR DAMAGE.                   *
#*                                                                           *
#* ------------------------------------------------------------------------- *
# "@(#)[auto.profile] [...] [2012-03-15 22:46:04]"
#* ------------------------------------------------------------------------- *
#
# Set CA Workload Automation AE Environmental Variables:
#
# This must be a Bourne shell script, and the variables must be exported
# for your command to have access to them.

# Windowing system environment variable
DISPLAY=":0.0"
export DISPLAY

export ORACLE_TERM=hft
export VERSION_ORACLE="11204"
export ORACLE_BASE=/apps/oracle
export ORACLE_HOME=/apps/oracle/${VERSION_ORACLE}/cli32
export ORA_NLS10=$ORACLE_HOME/nls/data
export TNS_ADMIN=/apps/waae/custom
export NLS_LANG=AMERICAN_AMERICA.WE8ISO8859P15
export NLSPATH=$NLSPATH:/conv/unix/msg/%L/%N:/conv/unix/msg/%L/%N.cat

# Set a PATH so executables can be found
#PATH=".:$AUTOSYS/bin:$AUTOSYS/test/bin:/bin:/usr/bin:/usr/local/bin:/usr/openwin/bin:/usr/bin/X11:/bin:/usr/ucb:/usr/etc"
PATH=".:$AUTOSYS/bin:$AUTOSYS/test/bin:$ORACLE_HOME/bin:/usr/lbin:/bin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/openwin/bin:/usr/bin/X11:/bin:/usr/ucb:/usr/etc:/etc:/usr/ccs/bin:/usr/local/lbin"
export PATH
LIBPATH=$AUTOSYS/lib:$ORACLE_HOME/lib32:$ORACLE_HOME/lib:$LIBPATH
export LIBPATH

# Set the library path
case `uname` in
   AIX   ) LIBPATH=$AUTOSYS/lib:$LIBPATH
           export LIBPATH;;
   HP-UX ) SHLIB_PATH=$AUTOSYS/lib:$SHLIB_PATH
           export SHLIB_PATH;;
   *     ) LD_LIBRARY_PATH=$AUTOSYS/lib:$ORACLE_HOME/lib:$ORACLE_HOME/lib32:$ORACLE_HOME/precomp/public:$LD_LIBRARY_PATH
           export LD_LIBRARY_PATH;;
   esac

# The AUTOSYS and AUTOUSER environment variables are needed if the job's
# command uses CA Workload Automation AE programs.
#
# AUTOSYS is already set in the environment for cybAgent, the Agent.
# AUTOUSER can be different for each instance in the case statement below.

case $AUTOSERV in
QI1)
        AUTOUSER=/apps/waae/11.3/autouser.QI1
        test -f $AUTOUSER/autosys.sh.s00vl9941381 &&
        . $AUTOUSER/autosys.sh.s00vl9941381
        ;;
esac
