# OpenMP
cmake_minimum_required(VERSION 3.4)

macro(MODERN_PACKAGE_POSTLOAD)

    # For CMake < 3.9, we need to make the target ourselves
    if(OpenMP_FOUND OR OpenMP_CXX_FOUND)
        if(NOT TARGET OpenMP::OpenMP_CXX)
            find_package(Threads REQUIRED)
            add_library(OpenMP::OpenMP_CXX IMPORTED INTERFACE)
            set_property(TARGET OpenMP::OpenMP_CXX
                         PROPERTY INTERFACE_COMPILE_OPTIONS ${OpenMP_CXX_FLAGS})
            # Only works if the same flag is passed to the linker; use CMake 3.9+ otherwise (Intel, AppleClang)
            set_property(TARGET OpenMP::OpenMP_CXX
                         PROPERTY INTERFACE_LINK_LIBRARIES ${OpenMP_CXX_FLAGS} Threads::Threads)

        endif()
    endif()

    if((NOT "${OpenMP_FOUND}" OR NOT "${OpenMP_CXX_FOUND}")
        AND ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "AppleClang"
            AND NOT CMAKE_CXX_COMPILER_VERSION VERSION_LESS "7"))

        find_program(BREW NAMES brew)
        if(BREW)
            execute_process(COMMAND ${BREW} ls libomp RESULT_VARIABLE BREW_RESULT_CODE OUTPUT_QUIET ERROR_QUIET)
            if(BREW_RESULT_CODE)
                message(STATUS "This program supports OpenMP on Mac through Brew. Please run \"brew install libomp\"")
            else()
                execute_process(COMMAND ${BREW} --prefix libomp OUTPUT_VARIABLE BREW_LIBOMP_PREFIX OUTPUT_STRIP_TRAILING_WHITESPACE)
                set(OpenMP_CXX_FLAGS "-Xpreprocessor -fopenmp -I/usr/local/opt/libomp/include")
                set(OpenMP_CXX_LIB_NAMES "omp")
                set(OpenMP_omp_LIBRARY "${BREW_LIBOMP_PREFIX}/lib/libomp.dylib")

                add_library(OpenMP::OpenMP_CXX IMPORTED INTERFACE)
                set_target_properties(OpenMP::OpenMP_CXX PROPERTIES
                    INTERFACE_COMPILE_OPTIONS "${OpenMP_CXX_FLAGS}"
                    INTERFACE_LINK_LIBRARIES "${OpenMP_omp_LIBRARY}"
                    INTERFACE_INCLUDE_DIRECTORIES "${BREW_LIBOMP_PREFIX}/include")
                message(STATUS "Using Homebrew libomp from ${BREW_LIBOMP_PREFIX}")
                set(OpenMP_FOUND TRUE)
                set(OpenMP_CXX_FOUND TRUE)
            endif()
        else()
            message(STATUS "This program supports OpenMP on Mac through Homebrew, installing Homebrew recommmended https://brew.sh")
        endif()
    endif()

endmacro()
