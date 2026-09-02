# Core domain model. Public headers expose boost::filesystem::path.
add_library(${PROJECT_NAME}_core STATIC
    core/track.h
    core/track.cpp
    core/library.h
    core/playlist.h
    core/playlist.cpp
    core/media_bundle.h
)
target_include_directories(${PROJECT_NAME}_core
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}
        ${CMAKE_CURRENT_SOURCE_DIR}/core
)
target_link_libraries(${PROJECT_NAME}_core
    PUBLIC
        Boost::filesystem
)
mlm_enable_warnings(${PROJECT_NAME}_core)

# Application services operating on the core domain model.
add_library(${PROJECT_NAME}_service STATIC
    service/library_manager.h
    service/library_manager.cpp
    service/playlist_manager.h
    service/playlist_manager.cpp
)
target_include_directories(${PROJECT_NAME}_service
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}
)
target_link_libraries(${PROJECT_NAME}_service
    PUBLIC
        ${PROJECT_NAME}_core
)
mlm_enable_warnings(${PROJECT_NAME}_service)

# Search subsystem. Depends on the track and library model from core.
add_library(${PROJECT_NAME}_search STATIC
    search/search_engine.h
    search/search_engine.cpp
    search/inverted_index.h
    search/inverted_index.cpp
)
target_include_directories(${PROJECT_NAME}_search
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}
)
target_link_libraries(${PROJECT_NAME}_search
    PUBLIC
        ${PROJECT_NAME}_core
)
mlm_enable_warnings(${PROJECT_NAME}_search)

# Storage exporters. Depend on core and Boost.PropertyTree for JSON support.
add_library(${PROJECT_NAME}_storage STATIC
    storage/json_exporter.h
    storage/json_exporter.cpp
    storage/m3u_exporter.h
    storage/m3u_exporter.cpp
)
target_include_directories(${PROJECT_NAME}_storage
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}
)
target_link_libraries(${PROJECT_NAME}_storage
    PUBLIC
        ${PROJECT_NAME}_core
        Boost::property_tree
)
mlm_enable_warnings(${PROJECT_NAME}_storage)

# Statistics subsystem. Depends on the core library data.
add_library(${PROJECT_NAME}_stats STATIC
    stats/stats_collector.h
    stats/stats_collector.cpp
)
target_include_directories(${PROJECT_NAME}_stats
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}
)
target_link_libraries(${PROJECT_NAME}_stats
    PUBLIC
        ${PROJECT_NAME}_core
)
mlm_enable_warnings(${PROJECT_NAME}_stats)

# Command-line layer. Combines application services and feature subsystems.
add_library(${PROJECT_NAME}_cli STATIC
    cli/command_handler.h
    cli/command_handler.cpp
    cli/command_tokenizer.h
    cli/command_tokenizer.cpp
)
target_include_directories(${PROJECT_NAME}_cli
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}
)
target_link_libraries(${PROJECT_NAME}_cli
    PUBLIC
        ${PROJECT_NAME}_service
        ${PROJECT_NAME}_search
        ${PROJECT_NAME}_storage
        ${PROJECT_NAME}_stats
        Boost::tokenizer
)
mlm_enable_warnings(${PROJECT_NAME}_cli)

# Public umbrella target for executables and tests.
# It exposes all project modules and their transitive dependencies.
add_library(${PROJECT_NAME}_lib INTERFACE)
target_link_libraries(${PROJECT_NAME}_lib
    INTERFACE
        ${PROJECT_NAME}_core
        ${PROJECT_NAME}_service
        ${PROJECT_NAME}_search
        ${PROJECT_NAME}_storage
        ${PROJECT_NAME}_stats
        ${PROJECT_NAME}_cli
)

if(MLM_WITH_TAGLIB)
    target_compile_definitions(${PROJECT_NAME}_storage
        PUBLIC
            HAS_TAGLIB
    )
    target_link_libraries(${PROJECT_NAME}_storage
        PUBLIC
            TagLib::TagLib
    )
endif()
