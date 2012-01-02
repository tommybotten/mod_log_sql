# aclocal.m4 generated automatically by aclocal 1.6.3 -*- Autoconf -*-

# Copyright 1996, 1997, 1998, 1999, 2000, 2001, 2002
# Free Software Foundation, Inc.
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY, to the extent permitted by law; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.

dnl m4 for utility macros used by all out of order projects

dnl this writes a "config.nice" file which reinvokes ./configure with all
dnl of the arguments. this is different from config.status which simply
dnl regenerates the output files. config.nice is useful after you rebuild
dnl ./configure (via autoconf or autogen.sh)
AC_DEFUN([OOO_CONFIG_NICE],[
  echo configure: creating $1
  rm -f $1
  cat >$1<<EOF
#! /bin/sh
#
# Created by configure

EOF

  for arg in [$]0 "[$]@"; do
    if test "[$]arg" != "--no-create" -a "[$]arg" != "--no-recursion"; then
        echo "\"[$]arg\" \\" >> $1
    fi
  done
  echo '"[$]@"' >> $1
  chmod +x $1
])

dnl this macro adds a maintainer mode option to enable programmer specific
dnl  code in makefiles
AC_DEFUN([OOO_MAINTAIN_MODE],[
  AC_ARG_ENABLE(
        maintainer,
        [AC_HELP_STRING([--enable-maintainer],[Enable maintainer mode for this project])],
        AC_MSG_RESULT([Enabling Maintainer Mode!!])
        OOO_MAINTAIN=1,
        OOO_MAINTAIN=0)
  AC_SUBST(OOO_MAINTAIN)
])


dnl CHECK_APACHE([MINIMUM13-VERSION [, MINIMUM20-VERSION [, 
dnl            ACTION-IF-FOUND13 [, ACTION-IF-FOUND20 [, ACTION-IF-NOT-FOUND]]])
dnl Test for Apache apxs, APR, and APU

AC_DEFUN([CHECK_APACHE],
[dnl
AC_ARG_WITH(
    apxs,
    [AC_HELP_STRING([--with-apxs=PATH],[Path to apxs])],
    apxs_prefix="$withval",
    apxs_prefix="/usr"
    )

AC_ARG_ENABLE(
        apachetest,
        [AC_HELP_STRING([--disable-apxstest],[Do not try to compile and run apache version test program])],
        ,
        enable_apachetest=yes
    )

    if test -x $apxs_prefix -a ! -d $apxs_prefix; then
        APXS_BIN=$apxs_prefix
    else
        test_paths="$apxs_prefix:$apxs_prefix/bin:$apxs_prefix/sbin"
        test_paths="${test_paths}:/usr/bin:/usr/sbin"
        test_paths="${test_paths}:/usr/local/bin:/usr/local/sbin:/usr/local/apache2/bin"
        AC_PATH_PROG(APXS_BIN, apxs, no, [$test_paths])
    fi
    min_apache13_version=ifelse([$1], ,no,$1)
    min_apache20_version=ifelse([$2], ,no,$2)
    no_apxs=""
    if test "$APXS_BIN" = "no"; then
        AC_MSG_ERROR([*** The apxs binary installed by apache could not be found!])
        AC_MSG_ERROR([*** Use the --with-apxs option with the full path to apxs])
    else
        AP_INCLUDES="-I`$APXS_BIN -q INCLUDEDIR 2>/dev/null`"
        AP_INCLUDEDIR="`$APXS_BIN -q INCLUDEDIR 2>/dev/null`"

        AP_PREFIX="`$APXS_BIN -q prefix 2>/dev/null`"

        AP_BINDIR="`$APXS_BIN -q bindir 2>/dev/null`"
        AP_SBINDIR="`$APXS_BIN -q sbindir 2>/dev/null`"
        AP_SYSCONFDIR="`$APXS_BIN -q sysconfdir 2>/dev/null`"

        APXS_CFLAGS=""
        for flag in CFLAGS EXTRA_CFLAGS EXTRA_CPPFLAGS NOTEST_CFLAGS; do
            APXS_CFLAGS="$APXS_CFLAGS `$APXS_BIN -q $flag 2>/dev/null`"
        done

        AP_CPPFLAGS="$APXS_CPPFLAGS $AP_INCLUDES"
        AP_CFLAGS="$APXS_CFLAGS $AP_INCLUDES"

        AP_LIBEXECDIR=`$APXS_BIN -q LIBEXECDIR 2>/dev/null`

        if test "x$enable_apachetest" = "xyes" ; then
            if test "$min_apache20_version" != "no"; then
                APR_CONFIG="`$APXS_BIN -q APR_BINDIR 2>/dev/null`/apr-1-config"
                if test ! -x $APR_CONFIG; then
                    APR_CONFIG="`$APXS_BIN -q APR_BINDIR 2>/dev/null`/apr-config"
                fi
                APR_INCLUDES=`$APR_CONFIG --includes 2>/dev/null`
                APR_VERSION=`$APR_CONFIG --version 2>/dev/null`
                APU_CONFIG="`$APXS_BIN -q APU_BINDIR 2>/dev/null`/apu-1-config"
                if test ! -x $APU_CONFIG; then
                    APU_CONFIG="`$APXS_BIN -q APU_BINDIR 2>/dev/null`/apu-config"
                fi
                APU_INCLUDES=`$APU_CONFIG --includes 2>/dev/null`
                APU_VERSION=`$APU_CONFIG --version 2>/dev/null`

                AC_MSG_CHECKING(for Apache 2.0 version >= $min_apache20_version)
                TEST_APACHE_VERSION(20,$min_apache20_version,
                    AC_MSG_RESULT(yes)
                    AC_DEFINE(WITH_APACHE20,1,[Define to 1 if we are compiling with Apache 2.0.x])
                    AP_VERSION="2.0"
                    APXS_EXTENSION=.la
                    AP_CFLAGS="$AP_CFLAGS $APU_INCLUDES $APR_INCLUDES"
                    AP_CPPFLAGS="$AP_CPPFLAGS $APU_INCLUDES $APR_INCLUDES"
                    AP_DEFS="-DWITH_APACHE20"
                    ifelse([$4], , , $4),
                    AC_MSG_RESULT(no)
                    if test "x$min_apache13_version" = "xno"; then
                        ifelse([$5], , , $5)
                    fi
                )
            fi
            if test "$min_apache13_version" != "no" -a "x$AP_VERSION" = "x"; then
                APR_INCLUDES=""
                APR_VERSION=""
                APU_INCLUDES=""
                APU_VERSION=""
                AC_MSG_CHECKING(for Apache 1.3 version >= $min_apache13_version)
                TEST_APACHE_VERSION(13,$min_apache13_version,
                    AC_MSG_RESULT(yes)
                    AC_DEFINE(WITH_APACHE13,1,[Define to 1 if we are compiling with Apache 1.3.x])
                    AP_VERSION="1.3"
                    APXS_EXTENSION=.so
                    AP_CFLAGS="-g $AP_CFLAGS"
                    AP_DEFS="-DWITH_APACHE13"
                    ifelse([$3], , , $3),
                    AC_MSG_RESULT(no)
                    ifelse([$5], , , $5)
                )
            fi
        fi
        AC_SUBST(AP_DEFS)
        AC_SUBST(AP_PREFIX)
        AC_SUBST(AP_CFLAGS)
        AC_SUBST(AP_CPPFLAGS)
        AC_SUBST(AP_INCLUDES)
        AC_SUBST(AP_INCLUDEDIR)
        AC_SUBST(AP_LIBEXECDIR)
        AC_SUBST(AP_VERSION)
        AC_SUBST(AP_SYSCONFDIR)
        AC_SUBST(AP_BINDIR)
        AC_SUBST(AP_SBINDIR)
        AC_SUBST(APR_INCLUDES)
        AC_SUBST(APU_INCLUDES)
        AC_SUBST(APXS_EXTENSION)
        AC_SUBST(APXS_BIN)
        AC_SUBST(APXS_CFLAGS)
    fi
])

dnl TEST_APACHE_VERSION(RELEASE, [MINIMUM-VERSION [, ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]]])
dnl Test for Apache
dnl
AC_DEFUN([TEST_APACHE_VERSION],
[dnl
    AC_REQUIRE([AC_CANONICAL_TARGET])
    releasetest=$1
    min_apache_version="$2"
    no_apache=""
    ac_save_CFLAGS="$CFLAGS"
    CFLAGS="$CFLAGS $AP_CFLAGS"
    if test $releasetest -eq 20; then
        CFLAGS="$CFLAGS $APU_INCLUDES $APR_INCLUDES"
    fi
    AC_TRY_RUN([
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "httpd.h"

#ifndef AP_SERVER_BASEREVISION
    #define AP_SERVER_BASEREVISION SERVER_BASEREVISION
#endif
        
char* my_strdup (char *str)
{
    char *new_str;

    if (str) {
        new_str = (char *)malloc ((strlen (str) + 1) * sizeof(char));
        strcpy (new_str, str);
    } else
        new_str = NULL;

    return new_str;
}

int main (int argc, char *argv[])
{
    int major1, minor1, micro1;
    int major2, minor2, micro2;
    char *tmp_version;

    { FILE *fp = fopen("conf.apachetest", "a"); if ( fp ) fclose(fp); }

    tmp_version = my_strdup("$min_apache_version");
    if (sscanf(tmp_version, "%d.%d.%d", &major1, &minor1, &micro1) != 3) {
        printf("%s, bad version string\n", "$min_apache_version");
        exit(1);
    }
    tmp_version = my_strdup(AP_SERVER_BASEREVISION);
    if (sscanf(tmp_version, "%d.%d.%d", &major2, &minor2, &micro2) != 3) {
        printf("%s, bad version string\n", AP_SERVER_BASEREVISION);
        exit(1);
    }

    if ( (major2 == major1) &&
        ( (minor2 > minor1) ||
        ((minor2 == minor1) && (micro2 >= micro1)) ) ) {
        exit(0);
    } else {
        exit(1);
    }
}

],, no_apache=yes,[echo $ac_n "cross compiling; assumed OK... $ac_c"])
    CFLAGS="$ac_save_CFLAGS"

    if test "x$no_apache" = x ; then
        ifelse([$3], , :, [$3])
       else
        if test -f conf.apachetest ; then
            :
        else
            echo "*** Could not run Apache test program, checking why..."
            CFLAGS="$CFLAGS $AP_CFLAGS"
            if test $releasetest -eq 20; then
                CFLAGS="$CFLAGS $APU_INCLUDES $APR_INCLUDES"
            fi
            AC_TRY_LINK([
#include <stdio.h>
#include "httpd.h"

int main(int argc, char *argv[])
{ return 0; }
#undef main
#define main K_and_R_C_main
],                [ return 0; ],
                [ echo "*** The test program compiled, but failed to run. Check config.log" ],
                [ echo "*** The test program failed to compile or link. Check config.log" ])
            CFLAGS="$ac_save_CFLAGS"
        fi
         ifelse([$4], , :, [$4])
      fi
      rm -f conf.apachetest
])

dnl CHECK_PATH_MYSQL([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUNT]])
dnl Check for MySQL Libs
dnl
AC_DEFUN([CHECK_MYSQL],
[dnl
AC_ARG_WITH(
        mysql,
        [AC_HELP_STRING([--with-mysql=PATH],[Path to MySQL client library])],
        mysql_prefix="$withval",
        
    )
AC_ARG_ENABLE(
        mysqltest,
        [AC_HELP_STRING([--disble-mysqltest],[Do not try to compile and run mysql test program])],
        ,
        enable_mysqltest=yes)

    AC_REQUIRE([AC_CANONICAL_TARGET])

    testdirs="/usr /usr/local /usr/local /opt"
    if test "x$mysql_prefix" != "x" && test "x$mysql_prefix" != "xyes"; then
        testdirs="${testdirs} ${mysql_prefix}"
    fi
    for dir in $testdirs; do
      if test -e $dir/include/mysql.h; then
        MYSQL_CFLAGS=-I${dir}/include
        MYSQL_LDFLAGS=-L${dir}/lib${libsuff}
        MYSQL_LIBS="-lmysqlclient -lm -lz"
        break
      elif test -e $dir/include/mysql/mysql.h; then
        MYSQL_CFLAGS=-I${dir}/include/mysql
        MYSQL_LDFLAGS=-L${dir}/lib${libsuff}/mysql
        MYSQL_LIBS="-lmysqlclient -lm -lz"
        break
      fi
    done
    if test -z $MYSQL_CFLAGS; then
      echo "*** MySQL development files could not be found!"
    fi
    ac_save_CFLAGS=$CFLAGS
    ac_save_LDFLAGS=$LDFLAGS
    CFLAGS="$CFLAGS $MYSQL_CFLAGS"
    LDFLAGS="$LDFLAGS $MYSQL_LDFLAGS"
    AC_CHECK_LIB(m, floor)
    AC_CHECK_LIB(z, gzclose)
    with_mysql="yes"
    AC_DEFINE(WITH_MYSQL,1,[Define to 1 if we are compiling with mysql])
    AC_CHECK_LIB(mysqlclient, mysql_init, ,
      [AC_MSG_ERROR(libmysqlclient is needed for MySQL support)])
    AC_CHECK_FUNCS(mysql_real_escape_string)
    AC_MSG_CHECKING(whether mysql clients can run)
    AC_TRY_RUN([
      #include <stdio.h>
      #include <mysql.h>    
      int main(void)
      {
          MYSQL *a = mysql_init(NULL);
          return 0;
      }
      ], , no_mysql=yes,[echo $ac_n "cross compiling; assumed OK.... $ac_c"])
      CFLAGS=$ac_save_CFLAGS
      LDFLAGS=$ac_save_LDFLAGS
      if test "x$no_mysql" = x; then
        AC_MSG_RESULT(yes)
        ifelse([$1], , :, [$1])
      else
        AC_MSG_RESULT(no)
        echo "*** MySQL could not be found ***"
        MYSQL_CFLAGS=""
        MYSQL_LDFLAGS=""
        MYSQL_LIBS=""
        ifelse([$2], , :, [$2])
      fi
      AC_SUBST(MYSQL_LDFLAGS)
      AC_SUBST(MYSQL_CFLAGS)
      AC_SUBST(MYSQL_LIBS)
])

dnl Check for libdbi libraries
dnl CHECK_LIBDBI(ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND])
AC_DEFUN([CHECK_LIBDBI],
[dnl

AC_ARG_WITH(
    dbi,
    [AC_HELP_STRING([--with-dbi=PATH],[Path libdbi headers and libraries])],
    dbi_path="$withval",
    :)

# Determine dbi include directory.
if test -z $dbi_path; then
    test_paths="/usr/include /usr/local/include"
else
    test_paths="${dbi_path}/include"
fi

for x in $test_paths ; do
    AC_MSG_CHECKING([for dbi Includes in ${x}])
    if test -f ${x}/dbi/dbi.h; then
        DBI_CFLAGS="-I$x"
        AC_MSG_RESULT([found it! Use --with-dbi to specify another.])
        break
    else
        AC_MSG_RESULT(no)        
    fi
done

if test -z "$DBI_CFLAGS"; then
  ifelse([$2], , AC_MSG_ERROR([libdbi include files not found.]), $2)
fi

# Determine libdbi lib directory
if test -z $dbi_path; then
    test_paths="/usr/lib /usr/local/lib"
else
    test_paths="${dbi_path}/lib"
fi

for x in $test_paths ; do
    AC_MSG_CHECKING([for libdbi library in ${x}])
    if test -f ${x}/libdbi.so; then
        AC_MSG_RESULT([yes])
        save_CFLAGS=$CFLAGS
        save_LDFLAGS=$LDFLAGS
        CFLAGS="$DBI_CFLAGS $CFLAGS"
        LDFLAGS="-L$x $LDFLAGS"
        AC_CHECK_LIB(dbi, dbi_version,
            DBI_LDFLAGS="-L$x")
        dnl // TODO: Should we check for other libs here?
        CFLAGS=$save_CFLAGS
        LDFLAGS=$save_LDFLAGS
        break
    else
        AC_MSG_RESULT([no])
    fi
done
if test -z "$DBI_LDFLAGS"; then
  ifelse([$2], , AC_MSG_ERROR([libdbi library not found.]), $2)
else
  AC_SUBST(DBI_LDFLAGS)
  DBI_LIBS=-ldbi
  AC_SUBST(DBI_LIBS)
  AC_SUBST(DBI_CFLAGS)
  ifelse([$1], , , $1)
fi
])

dnl CHECK_PATH_MOD_SSL([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
dnl Test for mod_ssl and openssl header directory.
dnl
AC_DEFUN([CHECK_MOD_SSL],
[dnl
AC_ARG_ENABLE(
        ssl,
        [AC_HELP_STRING([--disable-ssl],[Do not compile in SSL support])],
        ssl_val=no,
        ssl_val=yes
    )
AC_ARG_WITH(
        ssl-inc,
        [AC_HELP_STRING([--with-ssl-inc=PATH],[Location of SSL header files])],
        ssl_incdir="$withval",
    )
AC_ARG_WITH(
        db-inc,
        [AC_HELP_STRING([--with-db-inc=PATH],[Location of DB header files])],
        db_incdir="$withval",
        db_incdir="/usr/include/db1"
    )

    if test "x$ssl_val" = "xyes"; then
        ac_save_CFLAGS=$CFLAGS
        ac_save_CPPFLAGS=$CPPFLAGS
        MOD_SSL_CFLAGS="-I/usr/include/openssl"
        if test "x$ssl_incdir" != "x"; then
            MOD_SSL_CFLAGS="-I$ssl_incdir -I$ssl_incdir/openssl $MOD_SSL_CFLAGS"
        fi
        if test "x$db_incdir" != "x"; then
            MOD_SSL_CFLAGS="-I$db_incdir $MOD_SSL_CFLAGS"
        fi
        CFLAGS="$AP_CFLAGS $MOD_SSL_CFLAGS $CFLAGS"
        CPPFLAGS="$AP_CFLAGS $MOD_SSL_CFLAGS $CPPFLAGS"
        AC_CHECK_HEADERS([mod_ssl.h],
            mod_ssl_h=yes
        )
        CFLAGS=$ac_save_CFLAGS
        CPPFLAGS=$ac_save_CPPFLAGS
        if test "x$mod_ssl_h" = "x"; then
            ifelse([$2], , :, [$2])
        else
            AC_SUBST(MOD_SSL_CFLAGS)
            ifelse([$1], , :, [$1])
        fi
    else
        ifelse([$2], , :, [$2])
    fi
])

