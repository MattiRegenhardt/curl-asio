# Find libcurl
# Oliver Kuckertz <oliver.kuckertz@mologie.de>, 2013-10-06, public domain
#
# This is a lightweight replacement for CMake's FindCURL.cmake, dropping
# support for older libcurl libraries, adding a switch for static library
# support, and allowing to link to debug versions of libcurl.
#
# Searches for:
# <prefix>/include/curl/curl.h
# libcurl.lib
# libcurld.lib
#
# Defines:
# CURL_INCLUDE_DIR
# CURL_LIBRARIES
# CURL_VERSION
#
# Uses:
# CURL_ROOT
# CURL_STATIC
#

FIND_PATH(CURL_INCLUDE_DIR NAMES curl/curl.h HINTS ${CURL_ROOT} PATH_SUFFIXES include)
MARK_AS_ADVANCED(CURL_INCLUDE_DIR)

OPTION(CURL_STATIC "Use the static curl library." ON)
MARK_AS_ADVANCED(CURL_STATIC)

FIND_LIBRARY(CURL_LIBRARY_DEBUG libcurld HINTS ${CURL_ROOT} PATH_SUFFIXES lib)
FIND_LIBRARY(CURL_LIBRARY_RELEASE libcurl HINTS ${CURL_ROOT} PATH_SUFFIXES lib)
MARK_AS_ADVANCED(CURL_LIBRARY_DEBUG CURL_LIBRARY_RELEASE)

SET(CURL_LIBRARIES)
IF(CURL_LIBRARY_DEBUG)
	LIST(APPEND CURL_LIBRARIES debug ${CURL_LIBRARY_DEBUG})
	SET(CURL_LIBRARY_DEBUG_FOUND TRUE)
ENDIF()
IF(CURL_LIBRARY_RELEASE)
	LIST(APPEND CURL_LIBRARIES optimized ${CURL_LIBRARY_RELEASE})
	SET(CURL_LIBRARY_RELEASE_FOUND TRUE)
ENDIF()

SET(_CURL_VERSION_FILE "${CURL_INCLUDE_DIR}/curl/curl.h")

IF(EXISTS ${_CURL_VERSION_FILE})
	FILE(STRINGS ${_CURL_VERSION_FILE} _CURL_VERSION_LINE REGEX "^#define[\t ]+LIBCURL_VERSION[\t ]+\".*\"")
	STRING(REGEX REPLACE ".*\"(.*)\".*" "\\1" CURL_VERSION "${_CURL_VERSION_LINE}")
ELSE()
	SET(CURL_VERSION "unknown")
ENDIF()

IF(CURL_STATIC)
	ADD_DEFINITIONS(-DCURL_STATICLIB)
ENDIF()

INCLUDE(FindPackageHandleStandardArgs)

FIND_PACKAGE_HANDLE_STANDARD_ARGS(CURLASIO
	REQUIRED_VARS
		CURL_INCLUDE_DIR
		CURL_LIBRARIES
	VERSION_VAR
		CURL_VERSION
	FAIL_MESSAGE
		"Could not find libcurl, ensure it is in either the system's or CMake's path, or set CURL_ROOT."
	)
