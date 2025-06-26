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
#ifndef MUSE_ACCESSIBILITY_ACCESSIBLEITEMINTERFACE_H
#define MUSE_ACCESSIBILITY_ACCESSIBLEITEMINTERFACE_H

#include <QAccessibleInterface>

#include "accessibleobject.h"

#include "modularity/ioc.h"
#include "ui/iinteractiveprovider.h"
#include "log.h"

namespace muse::accessibility {
class AccessibleItemInterface :
    public muse::Injectable,

    // Inherited interfaces must be returned in this->interface_cast(type)
    // or their virual methods won't be discovered by screen readers.
    public QAccessibleInterface,
    public QAccessibleTextInterface,
    public QAccessibleEditableTextInterface,
    public QAccessibleValueInterface,
    public QAccessibleActionInterface,
    public QAccessibleTableCellInterface
{
    Inject<ui::IInteractiveProvider> interactiveProvider = { this };

public:
    AccessibleItemInterface(AccessibleObject* object);

    bool isValid() const override;
    QObject* object() const override;
    QWindow* window() const override;
    QRect rect() const override;

    QAccessibleInterface* focusChild() const override;
    QAccessibleInterface* childAt(int x, int y) const override;

    QAccessibleInterface* parent() const override;
    QAccessibleInterface* child(int index) const override;
    int childCount() const override;
    int indexOfChild(const QAccessibleInterface* iface) const override;

    QAccessible::State state() const override;
    QAccessible::Role role() const override;
    QString text(QAccessible::Text) const override;
    void setText(QAccessible::Text, const QString& text) override;

    // Value Interface
    QVariant currentValue() const override;
    void setCurrentValue(const QVariant& value) override;
    QVariant maximumValue() const override;
    QVariant minimumValue() const override;
    QVariant minimumStepSize() const override;

    // Action Interface
    QStringList actionNames() const override { return { pressAction(), increaseAction(), decreaseAction() }; }
    void doAction(const QString &actionName) override { UNUSED(actionName); }
    QStringList keyBindingsForAction(const QString &actionName) const override {
        if (actionName == pressAction()) {
            return { "Space" };
        }
        if (actionName == increaseAction()) {
            return { "Up" };
        }
        if (actionName == decreaseAction()) {
            return { "Down" };
        }
        return {};
    }

    // Text Interface
    void selection(int selectionIndex, int* startOffset, int* endOffset) const override;
    int selectionCount() const override;
    void addSelection(int startOffset, int endOffset) override;
    void removeSelection(int selectionIndex) override;
    void setSelection(int selectionIndex, int startOffset, int endOffset) override;

    int cursorPosition() const override;
    void setCursorPosition(int position) override;

    QString text(int startOffset, int endOffset) const override;
    QString textBeforeOffset(int offset, QAccessible::TextBoundaryType boundaryType, int* startOffset, int* endOffset) const override;
    QString textAfterOffset(int offset, QAccessible::TextBoundaryType boundaryType, int* startOffset, int* endOffset) const override;
    QString textAtOffset(int offset, QAccessible::TextBoundaryType boundaryType, int* startOffset, int* endOffset) const override;
    int characterCount() const override;

    QRect characterRect(int offset) const override;
    int offsetAtPoint(const QPoint& point) const override;

    void scrollToSubstring(int startIndex, int endIndex) override;
    QString attributes(int /* offset */, int* startOffset, int* endOffset) const override;

    // Editable Text Interface
    void deleteText(int startOffset, int endOffset) override { UNUSED(startOffset); UNUSED(endOffset); }
    void insertText(int offset, const QString &text) override { UNUSED(offset); UNUSED(text); }
    void replaceText(int startOffset, int endOffset, const QString &text) override { UNUSED(startOffset); UNUSED(endOffset); UNUSED(text); }

    // Table cell(list view item) Interface
    bool isSelected() const override;

    QList<QAccessibleInterface*> columnHeaderCells() const override;
    QList<QAccessibleInterface*> rowHeaderCells() const override;
    int columnIndex() const override;
    int rowIndex() const override;
    int columnExtent() const override;
    int rowExtent() const override;

    QAccessibleInterface* table() const override;

protected:
    void* interface_cast(QAccessible::InterfaceType t) override;

private:

    IAccessible::TextBoundaryType muBoundaryType(QAccessible::TextBoundaryType qtBoundaryType) const;

    AccessibleObject* m_object = nullptr;
};
}

#endif // MUSE_ACCESSIBILITY_ACCESSIBLEITEMINTERFACE_H
