# curl-asio
# Seamlessly integrate libcurl with Boost.Asio
#
# Copyright (c) 2013 Oliver Kuckertz <oliver.kuckertz@mologie.de>
# See COPYING for license information.

cmake_minimum_required(VERSION 3.18)
project(curl-asio)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

option(BUILD_STATIC "Build the static library" ON)
option(BUILD_SHARED "Build the shared library" OFF)
option(BUILD_EXAMPLES "Build the examples" ON)

if (NOT BUILD_STATIC AND NOT BUILD_SHARED)
    message(FATAL_ERROR "Neither BUILD_STATIC nor BUILD_SHARED is set")
endif ()

set(CURLASIO_INCLUDE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/include")

if (NOT TARGET curl::libcurl)
    find_package(CURLASIO-CURL REQUIRED)
endif()
if (NOT TARGET Boost::boost OR NOT TARGET Boost::system)
    find_package(Boost REQUIRED COMPONENTS system)
endif()

add_subdirectory(src)
if (BUILD_EXAMPLES)
    add_subdirectory(examples)
endif ()

option(INSTALL_CMAKE_MODULES "Install CMake module files for libcurl and curl-asio" ON)

if (INSTALL_CMAKE_MODULES)
    if (APPLE)
        if ((IS_SYMLINK "${CMAKE_INSTALL_PREFIX}/share/cmake") OR (IS_SYMLINK "${CMAKE_INSTALL_PREFIX}/share/cmake/Modules"))
            message(FATAL_ERROR "The destination path '${CMAKE_INSTALL_PREFIX}/share/cmake' is a symlink."
                    "If you are using Homebrew, run the following set of commands prior to installing this library:\n"
                    "    brew unlink cmake\n"
                    "    mkdir -p '${CMAKE_INSTALL_PREFIX}/share/cmake/Modules'\n"
                    "    brew link cmake\n"
                    "Without these changes, updating CMake through Homebrew would break the installation. Alternatively, choose a difference CMAKE_INSTALL_PREFIX.")
        endif ()
    endif ()
    install(DIRECTORY cmake/ DESTINATION share/cmake/Modules)
endif ()
