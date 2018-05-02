# MPI
cmake_minimum_required(VERSION 3.1)

macro(MODERN_PACKAGE_FOUND_POSTLOAD)
    # For supporting CMake < 3.9:
    if(NOT TARGET MPI::MPI_CXX)
        add_library(MPI::MPI_CXX IMPORTED INTERFACE)
        set_property(TARGET MPI::MPI_CXX
                     PROPERTY INTERFACE_COMPILE_OPTIONS ${MPI_CXX_COMPILE_FLAGS})
        set_property(TARGET MPI::MPI_CXX
                     PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${MPI_CXX_INCLUDE_PATH}")
        set_property(TARGET MPI::MPI_CXX
                     PROPERTY INTERFACE_LINK_LIBRARIES ${MPI_CXX_LINK_FLAGS} ${MPI_CXX_LIBRARIES})
    endif()
endmacro()
