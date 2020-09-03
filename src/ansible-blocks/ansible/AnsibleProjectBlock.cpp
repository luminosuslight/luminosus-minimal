#include "AnsibleProjectBlock.h"

#include "core/manager/BlockList.h"

#include <QDir>


bool AnsibleProjectBlock::s_registered = BlockList::getInstance().addBlock(AnsibleProjectBlock::info());


AnsibleProjectBlock::AnsibleProjectBlock(CoreController* controller, QString uid)
    : BlockBase(controller, uid)
    , m_projectPath(this, "projectPath", "")
    , m_playbooks(this, "playbooks", {}, /*persistent*/ false)
{
    connect(&m_projectPath, &StringAttribute::valueChanged, this, &AnsibleProjectBlock::updatePlaybooks);
}

void AnsibleProjectBlock::updatePlaybooks() {
    QDir dir(QUrl(m_projectPath).toLocalFile());

    QRegularExpression re("([\\w\\-\\_\\d]+)(.yml|.yaml)\\Z", QRegularExpression::CaseInsensitiveOption);

    QVariantList items;

    for (const QFileInfo& info: dir.entryInfoList({QDir::Files})) {
        if (info.fileName().startsWith("requirements")) continue;
        QRegularExpressionMatch match = re.match(info.fileName());
        if (!match.hasMatch()) continue;

        QVariantMap item;
        item["path"] = info.filePath();
        item["name"] = match.captured(1);

        items << item;
    }

    std::sort(items.begin(), items.end(), [](const QVariant& lhs, const QVariant& rhs) {
        const QString lPath = lhs.toMap().value("path").toString().toLower();
        const QString rPath = rhs.toMap().value("path").toString().toLower();
        return  lPath < rPath;
    });

    m_playbooks = items;
}
