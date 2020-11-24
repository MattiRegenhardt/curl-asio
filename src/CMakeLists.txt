# curl-asio
# Seamlessly integrate libcurl with Boost.Asio
#
# Copyright (c) 2013 Oliver Kuckertz <oliver.kuckertz@mologie.de>
# See COPYING for license information.

set(LIBCURLASIO_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}")
set(LIBCURLASIO_HEADER_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../include")
file(GLOB LIBCURLASIO_SOURCE_FILES "${LIBCURLASIO_SOURCE_DIR}/*.cpp")
file(GLOB LIBCURLASIO_HEADER_FILES "${LIBCURLASIO_HEADER_DIR}/curl-asio/*.h")
list(APPEND LIBCURLASIO_HEADER_FILES "${LIBCURLASIO_HEADER_DIR}/curl-asio.h")

if (BUILD_SHARED)
    add_library(
            curlasio-shared
            SHARED
            ${LIBCURLASIO_SOURCE_FILES}
            ${LIBCURLASIO_HEADER_FILES}
    )
    target_link_libraries(
            curlasio-shared
            PUBLIC
            ${Boost_LIBRARIES}
            ${CURL_LIBRARIES}
    )
    target_include_directories(
            curlasio-shared
            PUBLIC
            ${LIBCURLASIO_HEADER_DIR}
            ${Boost_INCLUDE_DIR}
            ${CURL_INCLUDE_DIR}
    )
    target_compile_features(
            curlasio-shared
            PUBLIC
            cxx_std_11
    )
    target_compile_definitions(
            curlasio-shared
            PUBLIC
            $<$<BOOL:${CURL_IS_STATIC}>:CURL_STATICLIB>
    )
    set_target_properties(
            curlasio-shared
            PROPERTIES
            DEBUG_POSTFIX d
            OUTPUT_NAME curlasio
    )
    add_library(curlasio::shared ALIAS curlasio-shared)
    install(
            TARGETS curlasio-shared
            RUNTIME DESTINATION bin
            LIBRARY DESTINATION lib
            ARCHIVE DESTINATION lib
    )
endif ()
if (BUILD_STATIC)
    add_library(
            curlasio-static
            STATIC
            ${LIBCURLASIO_SOURCE_FILES}
            ${LIBCURLASIO_HEADER_FILES}
    )
    target_link_libraries(
            curlasio-static
            PUBLIC
            ${Boost_LIBRARIES}
            ${CURL_LIBRARIES}
    )
    target_include_directories(
            curlasio-static
            PUBLIC
            ${LIBCURLASIO_HEADER_DIR}
            ${Boost_INCLUDE_DIR}
            ${CURL_INCLUDE_DIR}
    )
    target_compile_features(
            curlasio-static
            PUBLIC
            cxx_std_11
    )
    target_compile_definitions(
            curlasio-static
            PUBLIC
            $<$<BOOL:${CURL_IS_STATIC}>:CURL_STATICLIB>
            CURLASIO_STATIC
    )
    set_target_properties(
            curlasio-static
            PROPERTIES
            DEBUG_POSTFIX d
            OUTPUT_NAME curlasio
    )
    add_library(curlasio::static ALIAS curlasio-static)
    install(
            TARGETS curlasio-static
            RUNTIME DESTINATION bin
            LIBRARY DESTINATION lib
            ARCHIVE DESTINATION lib
    )
endif ()

if (BUILD_SHARED)
    add_library(curlasio::curlasio ALIAS curlasio-shared)
else ()
    add_library(curlasio::curlasio ALIAS curlasio-static)
endif ()

install(DIRECTORY "${LIBCURLASIO_HEADER_DIR}/" DESTINATION include)
