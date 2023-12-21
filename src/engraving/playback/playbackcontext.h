/*
 * SPDX-License-Identifier: GPL-3.0-only
 * MuseScore-CLA-applies
 *
 * MuseScore
 * Music Composition & Notation
 *
 * Copyright (C) 2021 MuseScore BVBA and others
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

#ifndef MU_ENGRAVING_PLAYBACKCONTEXT_H
#define MU_ENGRAVING_PLAYBACKCONTEXT_H

#include "mpe/mpetypes.h"
#include "mpe/events.h"

#include "types/types.h"

namespace mu::engraving {
class Segment;
class Dynamic;
class PlayTechAnnotation;
class SoundFlag;
class Score;
class MeasureRepeat;

class PlaybackContext
{
public:
    mpe::dynamic_level_t appliableDynamicLevel(const int nominalPositionTick) const;
    mpe::ArticulationType persistentArticulationType(const int nominalPositionTick) const;

    mpe::PlaybackParamMap playbackParamMap(const Score* score, const int nominalPositionTick, const staff_idx_t staffIdx) const;
    mpe::PlaybackParamMap playbackParamMap(const Score* score) const;
    mpe::DynamicLevelMap dynamicLevelMap(const Score* score) const;

    void update(const ID partId, const Score* score);
    void clear();

    bool hasSoundFlags() const;

private:
    using DynamicMap = std::map<int /*nominalPositionTick*/, mpe::dynamic_level_t>;
    using PlayTechniquesMap = std::map<int /*nominalPositionTick*/, mpe::ArticulationType>;
    using ParamMap = std::map<int /*nominalPositionTick*/, mpe::PlaybackParamList>;

    mpe::dynamic_level_t nominalDynamicLevel(const int positionTick) const;

    void updateDynamicMap(const Dynamic* dynamic, const Segment* segment, const int segmentPositionTick);
    void updatePlayTechMap(const ID partId, const Score* score, const PlayTechAnnotation* annotation, const int segmentPositionTick);
    void updatePlaybackParamMap(const ID partId, const Score* score, const SoundFlag* flag, const int segmentPositionTick);
    void applyDynamicToNextSegment(const Segment* currentSegment, const int segmentPositionTick,
                                   const mu::mpe::dynamic_level_t dynamicLevel);

    void handleSpanners(const ID partId, const Score* score, const int segmentStartTick, const int segmentEndTick,
                        const int tickPositionOffset);
    void handleAnnotations(const ID partId, const Score* score, const Segment* segment, const int segmentPositionTick);
    void handleMeasureRepeats(const std::vector<const MeasureRepeat*>& measureRepeats, const int tickPositionOffset);

    void copyDynamicsInRange(const int rangeStartTick, const int rangeEndTick, const int newDynamicsOffsetTick);
    void copyPlayTechniquesInRange(const int rangeStartTick, const int rangeEndTick, const int newPlayTechOffsetTick);

    DynamicMap m_dynamicsMap;
    PlayTechniquesMap m_playTechniquesMap;
    ParamMap m_playbackParamMap;
};
}

#endif // MU_ENGRAVING_PLAYBACKCONTEXT_H
