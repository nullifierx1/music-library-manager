add_executable(tests
    track_ut.cpp
    library_ut.cpp
    playlist_ut.cpp
    search_ut.cpp
    integration_ut.cpp
)

target_link_libraries(tests
    PRIVATE
        gtest_main
        ${PROJECT_NAME}_lib
)

mlm_enable_warnings(tests)

include(GoogleTest)
gtest_discover_tests(tests)
