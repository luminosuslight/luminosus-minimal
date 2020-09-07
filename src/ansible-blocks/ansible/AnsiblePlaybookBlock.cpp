#include "AnsiblePlaybookBlock.h"

#include "core/manager/BlockList.h"

#include <qsyncable/QSDiffRunner>

#include <QFileInfo>
#include <QDir>
#include <QProcess>
#include <QJsonDocument>
#include <QJsonObject>


bool AnsiblePlaybookBlock::s_registered = BlockList::getInstance().addBlock(AnsiblePlaybookBlock::info());


AnsiblePlaybookBlock::AnsiblePlaybookBlock(CoreController* controller, QString uid)
    : BlockBase(controller, uid)
    , m_filePath(this, "filePath", "")
    , m_hostsLimit(this, "hostsLimit", "")
    , m_vaultSecret(this, "vaultSecret", "", /*persistent*/ false)
    , m_titleWhitelist(this, "titleWhitelist", "")
    , m_titleBlacklist(this, "titleBlacklist", "")
    , m_totalMessageCount(this, "totalMessageCount", 0, 0, std::numeric_limits<int>::max())
    , m_skippedMessageCount(this, "skippedMessageCount", 0, 0, std::numeric_limits<int>::max())
    , m_okMessageCount(this, "okMessageCount", 0, 0, std::numeric_limits<int>::max())
    , m_changedMessageCount(this, "changedMessageCount", 0, 0, std::numeric_limits<int>::max())
    , m_warningMessageCount(this, "warningMessageCount", 0, 0, std::numeric_limits<int>::max())
    , m_fatalMessageCount(this, "fatalMessageCount", 0, 0, std::numeric_limits<int>::max())
    , m_messages(this, "messages", {}, /*persistent*/ false)
{
    m_widthIsResizable = true;
    m_heightIsResizable = true;

    qmlRegisterAnonymousType<QSListModel>("Luminosus", 1);

    // prevent QML engine from taking ownership and deleting this object:
    m_messagesModel.setParent(this);
    m_messagesModel.setRoleNames({"id", "title", "content", "channel", "color"});

    retrieveUserEnvironment();
}

void AnsiblePlaybookBlock::run() {
    if (m_filePath.getValue().isEmpty()) return;

    QStringList arguments {m_filePath};
    if (!m_hostsLimit.getValue().isEmpty()) {
        arguments << "--limit";
        arguments << m_hostsLimit.getValue();
    }
    if (!m_vaultSecret.getValue().isEmpty()) {
        arguments << "--vault-id";
        arguments << "@prompt";
    }

    m_rawProgrammOutput.clear();

#ifdef Q_OS_LINUX
    QProcess* process = new QProcess(this);
    process->setProcessEnvironment(m_userEnvironment);
    process->setWorkingDirectory(QFileInfo(m_filePath).absoluteDir().path());
    process->setProgram("ansible-playbook");
    process->setArguments(arguments);

    connect(process, &QProcess::readyReadStandardOutput, this, [this, process]() {
         m_rawProgrammOutput.append(process->readAllStandardOutput());
         buildMessagesFromProgrammOutput();
    });

    connect(process, &QProcess::readyReadStandardError, this, [this, process]() {
         m_rawProgrammOutput.append(process->readAllStandardError());
         buildMessagesFromProgrammOutput();
    });

    connect(process, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
            this, [this](int exitCode, QProcess::ExitStatus exitStatus) {
        m_process = nullptr;
        m_rawProgrammOutput.append("\nAnsible Exit Code: " + QString::number(exitCode) + " " + exitStatus);
        buildMessagesFromProgrammOutput();
    });

    process->start();
    m_process = process;

    if (!m_vaultSecret.getValue().isEmpty()) {
        process->waitForStarted();
        process->write(m_vaultSecret.getValue().toUtf8());
        process->write("\n");
    }
#endif
}

void AnsiblePlaybookBlock::stop() {
    if (!m_process) return;
    m_process->terminate();
}

void AnsiblePlaybookBlock::buildMessagesFromProgrammOutput() {
    QVariantList messages;

    QString currentTitle = "";
    QStringList currentContent = {};

    QRegularExpression jsonRegex("({.*})", QRegularExpression::CaseInsensitiveOption);

    int index = 0;
    int totalMessageCount = 0;
    int skippedMessageCount = 0;
    int okMessageCount = 0;
    int changedMessageCount = 0;
    int warningMessageCount = 0;
    int fatalMessageCount = 0;

    for (QString msg: m_rawProgrammOutput.split("\n")) {
        if (msg.isEmpty()) continue;

        if (msg.startsWith("PLAY ") || msg.startsWith("TASK ") || msg.startsWith("Ansible Exit Code:")) {
            if (!currentTitle.isEmpty() || !currentContent.isEmpty()) {
                // submit previous item:
                QVariantMap item;
                item["id"] = index;
                item["title"] = currentTitle.isEmpty() ? "Message" : currentTitle;
                item["content"] = currentContent.join("\n");
                item["channel"] = "standard_output";
                if (item["content"].toString().contains("skipped:")) {
                    ++skippedMessageCount;
                } else if (item["content"].toString().contains("ok:")) {
                    item["color"] = QColor(0, 255, 0).lighter();
                    ++okMessageCount;
                } else if (item["content"].toString().contains("fatal:") || item["content"].toString().contains("failed:")) {
                    item["color"] = QColor(255, 0, 0).lighter();
                    ++fatalMessageCount;
                } else if (item["content"].toString().contains("changed:")) {
                    item["color"] = QColor(255, 255, 0).lighter();
                    ++changedMessageCount;
                } else if (item["content"].toString().contains("[WARNING]")) {
                    item["color"] = QColor(255, 0, 255).lighter();
                    ++warningMessageCount;
                }
                messages << item;
                ++index;
                ++totalMessageCount;
            }
            currentTitle = msg;
            currentContent.clear();
        } else {
            QRegularExpressionMatch match = jsonRegex.match(msg);
            if (match.hasMatch()) {
                QString json = match.captured(1);
                QJsonDocument doc = QJsonDocument::fromJson(json.toUtf8());
                QString jsonString = doc.toJson(QJsonDocument::Indented);
                msg.replace(json, jsonString);
            }
            currentContent << msg;
        }
    }

    if (!currentTitle.isEmpty() || !currentContent.isEmpty()) {
        // submit last item:
        QVariantMap item;
        item["id"] = index;
        item["title"] = currentTitle;
        item["content"] = currentContent.join("\n");
        item["channel"] = "standard_output";
        messages << item;
        ++index;
        ++totalMessageCount;
    }

    m_messages = messages;

    m_totalMessageCount = totalMessageCount;
    m_skippedMessageCount = skippedMessageCount;
    m_okMessageCount = okMessageCount;
    m_changedMessageCount = changedMessageCount;
    m_warningMessageCount = warningMessageCount;
    m_fatalMessageCount = fatalMessageCount;

    updateMessagesModel();
}

void AnsiblePlaybookBlock::updateMessagesModel() {
    QVariantList visibleMessages;

    for (const auto& msg: m_messages.getValue()) {
        if (m_titleWhitelist.getValue().isEmpty()
                || msg.toMap()["title"].toString().toLower().contains(m_titleWhitelist.getValue())) {
            if (m_titleBlacklist.getValue().isEmpty()
                    || !msg.toMap()["title"].toString().toLower().contains(m_titleBlacklist.getValue())) {
                visibleMessages.prepend(msg);
            }
        }
    }

    QSDiffRunner runner;
    runner.setKeyField("id");
    QList<QSPatch> patches = runner.compare(m_messagesModel.storage(), visibleMessages);
    runner.patch(&m_messagesModel, patches);
}

void AnsiblePlaybookBlock::retrieveUserEnvironment() {

#ifdef Q_OS_LINUX
    QProcess* process = new QProcess(this);

    connect(process, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
            this, [this, process](int, QProcess::ExitStatus) {
        m_userEnvironment = QProcessEnvironment::systemEnvironment();
        for (const auto& s: QString::fromUtf8(process->readAllStandardOutput()).split("\n")) {
            QString name = s.left(s.indexOf("="));
            QString value = s.mid(s.indexOf("=") + 1);
            m_userEnvironment.insert(name, value);
        }
    });

    process->setProgram("bash");
    process->setArguments({"-i"});
    process->start();
    process->waitForStarted();
    process->write("printenv");
    process->closeWriteChannel();
#endif
}
