#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only
# MuseScore-Studio-CLA-applies
#
# MuseScore Studio
# Music Composition & Notation
#
# Copyright (C) 2024 MuseScore Limited
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 3 as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

o="$(basename "$0")" # script name

((${BASH_VERSION%%.*} >= 4)) || { echo >&2 "$o: Error: Please upgrade Bash."; exit 1; }

set -euo pipefail # exit on error, error on unset variable, preserve errors in pipelines

function tag_exists()
{
    local name="$1"
    [[ "$(git tag --list -- "${name}")" ]]
}

function version_exists()
{
    local version="$1" label="${2-}" # label is optional
    local suffix="${label:+-${label}}" # if label not empty prepend hyphen
    tag_exists "v${version}${suffix}" \
        || tag_exists "v${version}.0${suffix}" \
        || tag_exists "v${version}.0.0${suffix}"
}

if [[ "${CREATE_TAG}" == 'on' ]]; then
    types="alpha|beta|rc|stable"
    if [[ ! "${RELEASE_TYPE}" =~ ^(${types})$ ]]; then
        echo >&2 "$o: Error: Creating tag with RELEASE_TYPE '${RELEASE_TYPE}'."
        echo >&2 "$o: Allowed values are: ${types//|/, }."
        exit 1
    fi
else
    pattern="^[A-Za-z][A-Za-z0-9]*([._][A-Za-z0-9]+)*$"
    if [[ ! "${RELEASE_TYPE}" =~ ${pattern} ]]; then
        echo >&2 "$o: Error: Invalid RELEASE_TYPE '${RELEASE_TYPE}'."
        echo >&2 "$o: Allowed characters are ASCII letters, numbers, dot '.' and underscore '_'."
        echo >&2 "$o: It must start with a letter and avoid consecutive '.' or '_' characters."
        echo >&2 "$o: Regex: ${pattern}"
        exit 1
    fi
fi

VERSION="$(cmake -P version.cmake | sed -n "s|^-- MUSE_APP_VERSION ||p")"
int="(0|[1-9][0-9]*)"

if [[ ! "${VERSION}" =~ ^${int}\.${int}\.${int}$ ]]; then
    echo >&2 "Badly formed version: ${VERSION}"
    exit 1
fi

MAJOR="${VERSION%%.*}"
MINOR="${VERSION#*.}"
MINOR="${MINOR%%.*}"
PATCH="${VERSION##*.}"
VERSION="${VERSION%.0}" # strip patch number if it's zero
VERSION="${VERSION%.0}" # strip minor number if it's zero

if version_exists "${VERSION}"; then
    if [[ "${RELEASE_TYPE}" == 'stable' ]]; then
        echo >&2 "$o: Error: Tag already exists for version '${VERSION}'."
    else
        echo >&2 "$o: Error: Creating pre-release for already released version '${VERSION}'."
    fi
    echo >&2 "$o: You need to bump the version numbers in version.cmake (e.g. increase patch by 1)."
    exit 1
fi

if ((PATCH > 0)); then
    OLDER_VERSION="${MAJOR}.${MINOR}.$((PATCH-1))"
    OLDER_VERSION="${OLDER_VERSION%.0}" # strip patch number if it's zero
    OLDER_VERSION="${OLDER_VERSION%.0}" # strip minor number if it's zero
elif ((MINOR > 0)); then
    OLDER_VERSION="${MAJOR}.$((MINOR-1))" # unknown patch
    OLDER_VERSION="${OLDER_VERSION%.0}" # strip minor number if it's zero
else
    OLDER_VERSION="$((MAJOR-1))" # unknown minor and patch
fi

if ! version_exists "${OLDER_VERSION}"; then
    echo >&2 "$o: Error: Version is ${VERSION} but no tag exists for ${OLDER_VERSION}."
    echo >&2 "$o: You need to reduce the version numbers in version.cmake to avoid skipping releases."
    exit 1
fi

if [[ "${RELEASE_TYPE}" == 'stable' ]]; then
    VERSION_LABEL=""
else
    VERSION_LABEL="${RELEASE_TYPE}" # e.g. 'rc'
    if [[ "${CREATE_TAG}" == 'on' ]]; then
        count=1
        label="${VERSION_LABEL}"
        while version_exists "${VERSION}" "${label}"; do
            ((++count))
            label="${VERSION_LABEL}.${count}" # e.g. 'rc.2'
        done
        VERSION_LABEL="${label}"
    fi
fi

suffix="${VERSION_LABEL:+-${VERSION_LABEL}}" # if label not empty prepend hyphen

if ((PATCH == 0)); then
    TAG_NAME="v${MAJOR}.${MINOR}${suffix}"           # e.g. 'v4.0-rc.2'
else
    TAG_NAME="v${MAJOR}.${MINOR}.${PATCH}${suffix}"  # e.g. 'v4.0.1-rc.2'
fi

if tag_exists "${TAG_NAME}"; then
    echo >&2 "$o: Error: '${TAG_NAME}' tag already exists."
    echo >&2 "$o: This shouldn't happen. Check for bugs in the script code."
    exit 1
fi

echo "VERSION_LABEL=${VERSION_LABEL}"
echo "TAG_NAME=${TAG_NAME}"
