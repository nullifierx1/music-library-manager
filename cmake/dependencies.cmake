include(FetchContent)
set(FETCHCONTENT_QUIET OFF)

# FetchContent_Populate() is deprecated in CMake >= 3.30.
if(POLICY CMP0169)
    cmake_policy(SET CMP0169 OLD)
endif()

# Prefer system Boost, fall back to fetching from git.
find_package(Boost QUIET COMPONENTS filesystem system)

if(Boost_FOUND)
    add_library(boost_headers INTERFACE)
    target_link_libraries(boost_headers INTERFACE Boost::headers)

    add_library(boost_tokenizer INTERFACE)
    add_library(Boost::tokenizer ALIAS boost_tokenizer)
    target_link_libraries(boost_tokenizer INTERFACE Boost::headers)

    add_library(boost_property_tree INTERFACE)
    add_library(Boost::property_tree ALIAS boost_property_tree)
    target_link_libraries(boost_property_tree INTERFACE Boost::headers)
else()
    set(MLM_BOOST_TAG boost-1.83.0)

    # Modules used by the project and their transitive closure.
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

    # Single boost include tree shared by all modules.
    add_library(boost_headers INTERFACE)
    target_include_directories(boost_headers SYSTEM INTERFACE ${MLM_BOOST_INCLUDE_DIRS})

    # Header-only boost components.
    add_library(boost_tokenizer INTERFACE)
    add_library(Boost::tokenizer ALIAS boost_tokenizer)
    target_link_libraries(boost_tokenizer INTERFACE boost_headers)

    add_library(boost_property_tree INTERFACE)
    add_library(Boost::property_tree ALIAS boost_property_tree)
    target_link_libraries(boost_property_tree INTERFACE boost_headers)

    add_library(boost_system INTERFACE)
    add_library(Boost::system ALIAS boost_system)
    target_link_libraries(boost_system INTERFACE boost_headers)

    # Boost.Filesystem: the only compiled component.
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
endif()

# GoogleTest (for tests).
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

# TagLib (optional).
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
