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

find_path(CURL_INCLUDE_DIR NAMES curl/curl.h HINTS ${CURL_ROOT} PATH_SUFFIXES include)
mark_as_advanced(CURL_INCLUDE_DIR)

option(CURL_STATIC "Use the static curl library." ON)
mark_as_advanced(CURL_STATIC)

if (CURL_STATIC)
    ADD_DEFINITIONS(-DCURL_STATICLIB)
endif ()

if (MSVC)
    if (CURL_STATIC)
        set(CURL_LIBRARY_NAME libcurl)
    else ()
        set(CURL_LIBRARY_NAME libcurl_imp)
    endif ()
else ()
    if (CURL_STATIC)
        set(CURL_LIBRARY_NAME curl)
    else ()
        set(CURL_LIBRARY_NAME libcurl)
    endif ()
endif ()

find_library(CURL_LIBRARY_DEBUG "${CURL_LIBRARY_NAME}d" HINTS ${CURL_ROOT} PATH_SUFFIXES lib)
find_library(CURL_LIBRARY_RELEASE "${CURL_LIBRARY_NAME}" HINTS ${CURL_ROOT} PATH_SUFFIXES lib)
mark_as_advanced(CURL_LIBRARY_DEBUG CURL_LIBRARY_RELEASE)

if (CURL_LIBRARY_DEBUG AND NOT CURL_LIBRARY_RELEASE)
    set(CURL_LIBRARIES ${CURL_LIBRARY_DEBUG})
elseif (NOT CURL_LIBRARY_DEBUG AND CURL_LIBRARY_RELEASE)
    set(CURL_LIBRARIES ${CURL_LIBRARY_RELEASE})
else ()
    set(CURL_LIBRARIES)
    if (CURL_LIBRARY_DEBUG)
        list(APPEND CURL_LIBRARIES debug ${CURL_LIBRARY_DEBUG})
        set(CURL_LIBRARY_DEBUG_FOUND TRUE)
    endif ()
    if (CURL_LIBRARY_RELEASE)
        list(APPEND CURL_LIBRARIES optimized ${CURL_LIBRARY_RELEASE})
        set(CURL_LIBRARY_RELEASE_FOUND TRUE)
    endif ()
endif ()

# If only the debug or only the release library was found, use it for all configurations
if (CURL_LIBRAY_RELEASE_FOUND AND NOT CURL_LIBRARY_DEBUG_FOUND)
    set(CURL_LIBRARIES ${CURL_LIBRARY_RELEASE})
elseif (CURL_LIBRARY_DEBUG_FOUND AND NOT CURL_LIBRARY_RELEASE_FOUND)
    set(CURL_LIBRARIES ${CURL_LIBRARY_DEBUG})
endif ()

set(_CURL_VERSION_FILE "${CURL_INCLUDE_DIR}/curl/curl.h")
if (EXISTS ${_CURL_VERSION_FILE})
    file(STRINGS ${_CURL_VERSION_FILE} _CURL_VERSION_LINE REGEX "^#define[\t ]+LIBCURL_VERSION[\t ]+\".*\"")
    string(REGEX REPLACE ".*\"(.*)\".*" "\\1" CURL_VERSION "${_CURL_VERSION_LINE}")
else ()
    set(CURL_VERSION "unknown")
ENDIF ()

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(CURL
        REQUIRED_VARS
        CURL_INCLUDE_DIR
        CURL_LIBRARIES
        VERSION_VAR
        CURL_VERSION
        FAIL_MESSAGE
        "Could not find libcurl, ensure it is in either the system's or CMake's path, or set CURL_ROOT."
        )
