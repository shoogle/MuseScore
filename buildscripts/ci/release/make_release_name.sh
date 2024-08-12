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

version="${TAG_NAME%%-*}"
label="${TAG_NAME#${version}}"
label="${label#-}"
version="${version#v}"
type="${label%.*}"
count="${label#${type}}"
count="${count#.}"
int="(0|[1-9][0-9]*)"

if [[ ! "${version}" =~ ^${int}\.${int}(\.[1-9][0-9]*)?$ ]]; then
    echo >&2 "$o: Error: version '${version}' is badly formed."
    echo >&2 "$o: The patch number should be omitted if it is zero."
    exit 1
fi

if [[ "${RELEASE_TYPE}" == 'stable' ]]; then
    if [[ "${label}${type}${count}" ]]; then
        echo >&2 "$o: Error: label='${label}', type='${type}', count='${count}'."
        echo >&2 "$o: They should all be empty when RELEASE_TYPE is 'stable'."
        exit 1
    fi
else
    if [[ "${type}" != "${RELEASE_TYPE}" ]]; then
        echo >&2 "$o: Error: type '${type}' doesn't match RELEASE_TYPE '${RELEASE_TYPE}'."
        exit 1
    fi

    if [[ ! "${count}" ]]; then
        : # pass
    elif [[ "${count}" =~ ^([2-9]|[1-9][0-9]+)$ ]]; then
        count=" ${count}" # add space
    else
        echo >&2 "$o: Error: count '${count}' should be empty or an integer greater than 1."
        exit 1
    fi
fi

case "${RELEASE_TYPE}" in
stable)   pretty_type="Release";;
rc)       pretty_type="Release Candidate";;
beta)     pretty_type="Beta";;
alpha)    pretty_type="Alpha";;
*) echo >&2 "$o: Error: Unrecognized RELEASE_TYPE '${RELEASE_TYPE}'."; exit 1;;
esac

echo "RELEASE_NAME=MuseScore ${version} ${pretty_type}${count}"
