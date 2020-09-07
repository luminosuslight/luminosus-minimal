#ifndef ANSIBLEPLAYBOOKBLOCK_H
#define ANSIBLEPLAYBOOKBLOCK_H

#include "core/block_basics/BlockBase.h"

#include <qsyncable/QSListModel>

#include <QProcess>
#include <QProcessEnvironment>


class AnsiblePlaybookBlock: public BlockBase {

    Q_OBJECT

public:

    static bool s_registered;
    static BlockInfo info() {
        static BlockInfo info;
        info.typeName = "Ansible Playbook";
        info.nameInUi = "Playbook";
        info.category << "Ansible";
        info.orderHint = 100 + 1;
        info.helpText = "Allows to run a playbook and analyze the output.";
        info.qmlFile = "qrc:/ansible-blocks/ansible/AnsiblePlaybookBlock.qml";
        info.complete<AnsiblePlaybookBlock>();
        return info;
    }

    explicit AnsiblePlaybookBlock(CoreController* controller, QString uid);

public slots:
    virtual BlockInfo getBlockInfo() const override { return info(); }

    void run();
    void stop();

    QSListModel* messagesModel() { return &m_messagesModel; }

private slots:
    void buildMessagesFromProgrammOutput();
    void updateMessagesModel();

private:
    void retrieveUserEnvironment();

protected:
    StringAttribute m_filePath;
    StringAttribute m_hostsLimit;
    StringAttribute m_vaultSecret;

    StringAttribute m_searchPhrase;
    StringAttribute m_titleBlacklist;

    IntegerAttribute m_totalMessageCount;
    IntegerAttribute m_skippedMessageCount;
    IntegerAttribute m_okMessageCount;
    IntegerAttribute m_changedMessageCount;
    IntegerAttribute m_warningMessageCount;
    IntegerAttribute m_failedMessageCount;

    BoolAttribute m_skippedMessagesEnabled;
    BoolAttribute m_okMessagesEnabled;
    BoolAttribute m_changedMessagesEnabled;
    BoolAttribute m_warningMessagesEnabled;
    BoolAttribute m_failedMessagesEnabled;

    QProcessEnvironment m_userEnvironment;

    // runtime:
    QPointer<QProcess> m_process;
    QString m_rawProgrammOutput;
    VariantListAttribute m_messages;
    QSListModel m_messagesModel;
};

#endif // ANSIBLEPLAYBOOKBLOCK_H
