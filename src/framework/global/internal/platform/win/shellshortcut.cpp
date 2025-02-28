/*
 * SPDX-License-Identifier: GPL-3.0-only
 * MuseScore-CLA-applies
 *
 * MuseScore
 * Music Composition & Notation
 *
 * Copyright (C) 2025 MuseScore BVBA and others
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
#include "shellshortcut.h"

#include "io/path.h"
#include "log.h"

//#include "stdafx.h"
#include "windows.h"
#include "winnls.h"
#include "shobjidl.h"
#include "objbase.h"
#include "objidl.h"
#include "shlguid.h"
#include "fileapi.h"

using namespace muse;

bool ShellShortcut::create(const io::path_t& targetPath, const io::path_t& linkPath)
{
    // io::path_t p1 = targetPath;
    // io::path_t p2 = linkPath;
    io::path_t p1 = "C:/src/MuseScore/master/builds/Qt6_MSVC2019_Unity/install//styles";
    io::path_t p2 = "C:/Users/peter/Documents/MuseScore4Development/Styles/Built";

    // std::wstring wTargetPath = p1.toStdWString(); // L"C:\\src\\MuseScore\\master\\builds\\Qt6_MSVC2019_Unity\\install\\styles"; // Directory to link to
    // std::wstring wLinkPath = p2.toStdWString(); //L"C:\\Users\\peter\\Documents\\MuseScore4Development\\Styles\\MSS.lnk"; // Where to save the shortcut

    QString target = p1.toQString().replace(QRegularExpression("[\\\\/]+"), "\\");
    QString link = p2.toQString().replace(QRegularExpression("[\\\\/]+"), "\\") + ".lnk";
    const std::wstring wTargetPath = target.toStdWString();
    const std::wstring wLinkPath = link.toStdWString();

    const bool isDirectory = false;// GetFileAttributes(wTargetPath.c_str()) & FILE_ATTRIBUTE_DIRECTORY;

    LOGI() << "P1: " << p1;
    LOGI() << "T1: " << targetPath;
    LOGI() << "T2: " << target;
    LOGI() << "Equal: " << (p1 == targetPath);

    LOGI() << "P2: " << p2;
    LOGI() << "L1: " << linkPath;
    LOGI() << "L2: " << link;
    LOGI() << "Equal: " << (p2 == linkPath);

    // Use the Shell's IShellLink and IPersistFile interfaces to create
    // and store a shortcut to the specified object (file or directory).
    // See https://learn.microsoft.com/en-gb/windows/win32/shell/links

    CoInitialize(NULL); // Initialize COM
    LPCWSTR lpszPathObj = wTargetPath.c_str(); // Target path (buffer address)
    LPCWSTR lpszPathLink = wLinkPath.c_str(); // Link path (buffer address)
    LPCWSTR lpszDesc = L""; // Shell link properties (buffer address)
    IID linkType = isDirectory ? CLSID_FolderShortcut : CLSID_ShellLink;

    HRESULT hres;
    IShellLink* psl = nullptr;

    // Get a pointer to the IShellLink interface. It is assumed that CoInitialize
    // has already been called.
    hres = CoCreateInstance(linkType, NULL, CLSCTX_INPROC_SERVER, IID_IShellLink, (LPVOID*)&psl);

    if (SUCCEEDED(hres))
    {
        IPersistFile* ppf;

        // Set the path to the shortcut target and add the description.
        psl->SetPath(lpszPathObj);
        psl->SetDescription(lpszDesc);

        // Query IShellLink for the IPersistFile interface, used for saving the
        // shortcut in persistent storage.
        hres = psl->QueryInterface(IID_IPersistFile, (LPVOID*)&ppf);

        if (SUCCEEDED(hres))
        {
            // WCHAR wsz[MAX_PATH];

            // // Ensure that the string is Unicode.
            // MultiByteToWideChar(CP_ACP, 0, lpszPathLink, -1, wsz, MAX_PATH);

            // // Add code here to check return value from MultiByteWideChar
            // // for success.

            // Save the link by calling IPersistFile::Save.
            hres = ppf->Save(lpszPathLink, TRUE); // wsz -> lpszPathLink
            ppf->Release();
        }
        psl->Release();
    }
    return SUCCEEDED(hres);
}
