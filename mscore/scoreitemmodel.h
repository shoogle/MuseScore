//=============================================================================
//  ScoreItemModel
//
//  Copyright (C) 2020 Peter Jonas
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License version 2
//  as published by the Free Software Foundation and appearing in
//  the file LICENCE.GPL
//=============================================================================

#ifndef __SCOREITEMMODEL_H__
#define __SCOREITEMMODEL_H__

#include "scoreview.h"
#ifndef __SCANVAS_H__
#include <QAbstractItemModel>
#endif

namespace Ms {

class ScoreElement;
class Score;
class ScoreView;

//---------------------------------------------------------
//   ScoreItemModel
//---------------------------------------------------------

class ScoreItemModel : public QAbstractItemModel
      {
      Q_OBJECT

   private:
      Score* _scoreRoot;
      ScoreView *_view;

   public:
      ScoreItemModel(ScoreView *view, QObject *parent = nullptr);

      // compulsory overrides
      virtual int columnCount(const QModelIndex &parent = QModelIndex()) const override { Q_UNUSED(parent) return 1; }
      virtual QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
      virtual QModelIndex index(int row, int column, const QModelIndex &parent = QModelIndex()) const override;
      virtual QModelIndex parent(const QModelIndex &child) const override;
      virtual int rowCount(const QModelIndex &parent = QModelIndex()) const override;

      // optional overrides
      virtual QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;

   private:
      ScoreElement* scoreElementFromIndex(const QModelIndex &index) const;

      };
}

#endif // __SCOREITEMMODEL_H__
