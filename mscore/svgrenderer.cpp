//=============================================================================
//  MuseScore
//  Music Composition & Notation
//  $Id: abstractdialog.cpp 4220 2011-04-22 10:31:26Z wschweer $
//
//  Copyright (C) 2002-2016 Werner Schweer and others
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License version 2.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
//=============================================================================

#include "svgrenderer.h"
#include "globals.h"

namespace Ms {

SvgRenderer::SvgRenderer(const QString &filename, QObject *parent)
   : QSvgRenderer(filename, parent)
      {

      }

QPixmap SvgRenderer::hdpiPixmap(QSize size, bool scaleWithGui, const QColor &background)
      {
      if (!size.isValid())
            size = defaultSize();
      if (scaleWithGui)
            size *= (guiScaling * qApp->devicePixelRatio());
      else
            size *= qApp->devicePixelRatio();
      QPixmap pm(size);
      pm.fill(background);
      QPainter painter(&pm);
      render(&painter);
      pm.setDevicePixelRatio(qApp->devicePixelRatio());
      return pm;
      }
}
