#!/bin/bash

# C++ Project Setup Script
# Usage: ./setup-cpp-project.sh [project-name] [project-type]
# Project types: simple, cmake, competitive, library

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_color() {
    printf "${1}${2}${NC}\n"
}

print_header() {
    echo
    print_color $CYAN "🚀 C++ Project Setup Script"
    print_color $CYAN "=============================="
    echo
}

print_success() {
    print_color $GREEN "✅ $1"
}

print_info() {
    print_color $BLUE "ℹ️  $1"
}

print_warning() {
    print_color $YELLOW "⚠️  $1"
}

print_error() {
    print_color $RED "❌ $1"
}

# Function to get project name
get_project_name() {
    if [ -z "$1" ]; then
        read -p "Enter project name: " PROJECT_NAME
        if [ -z "$PROJECT_NAME" ]; then
            print_error "Project name cannot be empty!"
            exit 1
        fi
    else
        PROJECT_NAME="$1"
    fi
    
    # Sanitize project name
    PROJECT_NAME=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_-]//g')
    
    if [ -z "$PROJECT_NAME" ]; then
        print_error "Invalid project name!"
        exit 1
    fi
}

# Function to get project type
get_project_type() {
    if [ -z "$1" ]; then
        echo
        print_info "Available project types:"
    echo "  1) simple      - Basic C++ project with main.cpp"
    echo "  2) cmake       - CMake-based project structure"
    echo "  3) competitive - Competitive programming setup"
    echo "  4) library     - Library project with headers"
    echo "  5) opengl      - OpenGL project with GLFW and GLEW (system libs)"
    echo "  6) opengl-local - OpenGL project with downloaded GLFW and GLEW"
        echo
        read -p "Choose project type (1-6) or enter name: " choice
        
        case $choice in
            1|simple) PROJECT_TYPE="simple" ;;
            2|cmake) PROJECT_TYPE="cmake" ;;
            3|competitive) PROJECT_TYPE="competitive" ;;
            4|library) PROJECT_TYPE="library" ;;
            5|opengl) PROJECT_TYPE="opengl" ;;
            6|opengl-local) PROJECT_TYPE="opengl-local" ;;
            *) PROJECT_TYPE="$choice" ;;
        esac
    else
        PROJECT_TYPE="$1"
    fi
}

# Function to create directory structure
create_directories() {
    print_info "Creating project directory: $PROJECT_NAME"
    
    if [ -d "$PROJECT_NAME" ]; then
        print_warning "Directory $PROJECT_NAME already exists!"
        read -p "Continue anyway? (y/N): " confirm
        if [[ ! $confirm =~ ^[Yy]$ ]]; then
            print_info "Aborted."
            exit 0
        fi
    fi
    
    mkdir -p "$PROJECT_NAME"
    cd "$PROJECT_NAME"
    
    case $PROJECT_TYPE in
        "cmake"|"library")
            mkdir -p src include tests build docs
            ;;
        "competitive")
            mkdir -p problems solutions templates
            ;;
        *)
            mkdir -p src
            ;;
    esac
    
    if [[ "$PROJECT_TYPE" == "opengl" || "$PROJECT_TYPE" == "opengl-local" ]]; then
        mkdir -p src include shaders assets build
        if [ "$PROJECT_TYPE" == "opengl-local" ]; then
            mkdir -p libs external
        fi
    fi
    
    print_success "Directory structure created"
}

# Function to create main source file
create_main_file() {
    case $PROJECT_TYPE in
        "simple")
            cat > src/main.cpp << 'EOF'
#include <iostream>

int main() {
    std::cout << "Hello, World!" << std::endl;
    return 0;
}
EOF
            ;;
        "cmake"|"library")
            cat > src/main.cpp << 'EOF'
#include <iostream>
#include "../include/project.h"

int main() {
    std::cout << "Hello from " << PROJECT_NAME << "!" << std::endl;
    return 0;
}
EOF
            ;;
        "competitive")
            cat > templates/template.cpp << 'EOF'
#include <iostream>
#include <vector>
#include <string>
#include <algorithm>
#include <map>
#include <set>
#include <queue>
#include <stack>
#include <cmath>
#include <climits>

using namespace std;

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);
    
    // Your code here
    
    return 0;
}
EOF
            
            cat > src/main.cpp << 'EOF'
#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);
    
    cout << "Competitive Programming Setup Ready!" << endl;
    
    return 0;
}
EOF
            ;;
        "opengl"|"opengl-local")
            cat > src/main.cpp << 'EOF'
#include <GL/glew.h>
#include <GLFW/glfw3.h>
#include <iostream>
#include <fstream>
#include <sstream>
#include <string>

// Window dimensions
const GLuint WIDTH = 800, HEIGHT = 600;

// Function prototypes
void key_callback(GLFWwindow* window, int key, int scancode, int action, int mode);
std::string loadShader(const std::string& filepath);
GLuint compileShader(const std::string& source, GLenum shaderType);
GLuint createShaderProgram(const std::string& vertexPath, const std::string& fragmentPath);

int main() {
    std::cout << "Starting OpenGL Application..." << std::endl;

    // Initialize GLFW
    if (!glfwInit()) {
        std::cerr << "Failed to initialize GLFW" << std::endl;
        return -1;
    }

    // Configure GLFW
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
    glfwWindowHint(GLFW_RESIZABLE, GL_FALSE);

    // Create window
    GLFWwindow* window = glfwCreateWindow(WIDTH, HEIGHT, "OpenGL Window", nullptr, nullptr);
    if (!window) {
        std::cerr << "Failed to create GLFW window" << std::endl;
        glfwTerminate();
        return -1;
    }

    glfwMakeContextCurrent(window);
    glfwSetKeyCallback(window, key_callback);

    // Initialize GLEW
    glewExperimental = GL_TRUE;
    if (glewInit() != GLEW_OK) {
        std::cerr << "Failed to initialize GLEW" << std::endl;
        return -1;
    }

    // Define viewport dimensions
    glViewport(0, 0, WIDTH, HEIGHT);

    // OpenGL settings
    glEnable(GL_DEPTH_TEST);

    // Triangle vertices
    GLfloat vertices[] = {
        -0.5f, -0.5f, 0.0f,  // Left
         0.5f, -0.5f, 0.0f,  // Right
         0.0f,  0.5f, 0.0f   // Top
    };

    // Generate buffers
    GLuint VBO, VAO;
    glGenVertexArrays(1, &VAO);
    glGenBuffers(1, &VBO);

    // Bind VAO
    glBindVertexArray(VAO);

    // Bind and set vertex buffer
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

    // Configure vertex attributes
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GLfloat), (GLvoid*)0);
    glEnableVertexAttribArray(0);

    // Unbind VAO
    glBindVertexArray(0);

    // Create shader program
    GLuint shaderProgram = createShaderProgram("shaders/vertex.glsl", "shaders/fragment.glsl");

    std::cout << "OpenGL Version: " << glGetString(GL_VERSION) << std::endl;
    std::cout << "GLSL Version: " << glGetString(GL_SHADING_LANGUAGE_VERSION) << std::endl;

    // Render loop
    while (!glfwWindowShouldClose(window)) {
        // Check events
        glfwPollEvents();

        // Clear screen
        glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        // Use shader program
        glUseProgram(shaderProgram);

        // Draw triangle
        glBindVertexArray(VAO);
        glDrawArrays(GL_TRIANGLES, 0, 3);
        glBindVertexArray(0);

        // Swap buffers
        glfwSwapBuffers(window);
    }

    // Clean up
    glDeleteVertexArrays(1, &VAO);
    glDeleteBuffers(1, &VBO);
    glDeleteProgram(shaderProgram);

    glfwTerminate();
    return 0;
}

void key_callback(GLFWwindow* window, int key, int scancode, int action, int mode) {
    if (key == GLFW_KEY_ESCAPE && action == GLFW_PRESS) {
        glfwSetWindowShouldClose(window, GL_TRUE);
    }
}

std::string loadShader(const std::string& filepath) {
    std::ifstream file(filepath);
    if (!file.is_open()) {
        std::cerr << "Failed to open shader file: " << filepath << std::endl;
        return "";
    }
    
    std::stringstream buffer;
    buffer << file.rdbuf();
    return buffer.str();
}

GLuint compileShader(const std::string& source, GLenum shaderType) {
    GLuint shader = glCreateShader(shaderType);
    const char* src = source.c_str();
    glShaderSource(shader, 1, &src, nullptr);
    glCompileShader(shader);

    // Check compilation errors
    GLint success;
    GLchar infoLog[512];
    glGetShaderiv(shader, GL_COMPILE_STATUS, &success);
    if (!success) {
        glGetShaderInfoLog(shader, 512, nullptr, infoLog);
        std::cerr << "Shader compilation failed: " << infoLog << std::endl;
    }

    return shader;
}

GLuint createShaderProgram(const std::string& vertexPath, const std::string& fragmentPath) {
    std::string vertexSource = loadShader(vertexPath);
    std::string fragmentSource = loadShader(fragmentPath);

    if (vertexSource.empty() || fragmentSource.empty()) {
        std::cerr << "Using default shaders due to file loading errors" << std::endl;
        
        // Default vertex shader
        vertexSource = R"(
#version 330 core
layout (location = 0) in vec3 aPos;

void main() {
    gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
}
)";
        
        // Default fragment shader
        fragmentSource = R"(
#version 330 core
out vec4 FragColor;

void main() {
    FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);
}
)";
    }

    GLuint vertexShader = compileShader(vertexSource, GL_VERTEX_SHADER);
    GLuint fragmentShader = compileShader(fragmentSource, GL_FRAGMENT_SHADER);

    // Create shader program
    GLuint shaderProgram = glCreateProgram();
    glAttachShader(shaderProgram, vertexShader);
    glAttachShader(shaderProgram, fragmentShader);
    glLinkProgram(shaderProgram);

    // Check linking errors
    GLint success;
    GLchar infoLog[512];
    glGetProgramiv(shaderProgram, GL_LINK_STATUS, &success);
    if (!success) {
        glGetProgramInfoLog(shaderProgram, 512, nullptr, infoLog);
        std::cerr << "Shader program linking failed: " << infoLog << std::endl;
    }

    // Clean up shaders
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);

    return shaderProgram;
}
EOF
            ;;
    esac
    
    print_success "Main source file created"
}

# Function to download and build libraries for opengl-local projects
download_libraries() {
    if [ "$PROJECT_TYPE" == "opengl-local" ]; then
        print_info "Downloading and building OpenGL libraries..."
        
        cd external
        
        # Download GLFW
        print_info "Downloading GLFW..."
        if ! wget -q https://github.com/glfw/glfw/releases/download/3.3.8/glfw-3.3.8.zip; then
            print_error "Failed to download GLFW"
            exit 1
        fi
        unzip -q glfw-3.3.8.zip
        mv glfw-3.3.8 glfw
        rm glfw-3.3.8.zip
        
        # Build GLFW
        print_info "Building GLFW..."
        cd glfw
        mkdir -p build
        cd build
        cmake -DCMAKE_INSTALL_PREFIX=../../../libs -DGLFW_BUILD_EXAMPLES=OFF -DGLFW_BUILD_TESTS=OFF -DGLFW_BUILD_DOCS=OFF ..
        make -j$(nproc)
        make install
        cd ../../
        
        # Download GLEW
        print_info "Downloading GLEW..."
        if ! wget -q https://github.com/nigels-com/glew/releases/download/glew-2.2.0/glew-2.2.0.tgz; then
            print_error "Failed to download GLEW"
            exit 1
        fi
        tar -xzf glew-2.2.0.tgz
        mv glew-2.2.0 glew
        rm glew-2.2.0.tgz
        
        # Build GLEW
        print_info "Building GLEW..."
        cd glew
        make -j$(nproc) GLEW_DEST=../../../libs install
        cd ../
        
        cd ..
        print_success "Libraries downloaded and built"
    fi
}

# Function to create shader files for OpenGL projects
create_shaders() {
    if [[ "$PROJECT_TYPE" == "opengl" || "$PROJECT_TYPE" == "opengl-local" ]]; then
        # Create vertex shader
        cat > shaders/vertex.glsl << 'EOF'
#version 330 core
layout (location = 0) in vec3 aPos;

void main() {
    gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
}
EOF

        # Create fragment shader
        cat > shaders/fragment.glsl << 'EOF'
#version 330 core
out vec4 FragColor;

void main() {
    FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);
}
EOF

        print_success "Shader files created"
    fi
}

# Function to create header files
create_headers() {
    if [[ "$PROJECT_TYPE" == "cmake" || "$PROJECT_TYPE" == "library" ]]; then
        cat > include/project.h << EOF
#ifndef PROJECT_H
#define PROJECT_H

#include <string>

class Project {
public:
    Project(const std::string& name);
    ~Project();
    
    void run();
    std::string getName() const;

private:
    std::string m_name;
};

#endif // PROJECT_H
EOF
        
        cat > src/project.cpp << EOF
#include "../include/project.h"
#include <iostream>

Project::Project(const std::string& name) : m_name(name) {
    std::cout << "Project " << m_name << " initialized." << std::endl;
}

Project::~Project() {
    std::cout << "Project " << m_name << " destroyed." << std::endl;
}

void Project::run() {
    std::cout << "Running project: " << m_name << std::endl;
}

std::string Project::getName() const {
    return m_name;
}
EOF
        
        print_success "Header and implementation files created"
    fi
}

# Function to create CMakeLists.txt
create_cmake() {
    if [[ "$PROJECT_TYPE" == "cmake" || "$PROJECT_TYPE" == "library" || "$PROJECT_TYPE" == "opengl" || "$PROJECT_TYPE" == "opengl-local" ]]; then
        if [ "$PROJECT_TYPE" == "opengl" ]; then
            cat > CMakeLists.txt << EOF
cmake_minimum_required(VERSION 3.16)
project($PROJECT_NAME)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Compiler flags
set(CMAKE_CXX_FLAGS "-Wall -Wextra -Wpedantic")
set(CMAKE_CXX_FLAGS_DEBUG "-g -O0 -DDEBUG")
set(CMAKE_CXX_FLAGS_RELEASE "-O3 -DNDEBUG")

# Find required packages
find_package(PkgConfig REQUIRED)
find_package(OpenGL REQUIRED)

# Find GLFW
pkg_check_modules(GLFW REQUIRED glfw3)

# Find GLEW
find_package(GLEW REQUIRED)

# Include directories
include_directories(include)
include_directories(\${OPENGL_INCLUDE_DIRS})
include_directories(\${GLFW_INCLUDE_DIRS})
include_directories(\${GLEW_INCLUDE_DIRS})

# Source files
file(GLOB_RECURSE SOURCES "src/*.cpp")

# Create executable
add_executable(\${PROJECT_NAME} \${SOURCES})

# Link libraries
target_link_libraries(\${PROJECT_NAME} 
    \${OPENGL_LIBRARIES}
    \${GLFW_LIBRARIES}
    \${GLEW_LIBRARIES}
    GL
    glfw
    GLEW
)

# Copy shaders to build directory
file(COPY shaders DESTINATION \${CMAKE_BINARY_DIR})
file(COPY assets DESTINATION \${CMAKE_BINARY_DIR})
EOF
        elif [ "$PROJECT_TYPE" == "opengl-local" ]; then
            cat > CMakeLists.txt << EOF
cmake_minimum_required(VERSION 3.16)
project($PROJECT_NAME)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Compiler flags
set(CMAKE_CXX_FLAGS "-Wall -Wextra -Wpedantic")
set(CMAKE_CXX_FLAGS_DEBUG "-g -O0 -DDEBUG")
set(CMAKE_CXX_FLAGS_RELEASE "-O3 -DNDEBUG")

# Find required packages
find_package(OpenGL REQUIRED)

# Set library paths for locally built libraries
set(GLFW_ROOT \${CMAKE_CURRENT_SOURCE_DIR}/libs)
set(GLEW_ROOT \${CMAKE_CURRENT_SOURCE_DIR}/libs)

# Include directories
include_directories(include)
include_directories(\${GLFW_ROOT}/include)
include_directories(\${GLEW_ROOT}/include)
include_directories(\${OPENGL_INCLUDE_DIRS})

# Library directories
link_directories(\${GLFW_ROOT}/lib)
link_directories(\${GLEW_ROOT}/lib)

# Source files
file(GLOB_RECURSE SOURCES "src/*.cpp")

# Create executable
add_executable(\${PROJECT_NAME} \${SOURCES})

# Link libraries
target_link_libraries(\${PROJECT_NAME} 
    \${OPENGL_LIBRARIES}
    glfw3
    GLEW
    GL
    X11
    pthread
    Xrandr
    Xi
    dl
)

# Copy shaders to build directory
file(COPY shaders DESTINATION \${CMAKE_BINARY_DIR})
file(COPY assets DESTINATION \${CMAKE_BINARY_DIR})
EOF
        else
            cat > CMakeLists.txt << EOF
cmake_minimum_required(VERSION 3.16)
project($PROJECT_NAME)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Compiler flags
set(CMAKE_CXX_FLAGS "-Wall -Wextra -Wpedantic")
set(CMAKE_CXX_FLAGS_DEBUG "-g -O0 -DDEBUG")
set(CMAKE_CXX_FLAGS_RELEASE "-O3 -DNDEBUG")

# Include directories
include_directories(include)

# Source files
file(GLOB_RECURSE SOURCES "src/*.cpp")

# Create executable
add_executable(\${PROJECT_NAME} \${SOURCES})

# Enable testing
enable_testing()

# Add subdirectories
add_subdirectory(tests)
EOF
        fi
        
        # Create tests CMakeLists.txt (only for cmake and library projects)
        if [[ "$PROJECT_TYPE" == "cmake" || "$PROJECT_TYPE" == "library" ]]; then
            cat > tests/CMakeLists.txt << EOF
# Test executable
add_executable(test_${PROJECT_NAME} test_main.cpp)
target_link_libraries(test_${PROJECT_NAME})

# Add test
add_test(NAME ${PROJECT_NAME}_test COMMAND test_${PROJECT_NAME})
EOF
        
            # Create basic test file
            cat > tests/test_main.cpp << 'EOF'
#include <iostream>
#include <cassert>

void test_basic() {
    assert(1 + 1 == 2);
    std::cout << "✅ Basic test passed" << std::endl;
}

int main() {
    std::cout << "Running tests..." << std::endl;
    
    test_basic();
    
    std::cout << "✅ All tests passed!" << std::endl;
    return 0;
}
EOF
        fi
        
        print_success "CMake configuration created"
    fi
}

# Function to create Makefile for simple projects
create_makefile() {
    if [ "$PROJECT_TYPE" == "opengl" ]; then
        cat > Makefile << EOF
# OpenGL Project Makefile
CXX = g++
CXXFLAGS = -std=c++17 -Wall -Wextra -Wpedantic
DEBUGFLAGS = -g -O0 -DDEBUG
RELEASEFLAGS = -O3 -DNDEBUG

# OpenGL Libraries
LIBS = -lGL -lGLEW -lglfw

# Directories
SRCDIR = src
BUILDDIR = build

# Source files
SOURCES = \$(wildcard \$(SRCDIR)/*.cpp)
OBJECTS = \$(SOURCES:\$(SRCDIR)/%.cpp=\$(BUILDDIR)/%.o)

# Target executable
TARGET = $PROJECT_NAME

# Default target
all: release

# Debug build
debug: CXXFLAGS += \$(DEBUGFLAGS)
debug: \$(TARGET)

# Release build
release: CXXFLAGS += \$(RELEASEFLAGS)
release: \$(TARGET)

# Build target
\$(TARGET): \$(OBJECTS) | \$(BUILDDIR)
	\$(CXX) \$(OBJECTS) -o \$(TARGET) \$(LIBS)

# Build object files
\$(BUILDDIR)/%.o: \$(SRCDIR)/%.cpp | \$(BUILDDIR)
	\$(CXX) \$(CXXFLAGS) -c \$< -o \$@

# Create build directory
\$(BUILDDIR):
	mkdir -p \$(BUILDDIR)

# Clean build files
clean:
	rm -rf \$(BUILDDIR) \$(TARGET)

# Run the program
run: \$(TARGET)
	./\$(TARGET)

# Install system dependencies (Ubuntu/Debian)
install-deps:
	sudo apt update
	sudo apt install -y libgl1-mesa-dev libglew-dev libglfw3-dev

# Install system dependencies (Arch Linux)
install-deps-arch:
	sudo pacman -S mesa glew glfw-x11

# Install system dependencies (Fedora)
install-deps-fedora:
	sudo dnf install mesa-libGL-devel glew-devel glfw-devel

.PHONY: all debug release clean run install-deps install-deps-arch install-deps-fedora
EOF
        
        print_success "OpenGL Makefile created with system library linking"
    elif [ "$PROJECT_TYPE" == "opengl-local" ]; then
        cat > Makefile << EOF
# OpenGL Project Makefile (Local Libraries)
CXX = g++
CXXFLAGS = -std=c++17 -Wall -Wextra -Wpedantic
DEBUGFLAGS = -g -O0 -DDEBUG
RELEASEFLAGS = -O3 -DNDEBUG

# Local library paths
LIBS_DIR = libs
GLFW_DIR = \$(LIBS_DIR)
GLEW_DIR = \$(LIBS_DIR)

# Include paths
INCLUDES = -Iinclude -I\$(GLFW_DIR)/include -I\$(GLEW_DIR)/include

# Library paths and libraries
LIBPATHS = -L\$(GLFW_DIR)/lib -L\$(GLEW_DIR)/lib
LIBS = -lglfw3 -lGLEW -lGL -lX11 -lpthread -lXrandr -lXi -ldl

# Directories
SRCDIR = src
BUILDDIR = build

# Source files
SOURCES = \$(wildcard \$(SRCDIR)/*.cpp)
OBJECTS = \$(SOURCES:\$(SRCDIR)/%.cpp=\$(BUILDDIR)/%.o)

# Target executable
TARGET = $PROJECT_NAME

# Default target
all: check-libs release

# Check if libraries are built
check-libs:
	@if [ ! -d "\$(LIBS_DIR)" ]; then \\
		echo "❌ Libraries not found. Run 'make setup-libs' first."; \\
		exit 1; \\
	fi

# Setup libraries (download and build)
setup-libs:
	@echo "📦 Setting up local libraries..."
	@if [ ! -d "external" ]; then mkdir -p external; fi
	@if [ ! -d "libs" ]; then mkdir -p libs; fi
	@cd external && \\
	if [ ! -d "glfw" ]; then \\
		echo "⬇️  Downloading GLFW..."; \\
		wget -q https://github.com/glfw/glfw/releases/download/3.3.8/glfw-3.3.8.zip && \\
		unzip -q glfw-3.3.8.zip && \\
		mv glfw-3.3.8 glfw && \\
		rm glfw-3.3.8.zip; \\
	fi && \\
	if [ ! -f "../libs/lib/libglfw3.a" ]; then \\
		echo "🔨 Building GLFW..."; \\
		cd glfw && mkdir -p build && cd build && \\
		cmake -DCMAKE_INSTALL_PREFIX=../../../libs -DGLFW_BUILD_EXAMPLES=OFF -DGLFW_BUILD_TESTS=OFF -DGLFW_BUILD_DOCS=OFF .. && \\
		make -j\$(shell nproc) && make install && cd ../../; \\
	fi && \\
	if [ ! -d "glew" ]; then \\
		echo "⬇️  Downloading GLEW..."; \\
		wget -q https://github.com/nigels-com/glew/releases/download/glew-2.2.0/glew-2.2.0.tgz && \\
		tar -xzf glew-2.2.0.tgz && \\
		mv glew-2.2.0 glew && \\
		rm glew-2.2.0.tgz; \\
	fi && \\
	if [ ! -f "../libs/lib/libGLEW.a" ]; then \\
		echo "🔨 Building GLEW..."; \\
		cd glew && \\
		make -j\$(shell nproc) GLEW_DEST=../../../libs install; \\
	fi
	@echo "✅ Libraries setup complete!"

# Debug build
debug: CXXFLAGS += \$(DEBUGFLAGS)
debug: check-libs \$(TARGET)

# Release build
release: CXXFLAGS += \$(RELEASEFLAGS)
release: check-libs \$(TARGET)

# Build target
\$(TARGET): \$(OBJECTS) | \$(BUILDDIR)
	\$(CXX) \$(OBJECTS) -o \$(TARGET) \$(LIBPATHS) \$(LIBS)

# Build object files
\$(BUILDDIR)/%.o: \$(SRCDIR)/%.cpp | \$(BUILDDIR)
	\$(CXX) \$(CXXFLAGS) \$(INCLUDES) -c \$< -o \$@

# Create build directory
\$(BUILDDIR):
	mkdir -p \$(BUILDDIR)

# Clean build files
clean:
	rm -rf \$(BUILDDIR) \$(TARGET)

# Clean everything including libraries
clean-all: clean
	rm -rf libs external

# Run the program
run: \$(TARGET)
	./\$(TARGET)

.PHONY: all debug release clean clean-all run check-libs setup-libs
EOF
        
        print_success "OpenGL Makefile created with local library support"
    elif [ "$PROJECT_TYPE" == "simple" ]; then
        cat > Makefile << EOF
# Compiler and flags
CXX = g++
CXXFLAGS = -std=c++17 -Wall -Wextra -Wpedantic
DEBUGFLAGS = -g -O0 -DDEBUG
RELEASEFLAGS = -O3 -DNDEBUG

# Directories
SRCDIR = src
BUILDDIR = build

# Source files
SOURCES = \$(wildcard \$(SRCDIR)/*.cpp)
OBJECTS = \$(SOURCES:\$(SRCDIR)/%.cpp=\$(BUILDDIR)/%.o)

# Target executable
TARGET = $PROJECT_NAME

# Default target
all: release

# Debug build
debug: CXXFLAGS += \$(DEBUGFLAGS)
debug: \$(TARGET)

# Release build
release: CXXFLAGS += \$(RELEASEFLAGS)
release: \$(TARGET)

# Build target
\$(TARGET): \$(OBJECTS) | \$(BUILDDIR)
	\$(CXX) \$(OBJECTS) -o \$(TARGET)

# Build object files
\$(BUILDDIR)/%.o: \$(SRCDIR)/%.cpp | \$(BUILDDIR)
	\$(CXX) \$(CXXFLAGS) -c \$< -o \$@

# Create build directory
\$(BUILDDIR):
	mkdir -p \$(BUILDDIR)

# Clean build files
clean:
	rm -rf \$(BUILDDIR) \$(TARGET)

# Run the program
run: \$(TARGET)
	./\$(TARGET)

# Install (optional)
install: \$(TARGET)
	cp \$(TARGET) /usr/local/bin/

.PHONY: all debug release clean run install
EOF
        
        print_success "Makefile created"
    elif [ "$PROJECT_TYPE" == "competitive" ]; then
        cat > Makefile << EOF
# Competitive Programming Makefile
CXX = g++
CXXFLAGS = -std=c++17 -Wall -Wextra -O2

# Default source file
SRC = src/main.cpp
TARGET = solution

# Build and run
all: build run

build:
	\$(CXX) \$(CXXFLAGS) \$(SRC) -o \$(TARGET)

run: build
	./\$(TARGET)

# Build specific problem
problem:
	@read -p "Enter problem file (without .cpp): " prob; \\
	\$(CXX) \$(CXXFLAGS) problems/\$\$prob.cpp -o \$\$prob; \\
	./\$\$prob

clean:
	rm -f \$(TARGET) problems/*.out solutions/*

.PHONY: all build run problem clean
EOF
        
        print_success "Competitive programming Makefile created"
    fi
}

# Function to create additional files
create_additional_files() {
    # Create .gitignore
    cat > .gitignore << 'EOF'
# Build directories
build/
bin/
obj/

# Executables
*.exe
*.out
*.app
solution
a.out

# Object files
*.o
*.obj

# Debug files
*.dSYM/
*.su
*.idb
*.pdb

# IDE files
.vscode/
.idea/
*.swp
*.swo
*~

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# CMake
CMakeCache.txt
CMakeFiles/
cmake_install.cmake
Makefile
*.cmake
!CMakeLists.txt

# Competitive programming
input.txt
output.txt
*.in
*.ans
EOF
    
    # Create README.md
    cat > README.md << EOF
# $PROJECT_NAME

## Description
A C++ project created with the automated setup script.

## Project Type
$PROJECT_TYPE

## Building

EOF
    
    case $PROJECT_TYPE in
        "cmake"|"library")
            cat >> README.md << 'EOF'
### Using CMake
```bash
mkdir build && cd build
cmake ..
make
```

### Running
```bash
./project_name
```

### Running Tests
```bash
make test
```
EOF
            ;;
        "simple")
            cat >> README.md << 'EOF'
### Using Make
```bash
make          # Release build
make debug    # Debug build
make run      # Build and run
make clean    # Clean build files
```
EOF
            ;;
        "competitive")
            cat >> README.md << 'EOF'
### Competitive Programming
```bash
make          # Build and run main solution
make problem  # Build and run specific problem
```

### Templates
- Use `templates/template.cpp` as a starting point
- Save problems in `problems/` directory
- Save solutions in `solutions/` directory
EOF
            ;;
    esac
    
    cat >> README.md << EOF

## Development
- C++ Standard: C++17
- Compiler: g++
- Build System: $([ "$PROJECT_TYPE" == "simple" ] && echo "Make" || [ "$PROJECT_TYPE" == "competitive" ] && echo "Make" || echo "CMake")

## Author
Created on $(date)
EOF
    
    # Create clang-format configuration
    cat > .clang-format << 'EOF'
BasedOnStyle: LLVM
IndentWidth: 4
TabWidth: 4
UseTab: Never
ColumnLimit: 100
BreakBeforeBraces: Attach
AllowShortFunctionsOnASingleLine: Empty
AllowShortIfStatementsOnASingleLine: false
AllowShortLoopsOnASingleLine: false
EOF
    
    print_success "Additional files created (.gitignore, README.md, .clang-format)"
}

# Function to initialize git repository
init_git() {
    if command -v git &> /dev/null; then
        print_info "Initializing git repository..."
        git init
        git add .
        git commit -m "Initial commit: $PROJECT_TYPE C++ project setup"
        print_success "Git repository initialized"
    else
        print_warning "Git not found, skipping repository initialization"
    fi
}

# Function to create build script
create_build_script() {
    cat > build.sh << 'EOF'
#!/bin/bash

# Build script for the project

set -e

BUILD_TYPE=${1:-release}
CLEAN=${2:-false}

if [ "$CLEAN" == "clean" ]; then
    echo "🧹 Cleaning build files..."
    make clean 2>/dev/null || rm -rf build/
    echo "✅ Clean complete"
    exit 0
fi

echo "🔨 Building project ($BUILD_TYPE)..."

if [ -f "CMakeLists.txt" ]; then
    mkdir -p build
    cd build
    cmake -DCMAKE_BUILD_TYPE=$(echo $BUILD_TYPE | tr '[:lower:]' '[:upper:]') ..
    make -j$(nproc)
    echo "✅ Build complete! Executable in build/"
elif [ -f "Makefile" ]; then
    make $BUILD_TYPE
    echo "✅ Build complete!"
else
    echo "❌ No build system found!"
    exit 1
fi
EOF
    
    chmod +x build.sh
    print_success "Build script created (build.sh)"
}

# Function to show project summary
show_summary() {
    echo
    print_color $PURPLE "🎉 Project Setup Complete!"
    print_color $PURPLE "=========================="
    echo
    print_info "Project Name: $PROJECT_NAME"
    print_info "Project Type: $PROJECT_TYPE"
    print_info "Location: $(pwd)"
    echo
    print_color $CYAN "📁 Directory Structure:"
    tree -a -I '.git' 2>/dev/null || find . -type f -name ".*" -prune -o -type f -print | head -20
    echo
    print_color $CYAN "🚀 Next Steps:"
    echo "  1. cd $PROJECT_NAME"
    
    case $PROJECT_TYPE in
        "cmake"|"library")
            echo "  2. mkdir build && cd build && cmake .. && make"
            echo "  3. ./$(basename $(pwd))"
            ;;
        "simple")
            echo "  2. make"
            echo "  3. ./$PROJECT_NAME"
            ;;
        "competitive")
            echo "  2. make"
            echo "  3. Start coding in src/main.cpp or use templates/"
            ;;
        "opengl")
            echo "  2. Install dependencies: make install-deps (Ubuntu/Debian)"
            echo "     Or: make install-deps-arch (Arch Linux)"
            echo "     Or: make install-deps-fedora (Fedora)"
            echo "  3. make"
            echo "  4. ./$PROJECT_NAME"
            echo "  5. Edit shaders in shaders/ directory"
            ;;
        "opengl-local")
            echo "  2. make setup-libs (downloads and builds GLFW/GLEW locally)"
            echo "  3. make"
            echo "  4. ./$PROJECT_NAME"
            echo "  5. Edit shaders in shaders/ directory"
            echo "  6. Use 'make clean-all' to remove libraries if needed"
            ;;
    esac
    
    echo "  4. Open in Neovim: nvim ."
    echo
    print_success "Happy coding! 🚀"
}

# Main execution
main() {
    print_header
    
    get_project_name "$1"
    get_project_type "$2"
    
    print_info "Setting up $PROJECT_TYPE project: $PROJECT_NAME"
    
    create_directories
    create_main_file
    create_shaders
    download_libraries
    create_headers
    create_cmake
    create_makefile
    create_additional_files
    create_build_script
    init_git
    
    show_summary
}

# Run main function with all arguments
main "$@"
