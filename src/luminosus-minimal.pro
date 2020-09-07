include(core/luminosus-core.pri)

include(qsyncable/qsyncable.pri)

include(universal-blocks/universal-blocks.pri)
include(ansible-blocks/ansible-blocks.pri)

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

SOURCES += \
        main.cpp

RESOURCES += qml.qrc \
    fonts.qrc \
    images.qrc
