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

# Function to extract version from the main script
get_current_version() {
	grep '^VERSION=' bin/ksession | cut -d'"' -f2
}

# Function to update version in all files
update_version() {
	local new_version="$1"
	local current_version="$2"

	log_info "Updating version from $current_version to $new_version"

	# Update main script
	sed -i "s/^VERSION=\".*\"/VERSION=\"$new_version\"/" bin/ksession
	log_info "Updated version in bin/ksession"

	# Update man page
	sed -i "s/^\.TH \"KSESSION\" \"1\" \".*\" \".*\" \"Custom Commands\"$/.TH \"KSESSION\" \"1\" \"$(date +"%b %Y")\" \"$new_version\" \"Custom Commands\"/" share/man/man1/ksession.1
	log_info "Updated version in man page"

	# Update DEBIAN/control
	sed -i "s/^Version: .*/Version: $new_version/" debian/ksession/DEBIAN/control
	log_info "Updated version in DEBIAN/control"
}

# Function to sync files to debian package structure
sync_files() {
	log_info "Syncing files to debian package structure..."

	# Copy main script
	cp bin/ksession debian/ksession/usr/bin/
	log_info "Copied bin/ksession"

	# Copy completion script
	cp share/bash-completion/completions/ksession debian/ksession/usr/share/bash-completion/completions/
	log_info "Copied bash completion"

	# Copy man page
	cp share/man/man1/ksession.1 debian/ksession/usr/share/man/man1/
	log_info "Copied man page"

	log_success "All files synced successfully"
}

# Function to build the deb package
build_package() {
	local version="$1"
	local package_name="ksession-${version}-amd64.deb"

	log_info "Building debian package: $package_name"

	cd debian
	dpkg-deb --build ./ksession "$package_name"
	cd ..

	if [ -f "debian/$package_name" ]; then
		log_success "Package built successfully: debian/$package_name"

		# Show package info
		log_info "Package information:"
		dpkg-deb --info "debian/$package_name"
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

	log_success "Environment validation passed"
}

# Function to check version consistency
check_version_consistency() {
	local script_version=$(get_current_version)
	local control_version=$(grep '^Version:' debian/ksession/DEBIAN/control | cut -d' ' -f2)
	local man_version=$(grep '^\.TH' share/man/man1/ksession.1 | awk '{print $4}' | tr -d '"')

	log_info "Current versions:"
	log_info "  Script: $script_version"
	log_info "  Control: $control_version"
	log_info "  Man page: $man_version"

	if [ "$script_version" != "$control_version" ] || [ "$script_version" != "$man_version" ]; then
		log_warning "Version mismatch detected!"
		return 1
	else
		log_success "All versions are consistent"
		return 0
	fi
}

# Function to show usage
show_usage() {
	cat <<EOF
Usage: $0 [OPTIONS]

Options:
    -v, --version VERSION    Set new version and build
    -b, --build             Build with current version (no version change)
    -c, --check             Check version consistency across files
    -h, --help              Show this help message

Examples:
    $0 --version 1.4.1      # Update to version 1.4.1 and build
    $0 --build               # Build with current version
    $0 --check               # Check if versions are consistent

If no options are provided, the script will check versions and build if consistent.
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

		update_version "$new_version" "$current_version"
		sync_files
		build_package "$new_version"
		;;
	-b | --build)
		if ! check_version_consistency; then
			log_error "Cannot build with inconsistent versions. Use --version to fix."
			exit 1
		fi
		local current_version=$(get_current_version)
		sync_files
		build_package "$current_version"
		;;
	-c | --check)
		check_version_consistency
		;;
	-h | --help)
		show_usage
		;;
	"")
		log_info "No options provided. Checking versions and building if consistent..."
		if check_version_consistency; then
			local current_version=$(get_current_version)
			sync_files
			build_package "$current_version"
		else
			log_error "Version inconsistency found. Use --version to update or fix manually."
			exit 1
		fi
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
