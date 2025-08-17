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
        echo
        read -p "Choose project type (1-4) or enter name: " choice
        
        case $choice in
            1|simple) PROJECT_TYPE="simple" ;;
            2|cmake) PROJECT_TYPE="cmake" ;;
            3|competitive) PROJECT_TYPE="competitive" ;;
            4|library) PROJECT_TYPE="library" ;;
            *) PROJECT_TYPE="simple" ;;
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
    esac
    
    print_success "Main source file created"
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
    if [[ "$PROJECT_TYPE" == "cmake" || "$PROJECT_TYPE" == "library" ]]; then
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
        
        # Create tests CMakeLists.txt
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
        
        print_success "CMake configuration created"
    fi
}

# Function to create Makefile for simple projects
create_makefile() {
    if [ "$PROJECT_TYPE" == "simple" ]; then
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
