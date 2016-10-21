if(NOT DEFINED CGET_REQUESTED_VERSION)
  set(CGET_REQUESTED_VERSION OpenSSL_1_0_2h)
endif()

if(NOT MSVC)
    CGET_GET_PACKAGE(OpenSSL GITHUB openssl/openssl VERSION "${CGET_REQUESTED_VERSION}")

    # autoconf does _not_ like spaces in prefix
    SET(TEMP_DIR "/tmp/cget/install_root")
    CGET_EXECUTE_PROCESS(COMMAND ${CMAKE_COMMAND} -E remove_directory "${TEMP_DIR}")
    FILE(MAKE_DIRECTORY ${TEMP_DIR})

    if(NOT ${CMAKE_CROSSCOMPILING})
        CGET_EXECUTE_PROCESS(COMMAND ./config shared --prefix=${TEMP_DIR} WORKING_DIRECTORY "${CGET_OpenSSL_REPO_DIR}")
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
        CGET_EXECUTE_PROCESS(COMMAND ./Configure  shared ${OS_COMPILER} --prefix=${TEMP_DIR}
            WORKING_DIRECTORY repo
            )  
    endif()

    CGET_EXECUTE_PROCESS(COMMAND make WORKING_DIRECTORY ${CGET_OpenSSL_REPO_DIR})
    CGET_EXECUTE_PROCESS(COMMAND make install WORKING_DIRECTORY ${CGET_OpenSSL_REPO_DIR})
    CGET_EXECUTE_PROCESS(COMMAND ${CMAKE_COMMAND} -E copy_directory "${TEMP_DIR}" "${CGET_INSTALL_DIR}")
else()
    CGET_NUGET_BUILD(openssl 1.0.2.0)
endif()
install(CODE "")

set(ARGS_NO_FIND_PACKAGE OFF)
