cmake_minimum_required(VERSION 3.16)

project(luminosus-minimal LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Enable automatic MOC, and RCC processing
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

# --- Qt Components ---
set(QT_REQUIRED_COMPONENTS Core Quick Svg Network Concurrent)

option(LUMINOSUS_MULTIMEDIA_AVAILABLE "Enable Multimedia support" OFF) # Corresponds to 'multimedia_available' CONFIG

if(LUMINOSUS_MULTIMEDIA_AVAILABLE)
    list(APPEND QT_REQUIRED_COMPONENTS Multimedia)
endif()

set(Qt6_DIR /Users/tim/Qt/6.9.1/macos/lib/cmake/Qt6)

find_package(Qt6 REQUIRED COMPONENTS ${QT_REQUIRED_COMPONENTS})

# --- Source Files ---
set(PROJECT_HEADERS
)

set(PROJECT_SOURCES
    main.cpp
)

# --- Resource Files ---
set(PROJECT_RESOURCES
    qml.qrc
    fonts.qrc
    images.qrc
)

# --- Include Subprojects ---
# They append their own source files to the PROJECT_SOURCES variable.
include(${CMAKE_CURRENT_SOURCE_DIR}/core/dependencies.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/universal-blocks/dependencies.cmake)

# --- Executable Definition ---
qt_add_executable(luminosus-minimal
    ${PROJECT_HEADERS}
    ${PROJECT_SOURCES}
    ${PROJECT_RESOURCES}
)

# --- Include Directories ---
target_include_directories(luminosus-minimal PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

# --- Link Libraries ---
target_link_libraries(luminosus-minimal PRIVATE
    Qt6::Core
    Qt6::Quick
    Qt6::Svg
    Qt6::Network
    Qt6::Concurrent
)

if(LUMINOSUS_MULTIMEDIA_AVAILABLE)
    target_link_libraries(luminosus-minimal PRIVATE Qt6::Multimedia)
endif()

if(ANDROID)
    target_link_libraries(luminosus-minimal PRIVATE Qt6::CorePrivate)
endif()

# --- Compile Definitions ---
target_compile_definitions(luminosus-minimal PRIVATE THREADS_ENABLED)

if(NOT CMAKE_SYSTEM_NAME STREQUAL "Emscripten") # !emscripten
    target_compile_definitions(luminosus-minimal PRIVATE SSL_ENABLED)
endif()

if(LUMINOSUS_MULTIMEDIA_AVAILABLE)
    target_compile_definitions(luminosus-minimal PRIVATE MULTIMEDIA_AVAILABLE)
endif()
