cmake_minimum_required(VERSION 3.4)

macro(MODERN_PACKAGE_FOUND_POSTLOAD)
# This patches problems in early version of ROOT Config

    if(NOT DEFINED ROOT_EXE_LINKER_FLAG_LIST)
        string(REPLACE "-L " "-L" ROOT_EXE_LINKER_FLAGS "${ROOT_EXE_LINKER_FLAGS}")
        string(STRIP "${ROOT_EXE_LINKER_FLAGS}" ROOT_EXE_LINKER_FLAG_LIST)
        separate_arguments(ROOT_EXE_LINKER_FLAG_LIST)
    endif()

    if(NOT DEFINED ROOT_DEFINITION_LIST)
        string(STRIP "${ROOT_DEFINITIONS}" ROOT_DEFINITION_LIST)
        separate_arguments(ROOT_DEFINITION_LIST)
    endif()

    if(NOT DEFINED ROOT_CXX_FLAG_LIST)
        string(STRIP "${ROOT_CXX_FLAGS}" ROOT_CXX_FLAG_LIST)
        separate_arguments(ROOT_CXX_FLAG_LIST)
    endif()

    if(NOT DEFINED ROOT_C_FLAG_LIST)
        string(STRIP "${ROOT_C_FLAGS}" ROOT_C_FLAG_LIST)
        separate_arguments(ROOT_C_FLAG_LIST)
    endif()

    if(NOT DEFINED ROOT_fortran_FLAG_LIST)
        string(STRIP "${ROOT_fortran_FLAGS}" ROOT_fortran_FLAG_LIST)
        separate_arguments(ROOT_fortran_FLAG_LIST)
    endif()


    if(NOT TARGET ROOT::Libraries)
        add_library(ROOT::Libraries INTERFACE IMPORTED)

        foreach(_library IN LISTS ROOT_LIBRARIES)
            get_filename_component(_library "${_library}" NAME_WE)
            string(REGEX REPLACE [=[^lib]=] "" _library "${_library}")
            target_link_libraries(ROOT::Libraries INTERFACE ROOT::${_library})
        endforeach()
    endif()

    if(NOT TARGET ROOT::Flags)
        add_library(ROOT::Flags INTERFACE IMPORTED)
        
        foreach(_flag ${ROOT_EXE_LINKER_FLAG_LIST})
            # Remove -D or /D if present
            string(REGEX REPLACE [=[^[-//]D]=] "" _flag ${_flag})
            set_property(TARGET ROOT::Flags APPEND PROPERTY INTERFACE_LINK_LIBRARIES ${_flag})
        endforeach()

        set_property(TARGET ROOT::Flags PROPERTY INTERFACE_COMPILE_DEFINITIONS ${ROOT_DEFINITION_LIST})

        if(CMAKE_CXX_COMPILER_LOADED)
          set_property(TARGET ROOT::Flags APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
            "$<$<COMPILE_LANGUAGE:CXX>:${ROOT_CXX_FLAG_LIST}>")
        endif()

        if(CMAKE_C_COMPILER_LOADED)
          set_property(TARGET ROOT::Flags APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
            "$<$<COMPILE_LANGUAGE:C>:${ROOT_C_FLAG_LIST}>")
        endif()
        
        if(CMAKE_Fortran_COMPILER_LOADED)
          set_property(TARGET ROOT::Flags APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
            "$<$<COMPILE_LANGUAGE:Fortran>:${ROOT_fortran_FLAG_LIST}>")
        endif()
    endif()


    if(ROOT_VERSION VERSION_LESS 6.14)
        set_property(TARGET ROOT::Core PROPERTY
            INTERFACE_INCLUDE_DIRECTORIES ${ROOT_INCLUDE_DIRS})
        include_directories(DUMMY_FOR_ROOT_GEN_BUG)
    endif()
endmacro()
