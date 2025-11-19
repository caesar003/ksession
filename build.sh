#!/bin/bash

# KSession Automated Build Script
# This script automates the entire build process for ksession

set -e # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
	echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
	echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
	echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
	echo -e "${RED}[ERROR]${NC} $1"
}

# Function to get version from VERSION file
get_current_version() {
	if [ -f "VERSION" ]; then
		cat VERSION
	else
		echo "0.0.0"
	fi
}

# Function to update VERSION file
update_version_file() {
	local new_version="$1"
	echo "$new_version" >VERSION
	log_info "Updated VERSION file to $new_version"
}

# Function to replace placeholders with actual version
replace_version_placeholders() {
	local version="$1"
	local target_dir="$2"
	local build_date=$(date +"%b %Y")

	log_info "Replacing version placeholders with $version"
	log_info "Using build date: $build_date"

	# Replace in main script
	sed "s/__VERSION__/$version/g" bin/ksession >"$target_dir/ksession/usr/bin/ksession"
	chmod +x "$target_dir/ksession/usr/bin/ksession"
	log_info "Processed bin/ksession"

	# Replace in DEBIAN/control
	sed "s/0\.0\.0/$version/g" debian/ksession/DEBIAN/control >"$target_dir/ksession/DEBIAN/control"
	log_info "Processed DEBIAN/control"

	# Replace in man page (both __VERSION__ and __DATE__)
	sed -e "s/__VERSION__/$version/g" -e "s/__DATE__/$build_date/g" share/man/man1/ksession.1 >"$target_dir/ksession/usr/share/man/man1/ksession.1"
	log_info "Processed man page"

	# Copy completion script (no version replacement needed)
	cp share/bash-completion/completions/ksession "$target_dir/ksession/usr/share/bash-completion/completions/ksession"
	log_info "Copied bash completion"
}

# Function to prepare build directory
prepare_build_dir() {
	local version="$1"
	local build_dir="dist/$version"

	log_info "Preparing build directory: $build_dir"

	# Create dist directory structure
	mkdir -p "$build_dir/ksession/usr/bin"
	mkdir -p "$build_dir/ksession/usr/share/bash-completion/completions"
	mkdir -p "$build_dir/ksession/usr/share/man/man1"
	mkdir -p "$build_dir/ksession/DEBIAN"

	# Copy DEBIAN files (postinst, postrm, etc.) if they exist
	if [ -d "debian/ksession/DEBIAN" ]; then
		for file in debian/ksession/DEBIAN/*; do
			if [ -f "$file" ] && [ "$(basename "$file")" != "control" ]; then
				cp "$file" "$build_dir/ksession/DEBIAN/"
				chmod 755 "$build_dir/ksession/DEBIAN/$(basename "$file")" 2>/dev/null || true
			fi
		done
	fi

	log_success "Build directory prepared"
	echo "$build_dir"
}

# Function to build the deb package
build_package() {
	local version="$1"
	local build_dir="dist/$version"
	local package_name="ksession-${version}-amd64.deb"

	log_info "Building debian package: $package_name"

	# Build the package
	dpkg-deb --build "$build_dir/ksession" "$build_dir/$package_name"

	if [ -f "$build_dir/$package_name" ]; then
		log_success "Package built successfully: $build_dir/$package_name"

		# Show package info
		log_info "Package information:"
		dpkg-deb --info "$build_dir/$package_name"
	else
		log_error "Package build failed!"
		exit 1
	fi
}

# Function to validate the current state
validate_environment() {
	log_info "Validating build environment..."

	# Check if we're in the right directory
	if [ ! -f "bin/ksession" ]; then
		log_error "bin/ksession not found. Are you in the project root?"
		exit 1
	fi

	if [ ! -f "debian/ksession/DEBIAN/control" ]; then
		log_error "debian/ksession/DEBIAN/control not found."
		exit 1
	fi

	# Check if dpkg-deb is available
	if ! command -v dpkg-deb &>/dev/null; then
		log_error "dpkg-deb is not installed. Please install dpkg-dev."
		exit 1
	fi

	# Check if VERSION file exists
	if [ ! -f "VERSION" ]; then
		log_warning "VERSION file not found. Creating with version 0.0.0"
		echo "0.0.0" >VERSION
	fi

	log_success "Environment validation passed"
}

# Function to check if source files have placeholders
check_placeholders() {
	log_info "Checking for version placeholders in source files..."

	local has_placeholders=true

	# Check main script
	if grep -q "VERSION=\"__VERSION__\"" bin/ksession; then
		log_info "  ✓ bin/ksession has placeholder"
	else
		log_warning "  ✗ bin/ksession missing placeholder"
		has_placeholders=false
	fi

	# Check control file
	if grep -q "Version: 0.0.0" debian/ksession/DEBIAN/control; then
		log_info "  ✓ DEBIAN/control has placeholder"
	else
		log_warning "  ✗ DEBIAN/control missing placeholder"
		has_placeholders=false
	fi

	# Check man page
	if grep -q "__VERSION__" share/man/man1/ksession.1 && grep -q "__DATE__" share/man/man1/ksession.1; then
		log_info "  ✓ Man page has placeholders"
	else
		log_warning "  ✗ Man page missing placeholders"
		has_placeholders=false
	fi

	if [ "$has_placeholders" = false ]; then
		log_warning "Some source files are missing placeholders"
		log_warning "Build will continue but source files should use placeholders"
	else
		log_success "All placeholders found"
	fi
}

# Function to show usage
show_usage() {
	cat <<EOF
Usage: $0 [OPTIONS]

Options:
    -v, --version VERSION    Set new version and build
    -b, --build             Build with current version (no version change)
    -c, --check             Check version file and placeholders
    -h, --help              Show this help message

Examples:
    $0 --version 1.4.5      # Update VERSION to 1.4.5 and build
    $0 --build              # Build with current VERSION
    $0 --check              # Check VERSION file and placeholders

If no options are provided, the script will check and build with current version.
EOF
}

# Main script logic
main() {
	validate_environment

	case "${1:-}" in
	-v | --version)
		if [ -z "$2" ]; then
			log_error "Version number required"
			show_usage
			exit 1
		fi
		local new_version="$2"
		local current_version=$(get_current_version)

		if [ "$new_version" = "$current_version" ]; then
			log_warning "New version is the same as current version ($current_version)"
		fi

		update_version_file "$new_version"
		check_placeholders

		local build_dir=$(prepare_build_dir "$new_version")
		replace_version_placeholders "$new_version" "dist/$new_version"
		build_package "$new_version"
		;;
	-b | --build)
		local current_version=$(get_current_version)
		check_placeholders

		local build_dir=$(prepare_build_dir "$current_version")
		replace_version_placeholders "$current_version" "dist/$current_version"
		build_package "$current_version"
		;;
	-c | --check)
		local current_version=$(get_current_version)
		log_info "Current version in VERSION file: $current_version"
		check_placeholders
		;;
	-h | --help)
		show_usage
		;;
	"")
		log_info "No options provided. Building with current version..."
		local current_version=$(get_current_version)
		check_placeholders

		local build_dir=$(prepare_build_dir "$current_version")
		replace_version_placeholders "$current_version" "dist/$current_version"
		build_package "$current_version"
		;;
	*)
		log_error "Unknown option: $1"
		show_usage
		exit 1
		;;
	esac
}

# Run main function with all arguments
main "$@"
