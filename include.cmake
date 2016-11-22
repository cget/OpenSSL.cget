if(NOT DEFINED CGET_REQUESTED_VERSION)
  set(CGET_REQUESTED_VERSION OpenSSL_1_0_2h)
endif()

CGET_FILE_CONTENTS("${BUILD_DIR}/.built" BUILD_CACHE_VAL)
if(NOT BUILD_CACHE_VAL STREQUAL Build_Hash)  
  if(NOT MSVC)
    CGET_GET_PACKAGE(OpenSSL GITHUB openssl/openssl VERSION "${CGET_REQUESTED_VERSION}")

    # autoconf does _not_ like spaces in prefix, or in pwd    
    SET(TEMP_DIR "/tmp/cget/install_root")
    SET(TEMP_SRC_DIR "/tmp/cget/OpenSSL")

    CGET_EXECUTE_PROCESS(COMMAND ${CMAKE_COMMAND} -E remove_directory "${TEMP_DIR}")

    if(EXISTS "${TEMP_SRC_DIR}")
      CGET_EXECUTE_PROCESS(COMMAND ${CMAKE_COMMAND} -E remove_directory "${TEMP_SRC_DIR}")    
    endif()
    
    FILE(MAKE_DIRECTORY ${TEMP_DIR})
    
    CGET_EXECUTE_PROCESS(COMMAND cp -R "${CGET_OpenSSL_REPO_DIR}" "${TEMP_SRC_DIR}")

    CGET_MESSAGE(3 "Configuring for ${CMAKE_SYSTEM_PROCESSOR}")
    if(APPLE)
      SET(OS_COMPILER "darwin64-x86_64-cc")
    elseif("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "x86_64")
      SET(OS_COMPILER "linux-x86_64")
    elseif("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "arm")
      SET(OS_COMPILER "linux-armv4")
    else()
      message(FATAL_ERROR "CMAKE_SYSTEM_PROCESSOR '${CMAKE_SYSTEM_PROCESSOR}' doesn't have an os/compiler mapping to OpenSSL.")
    endif()

    CGET_MESSAGE("Running ./Configure ${OS_COMPILER} --prefix=${CMAKE_INSTALL_PREFIX}")
    CGET_EXECUTE_PROCESS(COMMAND ./Configure shared ${OS_COMPILER} --prefix=${TEMP_DIR}
      WORKING_DIRECTORY "${TEMP_SRC_DIR}"
      )  

    CGET_EXECUTE_PROCESS(COMMAND make WORKING_DIRECTORY "${TEMP_SRC_DIR}")
    CGET_EXECUTE_PROCESS(COMMAND make install_sw WORKING_DIRECTORY "${TEMP_SRC_DIR}")
    CGET_EXECUTE_PROCESS(COMMAND ${CMAKE_COMMAND} -E copy_directory "${TEMP_DIR}" "${CGET_INSTALL_DIR}")
  else()
    CGET_NUGET_BUILD(openssl 1.0.2.0)
  endif()
  file(WRITE "${BUILD_DIR}/.built" "${Build_Hash}")          
endif()

install(CODE "")

set(ARGS_NO_FIND_PACKAGE OFF)
