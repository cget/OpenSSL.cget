cmake_minimum_required (VERSION 3.0) 
project (OpenSSL.cget C CXX)

find_package(Git)

if(NOT EXISTS ${CMAKE_CURRENT_LIST_DIR}/repo)
  execute_process(COMMAND
    ${GIT_EXECUTABLE} clone https://github.com/OpenSSL/OpenSSL ${CMAKE_CURRENT_LIST_DIR}/repo --depth=1 --branch=OpenSSL_1_0_1p)
endif()

if(NOT ${CMAKE_CROSSCOMPILING})
  execute_process(COMMAND ./config shared --prefix=${CMAKE_INSTALL_PREFIX}
    WORKING_DIRECTORY repo
    )
else()
  message("Configuring for ${CMAKE_SYSTEM_PROCESSOR}")
  if("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "x86_64")
    SET(OS_COMPILER "linux-x86_64")
  elseif("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "arm")
    SET(OS_COMPILER "linux-armv4")
  else()
    message(FATAL_ERROR "CMAKE_SYSTEM_PROCESSOR '${CMAKE_SYSTEM_PROCESSOR}' doesn't have an os/compiler mapping to OpenSSL.")
  endif()

  message("Running ./Configure ${OS_COMPILER} --prefix=${CMAKE_INSTALL_PREFIX}")
  execute_process(COMMAND ./Configure  shared ${OS_COMPILER} --prefix=${CMAKE_INSTALL_PREFIX}
    WORKING_DIRECTORY repo
    )  
endif()

execute_process(COMMAND make
  WORKING_DIRECTORY repo
)

install(CODE "execute_process(COMMAND make install WORKING_DIRECTORY repo)")

