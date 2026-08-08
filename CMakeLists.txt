cmake_minimum_required(VERSION 3.20)

project(
    music_manager
    VERSION 0.1.0
    LANGUAGES CXX
)

option(BUILD_TESTS "build unit tests" ON)
option(BUILD_BIN "build CLI executable" ON)
option(MLM_WITH_TAGLIB "enable TagLib metadata support" OFF)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include(cmake/CompilerWarnings.cmake)
include(cmake/dependencies.cmake)

add_subdirectory(src)

if(BUILD_BIN)
    add_subdirectory(bin)
endif()

if(BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()
