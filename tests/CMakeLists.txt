cmake_minimum_required(VERSION 3.5)


project(FFAudioPlayer_Test LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_FLAGS "-Wall -Wextra -Wpedantic -Werror=switch -Werror=return-type -Wno-trigraphs ${CMAKE_CXX_FLAGS}")


set(CMAKE_FIND_FRAMEWORK ON)
set(FRAMEWORK_NAME FFAudioPlayer)
set(FRAMEWORK_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../${FRAMEWORK_NAME}.xcframework/macos-arm64_x86_64/${FRAMEWORK_NAME}.framework)

set(BUILD_RPATH ${FRAMEWORK_NAME}.xcframework/macos-arm64_x86_64)
add_definitions(-DBUILD_RPATH=\"${BUILD_RPATH}\")
set(CMAKE_BUILD_RPATH  @executable_path/${BUILD_RPATH})
set(CMAKE_MACOSX_RPATH 1)

add_executable(${PROJECT_NAME}
    main.cpp
)

include_directories(${FRAMEWORK_DIR}/Headers)
target_include_directories(${PROJECT_NAME} PRIVATE ${FRAMEWORK_PATH}/Headers)

target_link_libraries(${PROJECT_NAME}  PRIVATE
    "-framework Foundation"
    "-F${FRAMEWORK_PATH}/.."
    "-framework ${FRAMEWORK_NAME}"
)


message("************************************")
message("** FRAMEWORK:         ${FRAMEWORK_NAME}")
message("** FRAMEWORK_PATH:    ${FRAMEWORK_PATH}")
message("** CMAKE_FRAMEWORK_PATH:     ${CMAKE_FRAMEWORK_PATH}")
message("************************************")

