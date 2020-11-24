# curl-asio
# Seamlessly integrate libcurl with Boost.Asio
#
# Copyright (c) 2013 Oliver Kuckertz <oliver.kuckertz@mologie.de>
# See COPYING for license information.

macro(add_example EXAMPLE_NAME)
    add_executable(
            ${EXAMPLE_NAME}_example
            ${EXAMPLE_NAME}.cpp
    )
    target_link_libraries(
            ${EXAMPLE_NAME}_example
            PRIVATE
            curlasio::curlasio
    )
endmacro()

add_example(asynchronous)
add_example(synchronous)
