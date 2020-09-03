#ifndef CLOCKBLOCK_H
#define CLOCKBLOCK_H

#include "core/block_basics/BlockBase.h"


class AnsibleProjectBlock: public BlockBase {

    Q_OBJECT

public:

    static bool s_registered;
    static BlockInfo info() {
        static BlockInfo info;
        info.typeName = "Ansible Project";
        info.nameInUi = "Project";
        info.category << "Ansible";
        info.orderHint = 100 + 1;
        info.helpText = "Allows to run playbooks of an ansible project.";
        info.qmlFile = "qrc:/ansible-blocks/ansible/AnsibleProjectBlock.qml";
        info.complete<AnsibleProjectBlock>();
        return info;
    }

    explicit AnsibleProjectBlock(CoreController* controller, QString uid);

public slots:
    virtual BlockInfo getBlockInfo() const override { return info(); }
};

#endif // CLOCKBLOCK_H
