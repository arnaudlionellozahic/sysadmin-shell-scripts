#* ------------------------------------------------------------------------- *
#*                                                                           *
#*                Copyright (c) 2016 CA.  All rights reserved.               *
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
# "@(#)[file] [version] [modtime]"
#* ------------------------------------------------------------------------- *
#
# Set CA Workload Automation AE Environmental Variables:
#
# This must be a Bourne shell script, and the variables must be exported
# for your command to have access to them.

# Windowing system environment variable
DISPLAY=":0.0"
export DISPLAY

# Set a PATH so executables can be found
#PATH=".:$AUTOSYS/bin:$AUTOSYS/test/bin:/bin:/usr/bin:/usr/local/bin:/usr/openwin/bin:/usr/bin/X11:/bin:/usr/ucb:/usr/etc:$PATH"
#export PATH
export PATH=$PATH:/apps/exploit/sche:/apps/exploit/exploitv3

# Set the library path
case `uname` in
   AIX   ) LIBPATH=$AUTOSYS/lib:$LIBPATH
           export LIBPATH;;
   HP-UX ) SHLIB_PATH=$AUTOSYS/lib:$SHLIB_PATH
           export SHLIB_PATH;;
   *     ) LD_LIBRARY_PATH=$AUTOSYS/lib:$LD_LIBRARY_PATH
           export LD_LIBRARY_PATH;;
   esac

# The AUTOSYS and AUTOUSER environment variables are needed if the job's
# command uses CA Workload Automation AE programs.
#
# AUTOSYS is already set in the environment for cybAgent, the Agent.
# AUTOUSER can be different for each instance in the case statement below.

case $AUTOSERV in
R41)
        AUTOUSER=/apps/waae/11.3/autouser.R41
        test -f $AUTOUSER/autosys.sh.s00va9949996 &&
        . $AUTOUSER/autosys.sh.s00va9949996
        ;;
esac
