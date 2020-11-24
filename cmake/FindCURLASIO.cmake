# Find curl-asio
# Oliver Kuckertz <oliver.kuckertz@mologie.de>, 2013-10-06, public domain
#
# Searches for:
# <prefix>/include/curl-asio.h
# curlasio.lib or libcurlasio.lib
# curlasiod.lib or libcurlasiod.lib
#
# Defines:
# CURLASIO_INCLUDE_DIR
# CURLASIO_LIBRARIES
#
# Uses:
# CURLASIO_ROOT
# CURLASIO_STATIC
#

find_path(CURLASIO_INCLUDE_DIR NAMES curl-asio.h HINTS ${CURLASIO_ROOT} PATH_SUFFIXES include)
mask_as_advanced(CURLASIO_INCLUDE_DIR)

option(CURLASIO_STATIC "Use the static curl-asio library." ON)
mark_as_advanced(CURLASIO_STATIC)

if (CURLASIO_STATIC)
    set(CURLASIO_LIBRARY_NAME curlasio)
else ()
    set(CURLASIO_LIBRARY_NAME libcurlasio)
endif ()

find_library(CURLASIO_LIBRARY_DEBUG "${CURLASIO_LIBRARY_NAME}d" HINTS ${CURLASIO_ROOT} PATH_SUFFIXES lib)
find_library(CURLASIO_LIBRARY_RELEASE "${CURLASIO_LIBRARY_NAME}" HINTS ${CURLASIO_ROOT} PATH_SUFFIXES lib)
mark_as_advanced(CURLASIO_LIBRARY_DEBUG CURLASIO_LIBRARY_RELEASE)

if (CURLASIO_LIBRARY_DEBUG AND NOT CURLASIO_LIBRARY_RELEASE)
    set(CURLASIO_LIBRARIES ${CURLASIO_LIBRARY_DEBUG})
elseif (NOT CURLASIO_LIBRARY_DEBUG AND CURLASIO_LIBRARY_RELEASE)
    set(CURLASIO_LIBRARIES ${CURLASIO_LIBRARY_RELEASE})
else ()
    set(CURLASIO_LIBRARIES)
    if (CURLASIO_LIBRARY_DEBUG)
        list(APPEND CURLASIO_LIBRARIES debug ${CURLASIO_LIBRARY_DEBUG})
        set(CURLASIO_LIBRARY_DEBUG_FOUND TRUE)
    endif ()
    if (CURLASIO_LIBRARY_RELEASE)
        list(APPEND CURLASIO_LIBRARIES optimized ${CURLASIO_LIBRARY_RELEASE})
        set(CURLASIO_LIBRARY_RELEASE_FOUND TRUE)
    endif ()
endif ()

if (NOT TARGET CURL::libcurl)
    find_package(CURLASIO-CURL REQUIRED)
    set(CURLASIO_INCLUDE_DIRS ${CURLASIO_INCLUDE_DIR} ${CURL_INCLUDE_DIR})

    if (CURLASIO_STATIC)
        list(APPEND CURLASIO_LIBRARIES ${CURL_LIBRARIES})
    endif ()
else()
    list(APPEND CURLASIO_LIBRARIES CURL::libcurl)
endif()

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(CURLASIO
        REQUIRED_VARS
        CURLASIO_INCLUDE_DIR
        CURLASIO_LIBRARIES
        FAIL_MESSAGE
        "Could not find curl-asio, ensure it is in either the system's or CMake's path, or set CURLASIO_ROOT."
        )
