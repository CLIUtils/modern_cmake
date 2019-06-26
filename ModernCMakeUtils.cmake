
# Most packages will work in CMake 3.1+
cmake_minimum_required(VERSION 3.1)

# Header style guard for multiple inclusion protection
if(DEFINED MODERN_CMAKE_UTILS)
    return()
endif()

set(MODERN_CMAKE_UTILS ON)

# Capture the current directory
set(MODERN_CMAKE_UTILS_DIR "${CMAKE_CURRENT_LIST_DIR}")

macro(FIND_PACKAGE PNAME)
# Default, empty functions
    macro(MODERN_PACKAGE_PRELOAD)
    endmacro()

    macro(MODERN_PACKAGE_POSTLOAD)
    endmacro()

    macro(MODERN_PACKAGE_FOUND_POSTLOAD)
    endmacro()

    # Load a helper file (error if one does not exist)
    if(EXISTS "${MODERN_CMAKE_UTILS_DIR}/Patch${PNAME}.cmake"
        message( STATUS "[MODERN_CMAKE_TOOLS] Found patch for module ${PNAME}" )
        include("${MODERN_CMAKE_UTILS_DIR}/Patch${PNAME}.cmake")
    endif()
    
    # These commands "override" any previously loaded command
    modern_package_preload()

    _find_package(${PNAME} ${ARGN})

    modern_package_postload()

    if(${PNAME}_FOUND)
        modern_package_found_postload()
    endif()

endmacro()

