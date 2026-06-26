#!/bin/ksh

##################################################################
#   Script de creation de packages
#   Christophe CONGIUSTI
#   29/04/2002
#
#   pack_langue .. langue (En_US ou Fr_FR)
#   pack_tag ..... estampille
#   pack_root .... repertoire de generation
#
##################################################################

# -----------------------------
# --- Langue En_US ou Fr_FR ---
# -----------------------------
# Langue
if [ $# -eq 1 ] ; then
        case "$1" in
                "En_US")
                        echo "--- English ---"
                        pack_langue=En_US;;
                "Fr_FR")
                        echo "--- Francais ---"
                        pack_langue=Fr_FR;;
                *)
                        echo "Unknown language parameter ($1)"
                        exit 1;;
        esac
else
        echo "--- Francais ---"
        pack_langue=Fr_FR
fi

# Go to compilation dir
cd $HOME/packages

#set verbose

# ------------------------------
# --- Generation Version 4.1 ---
# ------------------------------

#pack_root=vtom41

#pack_tag="4.1.2"
#pack_tag="4.1.3"

# ------------------------------
# --- Generation Version 4.2 ---
# ------------------------------

#pack_root=vtom42

#pack_tag="4.2.4"
#pack_tag="4.2.4i"
#pack_tag="4.2.4"
#pack_tag="4.2.5"
#pack_tag="4.2.4m"
#pack_tag="4.2.4r"
#pack_tag="4.2.4w"
#pack_tag="4.2.6a"

# MB : Generation du 07042004 Livraison pour NMPP + VALLOUREC + FTSNPI
#export livre=vtom42/version_42_build_4h
#pack_tag="4.2.5"

# ------------------------------
# --- Generation Version 4.3 ---
# ------------------------------

#pack_root=vtom43

#pack_tag="4.3.3"
#pack_tag="4.3.4e"
#pack_tag="4.3.5a"
#pack_tag="4.3.5b"
#pack_tag="4.3.5c"
#pack_tag="4.3.5d"
#pack_tag="4.3.7"
#pack_tag="4.3.7a"
#pack_tag="4.3.7d"
#pack_tag="4.3.7k"
#pack_tag="4.3.7l"
#pack_tag="4.3.7m"
#pack_tag="4.3.7r"
#pack_tag="4.3.7u"

# ------------------------------
# --- Generation Version 4.4 ---
# ------------------------------

#pack_root=vtom44

#pack_tag="4.4.1"
#pack_tag="4.4.1a"
#pack_tag="4.4.1a1"
#pack_tag="4.4.1b"
#pack_tag="4.4.2a"
#pack_tag="4.4.2d"
#pack_tag="4.4.3"

# ------------------------------
# --- Generation Version 4.5 ---
# ------------------------------

#pack_root=vtom45

#pack_tag="4.5.1b"
#pack_tag="4.5.2a"
#pack_tag="4.5.2c"
#pack_tag="4.5.4a"
#pack_tag="4.5.5"
#pack_tag="4.5.5a"

# ------------------------------
# --- Generation Version 4.6 ---
# ------------------------------

#pack_root=vtom46

#pack_tag="4.6.1"
#pack_tag="4.6.2a"
#pack_tag="4.6.3"
#pack_tag="4.6.3a"
#pack_tag="4.6.3b"
#pack_tag="4.6.3c"
#pack_tag="4.6.4"
#pack_tag="4.6.5"
#pack_tag="4.6.5c"
#pack_tag="4.6.6"
#pack_tag="4.6.7"
#pack_tag="4.6.8c"
#pack_tag="4.6.9b"
#pack_tag="4.6.10a"
#pack_tag="4.6.11a"
#pack_tag="4.6.11b"
#pack_tag="4.6.12"
#pack_tag="4.6.12a"
#pack_tag="4.6.13"
#pack_tag="4.6.13a"
#pack_tag="4.6.14"

# ------------------------------
# --- Generation Version 5.0 ---
# ------------------------------

#pack_root=vtom50

#pack_tag="5.0.48a"
#pack_tag="5.0.48b"

# ------------------------------
# --- Generation Version 5.1 ---
# ------------------------------

#pack_root=vtom51

#pack_tag="5.1.1"
#pack_tag="5.1.1a"
#pack_tag="5.1.1b"
#pack_tag="5.1.2"
#pack_tag="5.1.3"
#pack_tag="5.1.4"

# ------------------------------
# --- Generation Version 5.2 ---
# ------------------------------

#pack_root=vtom52

#pack_tag="5.2.2"
#pack_tag="5.2.2a"
#pack_tag="5.2.3"
#pack_tag="5.2.3a"
#pack_tag="5.2.4"
#pack_tag="5.2.4a"
#pack_tag="5.2.4b"
#pack_tag="5.2.4c"

# ------------------------------
# --- Generation Version 5.3 ---
# ------------------------------

#pack_root=vtom53

#pack_tag="5.3.1"
#pack_tag="5.3.2"
#pack_tag="5.3.2a1"
#pack_tag="5.3.2a2"
#pack_tag="5.3.2b"
#pack_tag="5.3.2c"
#pack_tag="5.3.2d"
#pack_tag="5.3.2e"
#pack_tag="5.3.2f"
#pack_tag="5.3.2g"
#pack_tag="5.3.2h"
#pack_tag="5.3.2i"
#pack_tag="5.3.2j"
#pack_tag="5.3.2k"
#pack_tag="5.3.3"
#pack_tag="5.3.3c"
#pack_tag="5.3.3d"
#pack_tag="5.3.3e"
#pack_tag="5.3.3f"
#pack_tag="5.3.3g"
#pack_tag="5.3.4"
#pack_tag="5.3.4a"
#pack_tag="5.3.4b"
#pack_tag="5.3.4c"
#pack_tag="5.3.4d"

# ------------------------------
# --- Generation Version 5.4 ---
# ------------------------------

pack_root=vtom54

#pack_tag="5.4.1"
#pack_tag="5.4.1a"
#pack_tag="5.4.1b"
#pack_tag="5.4.1c"
#pack_tag="5.4.2"
#pack_tag="5.4.3"
#pack_tag="5.4.3a"
pack_tag="5.4.3b"
#pack_tag="5.4.4d"

# -----------------------------
# --- Process de generation ---
# -----------------------------
case "$PROJECT_ARCH" in
	"sco")          pack_os="SCO";;
	"unixware")     pack_os="UNIXWARE";;
	"aix414")       pack_os="AI4";;
	"hp")           pack_os="HP";;
	"solaris")      pack_os="SOL";;
	"linux")        pack_os="LINUX";;
	"hpia64")       pack_os="HPIA64";;
	"decux")        pack_os="DECUX";;
	"solx86")       pack_os="SOL_X86";;
	"linuxx64")     pack_os="LINUX_X64";;
	"linuxia64")    pack_os="LINUX_IA64";;
	"ncr")          pack_os="NCR";;
        *)
                echo "Unknown PROJECT_ARCH ($PROJECT_ARCH)"
                exit 1
esac

./make_it.ksh "$pack_os" "$pack_tag" "$pack_root" "$pack_langue"