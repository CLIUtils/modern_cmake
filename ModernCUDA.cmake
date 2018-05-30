
set(CMAKE_MODULE_PATH  "${CMAKE_CURRENT_LIST_DIR}/cuda_support" ${CMAKE_MODULE_PATH})

if(CMAKE_VERSION VERSION_LESS 3.12)
  if(CMAKE_CUDA_COMPILER_ID)
    set(CMAKE_CUDA_COMPILER_LOADED ON)
  endif()
endif()

include("${CMAKE_CURRENT_LIST_DIR}/cuda_support/CUDA/protect_flags.cmake")
