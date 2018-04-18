# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#[=======================================================================[.rst:

CUDAUtilities
-------------

.. only:: html

   .. contents::

CUDA Utilities
^^^^^^^^^^^^^^

This module provides a set of utilities to assist users with CUDA as a language.


It adds:


.. command:: cmake_cuda_arch_select

  Selects GPU arch flags for nvcc based on ``target_CUDA_architectures``. Safe to call multiple times, will cache auto detection results::

  cmake_cuda_arch_select([TARGETS target ...] [FLAGS name] [READABLE name] [ARCH arch1 ...])

  ``ARCH: Auto | Common | All | LIST(ARCH_AND_PTX ...)``
      - "Auto" detects local machine GPU compute arch at runtime (cached on first call)
      - "Common" and "All" cover common and entire subsets of architectures
      - ``ARCH_AND_PTX`` : NAME | NUM.NUM | NUM.NUM(NUM.NUM) | NUM.NUM+PTX
        - NAME: Fermi Kepler Maxwell Kepler+Tegra Kepler+Tesla Maxwell+Tegra Pascal
        - NUM: Any number. Only those pairs are currently accepted by NVCC though: 2.0 2.1 3.0 3.2 3.5 3.7 5.0 5.2 5.3 6.0 6.2
      - "None" does not add a flag

        Returns ``LIST`` of flags to be added to CUDA targets in ``${out_variable}``.

  ``TARGET <target_name>``
    Add the flags, protected for CUDA, to the target.
    ``PUBLIC``, ``PRIVATE``, and ``INTERFACE`` keywords are allowed; otherwise this will
    default to ``PUBLIC`` or ``INTERFACE`` depending on what the target supports.

  ``FLAGS <variable_name>``
    Output a list of flags for the selected archetecture(s).

  ``READABLE <variable_name>``
    Output a human readable list for the selected archetecture(s).

   More info on CUDA architectures: https://en.wikipedia.org/wiki/CUDA

   Example:

   .. code: cmake

      add_library(CUDA::Arch IMPORTED INTERFACE)
      cmake_cuda_arch_select(TARGET CUDA::Arch ARCH Auto)
      target_link_libraries(... PRIVATE CUDA::Arch)



#]=======================================================================]

include("${CMAKE_CURRENT_LIST_DIR}/CUDA/select_compute_arch.cmake")
