# $FreeBSD: src/share/skel/dot.cshrc,v 1.13 2001/01/10 17:35:28 archie Exp $
#
# .cshrc - csh resource script, read at beginning of execution by each shell
#
# see also csh(1), environ(7).
#

alias h		history 25
alias j		jobs -l
alias la	ls -a
alias lf	ls -FA
alias ll	ls -lA

# A righteous umask
umask 22

set path = (/sbin /bin /usr/sbin /usr/bin /usr/games /usr/local/sbin /usr/local/bin /usr/X11R6/bin $HOME/bin)

setenv	EDITOR	vi
setenv	PAGER	more
setenv	BLOCKSIZE	K

if ($?prompt) then
	# An interactive shell -- set some stuff up
	set filec
	set history = 100
	set savehist = 100
	set mail = (/var/mail/$USER)
	if ( $?tcsh ) then
		bindkey "^W" backward-delete-word
		bindkey -k up history-search-backward
		bindkey -k down history-search-forward
	endif
endif
source /home4/alozahic/Linux/mardeuil/Ver541/vtom/admin/vtom_init.csh
source /home4/alozahic/HP-UX/hp9000-2/Ver524c/admin/vtom_init.csh
source /home4/alozahic/HP-UX/hp9000-2/Ver524c_us/admin/vtom_init.csh
source /home4/alozahic/HP-UX/hp9000-2/Ver524c_us/admin/vtom_init.csh
source /home4/alozahic/HP-UX/hp9000-2/Ver532_us/admin/vtom_init.csh
source /home4/alozahic/AIX/uranus/Ver461/admin/vtom_init.csh
source /home4/alozahic/Linux/Ver533c/admin/vtom_init.csh
source /home4/alozahic/Linux/savigny/Ver533c/admin/vtom_init.csh
source /home4/alozahic/Linux/savigny/Ver541/admin/vtom_init.csh
source /home4/alozahic/SunOS/ultra/Ver532/admin/vtom_init.csh
source /home4/alozahic/Linux/lisses/Ver531/admin/vtom_init.csh
source /home4/alozahic/Linux/savigny/Ver543/admin/vtom_init.csh
source /home4/alozahic/Linux/avize/Ver543/admin/vtom_init.csh
source /home4/alozahic/Linux/qcentos5/Ver543/admin/vtom_init.csh
source /home4/alozahic/AIX/mars/Ver543/admin/vtom_init.csh
source /home4/alozahic/SunOS/ultra/Ver543/admin/vtom_init.csh
source /home4/alozahic/HP-UX/hp9000-2/Ver532_us/admin/vtom_init.csh
source /home4/alozahic/Linux/savigny/Ver533/admin/vtom_init.csh
source /home4/alozahic/Linux/lisses/Ver533/admin/vtom_init.csh
source /home4/alozahic/Linux/lisses/Ver543/admin/vtom_init.csh
source /home4/alozahic/Linux/avize/Ver534/admin/vtom_init.csh
source /home4/alozahic/SunOS/frodon/Ver4614/admin/vtom_init.csh
source /home4/alozahic/Linux/savigny/Ver543/admin/vtom_init.csh
source /home4/alozahic/Linux/savigny/Ver543a/admin/vtom_init.csh
source /home4/alozahic/HP-UX/hp9000-2/Ver543a/admin/vtom_init.csh
source /home4/alozahic/AIX/mars/Ver543a/admin/vtom_init.csh
source /home4/alozahic/SunOS/ultra/Ver543a/admin/vtom_init.csh
source /home4/alozahic/Linux/savigny/Ver533/admin/vtom_init.csh
source /home4/alozahic/Linux/lisses/Ver533/admin/vtom_init.csh
source /home4/alozahic/Linux/athis/Ver543b/admin/vtom_init.csh
source /home4/alozahic/Linux/Ver534/admin/vtom_init.csh
source /home4/alozahic/Linux/savigny/Ver534/admin/vtom_init.csh
source /home4/alozahic/HP-UX/hp9000-2/Ver522/admin/vtom_init.csh
source /home4/alozahic/HP-UX/hp9000-2/Ver522/admin/vtom_init.csh
source /home4/alozahic/Linux/savigny/Ver542/admin/vtom_init.csh
source /home4/alozahic/SunOS/frodon/Ver4614/admin/vtom_init.csh
source /home4/alozahic/SunOS/frodon/Ver4614/admin/vtom_init.csh
source /home4/alozahic/SunOS/frodon/Ver4611/admin/vtom_init.csh
source /home4/alozahic/SunOS/frodon/Ver4611/admin/vtom_init.csh
source /home4/alozahic/Linux/athis/Ver544/admin/vtom_init.csh
source /home4/alozahic/Linux/savigny/Ver544/admin/vtom_init.csh
source /home4/alozahic/AIX/uranus/Ver544/admin/vtom_init.csh
source /home4/alozahic/Linux/athis/Ver544/admin/vtom_init.csh
source /home4/alozahic/Linux/savigny/Ver544/admin/vtom_init.csh
source /home4/alozahic/AIX/uranus/Ver544/admin/vtom_init.csh
source /home4/alozahic/SunOS/frodon/Ver45b2/admin/vtom_init.csh
source /home4/alozahic/Linux/lisses/Ver544_client/admin/vtom_init.csh
source /home4/alozahic/Linux/lisses/Ver544/admin/vtom_init.csh
source /home4/alozahic/Linux/savigny/Ver522/admin/vtom_init.csh
source /home4/alozahic/AIX/uranus/Ver544_new/admin/vtom_init.csh
source /home4/alozahic/SunOS/frodon/Ver544/admin/vtom_init.csh
source /home4/alozahic/SunOS/ultra/Ver544/admin/vtom_init.csh
source /home4/alozahic/Linux/savigny/Ver544/admin/vtom_init.csh
source /home4/alozahic/AIX/uranus/Ver544/admin/vtom_init.csh
source /home4/alozahic/Linux/savigny/Ver544/admin/vtom_init.csh
source /home4/alozahic/HP-UX/hp9000-2/Ver544/admin/vtom_init.csh
source /home4/alozahic/HP-UX/hp9000-2/ver544/admin/vtom_init.csh
source /home4/alozahic/HP-UX/hp9000-2/Ver544/admin/vtom_init.csh
source /home4/alozahic/Linux/avize/Ver544/admin/vtom_init.csh
