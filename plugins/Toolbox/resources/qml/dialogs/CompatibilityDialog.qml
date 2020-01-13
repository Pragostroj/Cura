// Copyright (c) 2020 Ultimaker B.V.
// Toolbox is released under the terms of the LGPLv3 or higher.

import QtQuick 2.10
import QtQuick.Window 2.2
import QtQuick.Controls 2.3

import UM 1.1 as UM
import Cura 1.6 as Cura


UM.Dialog{
    visible: true
    title: catalog.i18nc("@title", "Changes from your account")
    width: UM.Theme.getSize("popup_dialog").width
    height: UM.Theme.getSize("popup_dialog").height
    minimumWidth: width
    maximumWidth: minimumWidth
    minimumHeight: height
    maximumHeight: minimumHeight
    margin: 0

    Rectangle
    {
        id: root
        anchors.fill: parent
        color: UM.Theme.getColor("main_background")

        UM.I18nCatalog
        {
            id: catalog
            name: "cura"
        }

        ScrollView
        {
            width: parent.width
            height: parent.height - nextButton.height - nextButton.anchors.margins * 2 // We want some leftover space for the button at the bottom
            clip: true

            Column
            {
                anchors.fill: parent
                anchors.margins: UM.Theme.getSize("default_margin").width

                // Compatible packages
                Label
                {
                    font: UM.Theme.getFont("default")
                    text: catalog.i18nc("@label", "The following packages will be added:")
                    visible: toolbox.has_compatible_packages
                    color: UM.Theme.getColor("text")
                    height: contentHeight + UM.Theme.getSize("default_margin").height
                }
                Repeater
                {
                    model: toolbox.subscribedPackagesModel
                    Component
                    {
                        Item
                        {
                            width: parent.width
                            property int lineHeight: 60
                            visible: model.is_compatible
                            height: visible ? (lineHeight + UM.Theme.getSize("default_margin").height) : 0 // We only show the compatible packages here
                            Image
                            {
                                id: packageIcon
                                source: model.icon_url || "../../images/logobot.svg"
                                height: lineHeight
                                width: height
                                mipmap: true
                                fillMode: Image.PreserveAspectFit
                            }
                            Label
                            {
                                text: model.display_name
                                font: UM.Theme.getFont("medium_bold")
                                anchors.left: packageIcon.right
                                anchors.leftMargin: UM.Theme.getSize("default_margin").width
                                anchors.verticalCenter: packageIcon.verticalCenter
                                color: UM.Theme.getColor("text")
                                elide: Text.ElideRight
                            }
                        }
                    }
                }

                // Incompatible packages
                Label
                {
                    font: UM.Theme.getFont("default")
                    text: catalog.i18nc("@label", "The following packages can not be installed because of incompatible Cura version:")
                    visible: toolbox.has_incompatible_packages
                    color: UM.Theme.getColor("text")
                    height: contentHeight + UM.Theme.getSize("default_margin").height
                }
                Repeater
                {
                    model: toolbox.subscribedPackagesModel
                    Component
                    {
                        Item
                        {
                            width: parent.width
                            property int lineHeight: 60
                            visible: !model.is_compatible && !model.is_dismissed
                            height: visible ? (lineHeight + UM.Theme.getSize("default_margin").height) : 0 // We only show the incompatible packages here
                            Image
                            {
                                id: packageIcon
                                source: model.icon_url || "../../images/logobot.svg"
                                height: lineHeight
                                width: height
                                mipmap: true
                                fillMode: Image.PreserveAspectFit
                            }
                            Label
                            {
                                text: model.display_name
                                font: UM.Theme.getFont("medium_bold")
                                anchors.left: packageIcon.right
                                anchors.leftMargin: UM.Theme.getSize("default_margin").width
                                anchors.verticalCenter: packageIcon.verticalCenter
                                color: UM.Theme.getColor("text")
                                elide: Text.ElideRight
                            }

                            Label
                            {
                                text: "(Dismiss)"
                                font: UM.Theme.getFont("small")
                                anchors.right: parent.right
                                anchors.verticalCenter: packageIcon.verticalCenter
                                color: UM.Theme.getColor("text")

                                MouseArea
                                {
                                    anchors.fill: parent
                                    onClicked: toolbox.dismissIncompatiblePackage(model.package_id)
                                }
                            }
                        }
                    }
                }
            }

        } // End of ScrollView

        Cura.ActionButton
        {
            id: nextButton
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: UM.Theme.getSize("default_margin").height
            text: catalog.i18nc("@button", "Next")
        }
    }
}
