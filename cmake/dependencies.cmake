# Все зависимости приходят из git через FetchContent.
#
# Boost подключается покомпонентно: каждый модуль фетчится из своего
# репозитория boostorg/<module>, без монолитного суперпроекта Boost.
# Хедеры всех модулей лежат в <repo>/include/boost/..., поэтому из
# скачанных модулей собирается единое системное дерево include.

include(FetchContent)
set(FETCHCONTENT_QUIET OFF)

# FetchContent_Populate() deprecated в CMake >= 3.30; отключаем предупреждение.
if(POLICY CMP0169)
    cmake_policy(SET CMP0169 OLD)
endif()

set(MLM_BOOST_TAG boost-1.86.0)

# Модули, используемые проектом, и их транзитивное замыкание.
# Список соответствует выходу `boostdep --cmake <lib>`.
set(MLM_BOOST_MODULES
    tokenizer
    property_tree
    system
    filesystem

    config
    assert
    throw_exception
    core
    static_assert
    type_traits
    preprocessor
    predef
    detail
    io
    utility
    iterator
    mpl
    smart_ptr
    container_hash
    integer
    tuple
    move
    function
    bind
    optional
    any
    variant2
    mp11
    range
    multi_index
    lexical_cast
    type_index
    variant
    winapi
    scope
    atomic
    array
    concept_check
    fusion
    function_types
)

foreach(module IN LISTS MLM_BOOST_MODULES)
    FetchContent_Declare(
        boost_${module}
        GIT_REPOSITORY https://github.com/boostorg/${module}.git
        GIT_TAG ${MLM_BOOST_TAG}
        GIT_SHALLOW TRUE
    )
endforeach()

set(MLM_BOOST_INCLUDE_DIRS "")
foreach(module IN LISTS MLM_BOOST_MODULES)
    FetchContent_GetProperties(boost_${module})
    if(NOT boost_${module}_POPULATED)
        FetchContent_Populate(boost_${module})
    endif()
    list(APPEND MLM_BOOST_INCLUDE_DIRS "${boost_${module}_SOURCE_DIR}/include")
endforeach()

# Единое дерево boost-хедеров для всех модулей проекта.
add_library(boost_headers INTERFACE)
target_include_directories(boost_headers SYSTEM INTERFACE ${MLM_BOOST_INCLUDE_DIRS})

# --- Header-only компоненты Boost ---
add_library(boost_tokenizer INTERFACE)
add_library(Boost::tokenizer ALIAS boost_tokenizer)
target_link_libraries(boost_tokenizer INTERFACE boost_headers)

add_library(boost_property_tree INTERFACE)
add_library(Boost::property_tree ALIAS boost_property_tree)
target_link_libraries(boost_property_tree INTERFACE boost_headers)

add_library(boost_system INTERFACE)
add_library(Boost::system ALIAS boost_system)
target_link_libraries(boost_system INTERFACE boost_headers)

# --- Boost.Filesystem: единственный компилируемый компонент ---
add_library(boost_filesystem STATIC
    ${boost_filesystem_SOURCE_DIR}/src/codecvt_error_category.cpp
    ${boost_filesystem_SOURCE_DIR}/src/exception.cpp
    ${boost_filesystem_SOURCE_DIR}/src/operations.cpp
    ${boost_filesystem_SOURCE_DIR}/src/directory.cpp
    ${boost_filesystem_SOURCE_DIR}/src/path.cpp
    ${boost_filesystem_SOURCE_DIR}/src/path_traits.cpp
    ${boost_filesystem_SOURCE_DIR}/src/portability.cpp
    ${boost_filesystem_SOURCE_DIR}/src/unique_path.cpp
    ${boost_filesystem_SOURCE_DIR}/src/utf8_codecvt_facet.cpp
)
add_library(Boost::filesystem ALIAS boost_filesystem)

target_include_directories(boost_filesystem SYSTEM PUBLIC ${MLM_BOOST_INCLUDE_DIRS})
target_include_directories(boost_filesystem PRIVATE ${boost_filesystem_SOURCE_DIR}/src)
target_link_libraries(boost_filesystem PUBLIC boost_headers Boost::system)
target_compile_features(boost_filesystem PUBLIC cxx_std_17)

target_compile_definitions(boost_filesystem PRIVATE
    BOOST_FILESYSTEM_SOURCE
    BOOST_FILESYSTEM_NO_DEPRECATED
)

if(WIN32)
    target_sources(boost_filesystem PRIVATE
        ${boost_filesystem_SOURCE_DIR}/src/windows_file_codecvt.cpp
    )
    target_compile_definitions(boost_filesystem PRIVATE
        BOOST_FILESYSTEM_HAS_BCRYPT
        BOOST_USE_WINDOWS_H
        WIN32_LEAN_AND_MEAN
        NOMINMAX
        _SCL_SECURE_NO_WARNINGS
        _CRT_SECURE_NO_WARNINGS
    )
    target_link_libraries(boost_filesystem PRIVATE bcrypt)
endif()

# --- GoogleTest (для тестов) ---
if(BUILD_TESTS)
    FetchContent_Declare(
        googletest
        GIT_REPOSITORY https://github.com/google/googletest.git
        GIT_TAG v1.14.0
        GIT_SHALLOW TRUE
    )
    set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
    FetchContent_MakeAvailable(googletest)
endif()

# --- TagLib (опционально) ---
if(MLM_WITH_TAGLIB)
    FetchContent_Declare(
        taglib
        GIT_REPOSITORY https://github.com/taglib/taglib.git
        GIT_TAG v2.0.2
        GIT_SHALLOW TRUE
    )
    set(BUILD_SHARED_LIBS OFF CACHE BOOL "" FORCE)
    set(BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
    set(BUILD_BINDINGS OFF CACHE BOOL "" FORCE)
    FetchContent_MakeAvailable(taglib)
    add_library(TagLib::TagLib ALIAS Tag)
endif()
