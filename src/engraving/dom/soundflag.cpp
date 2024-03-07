/*
 * SPDX-License-Identifier: GPL-3.0-only
 * MuseScore-CLA-applies
 *
 * MuseScore
 * Music Composition & Notation
 *
 * Copyright (C) 2024 MuseScore BVBA and others
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

#include "soundflag.h"

#include <climits>

#include "undo.h"
#include "linkedobjects.h"

using namespace mu::engraving;

SoundFlag::SoundFlag(EngravingItem* parent)
    : EngravingItem(ElementType::SOUND_FLAG, parent)
{
    m_iconFont = draw::Font(engravingConfiguration()->iconsFontFamily(), draw::Font::Type::Icon);
    m_iconFont.setPointSizeF(spatium() * 2.0);

    //! draw on top of all elements
    setZ(INT_MAX);
}

SoundFlag* SoundFlag::clone() const
{
    return new SoundFlag(*this);
}

bool SoundFlag::isEditable() const
{
    return false;
}

void SoundFlag::setSelected(bool f)
{
    EngravingItem* parent = parentItem();
    if (parent) {
        parent->setSelected(f);
    }

    EngravingItem::setSelected(f);
}

const SoundFlag::PresetCodes& SoundFlag::soundPresets() const
{
    return m_soundPresets;
}

void SoundFlag::setSoundPresets(const PresetCodes& soundPresets)
{
    m_soundPresets = soundPresets;
}

const SoundFlag::PlayingTechniqueCode& SoundFlag::playingTechnique() const
{
    return m_playingTechnique;
}

void SoundFlag::setPlayingTechnique(const PlayingTechniqueCode& technique)
{
    m_playingTechnique = technique;
}

void SoundFlag::clear()
{
    if (m_soundPresets.empty() && m_playingTechnique.empty()) {
        return;
    }

    m_soundPresets.clear();
    m_playingTechnique.clear();

    triggerLayout();
}

bool SoundFlag::shouldHide() const
{
    if (const Score* score = this->score()) {
        if (!score->showSoundFlags()) {
            return true;
        }

        if (score->printing()) {
            return true;
        }
    }

    if (!m_soundPresets.empty() || !m_playingTechnique.empty()) {
        return false;
    }

    if (selected()) {
        return false;
    }

    const EngravingItem* parent = parentItem();
    if (parent && parent->selected()) {
        return false;
    }

    return true;
}

void SoundFlag::undoChangeSoundFlag(const PresetCodes& presets, const PlayingTechniqueCode& technique)
{
    if (m_soundPresets == presets && m_playingTechnique == technique) {
        return;
    }

    score()->undo(new ChangeSoundFlag(this, presets, technique));
    triggerLayout();

    const LinkedObjects* links = this->links();
    if (!links) {
        return;
    }

    for (EngravingObject* obj : *links) {
        if (obj->isSoundFlag()) {
            SoundFlag* linkedSoundFlag = toSoundFlag(obj);
            score()->undo(new ChangeSoundFlag(linkedSoundFlag, presets, technique));
            linkedSoundFlag->triggerLayout();
        }
    }
}

char16_t SoundFlag::iconCode() const
{
    return 0xEF4E;
}

draw::Font SoundFlag::iconFont() const
{
    return m_iconFont;
}

void SoundFlag::setIconFontSize(double size)
{
    m_iconFont.setPointSizeF(size);
}

Color SoundFlag::iconBackgroundColor() const
{
    Color color = curColor();
    if (!selected()) {
        color = Color("#CFD5DD");
        color.setAlpha(128);
    }

    return color;
}
