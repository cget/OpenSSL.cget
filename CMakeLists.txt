cmake_minimum_required (VERSION 3.0) 
project (OpenSSL.cget C CXX)

find_package(Git)

if(NOT EXISTS ${CMAKE_CURRENT_LIST_DIR}/repo)
  execute_process(COMMAND
    ${GIT_EXECUTABLE} clone https://github.com/OpenSSL/OpenSSL ${CMAKE_CURRENT_LIST_DIR}/repo --depth=1)
endif()

execute_process(COMMAND ./Configure ${CMAKE_HOST_SYSTEM} --prefix=${CGET_INSTALL_DIR}
  WORKING_DIRECTORY repo
)

execute_process(COMMAND make ${CMAKE_HOST_SYSTEM} --prefix=${CGET_INSTALL_DIR}
  WORKING_DIRECTORY repo
)

add_custom_target(install
  COMMAND make install
  WORKING_DIRECTORY repo
)

install(FILES ${CMAKE_CURRENT_LIST_DIR}/repo/include/* DESTINATION include)

